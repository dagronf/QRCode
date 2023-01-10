//
//  QRCodeDocumentView.swift
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

// Basic document view for both AppKit/UIKit/tvOS. It provides no additional functionality.
// If you want built-in drag/drop, pasteboard support and customising settings use QRCodeView instead.

#if os(iOS) || os(tvOS)

import UIKit

// MARK: - UIView

/// Very simple QRCode view for displaying a document. No other functionality is provided
@objc public class QRCodeDocumentView: UIView {

	@objc public init(document: QRCode.Document = QRCode.Document()) {
		self.document = document
		super.init(frame: .zero)
		self.isOpaque = false
		self.setNeedsDisplay()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.isOpaque = false
	}

	/// The document to display
	@IBOutlet @objc public var document: QRCode.Document? {
		didSet {
			self.setNeedsDisplay()
		}
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		self.setNeedsDisplay()
	}
}

public extension QRCodeDocumentView {
	override func draw(_ rect: CGRect) {
		if let ctx = UIGraphicsGetCurrentContext() {
			self.document?.draw(ctx: ctx, rect: self.bounds)
		}
	}
}

#endif
