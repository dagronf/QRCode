//
//  PixelStylesView.swift
//  3D QRCode
//
//  Created by Darren Ford on 24/4/2024.
//

import Foundation
import AppKit

import DSFAppKitBuilder
import QRCode
import DSFValueBinders
import DSFMenuBuilder


class PixelStylesView: Element {

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

		Flow(minimumInteritemSpacing: 1, minimumLineSpacing: 1, ForEach(allPixelStyles.wrappedValue, { item in
			let image = try! QRCodePixelShapeFactory.shared.image(
				pixelGenerator: item,
				dimension: 120,
				foregroundColor: NSColor.textColor.cgColor
			)
			return Button(
				image: NSImage(cgImage: image, size: .init(width: 60, height: 60)),
				type: .onOff,
				bezelStyle: .smallSquare,
				customButtonCell: CustomButtonCell()
			) { [weak self] _ in
				guard let `self` = self else { return }
				self.qrCode.design.shape.onPixels = item
				self.sync()
				self.update()
			}
			.toolTip(item.title)
			.bindRadioGroup(
				selectedPixelStyle,
				initialSelection: item.name == qrCode.design.shape.onPixels.name
			)
		}))
		.onChange(of: pixelSelection) { [weak self] newValue in
			guard let `self` = self else { return }
			let gen = self.allPixelStyles.wrappedValue[newValue]
			self.qrCode.design.shape.onPixels = gen
			self.update()
		}

		HDivider()

		VStack(spacing: 4) {
			HStack {
				Label("Radius:").font(.callout)
				Slider(pixelCurveRadius, range: 0 ... 1)
					.controlSize(.small)
					.bindIsEnabled(pixelCurveRadiusEnabled)
					.onChange(of: pixelCurveRadius) { [weak self] newValue in
						_ = self?.qrCode.design.shape.onPixels.setSettingValue(newValue, forKey: QRCode.SettingsKey.cornerRadiusFraction)
						self?.update()
					}
				Button(title: "􀊞", type: .pushOnPushOff)
					.toolTip("Include inner curves in the path")
					.bindOnOffState(pixelInnerCurves)
					.bindIsEnabled(pixelInnerCurvesEnabled)
					.width(40)
					.onChange(of: pixelInnerCurves) { [weak self] newValue in
						_ = self?.qrCode.design.shape.onPixels.setSettingValue(newValue, forKey: QRCode.SettingsKey.hasInnerCorners)
						self?.update()
					}
			}

			HStack {
				Label("Inset:").font(.callout)
				Slider(pixelInset, range: 0 ... 1)
					.controlSize(.small)
					.bindIsEnabled(pixelInsetEnabled)
					.onChange(of: pixelInset) { [weak self] newValue in
						_ = self?.qrCode.design.shape.onPixels.setSettingValue(newValue, forKey: QRCode.SettingsKey.insetFraction)
						self?.update()
					}
				PopupButton {
					MenuItem("Fixed")
						.onAction { self.pixelInsetGeneratorName = "fixed" }
					MenuItem("Random")
						.onAction { self.pixelInsetGeneratorName = "random" }
					MenuItem("Punch")
						.onAction { self.pixelInsetGeneratorName = "punch" }
					MenuItem("Wave-H")
						.onAction { self.pixelInsetGeneratorName = "horizontalWave" }
					MenuItem("Wave-V")
						.onAction { self.pixelInsetGeneratorName = "verticalWave" }
				}
				.bindIsEnabled(pixelInsetEnabled)
				.toolTip("Customize the inset")
				.onChange(of: $pixelInsetGeneratorName) { [weak self] newValue in
					_ = self?.qrCode.design.shape.onPixels.setSettingValue(newValue, forKey: QRCode.SettingsKey.insetGeneratorName)
					self?.update()
				}
			}

			HStack {
				Label("Rotation:").font(.callout)
				Slider($pixelRotation, range: 0 ... 1)
					.controlSize(.small)
					.bindIsEnabled($pixelRotationEnabled)
					.onChange(of: $pixelRotation) { [weak self] newValue in
						_ = self?.qrCode.design.shape.onPixels.setSettingValue(newValue, forKey: QRCode.SettingsKey.rotationFraction)
						self?.update()
					}

				PopupButton {
					MenuItem("Fixed")
						.onAction { self.pixelRotationGeneratorName = "fixed" }
					MenuItem("Random")
						.onAction { self.pixelRotationGeneratorName = "random" }
					MenuItem("Wave-H")
						.onAction { self.pixelRotationGeneratorName = "horizontalWave" }
					MenuItem("Wave-V")
						.onAction { self.pixelRotationGeneratorName = "verticalWave" }
				}
				.bindIsEnabled($pixelRotationEnabled)
				.onChange(of: $pixelRotationGeneratorName) { [weak self] newvalue in
					_ = self?.qrCode.design.shape.onPixels.setSettingValue(newvalue, forKey: QRCode.SettingsKey.rotationGeneratorName)
					self?.update()
				}
			}
		}
	}
	.edgeInsets(top: 4, left: 4, bottom: 4, right: 4)

	private func performChangeOnModel(_ block: (QRCode.Document) -> Void) {
		block(self.qrCode)
		self.update()
	}

	private func sync() {
		let item = qrCode.design.shape.onPixels
		self.pixelCurveRadiusEnabled.wrappedValue = item.supportsSettingValue(forKey: QRCode.SettingsKey.cornerRadiusFraction)
		self.pixelCurveRadius.wrappedValue = item.settingsValue(forKey: QRCode.SettingsKey.cornerRadiusFraction) ?? 0.6

		self.pixelInnerCurves.wrappedValue = item.settingsValue(forKey: QRCode.SettingsKey.hasInnerCorners) ?? false
		self.pixelInnerCurvesEnabled.wrappedValue = item.supportsSettingValue(forKey: QRCode.SettingsKey.hasInnerCorners)

		self.pixelInsetEnabled.wrappedValue = item.supportsSettingValue(forKey: QRCode.SettingsKey.insetFraction)
		self.pixelInset.wrappedValue = item.settingsValue(forKey: QRCode.SettingsKey.insetFraction) ?? 0.1

		self.pixelInsetGeneratorName = item.settingsValue(forKey: QRCode.SettingsKey.insetGeneratorName)
		self.pixelInsetGeneratorNameEnabled = item.supportsSettingValue(forKey: QRCode.SettingsKey.insetGeneratorName)

		//self.pixelRotationGeneratorName = item.settingsValue(forKey: QRCode.SettingsKey.rotationGeneratorName)
		self.pixelRotation = item.settingsValue(forKey: QRCode.SettingsKey.rotationFraction) ?? 0.0
		self.pixelRotationEnabled = item.supportsSettingValue(forKey: QRCode.SettingsKey.rotationFraction)

		if let i = QRCodePixelShapeFactory.shared.availableGeneratorNames.firstIndex(of: item.name) {
			selectedPixelStyle.wrappedValue.activate(at: i)
		}
	}

	private func update() {
		self.updateBlock()
	}

	// Bindings
	let allPixelStyles = ValueBinder(QRCodePixelShapeFactory.shared.all())

	let selectedPixelStyle = ValueBinder(RadioBinding())

	private lazy var pixelSelection: ValueBinder<Int> = ValueBinder(0)

	private lazy var pixelCurveRadius = ValueBinder(1.0)
	private var pixelCurveRadiusEnabled = ValueBinder(false)

	private lazy var pixelInnerCurves = ValueBinder(false)
	private var pixelInnerCurvesEnabled = ValueBinder(false)

	@ValueBinding private var pixelInset = ValueBinder(1.0)
	@ValueBinding private var pixelInsetEnabled = ValueBinder(false)
	@ValueBinding private var pixelInsetGeneratorName: String? = nil
	@ValueBinding private var pixelInsetGeneratorNameEnabled: Bool = false

	@ValueBinding private var pixelRotationEnabled = false
	@ValueBinding private var pixelRotation = 1.0
	@ValueBinding private var pixelRotationGeneratorName: String? = nil
	@ValueBinding private var pixelRandomGeneratorNameEnabled = false
}
