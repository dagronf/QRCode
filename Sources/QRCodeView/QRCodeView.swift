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
	/// The error correction level
	@objc public enum ErrorCorrection: Int {
		/// Lowest error correction (L - Recovers 7% of data)
		case low = 0
		/// Medium error correction (M - Recovers 15% of data)
		case medium = 1
		/// High error correction (Q - Recovers 25% of data)
		case high = 2
		/// Maximum error correction (H - Recovers 30% of data)
		case max = 3
	}

	/// The correction level to use when generating the QR code
	@objc public var errorCorrection: QRCodeView.ErrorCorrection = .low {
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
	@objc public var content: String {
		get { String(data: self.data, encoding: .utf8) ?? "" }
		set { self.data = newValue.data(using: .utf8) ?? Data() }
	}

	/// The color to use when drawing the foreground
	@objc public var foreColor = CGColor(gray: 0, alpha: 1) {
		didSet {
			self.setNeedsDisplay()
		}
	}

	/// The color to use when drawing the background
	@objc public var backColor = CGColor(gray: 1, alpha: 1) {
		didSet {
			self.setNeedsDisplay()
		}
	}

	/// This is the pixel dimension for the QR Code.  You shouldn't make the dimensions smaller than this
	@objc dynamic public private(set) var minDimension = 0

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

	// Private
	private let context = CIContext()
	private let filter = CIFilter(name: "CIQRCodeGenerator")!
	private var current: [[Bool]] = []
}

// MARK: - Interface Builder

public extension QRCodeView {
	@IBInspectable var ibCorrectionLevel: Int {
		get { return self.errorCorrection.rawValue }
		set { self.errorCorrection = QRCodeView.ErrorCorrection(rawValue: newValue) ?? .low }
	}

	@IBInspectable var ibTextContent: String {
		get { String(data: self.data, encoding: .utf8) ?? "" }
		set { self.data = newValue.data(using: .utf8) ?? Data() }
	}

	#if os(macOS)
	@IBInspectable var ibForegroundColor: NSColor {
		get { NSColor(cgColor: self.foreColor) ?? .black }
		set { self.foreColor = newValue.cgColor }
	}

	@IBInspectable var ibBackgroundColor: NSColor {
		get { NSColor(cgColor: self.backColor) ?? .white }
		set { self.backColor = newValue.cgColor }
	}
	#else
	@IBInspectable var ibForegroundColor: UIColor {
		get { UIColor(cgColor: self.foreColor) }
		set { self.foreColor = newValue.cgColor }
	}

	@IBInspectable var ibBackgroundColor: UIColor {
		get { UIColor(cgColor: self.backColor) }
		set { self.backColor = newValue.cgColor }
	}
	#endif

	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		self.setup()
	}
}

public extension QRCodeView {
	/// Generate an image with the qrcode content
	@objc static func Image(content: String, size: CGSize) -> DSFImage? {
		let v = QRCodeView(frame: CGRect(x: 10000, y: 10000, width: size.width, height: size.height))
		v.content = content
		return v.snapshot()
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
		let r = self.bounds
		let dx = r.width / CGFloat(self.minDimension)
		let dy = r.height / CGFloat(self.minDimension)

		let dm = min(dx, dy)

		let xoff = (self.bounds.width - (CGFloat(self.minDimension) * dm)) / 2.0
		let yoff = (self.bounds.height - (CGFloat(self.minDimension) * dm)) / 2.0

		ctx.setFillColor(self.backColor)
		ctx.fill(self.bounds)

		var rects = [CGRect]()

		for row in 0 ..< self.minDimension {
			for col in 0 ..< self.minDimension {
				if self.current[row][col] == true {
					let r = CGRect(x: xoff + (CGFloat(col) * dm), y: yoff + (CGFloat(row) * dm), width: dm, height: dm)
					#if os(macOS)
					rects.append(self.backingAlignedRect(r, options: .alignAllEdgesNearest))
					#else
					rects.append(r)
					#endif
				}
			}
		}
		ctx.setFillColor(self.foreColor)
		ctx.fill(rects)
	}

	// Build up the qr representation
	private func regenerate() {
		self.current = []
		self.minDimension = 0

		self.filter.setValue(self.data, forKey: "inputMessage")
		self.filter.setValue(self.errorCorrection.ECLevel, forKey: "inputCorrectionLevel")

		guard
			let outputImage = filter.outputImage,
			let qrImage = context.createCGImage(outputImage, from: outputImage.extent) else
		{
			return
		}

		let w = qrImage.width
		let h = qrImage.height
		let colorspace = CGColorSpaceCreateDeviceGray()

		var rawData = [UInt8](repeating: 0, count: w * h)
		rawData.withUnsafeMutableBytes { rawBufferPointer in
			let rawPtr = rawBufferPointer.baseAddress!
			let context = CGContext(
				data: rawPtr,
				width: w,
				height: h,
				bitsPerComponent: 8,
				bytesPerRow: w,
				space: colorspace,
				bitmapInfo: 0
			)
			context?.draw(qrImage, in: CGRect(x: 0, y: 0, width: w, height: h))
		}

		var result = Array(repeating: Array(repeating: false, count: w), count: w)
		for r in 0 ..< w {
			for c in 0 ..< w {
				result[r][c] = rawData[r * w + c] == 0 ? true : false
			}
		}

		self.current = result
		self.minDimension = w

		self.setNeedsDisplay()
	}
}

public extension QRCodeView.ErrorCorrection {
	/// Returns the EC Level identifier for the error correction type (L, M, Q, H)
	var ECLevel: String {
		switch self {
		case .low: return "L"
		case .medium: return "M"
		case .high: return "Q"
		case .max: return "H"
		}
	}
}
