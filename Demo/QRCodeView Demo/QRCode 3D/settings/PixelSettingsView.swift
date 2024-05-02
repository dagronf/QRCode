//
//  PixelSettingsView.swift
//  QRCode 3D
//
//  Created by Darren Ford on 25/4/2024.
//

import SwiftUI
import QRCode

struct PixelGenerator: Identifiable {
	var id: String { generator.name }
	let generator: QRCodePixelShapeGenerator
	let image: Image
	init(_ generator: QRCodePixelShapeGenerator, _ image: CGImage) {
		self.generator = generator
		self.image = Image(image, scale: 2.0, orientation: .up, label: Text(generator.name))
	}
}

let availablePixelGenerators: [PixelGenerator] = {
	QRCodePixelShapeFactory.shared.all().map { gen in
		let image = QRCodePixelShapeFactory.shared.image(
			pixelGenerator: gen,
			dimension: 120,
			foregroundColor: textColor
		)!
		return PixelGenerator(gen, image)
	}
}()

struct PixelSettingsView: View {

	@EnvironmentObject var document: QRCode_3DDocument
	@State var generator: QRCodePixelShapeGenerator = QRCode.PixelShape.Square()

	@State var radiusFraction: CGFloat = 0
	@State var hasRadiusFraction = false

	@State var innerCurves = false
	@State var hasInnerCurves = false

	@State var insetFraction: CGFloat = 0
	@State var hasInsetFraction = false

	@State var randomInset = false
	@State var supportsRandomInset = false

	@State var rotationFraction: CGFloat = 0
	@State var supportsRotationFraction = false

	@State var randomRotation = false
	@State var supportsRandomRotation = false

	@State var fillStyle: QRCodeFillStyleGenerator? = QRCode.FillStyle.Solid(gray: 0, alpha: 1)

	var body: some View {
		VStack {
			FlowLayout {
				ForEach(availablePixelGenerators) { item in
					Button {
						generator = item.generator
						document.qrcode.design.shape.onPixels = item.generator
						document.objectWillChange.send()
						sync()
					} label: {
						item.image
					}
					.buttonStyle(.plain)
					.background(generator.name == item.generator.name ? Color.accentColor : Color.clear)
					.clipShape(RoundedRectangle(cornerSize: CGSize(width: 4, height: 4)))
				}
			}
			Divider()

			Form {
				LabeledContent("style") {
					StyleSelectorView(fillStyle: $fillStyle)
				}

				HStack {
					Slider(value: $radiusFraction, in: (0 ... 1)) {
						Text("radius")
					}
					Button("􀤑") {
						innerCurves.toggle()
					}
					.controlSize(.large)
					.background(innerCurves ? Color.accentColor : Color.clear)
					.disabled(!hasInnerCurves)
					.buttonStyle(.borderless)
					.clipShape(RoundedRectangle(cornerSize: CGSize(width: 4, height: 4)))
				}
				.disabled(!hasRadiusFraction)

				HStack {
					Slider(value: $insetFraction, in: (0 ... 1)) {
						Text("inset")
					}
					Button("􀖅") {
						randomInset.toggle()
					}
					.controlSize(.large)
					.disabled(!supportsRandomInset)
					.background(randomInset ? Color.accentColor : Color.clear)
					.buttonStyle(.borderless)
					.clipShape(RoundedRectangle(cornerSize: CGSize(width: 4, height: 4)))
				}
				.disabled(!hasInsetFraction)

				HStack {
					Slider(value: $rotationFraction, in: (0 ... 1)) {
						Text("rotation")
					}
					Button("􀖅") {
						randomRotation.toggle()
					}
					.controlSize(.large)
					.disabled(!supportsRandomRotation)
					.background(randomRotation ? Color.accentColor : Color.clear)
					.buttonStyle(.borderless)
					.clipShape(RoundedRectangle(cornerSize: CGSize(width: 4, height: 4)))
				}
				.disabled(!supportsRotationFraction)
			}
			.padding(8)
		}
		.onAppear {
			generator = document.qrcode.design.shape.onPixels
			sync()
		}
		.onChange(of: radiusFraction) { newValue in
			_ = document.qrcode.design.shape.onPixels.setSettingValue(newValue, forKey: QRCode.SettingsKey.cornerRadiusFraction)
			document.objectWillChange.send()
		}
		.onChange(of: innerCurves) { newValue in
			_ = document.qrcode.design.shape.onPixels.setSettingValue(newValue, forKey: QRCode.SettingsKey.hasInnerCorners)
			document.objectWillChange.send()
		}
		.onChange(of: insetFraction) { newValue in
			_ = document.qrcode.design.shape.onPixels.setSettingValue(newValue, forKey: QRCode.SettingsKey.insetFraction)
			document.objectWillChange.send()
		}
		.onChange(of: randomInset) { newValue in
			_ = document.qrcode.design.shape.onPixels.setSettingValue(newValue, forKey: QRCode.SettingsKey.useRandomInset)
			document.objectWillChange.send()
		}
		.onChange(of: rotationFraction) { newValue in
			_ = document.qrcode.design.shape.onPixels.setSettingValue(newValue, forKey: QRCode.SettingsKey.rotationFraction)
			document.objectWillChange.send()
		}
		.onChange(of: randomRotation) { newValue in
			_ = document.qrcode.design.shape.onPixels.setSettingValue(newValue, forKey: QRCode.SettingsKey.useRandomRotation)
			document.objectWillChange.send()
		}
	}

	func sync() {
		hasRadiusFraction = generator.supportsSettingValue(forKey: QRCode.SettingsKey.cornerRadiusFraction)
		radiusFraction = generator.settingsValue(forKey: QRCode.SettingsKey.cornerRadiusFraction) ?? 0

		hasInnerCurves = generator.supportsSettingValue(forKey: QRCode.SettingsKey.hasInnerCorners)
		innerCurves = generator.settingsValue(forKey: QRCode.SettingsKey.hasInnerCorners) ?? false

		hasInsetFraction = generator.supportsSettingValue(forKey: QRCode.SettingsKey.insetFraction)
		insetFraction = generator.settingsValue(forKey: QRCode.SettingsKey.insetFraction) ?? 0

		supportsRandomInset = generator.supportsSettingValue(forKey: QRCode.SettingsKey.useRandomInset)
		randomInset = generator.settingsValue(forKey: QRCode.SettingsKey.useRandomInset) ?? false

		supportsRotationFraction = generator.supportsSettingValue(forKey: QRCode.SettingsKey.rotationFraction)
		rotationFraction = generator.settingsValue(forKey: QRCode.SettingsKey.rotationFraction) ?? 0

		supportsRandomRotation = generator.supportsSettingValue(forKey: QRCode.SettingsKey.useRandomRotation)
		randomRotation = generator.settingsValue(forKey: QRCode.SettingsKey.useRandomRotation) ?? false
	}

}

#Preview {
	PixelSettingsView().environmentObject(QRCode_3DDocument())
		.controlSize(.small)
		.frame(maxWidth: 300)
}
