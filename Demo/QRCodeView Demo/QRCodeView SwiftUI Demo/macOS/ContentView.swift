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
	@State var correction: QRCode.ErrorCorrection = .low

	@State var dataColor: Color = .primary
	@State var eyeColor: Color = .primary
	@State var pupilColor: Color = .primary
	@State var backgroundColor: Color = .clear

	enum DataShapeType {
		case square
		case roundrect
		case circle
		case horizontal
		case vertical
	}
	@State var dataShape: DataShapeType = .square

	enum EyeShapeType {
		case square
		case circle
		case leaf
		case roundedRect
		case roundedOuter
		case roundedPointingIn
	}
	@State var eyeStyle: EyeShapeType = .square

	var body: some View {

		let qrContent = QRCodeUI(
			data: content.data(using: .utf8) ?? Data(),
			errorCorrection: correction
		)
		let dataShape: QRCodeDataShape = {
			switch self.dataShape {
			case .square:
				return QRCodeDataShapePixel(pixelType: .square)
			case .roundrect:
				return QRCodeDataShapePixel(pixelType: .roundedRect, cornerRadiusFraction: 0.7)
			case .circle:
				return QRCodeDataShapePixel(pixelType: .circle)
			case .horizontal:
				return QRCodeDataShapeHorizontal(inset: 1, cornerRadiusFraction: 1)
			case .vertical:
				return QRCodeDataShapeVertical(inset: 1, cornerRadiusFraction: 1)
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

		HSplitView {
			VStack {
				HStack {
					Text("Content")
					TextField("Text", text: $content)
				}
				Picker(selection: $correction, label: Text("Error correction:")) {
					Text("Low (L)").tag(QRCode.ErrorCorrection.low)
					Text("Medium (M)").tag(QRCode.ErrorCorrection.medium)
					Text("High (Q)").tag(QRCode.ErrorCorrection.high)
					Text("Max (H)").tag(QRCode.ErrorCorrection.max)
				}.pickerStyle(RadioGroupPickerStyle())
				Picker(selection: $dataShape, label: Text("Data Shape:")) {
					Text("Square").tag(DataShapeType.square)
					Text("Round Rect").tag(DataShapeType.roundrect)
					Text("Circle").tag(DataShapeType.circle)
					Text("Horizontal").tag(DataShapeType.horizontal)
					Text("Vertical").tag(DataShapeType.vertical)
				}.pickerStyle(RadioGroupPickerStyle())
				Picker(selection: $eyeStyle, label: Text("Eye Shape:")) {
					Text("Square").tag(EyeShapeType.square)
					Text("Round Rect").tag(EyeShapeType.roundedRect)
					Text("Circle").tag(EyeShapeType.circle)
					Text("Leaf").tag(EyeShapeType.leaf)
					Text("Rounded Outer").tag(EyeShapeType.roundedOuter)
				}.pickerStyle(RadioGroupPickerStyle())
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
					.components(.eye)
					.eyeShape(eyeStyle)
					.fill(eyeColor)
				qrContent
					.components(.eyePupil)
					.eyeShape(eyeStyle)
					.fill(pupilColor)
				qrContent
					.components(.content)
					.dataShape(dataShape)
					.fill(dataColor)
//				qrContent
//					.components(.unsetContent)
//					.dataShape(dataShape)
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
