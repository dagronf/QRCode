//
//  EyeStylesView.swift
//  3D QRCode
//
//  Created by Darren Ford on 24/4/2024.
//

import Foundation
import AppKit

import DSFAppKitBuilder
import QRCode
import DSFValueBinders

class EyeStylesView: Element {

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
	lazy var body: Element =
	VStack {
		Flow(minimumInteritemSpacing: 1, minimumLineSpacing: 1, ForEach(allEyeStyles.wrappedValue, { item in
			let image = QRCodeEyeShapeFactory.shared.image(
				eyeGenerator: item,
				dimension: 96,
				foregroundColor: NSColor.textColor.cgColor
			)!
			return Button(
				image: NSImage(cgImage: image, size: .init(width: 48, height: 48)),
				type: .onOff,
				bezelStyle: .smallSquare,
				customButtonCell: CustomButtonCell()
			) { [weak self] _ in
				guard let `self` = self else { return }
				self.qrCode.design.shape.eye = item
				self.qrCode.design.shape.pupil = nil
				self.sync()
				self.update()
			}
			.toolTip(item.title)
			.bindRadioGroup(
				selectedEyeStyle,
				initialSelection: item.name == qrCode.design.shape.eye.name
			)
		}))
		.onChange(of: eyeSelection) { [weak self] newValue in
			guard let `self` = self else { return }
			self.qrCode.design.shape.eye = self.allEyeStyles.wrappedValue[newValue]
			self.update()
		}

		HDivider()

		VStack(spacing: 4) {

			HStack {
				Label("radius:").font(.callout)
				Slider(eyeCornerRadius, range: 0 ... 1)
					.controlSize(.small)
					.bindIsEnabled(eyeCornerRadiusEnabled)
					.onChange(of: eyeCornerRadius) { [weak self] newValue in
						_ = self?.qrCode.design.shape.eye.setSettingValue(newValue, forKey: QRCode.SettingsKey.cornerRadiusFraction)
						self?.update()
					}
			}
			HStack {
				Label("flipped:").font(.callout)
				Toggle()
					.controlSize(.small)
					.bindOnOff(eyeFlipped)
					.bindIsEnabled(eyeFlippedEnabled)
					.onChange(of: eyeFlipped) { [weak self] newValue in
						_ = self?.qrCode.design.shape.eye.setSettingValue(newValue, forKey: QRCode.SettingsKey.isFlipped)
						self?.update()
					}
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
				.bindSelectedSegments(eyeSelectedCorners)
				.bindIsEnabled(eyeSelectedCornersEnabled)
				EmptyView()
			}
			.contentHugging(h: 1)
		}
	}
	.edgeInsets(top: 4, left: 4, bottom: 4, right: 4)

	private func sync() {
		let item = qrCode.design.shape.eye
		self.eyeCornerRadiusEnabled.wrappedValue = item.supportsSettingValue(forKey: QRCode.SettingsKey.cornerRadiusFraction)
		self.eyeCornerRadius.wrappedValue = item.settingsValue(forKey: QRCode.SettingsKey.cornerRadiusFraction) ?? 0.65

		self.eyeFlippedEnabled.wrappedValue = item.supportsSettingValue(forKey: QRCode.SettingsKey.isFlipped)
		self.eyeFlipped.wrappedValue = item.settingsValue(forKey: QRCode.SettingsKey.isFlipped) ?? false

		self.eyeSelectedCornersEnabled.wrappedValue = item.supportsSettingValue(forKey: QRCode.SettingsKey.corners)
		if let value: Int = item.settingsValue(forKey: QRCode.SettingsKey.corners) {
			let opts = QRCode.Corners(rawValue: value)
			let s = NSMutableSet()
			if opts.contains(.tl) { s.add(0) }
			if opts.contains(.tr) { s.add(1) }
			if opts.contains(.bl) { s.add(2) }
			if opts.contains(.br) { s.add(3) }
			self.eyeSelectedCorners.wrappedValue = s
		}
		else {
			self.eyeSelectedCorners.wrappedValue = NSSet()
		}

		if let i = QRCodeEyeShapeFactory.shared.availableGeneratorNames.firstIndex(of: item.name) {
			selectedEyeStyle.wrappedValue.activate(at: i)
		}
	}

	private func update() {
		self.updateBlock()
	}

	// Bindings

	let selectedEyeStyle = ValueBinder(RadioBinding())

	let allEyeStyles = ValueBinder(QRCodeEyeShapeFactory.shared.all())
	private lazy var eyeSelection = ValueBinder(0)

	private lazy var eyeCornerRadius = ValueBinder(0.65)
	private var eyeCornerRadiusEnabled = ValueBinder(false)

	private lazy var eyeFlipped = ValueBinder(false)
	private var eyeFlippedEnabled = ValueBinder(false)

	private lazy var eyeSelectedCorners = ValueBinder(NSSet()) { newValue in
		var value: Int = 0
		if newValue.contains(0) { value += QRCode.Corners.tl.rawValue }
		if newValue.contains(1) { value += QRCode.Corners.tr.rawValue }
		if newValue.contains(2) { value += QRCode.Corners.bl.rawValue }
		if newValue.contains(3) { value += QRCode.Corners.br.rawValue }

		_ = self.qrCode.design.shape.eye.setSettingValue(value, forKey: QRCode.SettingsKey.corners)
		self.update()
	}
	private var eyeSelectedCornersEnabled = ValueBinder(false)
}
