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
@available(macOS 11, iOS 14.0, tvOS 14.0, *)
public final class QRCodeViewUI: DSFViewRepresentable {
	public typealias NSViewType = QRCodeView

	/// The data to display in the QR Code
	let data: Data
	/// The error correction level to use
	let errorCorrection: QRCodeView.ErrorCorrection
	/// The color to use when drawing the foreground
	let foregroundColor: Color
	/// The color to use when drawing the background
	let backgroundColor: Color

	/// Create a QR Code view with a UTF8 encoded string
	/// - Parameters:
	///   - text: The text to encode within the control
	///   - errorCorrection: The error correctino level to use
	///   - foregroundColor: The foreground (dots) color when drawing
	///   - backgroundColor: The background color
	public convenience init(text: String,
		  errorCorrection: QRCodeView.ErrorCorrection = .low,
		  foregroundColor: Color = .black,
		  backgroundColor: Color = .white)
	{
		self.init(
			data: text.data(using: .utf8) ?? Data(),
			errorCorrection: errorCorrection,
			foregroundColor: foregroundColor,
			backgroundColor: backgroundColor
		)
	}

	/// Create a QR Code view
	/// - Parameters:
	///   - data: The binary data to encode within the control
	///   - errorCorrection: The error correctino level to use
	///   - foregroundColor: The foreground (dots) color when drawing
	///   - backgroundColor: The background color
	init(data: Data,
		  errorCorrection: QRCodeView.ErrorCorrection = .low,
		  foregroundColor: Color = .black,
		  backgroundColor: Color = .white)
	{
		self.data = data
		self.errorCorrection = errorCorrection
		self.foregroundColor = foregroundColor
		self.backgroundColor = backgroundColor
	}
}

@available(macOS 11, iOS 14.0, tvOS 14.0, *)
extension QRCodeViewUI {
	func updateContent(_ view: QRCodeView, context: Context) {
		view.data = self.data
		view.errorCorrection = self.errorCorrection

#if os(macOS)
		view.foreColor = NSColor(self.foregroundColor).cgColor
		view.backColor = NSColor(self.backgroundColor).cgColor
#else
		view.foreColor = UIColor(self.foregroundColor).cgColor
		view.backColor = UIColor(self.backgroundColor).cgColor
#endif
	}
}

@available(macOS 11, iOS 9999, tvOS 9999, *)
extension QRCodeViewUI {
	public func makeNSView(context: Context) -> QRCodeView {
		return QRCodeView()
	}

	public func updateNSView(_ nsView: QRCodeView, context: Context) {
		self.updateContent(nsView, context: context)
	}
}

@available(iOS 14, tvOS 14, macOS 9999, *)
extension QRCodeViewUI {
	public func makeUIView(context: Context) -> QRCodeView {
		return QRCodeView()
	}

	public func updateUIView(_ uiView: QRCodeView, context: Context) {
		self.updateContent(uiView, context: context)
	}
}

// MARK: - Previews

let DemoContent = "https://goo.gl/maps/Z4d9uVV87gVifrZKA"
let DemoContent2 = "Harness the power of Quartz technology to perform lightweight 2D rendering with high-fidelity output. Handle path-based drawing, antialiased rendering, gradients, images, color management, PDF documents, and more."

@available(macOS 11, iOS 14, tvOS 14, *)
struct QRCodeViewUI_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			HStack {
				VStack {
					Text("Low (L)")
					QRCodeViewUI(text: DemoContent, errorCorrection: .low)
						.frame(width: 150, height: 150)
				}
				VStack {
					Text("Medium (M)")
					QRCodeViewUI(text: DemoContent, errorCorrection: .medium)
						.frame(width: 150, height: 150)
				}
				VStack {
					Text("High (Q)")
					QRCodeViewUI(text: DemoContent, errorCorrection: .high)
						.frame(width: 150, height: 150)
				}
				VStack {
					Text("Max (H)")
					QRCodeViewUI(text: DemoContent, errorCorrection: .max)
						.frame(width: 150, height: 150)
				}
			}

			HStack {
				QRCodeViewUI(text: "caterpillar-noodle", foregroundColor: .red, backgroundColor: .clear)
					.frame(width: 100, height: 100)
				QRCodeViewUI(text: "caterpillar-noodle", foregroundColor: .green, backgroundColor: .clear)
					.frame(width: 100, height: 100)
				QRCodeViewUI(text: "caterpillar-noodle", foregroundColor: .blue, backgroundColor: .clear)
					.frame(width: 100, height: 100)
			}

			HStack {
				QRCodeViewUI(text: "caterpillar-noodle", foregroundColor: .red, backgroundColor: .white)
					.frame(width: 100, height: 100)
				QRCodeViewUI(text: "caterpillar-noodle", foregroundColor: .green, backgroundColor: .white)
					.frame(width: 100, height: 100)
				QRCodeViewUI(text: "caterpillar-noodle", foregroundColor: .blue, backgroundColor: .white)
					.frame(width: 100, height: 100)
			}

			HStack {
				QRCodeViewUI(text: DemoContent2,
								 foregroundColor: Color(.sRGB, red: 0.721, green: 0.376, blue: 0.603, opacity: 1.000),
								 backgroundColor: Color(.sRGB, red: 1.000, green: 0.709, blue: 0.656, opacity: 1.000))
					.frame(width: 150, height: 150)
				QRCodeViewUI(text: DemoContent2)
					.frame(width: 150, height: 150)
				QRCodeViewUI(text: DemoContent2)
					.frame(width: 300, height: 300)
			}
		}
	}
}
