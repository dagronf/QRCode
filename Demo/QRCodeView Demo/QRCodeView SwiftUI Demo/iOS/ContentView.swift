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

	@State var dataShape: DataShapeType = .square
	@State var eyeStyle: EyeShapeType = .square

	@State var dataInset: Double = 0
	@State var cornerRadiusFraction: Double = 0.5

	let gradient = Gradient(colors: [.black, .pink])

	var body: some View {

		let qrContent = QRCodeUI(
			data: content.data(using: .utf8) ?? Data(),
			errorCorrection: correction
		)
		let dataShape = dataShapeHandler(
			self.dataShape,
			inset: dataInset,
			cornerRadiusFraction: cornerRadiusFraction)
		let eyeStyle = eyeShapeHandler(self.eyeStyle)

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

					Picker(selection: $dataShape, label: Text("Data Shape:")) {
						Text("Square").tag(DataShapeType.square)
						Text("Round Rect").tag(DataShapeType.roundedrect)
						Text("Circle").tag(DataShapeType.circle)
						Text("Squircle").tag(DataShapeType.squircle)
						Text("Horizontal").tag(DataShapeType.horizontal)
						Text("Vertical").tag(DataShapeType.vertical)
						Text("Rounded Path").tag(DataShapeType.roundedpath)
						Text("Pointy").tag(DataShapeType.pointy)
					}.pickerStyle(WheelPickerStyle())
					Slider(value: $dataInset, in: 0.0 ... 5.0, label: { Text("Inset") })
					Slider(value: $cornerRadiusFraction, in: 0.0 ... 1.0, label: { Text("Corner Radius") })

					Picker(selection: $eyeStyle, label: Text("Eye Shape:")) {
						Text("Square").tag(EyeShapeType.square)
						Text("Round Rect").tag(EyeShapeType.roundedRect)
						Text("Circle").tag(EyeShapeType.circle)
						Text("Leaf").tag(EyeShapeType.leaf)
						Text("Rounded Outer").tag(EyeShapeType.roundedOuter)
						Text("Rounded Pointing In").tag(EyeShapeType.roundedPointingIn)
						Text("Squircle").tag(EyeShapeType.squircle)
					}.pickerStyle(WheelPickerStyle())
					
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
						.eyeShape(eyeStyle)
						.fill(eyeColor)
					qrContent
						.components(.eyePupil)
						.eyeShape(eyeStyle)
						.fill(pupilColor)
					qrContent
						.components(.onPixels)
						.dataShape(dataShape)
						.fill(dataColor)
				}
				.frame(width: 250, height: 250, alignment: .center)
				.padding()

				QRCodeUI(
					text: "A static simple QR code with some basic styling",
					errorCorrection: .high
				)!
				.eyeShape(QRCode.EyeShape.Leaf())
				.dataShape(QRCode.DataShape.RoundedPath())
				.fill(LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
				.shadow(color: .black, radius: 1, x: 1, y: 1)
				.frame(width: 250, height: 250, alignment: .center)
			}
		}
	}
}
