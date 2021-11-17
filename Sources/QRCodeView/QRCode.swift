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
	@objc public enum ErrorCorrection: Int {
		/// Lowest error correction (L - Recovers 7% of data)
		case low = 0
		/// Medium error correction (M - Recovers 15% of data)
		case medium = 1
		/// High error correction (Q - Recovers 25% of data)
		case high = 2
		/// Maximum error correction (H - Recovers 30% of data)
		case max = 3

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

	/// Build the QR Code using the given data and error correction
	@objc public func generate(_ data: Data, errorCorrection: ErrorCorrection) {
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
	@objc public func generate(text: String, errorCorrection: ErrorCorrection) {
		self.generate(text.data(using: .utf8) ?? Data(), errorCorrection: errorCorrection)
	}

	/// Build the QR Code using the given message formatter and error correction
	@objc public func generate(message: QRCodeMessageFormatter, errorCorrection: ErrorCorrection) {
		self.generate(message.data, errorCorrection: errorCorrection)
	}

	// Private
	private let context = CIContext()
	private let filter = CIFilter(name: "CIQRCodeGenerator")!
	internal var current = Array2D(rows: 0, columns: 0, initialValue: false)
}

// MARK: - QR Code path generation

public extension QRCode {

	/// The type of path to generate
	@objc class PathGeneration: NSObject, OptionSet {
		/// The outer ring of the eye
		public static let eyeOuter = PathGeneration(rawValue: 1 << 0)
		/// The pupil of the eye
		public static let eyePupil = PathGeneration(rawValue: 1 << 1)
		/// The content (non-eye)
		public static let content = PathGeneration(rawValue: 1 << 2)
		/// Path for the content that IS NOT drawn
		public static let unsetContent = PathGeneration(rawValue: 1 << 3)
		/// All components of the eye
		public static let eye: PathGeneration = [PathGeneration.eyeOuter, PathGeneration.eyePupil]
		/// The entire qrcode
		public static let all: PathGeneration = [PathGeneration.eyeOuter, PathGeneration.eyePupil, PathGeneration.content]

		public var rawValue: Int8
		@objc required public init(rawValue: Int8) {
			self.rawValue = rawValue
		}

		// MARK: OptionSet

		public func contains(_ member: QRCode.PathGeneration) -> Bool {
			return (self.rawValue & member.rawValue) != 0
		}
	}

	/// Return a CGPath containing the entire QR code
	@objc func path(
		_ size: CGSize,
		generationType: PathGeneration = .all,
		pixelShape: QRCode.Shape = QRCode.Shape()
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
		let eyeStyle = pixelShape.eyeStyle
		if generationType.contains(.eyeOuter) {
			let p = eyeStyle.eyePath()
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

		if generationType.contains(.eyePupil) {
			let p = eyeStyle.pupilPath()
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
		if generationType.contains(.content) {
			path.addPath(pixelShape.dataShape.onPath(size: size, data: self))
		}

		if generationType.contains(.unsetContent) {
			path.addPath(pixelShape.dataShape.offPath(size: size, data: self))
		}

		return path
	}
}

// MARK: - Eye positioning/paths

public extension QRCode {
	@objc class EyePositions: NSObject {
		@objc init(topLeft: CGRect, topRight: CGRect, bottomLeft: CGRect) {
			self.topLeft = topLeft
			self.topRight = topRight
			self.bottomLeft = bottomLeft
		}

		public let topLeft: CGRect
		public let topRight: CGRect
		public let bottomLeft: CGRect
	}

	/// Returns the eye positions for the given size
	@objc func eyePositions(_ size: CGSize) -> EyePositions {
		let dx = size.width / CGFloat(self.pixelSize)
		let dy = size.height / CGFloat(self.pixelSize)
		let dm = min(dx, dy)
		let xoff = (size.width - (CGFloat(self.pixelSize) * dm)) / 2.0
		let yoff = (size.height - (CGFloat(self.pixelSize) * dm)) / 2.0
		let tl = CGRect(x: xoff, y: yoff, width: 9 * dm, height: 9 * dm)
		let bl = CGRect(x: xoff, y: yoff + (CGFloat(pixelSize) * dm) - (9 * dm), width: 9 * dm, height: 9 * dm)
		let tr = CGRect(x: xoff + (CGFloat(pixelSize) * dm) - (9 * dm), y: yoff, width: 9 * dm, height: 9 * dm)
		return EyePositions(topLeft: tl, topRight: tr, bottomLeft: bl)
	}

	// Is the row/col within an 'eye' of the qr code?
	internal func isEyePixel(_ row: Int, _ col: Int) -> Bool {
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

// MARK: - Image generation

public extension QRCode {
	/// Returns an image representation of the qr code using the specified style
	/// - Parameters:
	///   - size: The pixel size of the image to generate
	///   - scale: The scale
	///   - style: The style to use when generating the image
	/// - Returns: The image, or nil if an error occurred
	@objc func image(_ size: CGSize, scale: CGFloat = 1, style: QRCode.Style = QRCode.Style()) -> CGImage? {
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
		self.draw(ctx: context, rect: CGRect(origin: .zero, size: size), style: style)

		let im = context.makeImage()
		return im
	}

	/// Draw the current qrcode into the context using the specified style
	@objc func draw(ctx: CGContext, rect: CGRect, style: QRCode.Style) {
		// Fill the background first
		ctx.saveGState()
		style.backgroundStyle.fill(ctx: ctx, rect: rect)
		ctx.restoreGState()

		// Now, the pixels
		let qrPath = self.path(rect.size, pixelShape: style.shape)
		ctx.saveGState()
		style.foregroundStyle.fill(ctx: ctx, rect: rect, path: qrPath)
		ctx.restoreGState()
	}
}
