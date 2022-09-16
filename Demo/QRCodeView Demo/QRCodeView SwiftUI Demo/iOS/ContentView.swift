//
//  ContentView.swift
//  Shared
//
//  Created by Darren Ford on 8/11/21.
//

import QRCode
import SwiftUI

struct ContentView: View {
	@State var content: String = "This is a test of the QR code control"
	@State var correction: QRCode.ErrorCorrection = .low

	@State var dataColor: Color = .primary
	@State var eyeColor: Color = .primary
	@State var pupilColor: Color = .primary
	@State var backgroundColor: Color = .clear

	@State var pixelShape: PixelShapeType = .square
	@State var eyeStyle: EyeShapeType = .square
	@State var pupilStyle: PupilShapeType = .square

	@State var dataInset: Double = 0
	@State var cornerRadiusFraction: Double = 0.5

	let gradient = Gradient(colors: [.black, .pink])

	var body: some View {

		let qrContent = QRCodeUI(
			data: content.data(using: .utf8) ?? Data(),
			errorCorrection: correction
		)
		let pixelShape = pixelShapeHandler(
			self.pixelShape,
			inset: dataInset,
			cornerRadiusFraction: cornerRadiusFraction)
		let _eyeStyle = eyeShapeHandler(self.eyeStyle)
		let _pupilStyle = pupilShapeHandler(self.pupilStyle)

		ScrollView {
			VStack {
				VStack(spacing: 0) {
					HStack {
						Text("Content")
						TextField("Text", text: $content)
					}
					Picker(selection: $correction, label: Text("Error correction:")) {
						Text("Low (L)").tag(QRCode.ErrorCorrection.low)
						Text("Medium (M)").tag(QRCode.ErrorCorrection.medium)
						Text("Quantize (Q)").tag(QRCode.ErrorCorrection.quantize)
						Text("Max (H)").tag(QRCode.ErrorCorrection.high)
					}.pickerStyle(WheelPickerStyle())

					Picker(selection: $pixelShape, label: Text("Data Shape:")) {
						Text("Square").tag(PixelShapeType.square)
						Text("Round Rect").tag(PixelShapeType.roundedrect)
						Text("Circle").tag(PixelShapeType.circle)
						Text("Squircle").tag(PixelShapeType.squircle)
						Text("Horizontal").tag(PixelShapeType.horizontal)
						Text("Vertical").tag(PixelShapeType.vertical)
						Text("Rounded Path").tag(PixelShapeType.roundedpath)
						Text("Pointy").tag(PixelShapeType.pointy)
					}.pickerStyle(WheelPickerStyle())
					Slider(value: $dataInset, in: 0.0 ... 5.0, label: { Text("Inset") })
					Slider(value: $cornerRadiusFraction, in: 0.0 ... 1.0, label: { Text("Corner Radius") })

					VStack {
						Picker(selection: $eyeStyle, label: Text("Eye Shape:")) {
							Text("Square").tag(EyeShapeType.square)
							Text("Round Rect").tag(EyeShapeType.roundedRect)
							Text("Circle").tag(EyeShapeType.circle)
							Text("Leaf").tag(EyeShapeType.leaf)
							Text("Rounded Outer").tag(EyeShapeType.roundedOuter)
							Text("Rounded Pointing In").tag(EyeShapeType.roundedPointingIn)
							Text("Squircle").tag(EyeShapeType.squircle)
							Text("Bar Horizontal").tag(EyeShapeType.barHorizontal)
							Text("Bar Vertical").tag(EyeShapeType.barVertical)
						}.pickerStyle(WheelPickerStyle())

						Picker(selection: $pupilStyle, label: Text("Pupil Shape:")) {
							Text("Square").tag(PupilShapeType.square)
							Text("Round Rect").tag(PupilShapeType.roundedRect)
							Text("Circle").tag(PupilShapeType.circle)
							Text("Leaf").tag(PupilShapeType.leaf)
							Text("Rounded Outer").tag(PupilShapeType.roundedOuter)
							Text("Rounded Pointing In").tag(PupilShapeType.roundedPointingIn)
							Text("Squircle").tag(PupilShapeType.squircle)
							Text("Bar Horizontal").tag(PupilShapeType.barHorizontal)
							Text("Bar Vertical").tag(PupilShapeType.barVertical)
						}.pickerStyle(WheelPickerStyle())
					}
					.onChange(of: eyeStyle) { newValue in
						pupilStyle = PupilShapeType(rawValue: newValue.rawValue)!
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

				QRCodeUI(
					text: "A static simple QR code with some basic styling",
					errorCorrection: .high
				)!
				.eyeShape(QRCode.EyeShape.Leaf())
				.onPixelShape(QRCode.PixelShape.RoundedPath())
				.fill(LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
				.shadow(color: .black, radius: 1, x: 1, y: 1)
				.frame(width: 250, height: 250, alignment: .center)
			}
		}
	}
}
