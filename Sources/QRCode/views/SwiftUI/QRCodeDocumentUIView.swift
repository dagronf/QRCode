//
//  QRCodeDocumentUIView.swift
//
//  Copyright © 2023 Darren Ford. All rights reserved.
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

#if os(macOS) || os(iOS) || os(tvOS)

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

@available(watchOS 6.0, *)
/// A SwiftUI view for display the content of a QRCode.Document on watchOS
///
/// Builds an image representation of the QR code for display
public struct QRCodeDocumentUIView: View {
	let document: QRCode.Document
	let _image: UIImage

	public init(document: QRCode.Document, cachedImageSize: Int = 300) {
		self.document = document
		self._image = document.uiImage(dimension: cachedImageSize)!
	}

	public var body: some View {
		Image(uiImage: self._image)
			.resizable()
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
