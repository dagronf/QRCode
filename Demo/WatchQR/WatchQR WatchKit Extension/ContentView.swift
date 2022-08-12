//
//  ContentView.swift
//  WatchQR WatchKit Extension
//
//  Created by Darren Ford on 12/8/2022.
//

import SwiftUI

import QRCode
import QRCode3rdPartyGenerator

struct ContentView: View {

	let fixedCode = QRCodeUI(
		text: "Generating a QR Code using watchOS - wheeeee!",
		errorCorrection: .quantize,
		generator: QRCodeGenerator_WatchOS())!

	var dataColor: Color = Color(red: 1.0, green: 1.0, blue: 0.5)
	var eyeColor: Color = .yellow
	var pupilColor: Color = Color(red: 1.0, green: 0.8, blue: 0.3)

	var body: some View {
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
				.pixelShape(QRCode.PixelShape.RoundedPath())
				.fill(dataColor)
		}
		.padding()
		.background(Color(red: 0.0, green: 0.0, blue: 0.2, opacity: 1.0))
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
