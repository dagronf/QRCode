//
//  QRCodeView.swift
//
//  Created by Darren Ford on 9/11/21.
//

import CoreImage
import SwiftUI

/// SwiftUI implementation of a basic QR Code view
@available(macOS 11, iOS 14.0, tvOS 14.0, *)
final class QRCodeViewUI: DSFViewRepresentable {
	public typealias NSViewType = QRCodeView

	/// The data to display in the QR Code
	let data: Data
	/// The error correction level to use
	let correction: QRCodeView.ErrorCorrection
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
	public convenience init(_ text: String,
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
		self.correction = errorCorrection
		self.foregroundColor = foregroundColor
		self.backgroundColor = backgroundColor
	}
}

@available(macOS 11, iOS 14.0, tvOS 14.0, *)
extension QRCodeViewUI {
	func updateContent(_ view: QRCodeView, context: Context) {
		view.data = self.data
		view.correction = self.correction

#if os(macOS)
		view._foregroundColor = NSColor(self.foregroundColor).cgColor
		view._backgroundColor = NSColor(self.backgroundColor).cgColor
#else
		view._foregroundColor = UIColor(self.foregroundColor).cgColor
		view._backgroundColor = UIColor(self.backgroundColor).cgColor
#endif
	}
}

@available(macOS 11, iOS 9999, tvOS 9999, *)
extension QRCodeViewUI {
	func makeNSView(context: Context) -> QRCodeView {
		return QRCodeView()
	}

	func updateNSView(_ nsView: QRCodeView, context: Context) {
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
					QRCodeViewUI(DemoContent, errorCorrection: .low)
						.frame(width: 150, height: 150)
				}
				VStack {
					Text("Medium (M)")
					QRCodeViewUI(DemoContent, errorCorrection: .medium)
						.frame(width: 150, height: 150)
				}
				VStack {
					Text("High (Q)")
					QRCodeViewUI(DemoContent, errorCorrection: .high)
						.frame(width: 150, height: 150)
				}
				VStack {
					Text("Max (H)")
					QRCodeViewUI(DemoContent, errorCorrection: .highest)
						.frame(width: 150, height: 150)
				}
			}

			HStack {
				QRCodeViewUI("caterpillar-noodle", foregroundColor: .red, backgroundColor: .clear)
					.frame(width: 100, height: 100)
				QRCodeViewUI("caterpillar-noodle", foregroundColor: .green, backgroundColor: .clear)
					.frame(width: 100, height: 100)
				QRCodeViewUI("caterpillar-noodle", foregroundColor: .blue, backgroundColor: .clear)
					.frame(width: 100, height: 100)
			}

			HStack {
				QRCodeViewUI("caterpillar-noodle", foregroundColor: .red, backgroundColor: .white)
					.frame(width: 100, height: 100)
				QRCodeViewUI("caterpillar-noodle", foregroundColor: .green, backgroundColor: .white)
					.frame(width: 100, height: 100)
				QRCodeViewUI("caterpillar-noodle", foregroundColor: .blue, backgroundColor: .white)
					.frame(width: 100, height: 100)
			}

			HStack {
				QRCodeViewUI(DemoContent2,
								 foregroundColor: Color(.sRGB, red: 0.721, green: 0.376, blue: 0.603, opacity: 1.000),
								 backgroundColor: Color(.sRGB, red: 1.000, green: 0.709, blue: 0.656, opacity: 1.000))
					.frame(width: 150, height: 150)
				QRCodeViewUI(DemoContent2)
					.frame(width: 150, height: 150)
				QRCodeViewUI(DemoContent2)
					.frame(width: 300, height: 300)
			}
		}
	}
}
