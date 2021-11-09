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
@IBDesignable public class QRCodeView: DSFView {
	/// The error correction level
	public enum ErrorCorrection: String {
		/// Lowest error correction (Recovers 7% of data)
		case low = "L"
		/// Medium error correction (Recovers 15% of data)
		case medium = "M"
		/// High error correction (Recovers 25% of data)
		case high = "Q"
		/// Maximum error correction (Recovers 30% of data)
		case max = "H"
	}

	/// The correction level to use when generating the QR code
	public var errorCorrection: QRCodeView.ErrorCorrection = .low {
		didSet {
			self.regenerate()
		}
	}

	/// Binary data to display in the QR code
	public var data = Data() {
		didSet {
			self.regenerate()
		}
	}

	/// Text content to display in the QR code
	public var content: String {
		get { String(data: self.data, encoding: .utf8) ?? "" }
		set { self.data = newValue.data(using: .utf8) ?? Data() }
	}

	/// The color to use when drawing the foreground
	public var foreColor = CGColor(gray: 0, alpha: 1) {
		didSet {
			self.setNeedsDisplay()
		}
	}

	/// The color to use when drawing the background
	public var backColor = CGColor(gray: 1, alpha: 1) {
		didSet {
			self.setNeedsDisplay()
		}
	}

	public convenience init() {
		self.init(frame: .zero)
	}

	override public init(frame frameRect: CGRect) {
		super.init(frame: frameRect)
		self.setup()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.setup()
	}

	private func setup() {
		self.regenerate()
	}

	// Private

	#if os(macOS)
	override public var isFlipped: Bool { true }
	#endif

	private let context = CIContext()
	private let filter = CIFilter(name: "CIQRCodeGenerator")!
	private var current: [[Bool]] = []
	private var currentDimension = 0
}

// MARK: - Interface Builder

public extension QRCodeView {
	@IBInspectable var ibCorrectionLevel: Int {
		get { return self.errorCorrection.tag }
		set { self.errorCorrection = QRCodeView.ErrorCorrection.Tag(newValue) }
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
	static func Image(content: String, size: CGSize) -> DSFImage? {
		let v = QRCodeView(frame: CGRect(x: 10000, y: 10000, width: size.width, height: size.height))
		v.content = content
		return v.snapshot()
	}
}


extension QRCodeView {
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
		let dx = r.width / CGFloat(self.currentDimension)
		let dy = r.height / CGFloat(self.currentDimension)

		let dm = min(dx, dy)

		let xoff = (self.bounds.width - (CGFloat(self.currentDimension) * dm)) / 2.0
		let yoff = (self.bounds.height - (CGFloat(self.currentDimension) * dm)) / 2.0

		ctx.setFillColor(self.backColor)
		ctx.fill(self.bounds)

		var rects = [CGRect]()

		for row in 0 ..< self.currentDimension {
			for col in 0 ..< self.currentDimension {
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
		self.currentDimension = 0

		self.filter.setValue(self.data, forKey: "inputMessage")
		self.filter.setValue(self.errorCorrection.rawValue, forKey: "inputCorrectionLevel")

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
		self.currentDimension = w

		self.setNeedsDisplay()
	}
}

extension QRCodeView.ErrorCorrection {
	static func Tag(_ value: Int) -> QRCodeView.ErrorCorrection {
		switch value {
		case 0: return .low
		case 1: return .medium
		case 2: return .high
		case 3: return .max
		default: return .low
		}
	}

	var tag: Int {
		switch self {
		case .low: return 0
		case .medium: return 1
		case .high: return 2
		case .max: return 3
		}
	}
}
