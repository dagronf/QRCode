//
//  ContentView.swift
//  Shared
//
//  Created by Darren Ford on 8/11/21.
//

import QRCode
import SwiftUI

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

	let gradient = Gradient(colors: [.black, .pink])

	var body: some View {

		let qrContent = QRCodeShape(
			data: content.data(using: .utf8) ?? Data(),
			errorCorrection: correction
		)
		let pixelShape = pixelShapeHandler(
			self.pixelShape,
			insetFraction: dataInset,
			cornerRadiusFraction: cornerRadiusFraction,
			rotationFraction: rotationFraction
		)
		let _eyeStyle = eyeShapeHandler(self.eyeStyle)
		let _pupilStyle = pupilShapeHandler(self.pupilStyle)

		ScrollView {
			VStack {
				VStack(spacing: 0) {
					HStack {
						Text("Content")
						TextField("Text", text: $content)
					}
					HStack {
						Picker(selection: $correction, label: Text("Error correction:")) {
							Text("Low (L)").tag(QRCode.ErrorCorrection.low)
							Text("Medium (M)").tag(QRCode.ErrorCorrection.medium)
							Text("Quantize (Q)").tag(QRCode.ErrorCorrection.quantize)
							Text("Max (H)").tag(QRCode.ErrorCorrection.high)
						}.pickerStyle(WheelPickerStyle())

						Picker(selection: $pixelShape, label: Text("Data Shape:")) {
							ForEach(pixelGenerators, id: \.identifier) { gen in
								Text(gen.title).tag(gen.identifier)
							}
						}.pickerStyle(WheelPickerStyle())
					}
					Form {
						Slider(value: $dataInset, in: 0.0 ... 1.0, label: { Text("Inset") })
						Slider(value: $cornerRadiusFraction, in: 0.0 ... 1.0, label: { Text("Corner Radius") })
						Slider(value: $rotationFraction, in: 0.0 ... 1.0, label: { Text("Rotation") })
					}

					HStack {
						Picker(selection: $eyeStyle, label: Text("Eye Shape:")) {
							ForEach(eyeGenerators, id: \.identifier) { gen in
								Text(gen.title).tag(gen.identifier)
							}
						}.pickerStyle(WheelPickerStyle())

						Picker(selection: $pupilStyle, label: Text("Pupil Shape:")) {
							ForEach(pupilGenerators, id: \.identifier) { gen in
								Text(gen.title).tag(gen.identifier)
							}
						}.pickerStyle(WheelPickerStyle())
					}
					.onChange(of: eyeStyle) { newValue in
						pupilStyle = newValue
					}

					ColorPicker("Data Color", selection: $dataColor)
					ColorPicker("Eye Color", selection: $eyeColor)
					ColorPicker("Pupil Color", selection: $pupilColor)
					ColorPicker("Background", selection: $backgroundColor)
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
				}
				.frame(width: 250, height: 250, alignment: .center)
				.padding()

//				QRCodeShape(
//					text: "A static simple QR code with some basic styling",
//					errorCorrection: .high
//				)!
//				.eyeShape(QRCode.EyeShape.Leaf())
//				.onPixelShape(QRCode.PixelShape.RoundedPath())
//				.fill(LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
//				.shadow(color: .black, radius: 1, x: 1, y: 1)
//				.frame(width: 250, height: 250, alignment: .center)
			}
		}
	}
}
