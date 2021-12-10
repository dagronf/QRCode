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
import Foundation

/// A protocol for qr code generation
public protocol QRCodeEngine {
	/// Generator a 2D QR Code
	func generate(_ data: Data, errorCorrection: QRCode.ErrorCorrection) -> Array2D<Bool>?
}

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

	/// The generator to use when generating the QR code.
	public var generator: QRCodeEngine = QRCodeGenerator_CoreImage()

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
		if let result = self.generator.generate(data, errorCorrection: errorCorrection) {
			self.current = result
		}
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
		let backgroundStyle = style.background ?? QRCode.FillStyle.clear
		ctx.usingGState { context in
			backgroundStyle.fill(ctx: context, rect: rect)
		}

		// Draw the outer eye
		let eyeOuterPath = self.path(rect.size, components: .eyeOuter, shape: design.shape)
		ctx.usingGState { context in
			let outerStyle = style.eye ?? style.data
			outerStyle.fill(ctx: context, rect: rect, path: eyeOuterPath)
		}

		// Draw the eye 'pupil'
		let eyePupilPath = self.path(rect.size, components: .eyePupil, shape: design.shape)
		ctx.usingGState { context in
			let pupilStyle = style.pupil ?? style.eye ?? style.data
			pupilStyle.fill(ctx: context, rect: rect, path: eyePupilPath)
		}

		// Now, the 'on' pixels
		let qrPath = self.path(rect.size, components: .onPixels, shape: design.shape)
		ctx.usingGState { context in
			style.data.fill(ctx: context, rect: rect, path: qrPath)
		}

		// The 'off' pixels ONLY IF the user specifies both a data inverted shape AND a data inverted style.
		if let s = style.dataInverted, let _ = design.shape.dataInverted {
			let qrPath = self.path(rect.size, components: .offPixels, shape: design.shape)
			ctx.usingGState { context in
				s.fill(ctx: context, rect: rect, path: qrPath)
			}
		}
	}
}

// MARK: - Ascii representations

public extension QRCode {

	/// Return an ASCII representation of the QR code using the extended ASCII code set
	///
	/// Only makes sense if presented using a fixed-width font
	@objc func asciiRepresentation() -> String {
		var result = ""
		for row in 0 ..< self.current.rows {
			for col in 0 ..< self.current.columns {
				if self.current[row, col] == true {
					result += "██"
				}
				else {
					result += "  "
				}
			}
			result += "\n"
		}
		return result
	}

	/// Returns an small ASCII representation of the QR code (about 1/2 the regular size) using the extended ASCII code set
	///
	/// Only makes sense if presented using a fixed-width font
	@objc func smallAsciiRepresentation() -> String {
		var result = ""
		for row in stride(from: 0, to: self.current.rows, by: 2) {
			for col in 0 ..< self.current.columns {
				let top = self.current[row, col]

				if row <= self.current.rows - 2 {
					let bottom = self.current[row + 1, col]
					if top,!bottom { result += "▀" }
					if !top, bottom { result += "▄" }
					if top, bottom { result += "█" }
					if !top, !bottom { result += " " }
				}
				else {
					if top { result += "▀" }
					else { result += " " }
				}
			}
			result += "\n"
		}
		return result
	}
}

// MARK: - Eye positioning/paths

internal extension QRCode {
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
