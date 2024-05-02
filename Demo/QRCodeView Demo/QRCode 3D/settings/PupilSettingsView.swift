//
//  PupilSettingsView.swift
//  QRCode 3D
//
//  Created by Darren Ford on 25/4/2024.
//

import SwiftUI
import QRCode

struct PupilGenerator: Identifiable {
	var id: String { generator.name }
	let generator: QRCodePupilShapeGenerator
	let image: Image
	init(_ generator: QRCodePupilShapeGenerator, _ image: CGImage) {
		self.generator = generator
		self.image = Image(image, scale: 2.0, orientation: .up, label: Text(generator.name))
	}
}

let availablePupilGenerators: [PupilGenerator] = {
	QRCodePupilShapeFactory.shared.all().map { gen in
		let image = QRCodePupilShapeFactory.shared.image(
			pupilGenerator: gen,
			dimension: 80,
			foregroundColor: textColor
		)!
		return PupilGenerator(gen, image)
	}
}()

struct PupilSettingsView: View {

	@EnvironmentObject var document: QRCode_3DDocument
	@State var generator: QRCodePupilShapeGenerator = QRCode.PupilShape.Square()

	@State var flipped = false
	@State var supportsFlipped = false

	@State var corners = QRCode.Corners.all
	@State var supportsCorners = false

	var body: some View {
		VStack {
			FlowLayout {
				ForEach(availablePupilGenerators) { item in
					Button {
						generator = item.generator
						document.qrcode.design.shape.pupil = item.generator
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
			//VStack(alignment: .leading, spacing: 6) {
				LabeledContent("style") {
					StyleSelectorView(current: document.qrcode.design.style.actualPupilStyle) { newFill in
						document.qrcode.design.style.pupil = newFill
						document.objectWillChange.send()
					}
				}
				
				Toggle(isOn: $flipped) {
					Text("flipped")
				}
				.disabled(!supportsFlipped)
				.onChange(of: flipped) { newValue in
					_ = document.qrcode.design.shape.pupil?.setSettingValue(newValue, forKey: QRCode.SettingsKey.isFlipped)
					document.objectWillChange.send()
				}

				LabeledContent("corners") {
					CornerPicker(corners: $corners)
				}
				.disabled(!supportsCorners)
				.onChange(of: corners) { newValue in
					_ = document.qrcode.design.shape.pupil?.setSettingValue(newValue.rawValue, forKey: QRCode.SettingsKey.corners)
					document.objectWillChange.send()
				}
			}
			.padding(8)
		}
		.onAppear {
			generator = document.qrcode.design.shape.actualPupilShape
			sync()
		}
	}

	func sync() {
		generator = document.qrcode.design.shape.actualPupilShape

		supportsFlipped = generator.supportsSettingValue(forKey: QRCode.SettingsKey.isFlipped)
		flipped = generator.settingsValue(forKey: QRCode.SettingsKey.isFlipped) ?? false

		supportsCorners = generator.supportsSettingValue(forKey: QRCode.SettingsKey.corners)
		let cnrs = generator.settingsValue(forKey: QRCode.SettingsKey.corners) ?? 0
		corners = QRCode.Corners(rawValue: cnrs)
	}

}

#Preview {
	PupilSettingsView().environmentObject(QRCode_3DDocument())
		.controlSize(.small)
		.frame(maxWidth: 300)
		.frame(height: 400)
}
