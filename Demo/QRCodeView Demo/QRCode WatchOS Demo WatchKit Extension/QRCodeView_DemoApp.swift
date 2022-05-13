//
//  QRCodeView_DemoApp.swift
//  QRCode WatchOS Demo WatchKit Extension
//
//  Created by Darren Ford on 10/12/21.
//

import SwiftUI
import QRCode
import QRCode3rdPartyGenerator

class testing {
	init() {
		let document = QRCode.Document(generator: QRCodeGenerator_3rdParty())
		document.errorCorrection = .quantize
		document.data = "Generating a QR Code using watchOS".data(using: .utf8)!

		let generatedImage = document.uiImage(CGSize(width: 400, height: 400))!
		Swift.print(generatedImage)
	}
}

@main
struct QRCodeView_DemoApp: App {
	let t = testing()
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
