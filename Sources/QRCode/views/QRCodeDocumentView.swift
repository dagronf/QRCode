//
//  QRCodeDocumentView.swift
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

// Basic document views for both AppKit/UIKit and SwiftUI

// MARK: - NSView/UIView

/// Very simple QRCode view for displaying a document. No other functionality is provided
@objc public class QRCodeDocumentView: DSFView {
	#if os(macOS)
	public override var isFlipped: Bool { true }
	#endif

	/// The document to display
	@objc public var document: QRCode.Document = QRCode.Document() {
		didSet {
			self.setNeedsDisplay()
		}
	}
}

public extension QRCodeDocumentView {

#if os(macOS)
	override func draw(_ dirtyRect: NSRect) {
		if let ctx = NSGraphicsContext.current?.cgContext {
			self.draw(ctx)
		}
	}
#else
	override func draw(_ rect: CGRect) {
		if let ctx = UIGraphicsGetCurrentContext() {
			self.draw(ctx)
		}
	}
#endif

	// Draw the QR Code into the specified context
	private func draw(_ ctx: CGContext) {
		self.document.draw(ctx: ctx, rect: self.bounds)
	}
}

// MARK: - SwiftUI

#if canImport(SwiftUI)

import SwiftUI

/// A SwiftUI view for display the content of a QRCode.Document
@available(macOS 11, iOS 13.0, tvOS 13.0, *)
public struct QRCodeDocumentUIView: DSFViewRepresentable {
	public typealias NSViewType = QRCodeDocumentView
	public typealias UIViewType = QRCodeDocumentView

	@Binding var document: QRCode.Document

	public init(document: Binding<QRCode.Document>) {
		self._document = document
	}

	#if os(macOS)
	public func makeNSView(context: Context) -> QRCodeDocumentView {
		let v = QRCodeDocumentView()
		v.document = self.document
		return v
	}

	public func updateNSView(_ nsView: QRCodeDocumentView, context: Context) {
		nsView.document = self.document
		nsView.setNeedsDisplay()
	}
	#else
	public func makeUIView(context: Context) -> QRCodeDocumentView {
		let v = QRCodeDocumentView()
		v.document = self.document
		return v
	}

	public func updateUIView(_ nsView: QRCodeDocumentView, context: Context) {
		nsView.document = self.document
		nsView.setNeedsDisplay()
	}
	#endif
}

@available(macOS 11, iOS 13.0, tvOS 13.0, *)
private let __dummy = QRCode.Document()

@available(macOS 11, iOS 13.0, tvOS 13.0, *)
struct QRCodeDocumentUIView_Previews: PreviewProvider {
	static var previews: some View {
		QRCodeDocumentUIView(document: .constant(__dummy))
	}
}

#endif
