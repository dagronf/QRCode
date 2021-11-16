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

	// The qrcode content generator
	private let qrCodeContent = QRCodeContent()

	/// The correction level to use when generating the QR code
	@objc public var errorCorrection: QRCodeContent.ErrorCorrection = .low {
		didSet {
			self.regenerate()
		}
	}

	/// Binary data to display in the QR code
	@objc public var data = Data() {
		didSet {
			self.regenerate()
		}
	}

	/// Text content to display in the QR code
	@objc public var textContent: String {
		get { String(data: self.data, encoding: .utf8) ?? "" }
		set { self.data = newValue.data(using: .utf8) ?? Data() }
	}

	/// The style to use when drawing the qr code
	@objc public var style = QRCodeContent.Style() {
		didSet {
			self.setNeedsDisplay()
		}
	}

	/// This is the pixel dimension for the QR Code.  You shouldn't make the dimensions smaller than this
	@objc public var pixelSize: Int {
		return self.qrCodeContent.pixelSize
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

	@objc func setMessage(_ msgType: QRCodeMessageFormatter) {
		self.data = msgType.data
	}
}

// MARK: - Interface Builder

public extension QRCodeView {
	@IBInspectable var ibCorrectionLevel: Int {
		get { return self.errorCorrection.rawValue }
		set { self.errorCorrection = QRCodeContent.ErrorCorrection(rawValue: newValue) ?? .low }
	}

	@IBInspectable var ibTextContent: String {
		get { String(data: self.data, encoding: .utf8) ?? "" }
		set { self.data = newValue.data(using: .utf8) ?? Data() }
	}

	#if os(macOS)
	@IBInspectable var ibForegroundColor: NSColor {
		get { NSColor(cgColor: (self.style.foregroundStyle as? QRCodeFillStyleSolid)?.color ?? .black) ?? .black }
		set { self.style.foregroundStyle = QRCodeFillStyleSolid(newValue.cgColor) }
	}

	@IBInspectable var ibBackgroundColor: NSColor {
		get { NSColor(cgColor: (self.style.backgroundStyle as? QRCodeFillStyleSolid)?.color ?? .white) ?? .white }
		set { self.style.backgroundStyle = QRCodeFillStyleSolid(newValue.cgColor) }
	}
	#else
	@IBInspectable var ibForegroundColor: UIColor {
		get { UIColor(cgColor: (self.style.foregroundStyle as? QRCodeFillStyleSolid)?.color ?? CGColor(gray: 0, alpha: 1)) }
		set { self.style.foregroundStyle = QRCodeFillStyleSolid(newValue.cgColor) }
	}

	@IBInspectable var ibBackgroundColor: UIColor {
		get { UIColor(cgColor: (self.style.backgroundStyle as? QRCodeFillStyleSolid)?.color ?? CGColor(gray: 1, alpha: 1)) }
		set { self.style.backgroundStyle = QRCodeFillStyleSolid(newValue.cgColor) }
	}
	#endif

	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		self.setup()
	}
}

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
		self.qrCodeContent.draw(ctx: ctx, rect: self.bounds, style: self.style)
	}

	// Build up the qr representation
	private func regenerate() {
		self.qrCodeContent.generate(self.data, errorCorrection: self.errorCorrection)
		self.setNeedsDisplay()
	}
}
