//
//  ContentView.swift
//  SwiftUI Demos
//
//  Created by Darren Ford on 9/1/2023.
//

import SwiftUI
import QRCode

extension CGImage {
	/// Load a CGImage from an image resource
	@inlinable static func named(_ name: String) -> CGImage? {
		#if os(macOS)
		NSImage(named: name)?.cgImage(forProposedRect: nil, context: nil, hints: nil)
		#else
		UIImage(named: name)?.cgImage
		#endif
	}
}

let doc1: QRCode.Document = {
	let d = QRCode.Document(generator: QRCodeGenerator_External())

	d.utf8String = "https://www.swift.org"

	d.design.backgroundColor(CGColor(gray: 0, alpha: 0))

	d.design.style.eye = QRCode.FillStyle.Solid(gray: 1)
	d.design.style.eyeBackground = CGColor(gray: 0, alpha: 0.3)

	d.design.shape.onPixels = QRCode.PixelShape.Square(insetFraction: 0.7)
	d.design.style.onPixels = QRCode.FillStyle.Solid(gray: 1)
	d.design.style.onPixelsBackground = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 0.3)

	d.design.shape.offPixels = QRCode.PixelShape.Square(insetFraction: 0.7)
	d.design.style.offPixels = QRCode.FillStyle.Solid(gray: 0)
	d.design.style.offPixelsBackground = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.3)

	d.design.style.background = QRCode.FillStyle.Image(CGImage.named("Apple_Swift_Logo"))

	return d
}()

struct ContentView: View {
	var body: some View {
		ScrollView(.vertical) {
			VStack {
				PixelBackgroundColorsView()
			}
			.frame(maxWidth: 100000)
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

// -

struct PixelBackgroundColorsView: View {
	var body: some View {
		VStack {
			Text("A logo with an overlaid QRCode.")
			Text("Note: The Eye color must match the on pixel color")
			QRCodeDocumentUIView(document: doc1)
				.frame(width: 300, height: 300)
		}
	}
}

struct PixelBackgroundColorsView_Previews: PreviewProvider {
	static var previews: some View {
		PixelBackgroundColorsView()
	}
}
