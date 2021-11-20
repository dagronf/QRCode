//
//  QRCode.swift
//
//  Created by Darren Ford on 15/11/21.
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

// QR Code Generator

import CoreGraphics
import CoreImage
import Foundation
import SwiftUI

/// A QRCode generator class
@objc public class QRCode: NSObject {
	/// The error correction level
	@objc(QRCodeErrorCorrection) public enum ErrorCorrection: Int {
		/// Lowest error correction (L - Recovers 7% of data)
		case low = 0
		/// Medium error correction (M - Recovers 15% of data)
		case medium = 1
		/// High error correction (Q - Recovers 25% of data)
		case high = 2
		/// Maximum error correction (H - Recovers 30% of data)
		case max = 3
		/// The default error correction level if it is not specified by the user
		public static let `default` = ErrorCorrection.high

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

	/// This is the pixel dimension for the QR Code.
	@objc public var pixelSize: Int {
		return self.current.rows
	}

	/// Create a blank QRCode
	@objc override public init() {
		super.init()
		self.update(Data(), errorCorrection: .default)
	}

	/// Create a QRCode with the given data and error correction
	@objc public init(_ data: Data, errorCorrection: ErrorCorrection = .default) {
		super.init()
		self.update(data, errorCorrection: errorCorrection)
	}

	/// Create a QRCode with the given text and error correction
	@objc public init(text: String, errorCorrection: ErrorCorrection = .default) {
		super.init()
		self.update(text: text, errorCorrection: errorCorrection)
	}

	/// Create a QRCode with the given message and error correction
	@objc public init(message: QRCodeMessageFormatter, errorCorrection: ErrorCorrection = .default) {
		super.init()
		self.update(message: message, errorCorrection: errorCorrection)
	}

	/// The QR code content as a 2D array of bool values
	public private(set) var current = Array2D(rows: 0, columns: 0, initialValue: false)

	/// Build the QR Code using the given data and error correction
	@objc public func update(_ data: Data, errorCorrection: ErrorCorrection) {
		self.filter.setValue(data, forKey: "inputMessage")
		self.filter.setValue(errorCorrection.ECLevel, forKey: "inputCorrectionLevel")

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

		self.current = Array2D(rows: w, columns: w, flattened: rawData.map { $0 == 0 ? true : false })
	}

	/// Build the QR Code using the given text and error correction
	@objc public func update(text: String, errorCorrection: ErrorCorrection = .default) {
		self.update(text.data(using: .utf8) ?? Data(), errorCorrection: errorCorrection)
	}

	/// Build the QR Code using the given message formatter and error correction
	@objc public func update(message: QRCodeMessageFormatter, errorCorrection: ErrorCorrection = .default) {
		self.update(message.data, errorCorrection: errorCorrection)
	}

	// Private
	private let context = CIContext()
	private let filter = CIFilter(name: "CIQRCodeGenerator")!
	private let DefaultPDFResolution: CGFloat = 72
}

extension QRCode: NSCopying {
	/// Return a copy of the QR Code
	public func copy(with zone: NSZone? = nil) -> Any {
		let c = QRCode()
		c.current = self.current
		return c
	}
}

// MARK: - QR Code path generation

public extension QRCode {
	/// The components of the QR code
	@objc(QRCodeComponents) class Components: NSObject, OptionSet {
		/// The outer ring of the eye
		public static let eyeOuter = Components(rawValue: 1 << 0)
		/// The pupil (center) of the eye
		public static let eyePupil = Components(rawValue: 1 << 1)
		/// All components of the eye
		public static let eyeAll: Components = [Components.eyeOuter, Components.eyePupil]

		/// The non-eye, 'on' pixels
		public static let onPixels = Components(rawValue: 1 << 2)
		/// The non-eye, 'off' pixels
		public static let offPixels = Components(rawValue: 1 << 3)

		/// The entire qrcode
		public static let all: Components = [Components.eyeOuter, Components.eyePupil, Components.onPixels]

		public var rawValue: Int8
		@objc public required init(rawValue: Int8) {
			self.rawValue = rawValue
		}

		// OptionSet requirement for class implementation (needed for Objective-C)

		public func contains(_ member: QRCode.Components) -> Bool {
			return (self.rawValue & member.rawValue) != 0
		}
	}

	/// Generate a path containing the QR Code components
	/// - Parameters:
	///   - size: The dimensions of the generated path
	///   - components: The components of the QR code to include in the path
	///   - shape: The shape definitions for genering the path components
	/// - Returns: A path containing the components
	@objc func path(
		_ size: CGSize,
		components: Components = .all,
		shape: QRCode.Shape = QRCode.Shape()
	) -> CGPath {
		let dx = size.width / CGFloat(self.pixelSize)
		let dy = size.height / CGFloat(self.pixelSize)

		let dm = min(dx, dy)

		let xoff = (size.width - (CGFloat(self.pixelSize) * dm)) / 2.0
		let yoff = (size.height - (CGFloat(self.pixelSize) * dm)) / 2.0
		let posTransform = CGAffineTransform(translationX: xoff, y: yoff)

		let fitScale = (dm * 9) / 90
		var scaleTransform = CGAffineTransform.identity
		scaleTransform = scaleTransform.scaledBy(x: fitScale, y: fitScale)

		let path = CGMutablePath()

		// The outer part of the eye
		let eyeShape = shape.eye
		if components.contains(.eyeOuter) {
			let p = eyeShape.eyePath()
			var scaledTopLeft = scaleTransform.concatenating(posTransform)

			// top left
			let tl = p.copy(using: &scaledTopLeft)!
			path.addPath(tl)

			// bottom left
			var blt = CGAffineTransform(scaleX: 1, y: -1)
				.concatenating(CGAffineTransform(translationX: 0, y: 90))
				.concatenating(scaledTopLeft)

			var bl = p.copy(using: &blt)!
			var bltrans = CGAffineTransform(translationX: 0, y: (dm * CGFloat(self.pixelSize)) - (9 * dm))
			bl = bl.copy(using: &bltrans)!
			path.addPath(bl)

			// top right
			var tlt = CGAffineTransform(scaleX: -1, y: 1)
				.concatenating(CGAffineTransform(translationX: 90, y: 0))
				.concatenating(scaledTopLeft)

			var br = p.copy(using: &tlt)!
			var brtrans = CGAffineTransform(translationX: (dm * CGFloat(self.pixelSize)) - (9 * dm), y: 0)
			br = br.copy(using: &brtrans)!
			path.addPath(br)
		}

		// Add the pupils if wanted

		if components.contains(.eyePupil) {
			let p = eyeShape.pupilPath()
			var scaledTopLeft = scaleTransform.concatenating(posTransform)

			// top left
			let tl = p.copy(using: &scaledTopLeft)!
			path.addPath(tl)

			// bottom left
			var blt = CGAffineTransform(scaleX: 1, y: -1)
				.concatenating(CGAffineTransform(translationX: 0, y: 90))
				.concatenating(scaledTopLeft)

			var bl = p.copy(using: &blt)!
			var bltrans = CGAffineTransform(translationX: 0, y: (dm * CGFloat(self.pixelSize)) - (9 * dm))
			bl = bl.copy(using: &bltrans)!
			path.addPath(bl)

			// top right
			var tlt = CGAffineTransform(scaleX: -1, y: 1)
				.concatenating(CGAffineTransform(translationX: 90, y: 0))
				.concatenating(scaledTopLeft)

			var br = p.copy(using: &tlt)!
			var brtrans = CGAffineTransform(translationX: (dm * CGFloat(self.pixelSize)) - (9 * dm), y: 0)
			br = br.copy(using: &brtrans)!
			path.addPath(br)
		}

		// 'on' content
		if components.contains(.onPixels) {
			path.addPath(shape.data.onPath(size: size, data: self))
		}

		// 'off' pixels
		if components.contains(.offPixels), let offPixelShape = shape.dataInverted {
			path.addPath(offPixelShape.offPath(size: size, data: self))
		}

		return path
	}
}

// MARK: - Eye positioning/paths

extension QRCode {
	// Is the row/col within an 'eye' of the qr code?
	func isEyePixel(_ row: Int, _ col: Int) -> Bool {
		if row < 9 {
			if col < 9 {
				return true
			}
			if col >= (self.pixelSize - 9) {
				return true
			}
		}
		else if row >= (self.pixelSize - 9), col < 9 {
			return true
		}
		return false
	}
}

// MARK: - Imaging

public extension QRCode {
	/// Returns an image representation of the qr code using the specified style
	/// - Parameters:
	///   - size: The pixel size of the image to generate
	///   - scale: The scale
	///   - design: The design for the qr code
	/// - Returns: The image, or nil if an error occurred
	@objc func image(
		_ size: CGSize,
		scale: CGFloat = 1,
		design: QRCode.Design = QRCode.Design()
	) -> CGImage? {
		let width = Int(size.width)
		let height = Int(size.height)
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		guard let context = CGContext(
			data: nil,
			width: width,
			height: height,
			bitsPerComponent: 8,
			bytesPerRow: 0,
			space: colorSpace,
			bitmapInfo: bitmapInfo.rawValue
		) else {
			return nil
		}

		context.scaleBy(x: 1, y: -1)
		context.translateBy(x: 0, y: -size.height)

		// Draw the qr with the required styles
		self.draw(ctx: context, rect: CGRect(origin: .zero, size: size), design: design)

		let im = context.makeImage()
		return im
	}

	/// Returns an pdf representation of the qr code using the specified style
	/// - Parameters:
	///   - size: The page size of the generated PDF
	///   - pdfResolution: The resolution of the pdf output
	///   - design: The design to use when generating the pdf output
	/// - Returns: A data object containing the PDF representation of the QR code
	@objc func pdfData(
		_ size: CGSize,
		pdfResolution: CGFloat = 72.0,
		design: QRCode.Design = QRCode.Design()
	) -> Data? {
		// Create a PDF context with a single page, and draw into that
		return UsingSinglePagePDFContext(size: size, pdfResolution: pdfResolution) { ctx, drawRect in

			// Need to flip the PDF context as it begins at the bottom right. We want top left.
			let af = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: drawRect.height)
			ctx.concatenate(af)

			// Draw the qr with the required styles
			self.draw(ctx: ctx, rect: drawRect, design: design)
		}
	}

	/// Draw the current qrcode into the context using the specified style
	@objc func draw(ctx: CGContext, rect: CGRect, design: QRCode.Design) {

		let style = design.style

		// Fill the background first
		if let background = style.background {
			ctx.saveGState()
			background.fill(ctx: ctx, rect: rect)
			ctx.restoreGState()
		}

		// Draw the outer eye
		let eyeOuterPath = self.path(rect.size, components: .eyeOuter, shape: design.shape)
		ctx.saveGState()
		let outerStyle = style.eye ?? style.data
		outerStyle.fill(ctx: ctx, rect: rect, path: eyeOuterPath)
		ctx.restoreGState()

		// Draw the eye 'pupil'
		let eyePupilPath = self.path(rect.size, components: .eyePupil, shape: design.shape)
		ctx.saveGState()
		let pupilStyle = style.pupil ?? style.eye ?? style.data
		pupilStyle.fill(ctx: ctx, rect: rect, path: eyePupilPath)
		ctx.restoreGState()

		// Now, the 'on' pixels
		let qrPath = self.path(rect.size, components: .onPixels, shape: design.shape)
		ctx.saveGState()
		style.data.fill(ctx: ctx, rect: rect, path: qrPath)
		ctx.restoreGState()

		// The 'off' pixels ONLY IF the user specifies both a data inverted shape and a data inverted style.
		if let s = style.dataInverted, let _ = design.shape.dataInverted {
			let qrPath = self.path(rect.size, components: .offPixels, shape: design.shape)
			ctx.saveGState()
			s.fill(ctx: ctx, rect: rect, path: qrPath)
			ctx.restoreGState()
		}
	}
}
