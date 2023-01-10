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

public extension QRCode {
	/// A QRCode logo template
	@objc(QRCodeLogoTemplate) class LogoTemplate: NSObject {
		/// A CGPath with the bounds x=0, y=0, width=1, height=1 in which to draw the image
		@objc public var path: CGPath {
			didSet {
				let bounds = self.path.boundingBoxOfPath
				assert(bounds.minX >= 0 && bounds.maxX <= 1)
				assert(bounds.minY >= 0 || bounds.maxY <= 1)
			}
		}

		/// The inset from the path bounds to draw the image
		@objc public var inset: CGFloat

		/// The image to display.
		///
		/// If no image is provided, the mask is still applied to the QR code when generating.
		@objc public var image: CGImage?

		/// Create a logo template
		/// - Parameters:
		///   - path: The bounds path for the logo (0,0 -> 1, 1)
		///   - inset: The inset from the path bounds to draw the image
		///   - image: The default image to display in the logo
		@objc public init(
			path: CGPath,
			inset: CGFloat = 4,
			image: CGImage? = nil
		) {
			let bounds = path.boundingBoxOfPath
			assert(bounds.minX >= 0 && bounds.maxX <= 1)
			assert(bounds.minY >= 0 || bounds.maxY <= 1)

			assert(inset >= 0)
			self.path = path
			self.inset = inset
			self.image = image
		}

		/// Returns the logo path scaled to fit the specified dimension value
		/// - Parameters:
		///   - dimension: The dimension for the returned path
		///   - flipped: If true, flips the returned path
		/// - Returns: The scaled path
		@objc public func absolutePathForMaskPath(dimension: CGFloat, flipped: Bool = false) -> CGPath {
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
		@objc public func copyLogoTemplate() -> QRCode.LogoTemplate {
			QRCode.LogoTemplate(path: self.path, inset: self.inset, image: self.image?.copy())
		}

		/// Return a dictionary representation of the logo template
		@objc public func settings() -> [String: Any] {
			var settings: [String: Any] = [
				"relativeMaskPath": CGPathCoder.encodeBase64(self.path)!,
				"inset": self.inset,
			]

			if let image = image,
				let data = image.pngRepresentation()
			{
				let b64 = data.base64EncodedString()
				settings["image"] = b64
			}

			return settings
		}

		/// Create a LogoTemplate from a dictionary of settings
		@objc public init?(settings: [String: Any]) {
			guard
				let pathB64 = settings["relativeMaskPath"] as? String,
				let path = try? CGPathCoder.decodeBase64(pathB64)
			else {
				return nil
			}
			self.path = path
			self.inset = DoubleValue(settings["inset"]) ?? 0

			if let imageb64 = settings["image"] as? String,
				let imageb64Data = imageb64.data(using: .ascii, allowLossyConversion: false),
				let imageData = Data(base64Encoded: imageb64Data)
			{
				self.image = CGImage.fromPNGData(imageData)
			}
		}

		/// Create a LogoTemplate from a dictionary of settings
		@objc public static func Create(settings: [String: Any]) -> QRCode.LogoTemplate? {
			return QRCode.LogoTemplate(settings: settings)
		}
	}
}

extension QRCode.LogoTemplate {
	func applyingMask(matrix: BoolMatrix, dimension: CGFloat) -> BoolMatrix {
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
			path: CGPath(ellipseIn: CGRect(x: 0.375, y: 0.375, width: 0.25, height: 0.25), transform: nil),
			inset: inset,
			image: image
		)
	}

	/// Generate a pre-built circle logo template in the bottom-right of the qr code
	@objc static func CircleBottomRight(image: CGImage, inset: CGFloat = 2) -> QRCode.LogoTemplate {
		return QRCode.LogoTemplate(
			path: CGPath(ellipseIn: CGRect(x: 0.70, y: 0.70, width: 0.25, height: 0.25), transform: nil),
			inset: inset,
			image: image
		)
	}

	/// Generate a pre-built square logo template in the center of the qr code
	@objc static func SquareCenter(image: CGImage, inset: CGFloat = 2) -> QRCode.LogoTemplate {
		return QRCode.LogoTemplate(
			path: CGPath(rect: CGRect(x: 0.375, y: 0.375, width: 0.25, height: 0.25), transform: nil),
			inset: inset,
			image: image
		)
	}

	/// Generate a pre-built square logo template in the bottom-right of the qr code
	@objc static func SquareBottomRight(image: CGImage, inset: CGFloat = 2) -> QRCode.LogoTemplate {
		return QRCode.LogoTemplate(
			path: CGPath(rect: CGRect(x: 0.70, y: 0.70, width: 0.25, height: 0.25), transform: nil),
			inset: inset,
			image: image
		)
	}
}
