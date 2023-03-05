//
//  ContentView.swift
//  QRCode WatchOS Demo WatchKit Extension
//
//  Created by Darren Ford on 10/12/21.
//

import SwiftUI

import QRCode

struct ContentView: View {
	let fixedCode = QRCodeShape(
		text: "QRCode WatchOS Demo",
		errorCorrection: .quantize,
		generator: QRCodeGenerator_External())!

	@State var number: CGFloat = 0

	var dataColor: Color = Color(red: 1.0, green: 1.0, blue: 0.5)
	var eyeColor: Color = .yellow
	var pupilColor: Color = Color(red: 1.0, green: 0.8, blue: 0.3)

	let document: QRCode.Document = {
		let d = QRCode.Document(
			utf8String: "This is a test of the watch view SwiftUI",
			generator: QRCodeGenerator_External())

		let p = CGPath(ellipseIn: CGRect(x: 0.60, y: 0.60, width: 0.40, height: 0.40), transform: nil)
		let logoTemplate = QRCode.LogoTemplate(
			path: p,
			inset: 8,
			image: UIImage(named: "logo")!.cgImage
		)
		d.logoTemplate = logoTemplate

		return d
	}()

	var body: some View {

		let c = Color(hue: number, saturation: 1.0, brightness: 1)

		ScrollView {
			VStack {
				ZStack {
					fixedCode
						.components(.eyeOuter)
						.eyeShape(QRCode.EyeShape.RoundedOuter())
						.fill(eyeColor)
					fixedCode
						.components(.eyePupil)
						.eyeShape(QRCode.EyeShape.RoundedOuter())
						.fill(pupilColor)
					fixedCode
						.components(.onPixels)
						.onPixelShape(QRCode.PixelShape.RoundedPath())
						.fill(c)
				}
				.padding()
				.background(Color(red: 0.0, green: 0.0, blue: 0.2, opacity: 1.0))
				.focusable()
				.digitalCrownRotation(
					$number,
					from: 0.0,
					through: 1.0,
					sensitivity: .low,
					isContinuous: true
				)
				.frame(height: 200)

				QRCodeDocumentUIView(document: self.document)
					.frame(height: 200)
					.padding(8)

			}
		}
		//.onChange(of: number) { print($0) }
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
