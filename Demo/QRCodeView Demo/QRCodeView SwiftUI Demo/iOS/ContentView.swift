//
//  ContentView.swift
//  Shared
//
//  Created by Darren Ford on 8/11/21.
//

import QRCodeView
import SwiftUI

struct ContentView: View {
	@State var content: String = "This is a test of the QR code control"
	@State var correction: QRCodeContent.ErrorCorrection = .low

	@State var foregroundColor: Color = .primary
	@State var eyeColor: Color = .primary
	@State var pupilColor: Color = .primary
	@State var backgroundColor: Color = .clear

	enum PixelType {
		case square
		case roundrect
		case circle
	}
	@State var pixelStyle: PixelType = .square

	enum EyeType {
		case square
		case circle
		case leaf
		case roundedRect
		case roundedOuter
		case roundedPointingIn
	}
	@State var eyeStyle: EyeType = .square

	let gradient = Gradient(colors: [.black, .pink])

	var body: some View {

		let qrContent = QRCodeUI(
			data: content.data(using: .utf8) ?? Data(),
			errorCorrection: correction
		)
		let pixelStyle: QRCodePixelStyle = {
			switch self.pixelStyle {
			case .square:
				return QRCodePixelStyleSquare()
			case .roundrect:
				return QRCodePixelStyleRoundedSquare(cornerRadius: 0.5, edgeInset: 0.5)
			case .circle:
				return QRCodePixelStyleCircle(edgeInset: 0.5)
			}
		}()

		let eyeStyle: QRCodeEyeShape = {
			switch self.eyeStyle {
			case .square:
				return QRCodeEyeStyleSquare()
			case .roundedRect:
				return QRCodeEyeStyleRoundedRect()
			case .circle:
				return QRCodeEyeStyleCircle()
			case .leaf:
				return QRCodeEyeStyleLeaf()
			case .roundedOuter:
				return QRCodeEyeStyleRoundedOuter()
			case .roundedPointingIn:
				return QRCodeEyeStyleRoundedPointingIn()
			}
		}()

		ScrollView {
			VStack {
				VStack(spacing: 0) {
					HStack {
						Text("Content")
						TextField("Text", text: $content)
					}
					Picker(selection: $correction, label: Text("Error correction:")) {
						Text("Low (L)").tag(QRCodeContent.ErrorCorrection.low)
						Text("Medium (M)").tag(QRCodeContent.ErrorCorrection.medium)
						Text("High (Q)").tag(QRCodeContent.ErrorCorrection.high)
						Text("Max (H)").tag(QRCodeContent.ErrorCorrection.max)
					}.pickerStyle(WheelPickerStyle())
					Picker(selection: $pixelStyle, label: Text("Pixel Style:")) {
						Text("Square").tag(PixelType.square)
						Text("Round Rect").tag(PixelType.roundrect)
						Text("Circle").tag(PixelType.circle)
					}.pickerStyle(WheelPickerStyle())
					Picker(selection: $eyeStyle, label: Text("Eye Style:")) {
						Text("Square").tag(EyeType.square)
						Text("Round Rect").tag(EyeType.roundedRect)
						Text("Circle").tag(EyeType.circle)
						Text("Leaf").tag(EyeType.leaf)
						Text("Rounded Outer").tag(EyeType.roundedOuter)
						Text("Rounded Pointing In").tag(EyeType.roundedPointingIn)
					}.pickerStyle(WheelPickerStyle())
					ColorPicker("Foreground", selection: $foregroundColor)
					ColorPicker("Eye Color", selection: $eyeColor)
					ColorPicker("Pupil Color", selection: $pupilColor)
					ColorPicker("Background", selection: $backgroundColor)

				}
				.frame(alignment: .top)
				.padding()

				ZStack {
					backgroundColor
					qrContent
						.masking(.eye)
						.eyeStyle(eyeStyle)
						.fill(eyeColor)
					qrContent
						.masking(.eyePupil)
						.eyeStyle(eyeStyle)
						.fill(pupilColor)
					qrContent
						.masking(.content)
						.pixelStyle(pixelStyle)
						.fill(foregroundColor)
				}
				.frame(width: 250, height: 250, alignment: .center)
				.padding()

				QRCodeUI(
					text: content,
					errorCorrection: .max
				)!
				.eyeStyle(QRCodeEyeStyleLeaf())
				.fill(LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
				.shadow(color: .black, radius: 1, x: 1, y: 1)
				.frame(width: 250, height: 250, alignment: .center)
			}
		}
	}
}
