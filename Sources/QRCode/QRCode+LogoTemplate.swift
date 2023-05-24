//
//  QRCode+Logo.swift
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

import CoreGraphics
import Foundation
import SwiftImageReadWrite

public extension QRCode {
	/// A QRCode logo template
	@objc(QRCodeLogoTemplate) class LogoTemplate: NSObject, Codable {
		/// A CGPath with the bounds x=0, y=0, width=1, height=1 in which to draw the image
		@objc public var path: CGPath {
			didSet {
				let bounds = self.path.boundingBoxOfPath
				assert(bounds.minX >= 0 && bounds.maxX <= 1)
				assert(bounds.minY >= 0 || bounds.maxY <= 1)
			}
		}

		/// The image to display.
		///
		/// If no image is provided, the mask is still applied to the QR code when generating.
		@objc public let image: CGImage

		/// An image to use as a mask for the logo.
		@objc public let maskImage: CGImage?

		/// If true, removes pixels under the drawn image
		@objc public let masksQRCodePixels: Bool

		/// Create a logo using an image and a drawing path
		/// - Parameters:
		///   - image: The image to display in the logo
		///   - path: The bounds path for the logo (0,0 -> 1, 1) within the QR code
		///   - inset: The inset from the path bounds to draw the image
		///   - masksQRCodePixels: If true, removes pixels underneath the drawn image
		@objc public init(
			image: CGImage,
			path: CGPath,
			inset: CGFloat = 0,
			masksQRCodePixels: Bool = true
		) {
			/// Check that the path bounds are 0,0 -> 1,1
			let bounds = path.boundingBoxOfPath
			assert(bounds.minX >= 0 && bounds.maxX <= 1)
			assert(bounds.minY >= 0 || bounds.maxY <= 1)
			assert(inset >= 0)

			self.image = image
			self.path = path
			self.inset = inset
			self.useImageMasking = false
			self.maskImage = nil
			self.masksQRCodePixels = masksQRCodePixels
		}

		/// Create a logo using an image and a drawing path
		/// - Parameters:
		///   - image: The logo image to display
		///   - maskImage: The mask to apply when drawing the image
		///   - masksQRCodePixels: If true, removes pixels underneath the drawn image
		@objc public init(
			image: CGImage,
			maskImage: CGImage? = nil,
			masksQRCodePixels: Bool = true
		) {
			self.path = CGPath(rect: CGRect(origin: .zero, size: .init(dimension: 1.0)), transform: nil)
			self.image = image
			self.maskImage = maskImage
			self.inset = 0
			self.useImageMasking = true
			self.masksQRCodePixels = masksQRCodePixels
		}

		/// Create a LogoTemplate from a dictionary of settings
		@objc public init?(settings: [String: Any]) {
			guard
				let pathB64 = settings["relativeMaskPath"] as? String,
				let path = try? CGPathCodable.decodeBase64(pathB64)
			else {
				return nil
			}
			self.path = path
			self.inset = DoubleValue(settings["inset"]) ?? 0

			self.useImageMasking = BoolValue(settings["maskUsingImageTransparency"]) ?? false
			self.masksQRCodePixels = BoolValue(settings["masksQRCodePixels"]) ?? true

			guard let image = CGImageValueFromB64String(settings["image"]) else { return nil }
			self.image = image
			self.maskImage = CGImageValueFromB64String(settings["maskImage"])
		}

		//// > Codable

		enum CodingKeys: CodingKey {
			case image
			case maskImage
			case path
			case inset
			case useImageMasking
			case masksQRCodePixels
		}

		public required init(from decoder: Decoder) throws {
			let container = try decoder.container(keyedBy: Self.CodingKeys)
			self.image = try container.decode(CGImageCodable.self, forKey: .image).image
			self.maskImage = try container.decodeIfPresent(CGImageCodable.self, forKey: .maskImage)?.image
			self.path = try container.decode(CGPathCodable.self, forKey: .path).path
			self.inset = try container.decode(Double.self, forKey: .inset)
			self.useImageMasking = try container.decode(Bool.self, forKey: .useImageMasking)
			self.masksQRCodePixels = try container.decodeIfPresent(Bool.self, forKey: .masksQRCodePixels) ?? true
		}

		public func encode(to encoder: Encoder) throws {
			var container = encoder.container(keyedBy: Self.CodingKeys)
			try container.encode(useImageMasking, forKey: .useImageMasking)
			try container.encode(masksQRCodePixels, forKey: .masksQRCodePixels)
			try container.encode(inset, forKey: .inset)
			try container.encode(CGPathCodable(self.path), forKey: .path)
			try container.encode(CGImageCodable(image), forKey: .image)
			if let maskImage = self.maskImage {
				try container.encode(CGImageCodable(maskImage), forKey: .maskImage)
			}
		}

		//// < Codable

		// private

		/// The inset from the path bounds to draw the image
		internal let inset: CGFloat

		/// If true, uses a transparent mask image to mask the QRCode when drawing the image
		///
		/// 1. If `maskImage` is not nil, masks the QR code using `maskImage` before drawing the logo image
		/// 2. If `maskImage` is not provided, uses the transparency information in `image` to generate a mask.
		internal let useImageMasking: Bool
	}
}

public extension QRCode.LogoTemplate {
	/// Returns the logo path scaled to fit the specified dimension value
	/// - Parameters:
	///   - dimension: The dimension for the returned path
	///   - flipped: If true, flips the returned path
	/// - Returns: The scaled path
	@objc func absolutePathForMaskPath(dimension: CGFloat, flipped: Bool = false) -> CGPath {
		// Scale the path to fit within the rect
		var transform = CGAffineTransform(scaleX: dimension, y: dimension)
		if flipped {
			transform = CGAffineTransform(scaleX: 1, y: -1)
				.concatenating(CGAffineTransform(translationX: 0, y: 1))
				.concatenating(transform)
		}
		let m = CGMutablePath()
		m.addPath(self.path, transform: transform)
		return m
	}

	/// Make a copy of the logo template
	@objc func copyLogoTemplate() -> QRCode.LogoTemplate {
		QRCode.LogoTemplate(image: self.image.copy()!, path: self.path, inset: self.inset)
	}

	/// Make a copy of this logo template using the specified image
	@objc func copyWithImage(_ image: CGImage, _ maskImage: CGImage? = nil) -> QRCode.LogoTemplate {
		if useImageMasking {
			return QRCode.LogoTemplate(image: image, maskImage: maskImage)
		}
		else {
			return QRCode.LogoTemplate(image: image, path: self.path, inset: self.inset)
		}
	}

	/// Return a dictionary representation of the logo template
	@objc func settings() -> [String: Any] {
		var settings: [String: Any] = [
			"relativeMaskPath": CGPathCodable.encodeBase64Enforced(self.path),
			"inset": self.inset,
		]

		if self.useImageMasking {
			settings["maskUsingImageTransparency"] = true
		}

		settings["masksQRCodePixels"] = self.masksQRCodePixels

		if let data = try? self.image.representation.png() {
			let b64 = data.base64EncodedString()
			settings["image"] = b64
		}

		if let data = try? self.maskImage?.representation.png() {
			let b64 = data.base64EncodedString()
			settings["maskImage"] = b64
		}

		return settings
	}

	/// Create a LogoTemplate from a dictionary of settings
	@objc static func Create(settings: [String: Any]) -> QRCode.LogoTemplate? {
		return QRCode.LogoTemplate(settings: settings)
	}
}

extension QRCode.LogoTemplate {
	// Apply masking via image masking
	func applyingTransparency(matrix: BoolMatrix, dimension: CGFloat) -> BoolMatrix {
		// If the user has supplied a mask image use it, or else use the transparency of the image
		let masked = self.maskImage ?? image

		let sz = matrix.dimension
		guard let scaled = CGImage.imageByScalingImageToFill(masked, targetSize: CGSize(dimension: sz)) else {
			Swift.print("Couldn't scale logo template image")
			return matrix
		}

		do {
			let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
			guard
				let space = CGColorSpace(name: CGColorSpace.sRGB),
				let ctx = CGContext(
					data: nil,
					width: sz,
					height: sz,
					bitsPerComponent: 8,
					bytesPerRow: 4 * sz,
					space: space,
					bitmapInfo: bitmapInfo.rawValue
				)
			else {
				Swift.print("Couldn't get image context")
				return matrix
			}

			// Work out the mapping to the path
			let pbb = self.path.boundingBoxOfPath
			let szf = CGFloat(sz)
			let dest = CGRect(
				x: pbb.minX * szf, y: pbb.minY * szf,
				width: pbb.width * szf, height: pbb.height * szf
			)

			ctx.draw(scaled, in: dest)

			guard let rawData = ctx.data else {
				Swift.print("Couldn't get image context")
				return matrix
			}
			let rawImage = rawData.assumingMemoryBound(to: UInt8.self)

			// Loop through the rows and columns, and if the pixel has (mostly) transparency it gets masked
			let mask = BoolMatrix(dimension: sz)
			for y in 0 ..< sz {
				for x in 0 ..< sz {
					let index = ((sz * y) + x) * 4
					let a = rawImage[index + 3]

					mask[y, x] = (a <= 1)
				}
			}
			return matrix.applyingMask(mask)
		}
	}

	func applyingMask(matrix: BoolMatrix, dimension: CGFloat) -> BoolMatrix {
		guard self.masksQRCodePixels else {
			return matrix
		}
		
		if self.useImageMasking {
			return self.applyingTransparency(matrix: matrix, dimension: dimension)
		}

		let absoluteMask = self.absolutePathForMaskPath(dimension: dimension)

		// The size of each pixel in the output
		let div = dimension / CGFloat(matrix.dimension)

		let maskMatrix = BoolMatrix(dimension: matrix.dimension)
		for y in 0 ..< matrix.dimension {
			for x in 0 ..< matrix.dimension {
				let isCovered = absoluteMask.contains(CGPoint(x: (CGFloat(x) * div) + (div / 2), y: (CGFloat(y) * div) + (div / 2)))
				maskMatrix[y, x] = !isCovered ? matrix[y, x] : false
			}
		}
		return maskMatrix
	}
}

// MARK: - Pre-built logo template shapes

public extension QRCode.LogoTemplate {
	/// Generate a pre-built circle logo template in the center of the qr code
	@objc static func CircleCenter(image: CGImage, inset: CGFloat = 2) -> QRCode.LogoTemplate {
		return QRCode.LogoTemplate(
			image: image,
			path: CGPath(ellipseIn: CGRect(x: 0.375, y: 0.375, width: 0.25, height: 0.25), transform: nil),
			inset: inset
		)
	}

	/// Generate a pre-built circle logo template in the bottom-right of the qr code
	@objc static func CircleBottomRight(image: CGImage, inset: CGFloat = 2) -> QRCode.LogoTemplate {
		return QRCode.LogoTemplate(
			image: image,
			path: CGPath(ellipseIn: CGRect(x: 0.70, y: 0.70, width: 0.25, height: 0.25), transform: nil),
			inset: inset
		)
	}

	/// Generate a pre-built square logo template in the center of the qr code
	@objc static func SquareCenter(image: CGImage, inset: CGFloat = 2) -> QRCode.LogoTemplate {
		return QRCode.LogoTemplate(
			image: image,
			path: CGPath(rect: CGRect(x: 0.375, y: 0.375, width: 0.25, height: 0.25), transform: nil),
			inset: inset
		)
	}

	/// Generate a pre-built square logo template in the bottom-right of the qr code
	@objc static func SquareBottomRight(image: CGImage, inset: CGFloat = 2) -> QRCode.LogoTemplate {
		return QRCode.LogoTemplate(
			image: image,
			path: CGPath(rect: CGRect(x: 0.70, y: 0.70, width: 0.25, height: 0.25), transform: nil),
			inset: inset
		)
	}
}
