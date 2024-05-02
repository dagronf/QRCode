//
//  PixelSettingsView.swift
//  QRCode 3D
//
//  Created by Darren Ford on 25/4/2024.
//

import SwiftUI
import QRCode

struct EyeGenerator: Identifiable {
	var id: String { generator.name }
	let generator: QRCodeEyeShapeGenerator
	let image: Image
	init(_ generator: QRCodeEyeShapeGenerator, _ image: CGImage) {
		self.generator = generator
		self.image = Image(image, scale: 2.0, orientation: .up, label: Text(generator.name))
	}
}

#if os(macOS)
let textColor = NSColor.textColor.cgColor
#else
let textColor = UIColor.darkText.cgColor
#endif

let availableEyeGenerators: [EyeGenerator] = {
	QRCodeEyeShapeFactory.shared.all().map { gen in
		let image = QRCodeEyeShapeFactory.shared.image(
			eyeGenerator: gen,
			dimension: 100,
			foregroundColor: textColor
		)!
		return EyeGenerator(gen, image)
	}
}()

struct EyeSettingsView: View {

	@EnvironmentObject var document: QRCode_3DDocument
	@State var generator: QRCodeEyeShapeGenerator = QRCode.EyeShape.Square()

	@State var radiusFraction: CGFloat = 0
	@State var supportsRadiusFraction = false

	@State var flipped = false
	@State var supportsFlipped = false

	@State var corners = QRCode.Corners.all
	@State var supportsCorners = false

	var body: some View {
		VStack {
			FlowLayout {
				ForEach(availableEyeGenerators) { item in
					Button {
						generator = item.generator
						document.qrcode.design.shape.eye = item.generator
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
					StyleSelectorView(current: document.qrcode.design.style.actualEyeStyle) { newFill in
						document.qrcode.design.style.eye = newFill
						document.objectWillChange.send()
					}
				}

				Slider(value: $radiusFraction, in: (0 ... 1)) {
					Text("radius")
				}
				.disabled(!supportsRadiusFraction)
				.onChange(of: radiusFraction) { newValue in
					_ = document.qrcode.design.shape.eye.setSettingValue(newValue, forKey: QRCode.SettingsKey.cornerRadiusFraction)
					document.objectWillChange.send()
				}

				Toggle(isOn: $flipped) {
					Text("flipped")
				}
				.disabled(!supportsFlipped)
				.onChange(of: flipped) { newValue in
					_ = document.qrcode.design.shape.eye.setSettingValue(newValue, forKey: QRCode.SettingsKey.isFlipped)
					document.objectWillChange.send()
				}

				LabeledContent("corners") {
					CornerPicker(corners: $corners)
				}
				.disabled(!supportsCorners)
				.onChange(of: corners) { newValue in
					_ = document.qrcode.design.shape.eye.setSettingValue(newValue.rawValue, forKey: QRCode.SettingsKey.corners)
					document.objectWillChange.send()
				}

			}
			.padding(8)
		}
		.onAppear {
			generator = document.qrcode.design.shape.eye
			sync()
		}
	}

	func sync() {
		supportsRadiusFraction = generator.supportsSettingValue(forKey: QRCode.SettingsKey.cornerRadiusFraction)
		radiusFraction = generator.settingsValue(forKey: QRCode.SettingsKey.cornerRadiusFraction) ?? 0

		supportsFlipped = generator.supportsSettingValue(forKey: QRCode.SettingsKey.isFlipped)
		flipped = generator.settingsValue(forKey: QRCode.SettingsKey.isFlipped) ?? false

		supportsCorners = generator.supportsSettingValue(forKey: QRCode.SettingsKey.corners)
		let c: Int = generator.settingsValue(forKey: QRCode.SettingsKey.corners) ?? 0
		corners = QRCode.Corners(rawValue: c)
	}

}

#Preview {
	EyeSettingsView().environmentObject(QRCode_3DDocument())
		.controlSize(.small)
		.frame(maxWidth: 300)
		.frame(height: 400)
}
