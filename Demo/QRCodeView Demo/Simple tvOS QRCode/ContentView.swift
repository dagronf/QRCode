//
//  ContentView.swift
//  Simple tvOS QRCode
//
//  Created by Darren Ford on 5/10/2022.
//

import SwiftUI

import QRCode

let qrcode: QRCode.Document = {
	let d = QRCode.Document(generator: QRCodeGenerator_External())
	d.utf8String = "https://www.apple.com.au"
	d.design.foregroundColor(CGColor(gray: 1, alpha: 1))
	d.design.style.background = nil
	d.design.shape.eye = QRCode.EyeShape.Leaf()
	d.design.shape.onPixels = QRCode.PixelShape.RoundedPath(cornerRadiusFraction: 0.5)
	return d
}()

struct ContentView: View {
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
