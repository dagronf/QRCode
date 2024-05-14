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
	let d = QRCode.Document(engine: QRCodeEngine_External())

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
		TabView {
			ScrollView(.vertical) {
				VStack {
					PixelBackgroundColorsView()
				}
				.frame(maxWidth: 100000)
			}
			.tabItem { Text("basic") }

			ItemView()
				.tabItem { Text("3d") }
		}
		.padding()
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


////

struct ItemView: View {

	@State var xdegrees = 0.0
	@State var ydegrees = 0.0

	var body: some View {
		VStack {
			Text("Example of using the SwiftUI shape component")
			try! QRCodeShape(
				text: "Wombling, wombling happy time",
				errorCorrection: .high,
				shape: QRCode.Shape(
					onPixels: QRCode.PixelShape.RoundedPath(),
					eye: QRCode.EyeShape.Leaf()
				)
			)
			.fill(.blue) //.shadow(.drop(color: .gray, radius: 3, x: 2, y: 2)))
			.aspectRatio(contentMode: .fit)
			.rotation3DEffect(.degrees(xdegrees), axis: (x: 0, y: 1, z: 0))
			.rotation3DEffect(.degrees(ydegrees), axis: (x: 1, y: 0, z: 0))
			//.border(Color.brown)
			
			.overlay {
				GeometryReader { geo in
					Spacer()
						.onContinuousHover(coordinateSpace: .local, perform: { p in
							let r = geo.frame(in: .local)
							withAnimation(.easeInOut(duration: 0.2)) {
								switch p {
								case .active(let point):
									let offx = point.x - ((r.origin.x + r.width) / 2)
									xdegrees = (offx / r.width * 15)
									let offy = point.y - ((r.origin.y + r.height) / 2)
									ydegrees = (-offy / r.height * 15)
								case .ended:
									xdegrees = 0
									ydegrees = 0
								}
							}
						})
				}
			}
		}
		.padding()
	}
}

#Preview("3d") {
	ItemView()
}
