//
//  ContentView.swift
//  Shared
//
//  Created by Darren Ford on 8/11/21.
//

import SwiftUI
import QRCode

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

	var body: some View {

		let qrContent = QRCodeShape(
			data: content.data(using: .utf8) ?? Data(),
			errorCorrection: correction
		)
		
		let pixelShape = pixelShapeHandler(
			self.pixelShape,
			insetFraction: dataInset,
			cornerRadiusFraction: cornerRadiusFraction)
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
					Text("Square").tag(PixelShapeType.square)
					Text("Round Rect").tag(PixelShapeType.roundedrect)
					Text("Circle").tag(PixelShapeType.circle)
					Text("Squircle").tag(PixelShapeType.squircle)
					Text("Horizontal").tag(PixelShapeType.horizontal)
					Text("Vertical").tag(PixelShapeType.vertical)
					Text("Rounded Path").tag(PixelShapeType.roundedpath)
					Text("Pointy").tag(PixelShapeType.pointy)
				}.pickerStyle(RadioGroupPickerStyle())
				Slider(value: $dataInset, in: 0.0 ... 1.0, label: { Text("Inset") })
				Slider(value: $cornerRadiusFraction, in: 0.0 ... 1.0, label: { Text("Corner Radius") })
				HStack {
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
						Text("Pixels").tag(EyeShapeType.pixels)
					}.pickerStyle(RadioGroupPickerStyle())
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
						Text("Pixels").tag(PupilShapeType.pixels)
					}.pickerStyle(RadioGroupPickerStyle())
				}
				.onChange(of: eyeStyle) { newValue in
					pupilStyle = PupilShapeType(rawValue: newValue.rawValue)!
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
	}
}
