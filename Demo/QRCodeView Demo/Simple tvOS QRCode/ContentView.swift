//
//  ContentView.swift
//  Simple tvOS QRCode
//
//  Created by Darren Ford on 5/10/2022.
//

import SwiftUI

import QRCode

struct ContentView: View {
	let qrcode = try! QRCode.build
		.engine(QRCodeEngineExternal())
		.url(URL(string: "https://www.apple.com.au")!)
		.foregroundColor(CGColor(gray: 1, alpha: 1))
		.backgroundColor(CGColor(gray: 0, alpha: 0))
		.eye.shape(QRCode.EyeShape.Leaf())
		.document

    var body: some View {
        VStack {
			  QRCodeDocumentUIView(document: qrcode)
				  .aspectRatio(contentMode: .fit)
            Text("Scan this code with your phone to visit Apple online")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
