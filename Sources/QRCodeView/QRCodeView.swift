//
//  QRCodeView2.swift
//  SwiftUIQRCode
//
//  Created by Darren Ford on 9/11/21.
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
public class QRCodeView: DSFView {
	/// The error correction level
	public enum ErrorCorrection: String {
		/// Lowest quality (Recovers 7% of data)
		case low = "L"
		/// Medium quality (Recovers 15% of data)
		case medium = "M"
		/// High quality (Recovers 25% of data)
		case high = "Q"
		/// Highest quality (Recovers 30% of data)
		case highest = "H"
	}

	/// The correction level to use when generating the QR code
	public var correction: QRCodeView.ErrorCorrection = .low {
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

	/// The color to use when drawing the foreground
	public var _foregroundColor = CGColor(gray: 0, alpha: 1) {
		didSet {
			self.setNeedsDisplay()
		}
	}

	/// The color to use when drawing the background
	public var _backgroundColor = CGColor(gray: 1, alpha: 1) {
		didSet {
			self.setNeedsDisplay()
		}
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

		ctx.setFillColor(self._backgroundColor)
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
		ctx.setFillColor(self._foregroundColor)
		ctx.fill(rects)
	}

	// Build up the qr representation
	private func regenerate() {
		self.current = []
		self.currentDimension = 0

		self.filter.setValue(self.data, forKey: "inputMessage")
		self.filter.setValue(self.correction.rawValue, forKey: "inputCorrectionLevel")

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
