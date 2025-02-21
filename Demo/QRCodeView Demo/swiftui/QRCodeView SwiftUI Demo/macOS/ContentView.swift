//
//  ContentView.swift
//  Shared
//
//  Created by Darren Ford on 8/11/21.
//

import SwiftUI
import QRCode

struct StyleIdentifier {
	let identifier: String
	let title: String
}

let pixelGenerators: [StyleIdentifier] = {
	QRCodePixelShapeFactory.shared.availableGeneratorNames.map {
		let gen = try! QRCodePixelShapeFactory.shared.named($0)
		return StyleIdentifier(identifier: gen.name, title: gen.title)
	}
}()

let eyeGenerators: [StyleIdentifier] = {
	QRCodeEyeShapeFactory.shared.availableGeneratorNames.map {
		let gen = try! QRCodeEyeShapeFactory.shared.named($0)
		return StyleIdentifier(identifier: gen.name, title: gen.title)
	}
}()

let pupilGenerators: [StyleIdentifier] = {
	QRCodePupilShapeFactory.shared.availableGeneratorNames.map {
		let gen = try! QRCodePupilShapeFactory.shared.named($0)
		return StyleIdentifier(identifier: gen.name, title: gen.title)
	}
}()

struct ContentView: View {

	@State var content: String = "This is a test of the QR code control"
	@State var correction: QRCode.ErrorCorrection = .low

	@State var dataColor: Color = .primary
	@State var eyeColor: Color = .primary
	@State var pupilColor: Color = .primary
	@State var backgroundColor: Color = .clear

	@State var pixelShape: String = "square"
	@State var eyeStyle: String = "square"
	@State var pupilStyle: String = "square"

	@State var dataInset: Double = 0
	@State var cornerRadiusFraction: Double = 0.5
	@State var rotationFraction: Double = 0.0

	@State var randomInset: Bool = false

	var body: some View {

		let qrContent = QRCodeShape(
			data: content.data(using: .utf8) ?? Data(),
			errorCorrection: correction
		)
		
		let pixelShape = pixelShapeHandler(
			self.pixelShape,
			insetFraction: dataInset,
			cornerRadiusFraction: cornerRadiusFraction,
			rotationFraction: rotationFraction,
			randomInset: randomInset
		)
		let _eyeStyle = eyeShapeHandler(self.eyeStyle)
		let _pupilStyle = pupilShapeHandler(self.pupilStyle)

		HSplitView {
			VStack {
				HStack {
					Text("Content")
					TextField("Text", text: $content)
				}
				Picker(selection: $correction, label: Text("Error correction:")) {
					Text("Low (L)").tag(QRCode.ErrorCorrection.low)
					Text("Medium (M)").tag(QRCode.ErrorCorrection.medium)
					Text("Quantize (Q)").tag(QRCode.ErrorCorrection.quantize)
					Text("High (H)").tag(QRCode.ErrorCorrection.high)
				}.pickerStyle(RadioGroupPickerStyle())
				Picker(selection: $pixelShape, label: Text("Data Shape:")) {
					ForEach(pixelGenerators, id: \.identifier) { gen in
						Text(gen.title).tag(gen.identifier)
					}
				}.pickerStyle(MenuPickerStyle())
				HStack {
					Slider(value: $dataInset, in: 0.0 ... 1.0, label: { Text("Inset") })
					Toggle("Random", isOn: $randomInset)
				}
				Slider(value: $cornerRadiusFraction, in: 0.0 ... 1.0, label: { Text("Corner Radius") })
				Slider(value: $rotationFraction, in: 0.0 ... 1.0, label: { Text("Rotation") })
				HStack {
					Picker(selection: $eyeStyle, label: Text("Eye Shape:")) {
						ForEach(eyeGenerators, id: \.identifier) { gen in
							Text(gen.title).tag(gen.identifier)
						}
					}.pickerStyle(MenuPickerStyle())
					Picker(selection: $pupilStyle, label: Text("Pupil Shape:")) {
						ForEach(pupilGenerators, id: \.identifier) { gen in
							Text(gen.title).tag(gen.identifier)
						}
					}.pickerStyle(MenuPickerStyle())
				}
				.onChange(of: eyeStyle) { newValue in
					let dp = eyeShapeHandler(newValue).defaultPupil().name
					pupilStyle = dp // _eyeStyle.defaultPupil().name
				}

				HStack {
					ColorPicker("Data Color", selection: $dataColor)
					ColorPicker("Background", selection: $backgroundColor)
				}
				HStack {
					ColorPicker("Eye Color", selection: $eyeColor)
					ColorPicker("Pupil Color", selection: $pupilColor)
				}

				Spacer()
			}
			.frame(alignment: .top)
			.padding()

			ZStack {
				backgroundColor
				qrContent
					.components(.eyeOuter)
					.eyeShape(_eyeStyle)
					.fill(eyeColor)
				qrContent
					.components(.eyePupil)
					.pupilShape(_pupilStyle)
					.fill(pupilColor)
				qrContent
					.components(.onPixels)
					.onPixelShape(pixelShape)
					.fill(dataColor)
//				qrContent
//					.components(.offPixels)
//					.offPixelShape(pixelShape)
//					.fill(.gray.opacity(0.2))
			}
			.frame(alignment: .center)
			.padding()

		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
		ContentView()
			.environment(\.locale, Locale(identifier: "en"))
	}
}
