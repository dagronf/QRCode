//
//  ContentView.swift
//  WatchQR WatchKit Extension
//
//  Created by Darren Ford on 12/8/2022.
//

import SwiftUI

import QRCode

let savedDocument: QRCode.Document = {
	let data = NSDataAsset(name: "saved-document")!
	return try! QRCode.Document(
		jsonData: data.data,
		engine: QRCodeEngineExternal()
	)
}()


struct ContentView: View {
	let fixedCode = try! QRCodeShape(
		text: "Generating a QR Code using watchOS - wheeeee!",
		errorCorrection: .quantize
	)

	var dataColor: Color = Color(red: 1.0, green: 1.0, blue: 0.5)
	var eyeColor: Color = .yellow
	var pupilColor: Color = Color(red: 1.0, green: 0.8, blue: 0.3)

	var body: some View {
		ScrollView {
			VStack {

				// Build a QR Code from its components
				ZStack {
					fixedCode
						.components(.eyeOuter)
						.eyeShape(QRCode.EyeShape.RoundedOuter())
						.fill(eyeColor)
					fixedCode
						.components(.eyePupil)
						.pupilShape(QRCode.PupilShape.RoundedOuter())
						.fill(pupilColor)
					fixedCode
						.components(.onPixels)
						.onPixelShape(QRCode.PixelShape.RoundedPath())
						.fill(dataColor)
				}
				.frame(width: 150, height: 150)

				// Use the QRCodeDocumentUIView class to draw a QR document
				QRCodeDocumentUIView(document: savedDocument)
					.frame(width: 150, height: 150)
			}

		}
		//.padding()
		.background(Color(red: 0.0, green: 0.0, blue: 0.2, opacity: 1.0))
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
