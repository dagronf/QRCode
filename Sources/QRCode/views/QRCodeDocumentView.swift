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

// Basic document view for both AppKit/UIKit/tvOS. It provides no additional functionality.
// If you want built-in drag/drop, pasteboard support and customising settings use QRCodeView instead.

#if os(macOS) || os(iOS) || os(tvOS)

#if os(macOS)
import AppKit
#else
import UIKit
#endif

// MARK: - NSView/UIView

/// Very simple QRCode view for displaying a document. No other functionality is provided
@objc public class QRCodeDocumentView: DSFView {
	#if os(macOS)
	public override var isFlipped: Bool { true }
	public override var isOpaque: Bool { false }
	#endif

	@objc public init(document: QRCode.Document = QRCode.Document()) {
		self.document = document
		super.init(frame: .zero)
		#if !os(macOS)
		self.isOpaque = false
		#endif
		self.setNeedsDisplay()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		#if !os(macOS)
		self.isOpaque = false
		#endif
	}

	/// The document to display
	@IBOutlet @objc public var document: QRCode.Document? {
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
		self.document?.draw(ctx: ctx, rect: self.bounds)
	}
}

#endif
