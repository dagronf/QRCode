//
//  QRCodeView.swift
//
//  Created by Darren Ford on 9/11/21.
//  Copyright © 2021 Darren Ford. All rights reserved.
//
//  MIT license
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial
//  portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
//  OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import CoreImage
import SwiftUI

/// SwiftUI implementation of a basic QR Code view
@available(macOS 11, iOS 13.0, tvOS 13.0, *)
public struct QRCodeUI: Shape {
	/// Create a QRCode shape using the specified data
	public init(
		data: Data,
		errorCorrection: QRCodeContent.ErrorCorrection = .low,
		masking: QRCodeContent.PathGenerationType = .all,
		pixelStyle: QRCodePixelStyle = QRCodePixelStyleSquare()
	) {
		self.data = data
		self.errorCorrection = errorCorrection
		self.masking = masking
		self.pixelStyle = pixelStyle
		self.generator.generate(data, errorCorrection: errorCorrection)
	}

	/// Create a QRCode shape using the specified text
	public init?(
		text: String,
		errorCorrection: QRCodeContent.ErrorCorrection = .low,
		masking: QRCodeContent.PathGenerationType = .all,
		pixelStyle: QRCodePixelStyle = QRCodePixelStyleSquare()
	) {
		guard let data = text.data(using: .utf8) else { return nil }
		self.data = data
		self.errorCorrection = errorCorrection
		self.masking = masking
		self.pixelStyle = pixelStyle
		self.generator.generate(data, errorCorrection: errorCorrection)
	}

	/// Create a QRCode shape using the specified message formatter
	public init(
		message: QRCodeMessageFormatter,
		errorCorrection: QRCodeContent.ErrorCorrection = .low,
		masking: QRCodeContent.PathGenerationType = .all,
		pixelStyle: QRCodePixelStyle = QRCodePixelStyleSquare()
	) {
		self.data = message.data
		self.errorCorrection = errorCorrection
		self.masking = masking
		self.pixelStyle = pixelStyle
		self.generator.generate(data, errorCorrection: errorCorrection)
	}

	// Private
	private let data: Data
	private let pixelStyle: QRCodePixelStyle
	private let masking: QRCodeContent.PathGenerationType
	private let errorCorrection: QRCodeContent.ErrorCorrection
	private let generator = QRCodeContent()
}

// MARK: - Modifiers

@available(macOS 11, iOS 13.0, tvOS 13.0, *)
public extension QRCodeUI {
	/// Returns a copy of the qrcode using the specified mask
	func masking(_ masking: QRCodeContent.PathGenerationType) -> QRCodeUI {
		return QRCodeUI(
			data: self.data,
			errorCorrection: self.errorCorrection,
			masking: masking,
			pixelStyle: self.pixelStyle
		)
	}

	/// Returns a copy of the qrcode using the specified pixel style
	func pixelStyle(_ style: QRCodePixelStyle) -> QRCodeUI {
		return QRCodeUI(
			data: self.data,
			errorCorrection: self.errorCorrection,
			masking: self.masking,
			pixelStyle: style
		)
	}

	/// Returns a copy of the qrcode using the specified error correction level
	func errorCorrection(_ errorCorrection: QRCodeContent.ErrorCorrection) -> QRCodeUI {
		return QRCodeUI(
			data: self.data,
			errorCorrection: errorCorrection,
			masking: self.masking,
			pixelStyle: self.pixelStyle
		)
	}
}

// MARK: - Paths

@available(macOS 11, iOS 13.0, tvOS 13.0, *)
public extension QRCodeUI {
	/// Returns the path for the qr code
	func path(in rect: CGRect) -> Path {
		let path = self.generator.path(rect.size, generationType: self.masking, pixelStyle: self.pixelStyle)
		return Path(path)
	}
}

// MARK: - Previews

let DemoContent = "https://goo.gl/maps/Z4d9uVV87gVifrZKA"
let DemoContent2 = "Harness the power of Quartz technology to perform lightweight 2D rendering with high-fidelity output. Handle path-based drawing, antialiased rendering, gradients, images, color management, PDF documents, and more."

@available(macOS 11, iOS 14, tvOS 14, *)
struct QRCodeUI_Previews: PreviewProvider {
	static var previews: some View {
		HStack {
			QRCodeUI(text: DemoContent, errorCorrection: .low)!
				.pixelStyle(QRCodePixelStyleRoundedSquare(cornerRadius: 0.5))
				.masking(.all)
		}
//		VStack {
//			HStack {
//				VStack {
//					Text("Low (L)")
//					QRCodeUI(text: DemoContent, errorCorrection: .low)
//						.frame(width: 150, height: 150)
//				}
//				VStack {
//					Text("Medium (M)")
//					QRCodeUI(text: DemoContent, errorCorrection: .medium)
//						.frame(width: 150, height: 150)
//				}
//				VStack {
//					Text("High (Q)")
//					QRCodeUI(text: DemoContent, errorCorrection: .high)
//						.frame(width: 150, height: 150)
//				}
//				VStack {
//					Text("Max (H)")
//					QRCodeUI(text: DemoContent, errorCorrection: .max)
//						.frame(width: 150, height: 150)
//				}
//			}
//
//			HStack {
//				QRCodeUI(text: "caterpillar-noodle")!
//					.fill(.red)
//					.frame(width: 100, height: 100)
//				QRCodeUI(text: "caterpillar-noodle")!
//					.fill(.green)
//					.frame(width: 100, height: 100)
//				QRCodeUI(text: "caterpillar-noodle")!
//					.fill(.blue)
//					.frame(width: 100, height: 100)
//			}
//
//			HStack {
//				QRCodeUI(text: "caterpillar-noodle")!
//					.fill(.red)
//					.frame(width: 100, height: 100)
//				QRCodeUI(text: "caterpillar-noodle")!
//					.fill(.green)
//					.frame(width: 100, height: 100)
//				QRCodeUI(text: "caterpillar-noodle")!
//					.fill(.blue)
//					.frame(width: 100, height: 100)
//			}
//
//			HStack {
//				QRCodeUI(text: DemoContent2)!
//					.fill(.black)
//					.frame(width: 150, height: 150)
//				QRCodeUI(text: DemoContent2)!
//					.fill(.black)
//					.frame(width: 150, height: 150)
//				QRCodeUI(text: DemoContent2)!
//					.fill(.black)
//					.frame(width: 300, height: 300)
//			}
//		}
	}
}

//@available(macOS 11, iOS 13.0, tvOS 13.0, *)
//struct ContentView22: View {
//
//	@State var content: String = "This is a test of the QR code control"
//	@State var correction: QRCodeContent.ErrorCorrection = .low
//	let gradient = Gradient(colors: [.black, .pink])
//
//	var body: some View {
//		VStack {
//			Text("Here is my QR code")
//			QRCodeUI(
//				text: content,
//				errorCorrection: correction
//			)!
//			.fill(LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
//			.frame(width: 250, height: 250, alignment: .center)
//			.shadow(color: .blue, radius: 1, x: 1, y: 1)
//		}
//	}
//}
//
//@available(macOS 11, iOS 14, tvOS 14, *)
//struct ContentView22_Previews: PreviewProvider {
//	static var previews: some View {
//		ContentView22()
//	}
//}
