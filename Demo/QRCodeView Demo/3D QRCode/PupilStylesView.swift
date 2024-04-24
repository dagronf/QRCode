//
//  PupilStylesView.swift
//  3D QRCode
//
//  Created by Darren Ford on 24/4/2024.
//

import Foundation
import AppKit

import DSFAppKitBuilder
import QRCode
import DSFValueBinders

class PupilStylesView: Element {

	init(qrCode: Observable<QRCode.Document>, _ updateBlock: @escaping () -> Void ) {
		self.qrCodeObject = qrCode
		self.updateBlock = updateBlock
		super.init()
		self.qrCodeObject.register { [weak self] _ in
			self?.sync()
		}
	}

	let qrCodeObject: Observable<QRCode.Document>
	var qrCode: QRCode.Document { qrCodeObject.object }
	let updateBlock: () -> Void

	override func view() -> NSView { return self.body.view() }

	private lazy var body: Element =
		VStack {
			Flow(minimumInteritemSpacing: 1, minimumLineSpacing: 1, ForEach(allPupilStyles.wrappedValue, { item in
				let image = QRCodePupilShapeFactory.shared.image(
					pupilGenerator: item,
					dimension: 80,
					foregroundColor: NSColor.textColor.cgColor
				)!
				return Button(
					image: NSImage(cgImage: image, size: .init(width: 40, height: 40)),
					type: .onOff,
					bezelStyle: .smallSquare,
					customButtonCell: CustomButtonCell()
				) { [weak self] _ in
					guard let `self` = self else { return }
					self.qrCode.design.shape.pupil = item
					self.sync()
					self.update()
				}
				.toolTip(item.title)
				.bindRadioGroup(
					selectedPupilStyle,
					initialSelection: item.name == qrCode.design.shape.actualPupilShape.name
				)
			}))

			HDivider()

			VStack(spacing: 4) {
				HStack {
					Label("flipped:").font(.callout)
					Toggle()
						.controlSize(.small)
						.bindOnOff(pupilFlipped)
						.bindIsEnabled(pupilFlippedEnabled)
					EmptyView()
				}

				HStack {
					Label("corners:").font(.callout)
					Segmented(trackingMode: .selectAny) {
						Segment("􀰼")
						Segment("􀄔")
						Segment("􀄖")
						Segment("􀄘")
					}
					.controlSize(.small)
					.bindSelectedSegments(pupilSelectedCorners)
					.bindIsEnabled(pupilSelectedCornersEnabled)
					EmptyView()
				}
			}
		}
		.edgeInsets(top: 4, left: 4, bottom: 4, right: 4)

	private func sync() {
		let item = qrCode.design.shape.actualPupilShape
		self.pupilFlippedEnabled.wrappedValue = item.supportsSettingValue(forKey: QRCode.SettingsKey.isFlipped)
		self.pupilFlipped.wrappedValue = item.settingsValue(for: QRCode.SettingsKey.isFlipped) ?? false

		self.pupilSelectedCornersEnabled.wrappedValue = item.supportsSettingValue(forKey: QRCode.SettingsKey.corners)
		if let value: Int = item.settingsValue(for: QRCode.SettingsKey.corners) {
			let opts = QRCode.Corners(rawValue: value)
			let s = NSMutableSet()
			if opts.contains(.tl) { s.add(0) }
			if opts.contains(.tr) { s.add(1) }
			if opts.contains(.bl) { s.add(2) }
			if opts.contains(.br) { s.add(3) }
			self.pupilSelectedCorners.wrappedValue = s
		}
		else {
			self.pupilSelectedCorners.wrappedValue = NSSet()
		}

		if let i = QRCodePupilShapeFactory.shared.availableGeneratorNames.firstIndex(of: item.name) {
			selectedPupilStyle.wrappedValue.activate(at: i)
		}
	}

	private func update() {
		self.updateBlock()
	}

	// Binding

	// A binding to tie buttons together into a radio-style grouping
	let selectedPupilStyle = ValueBinder(RadioBinding())

	let allPupilStyles = ValueBinder(QRCodePupilShapeFactory.shared.all())

	private lazy var pupilSelection: ValueBinder<Int> = ValueBinder(0) { newValue in
		self.qrCode.design.shape.pupil = self.allPupilStyles.wrappedValue[newValue]
		self.update()
	}

	private lazy var pupilFlipped = ValueBinder(false) { newValue in
		_ = self.qrCode.design.shape.pupil?.setSettingValue(newValue, forKey: QRCode.SettingsKey.isFlipped)
		self.update()
	}
	private var pupilFlippedEnabled = ValueBinder(false)

	private lazy var pupilSelectedCorners = ValueBinder(NSSet()) { newValue in
		var value: Int = 0
		if newValue.contains(0) { value += QRCode.Corners.tl.rawValue }
		if newValue.contains(1) { value += QRCode.Corners.tr.rawValue }
		if newValue.contains(2) { value += QRCode.Corners.bl.rawValue }
		if newValue.contains(3) { value += QRCode.Corners.br.rawValue }

		_ = self.qrCode.design.shape.pupil?.setSettingValue(value, forKey: QRCode.SettingsKey.corners)
		self.update()
	}
	private var pupilSelectedCornersEnabled = ValueBinder(false)
}
