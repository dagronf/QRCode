//
//  ContentView.swift
//  QRCode WatchOS Demo WatchKit Extension
//
//  Created by Darren Ford on 10/12/21.
//

import SwiftUI
import QRCode

struct ContentView: View {
	let fixedCode = QRCodeUI(text: "QRCode WatchOS Demo", errorCorrection: .quantize)!

	var dataColor: Color = Color(red: 1.0, green: 1.0, blue: 0.5)
	var eyeColor: Color = .yellow
	var pupilColor: Color = Color(red: 1.0, green: 0.8, blue: 0.3)

	var body: some View {
		GeometryReader { g in
			ScrollView {
				VStack {
					Text("Here is my QR Code")
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
							.fill(dataColor)
					}
					.background(Color(red: 0.0, green: 0.0, blue: 0.2, opacity: 1.0))

					.frame(width: g.size.width, height: g.size.width)

					Spacer()
				}
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
