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

#if !os(watchOS)

import CoreGraphics
import CoreImage

#if os(macOS)
import AppKit
#else
import UIKit
#endif

// MARK: - QRCode View

/// A simple NSView/UIView that displays a QR Code
@objc @IBDesignable public class QRCodeView: DSFView {

	/// The qrcode document to render
	@objc public var document = QRCode.Document()

	/// The correction level to use when generating the QR code
	@objc public var errorCorrection: QRCode.ErrorCorrection {
		get { return document.errorCorrection }
		set { document.errorCorrection = newValue; setNeedsDisplay() }
	}

	/// Binary data to display in the QR code
	@objc public var data: Data {
		get { return document.data }
		set { document.data = newValue; setNeedsDisplay() }
	}

	/// The style to use when drawing the qr code
	@objc public var design: QRCode.Design {
		get { return document.design }
		set { document.design = newValue; setNeedsDisplay() }
	}

	/// This is the pixel dimension for the QR Code.  You shouldn't make the view smaller than this
	@objc public var pixelSize: Int {
		get { document.pixelSize }
	}

	@objc public convenience init() {
		self.init(frame: .zero)
	}

	@objc override public init(frame frameRect: CGRect) {
		super.init(frame: frameRect)
		self.setup()
	}

	@objc public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.setup()
	}

	/// Text content to display in the QR code
	@objc @inlinable public func setString(_ text: String) -> Bool {
		guard let msg = text.data(using: .utf8) else { return false }
		self.data = msg
		return true
	}

	/// Set the content of the displayed QR code using the provided message formatter
	@objc @inlinable func setMessage(_ msgType: QRCodeMessageFormatter) {
		self.data = msgType.data
	}
}

// MARK: - Interface Builder conveniences

public extension QRCodeView {
	@IBInspectable var ibCorrectionLevel: String {
		get { return self.errorCorrection.ECLevel }
		set { self.errorCorrection = QRCode.ErrorCorrection.Create(newValue.first ?? "q") ?? .quantize }
	}

	@IBInspectable var ibTextContent: String {
		get { String(data: self.data, encoding: .utf8) ?? "" }
		set { self.data = newValue.data(using: .utf8) ?? Data() }
	}

#if os(macOS)
	@IBInspectable var ibDataColor: NSColor {
		get { NSColor(cgColor: (self.design.style.data as? QRCode.FillStyle.Solid)?.color ?? .black) ?? .black }
		set { self.design.style.data = QRCode.FillStyle.Solid(newValue.cgColor) }
	}

	@IBInspectable var ibEyeColor: NSColor {
		get { NSColor(cgColor: (self.design.style.eye as? QRCode.FillStyle.Solid)?.color ?? .black) ?? .black }
		set { self.design.style.eye = QRCode.FillStyle.Solid(newValue.cgColor) }
	}

	@IBInspectable var ibPupilColor: NSColor {
		get { NSColor(cgColor: (self.design.style.pupil as? QRCode.FillStyle.Solid)?.color ?? .black) ?? .black }
		set { self.design.style.pupil = QRCode.FillStyle.Solid(newValue.cgColor) }
	}

	@IBInspectable var ibBackgroundColor: NSColor {
		get { NSColor(cgColor: (self.design.style.background as? QRCode.FillStyle.Solid)?.color ?? .white) ?? .white }
		set { self.design.style.background = QRCode.FillStyle.Solid(newValue.cgColor) }
	}
#else
	@IBInspectable var ibDataColor: UIColor {
		get { UIColor(cgColor: (self.design.style.data as? QRCode.FillStyle.Solid)?.color ?? CGColor(gray: 0, alpha: 1)) }
		set { self.design.style.data = QRCode.FillStyle.Solid(newValue.cgColor) }
	}

	@IBInspectable var ibEyeColor: UIColor {
		get { UIColor(cgColor: (self.design.style.eye as? QRCode.FillStyle.Solid)?.color ?? CGColor(gray: 0, alpha: 1)) }
		set { self.design.style.eye = QRCode.FillStyle.Solid(newValue.cgColor) }
	}

	@IBInspectable var ibPupilColor: UIColor {
		get { UIColor(cgColor: (self.design.style.pupil as? QRCode.FillStyle.Solid)?.color ?? CGColor(gray: 0, alpha: 1)) }
		set { self.design.style.pupil = QRCode.FillStyle.Solid(newValue.cgColor) }
	}

	@IBInspectable var ibBackgroundColor: UIColor {
		get { UIColor(cgColor: (self.design.style.background as? QRCode.FillStyle.Solid)?.color ?? CGColor(gray: 1, alpha: 1)) }
		set { self.design.style.background = QRCode.FillStyle.Solid(newValue.cgColor) }
	}


#endif

	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		self.setup()
	}
}

// MARK: - Drawing

extension QRCodeView {
#if os(macOS)
	override public var isFlipped: Bool { true }
#endif

	private func setup() {
		self.regenerate()
	}

#if os(macOS)
	override public func draw(_ dirtyRect: NSRect) {
		if let ctx = NSGraphicsContext.current?.cgContext {
			self.draw(ctx)
		}
	}
#else
	override public func draw(_ rect: CGRect) {
		if let ctx = UIGraphicsGetCurrentContext() {
			self.draw(ctx)
		}
	}
#endif

	// Draw the QR Code into the specified context
	private func draw(_ ctx: CGContext) {
		self.document.draw(ctx: ctx, rect: self.bounds)
	}

	// Build up the qr representation
	private func regenerate() {
		self.document.update(self.data, errorCorrection: self.errorCorrection)
		self.setNeedsDisplay()
	}
}

#endif
