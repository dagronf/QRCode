//
//  ContentView.swift
//  Shared
//
//  Created by Darren Ford on 8/11/21.
//

import SwiftUI
import QRCodeView

struct ContentView: View {

	@State var content: String = "This is a test of the QR code control"
	@State var correction: QRCodeContent.ErrorCorrection = .low

	@State var foregroundColor: Color = .primary
	@State var eyeColor: Color = .primary
	@State var backgroundColor: Color = .clear

	enum PixelType {
		case square
		case roundrect
		case circle
	}
	@State var pixelStyle: PixelType = .square

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

		HSplitView {
			VStack {
				HStack {
					Text("Content")
					TextField("Text", text: $content)
				}
				Picker(selection: $correction, label: Text("Error correction:")) {
					Text("Low (L)").tag(QRCodeContent.ErrorCorrection.low)
					Text("Medium (M)").tag(QRCodeContent.ErrorCorrection.medium)
					Text("High (Q)").tag(QRCodeContent.ErrorCorrection.high)
					Text("Max (H)").tag(QRCodeContent.ErrorCorrection.max)
				}.pickerStyle(RadioGroupPickerStyle())
				Picker(selection: $pixelStyle, label: Text("Pixel Style:")) {
					Text("Square").tag(PixelType.square)
					Text("Round Rect").tag(PixelType.roundrect)
					Text("Circle").tag(PixelType.circle)
				}.pickerStyle(RadioGroupPickerStyle())
				ColorPicker("Foreground", selection: $foregroundColor)
				ColorPicker("Eye Color", selection: $eyeColor)
				ColorPicker("Background", selection: $backgroundColor)

				Spacer()
			}
			.frame(alignment: .top)
			.padding()

			ZStack {
				backgroundColor
				qrContent
					.masking(.eyesOnly)
					.fill(eyeColor)
				qrContent
					.masking(.contentOnly)
					.pixelStyle(pixelStyle)
					.fill(foregroundColor)
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
