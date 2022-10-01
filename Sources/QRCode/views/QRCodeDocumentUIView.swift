//
//  QRCodeDocumentUIView.swift
//
//  Copyright © 2022 Darren Ford. All rights reserved.
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

// QRCode.Document based SwiftUI view for macOS/iOS/tvOS and watchOS

#if canImport(SwiftUI)

import SwiftUI

// MARK: - macOS/iOS/tvOS implementation

#if os(macOS) || os(iOS)

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
/// A SwiftUI view for display the content of a QRCode.Document
public struct QRCodeDocumentUIView: DSFViewRepresentable {
	public typealias NSViewType = QRCodeDocumentView
	public typealias UIViewType = QRCodeDocumentView

	// The document to display
	@ObservedObject private var document: QRCode.Document

	public init(document: QRCode.Document, generator: QRCodeEngine? = nil) {
		self.document = document
	}

	#if os(macOS)
	public func makeNSView(context: Context) -> QRCodeDocumentView {
		let v = QRCodeDocumentView(document: self.document)
		return v
	}

	public func updateNSView(_ nsView: QRCodeDocumentView, context: Context) {
		nsView.document = self.document
		nsView.setNeedsDisplay()
	}
	#else
	public func makeUIView(context: Context) -> QRCodeDocumentView {
		return QRCodeDocumentView(document: self.document)
	}

	public func updateUIView(_ nsView: QRCodeDocumentView, context: Context) {
		nsView.document = self.document
		nsView.setNeedsDisplay()
	}
	#endif
}

#endif

// MARK: - watchOS implementation

#if os(watchOS)

import SwiftUI

@available(watchOS 8.0, *)
/// A SwiftUI view for display the content of a QRCode.Document on watchOS (v8 and above for AnyStyleShape)
public struct QRCodeDocumentUIView: View {
	let document: QRCode.Document

	public init(document: QRCode.Document) {
		self.document = document
	}

	public var body: some View {

		let qrCodeRepresentation = QRCodeUI(
			data: document.data,
			errorCorrection: document.errorCorrection,
			generator: document.qrcode.generator
		)

		GeometryReader { geo in

			let dimension = max(geo.size.width, geo.size.height)

			ZStack {
				if let backgroundStyle = document.design.style.background,
					let style = convertStyle(backgroundStyle, dimension: dimension)
				{
					Rectangle()
						.fill(style)
				}

				// Draw the 'on' pixels
				qrCodeRepresentation
					.components(.onPixels)
					.onPixelShape(document.design.shape.onPixels)
					.fill(convertStyle(document.design.style.onPixels, dimension: dimension))

				// Draw the outer part of the eye
				qrCodeRepresentation
					.components(.eyeOuter)
					.eyeShape(document.design.shape.eye)
					.fill(convertStyle(document.design.style.actualEyeStyle, dimension: dimension))

				// Draw the pupil
				qrCodeRepresentation
					.components(.eyePupil)
					.pupilShape(document.design.shape.actualPupilShape)
					.fill(convertStyle(document.design.style.actualPupilStyle, dimension: dimension))

				// If the document has a style and shape for the 'off' pixels, draw them
				if let offPixels = document.design.shape.offPixels,
					let offStyle = document.design.style.offPixels
				{
					qrCodeRepresentation
						.components(.offPixels)
						.onPixelShape(offPixels)
						.fill(convertStyle(offStyle, dimension: dimension))
				}
			}
		}
	}

	// Map between QR code styles and SwiftUI ShapeStyles
	private func convertStyle(_ q: QRCodeFillStyleGenerator?, dimension: CGFloat) -> AnyShapeStyle {
		if let c = q as? QRCode.FillStyle.Solid {
			return AnyShapeStyle(c.colorUI())
		}
		else if let c = q as? QRCode.FillStyle.LinearGradient {
			return AnyShapeStyle(c.linearGradient())
		}
		else if let c = q as? QRCode.FillStyle.RadialGradient {
			return AnyShapeStyle(c.radialGradient(startRadius: 0, endRadius: dimension))
		}
		return AnyShapeStyle(Color.red)
	}
}

#endif

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 8, *)
private let __dummy = QRCode.Document()

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 8, *)
struct QRCodeDocumentUIView_Previews: PreviewProvider {
	static var previews: some View {
		QRCodeDocumentUIView(document: __dummy)
	}
}

#endif
