//
//  QRCodePixelShapeBlob.swift
//
//  Copyright © 2024 Darren Ford. All rights reserved.
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

import Foundation
import CoreGraphics

public extension QRCode.PixelShape {
	/// A generator for a rounded path that links diagonal pixels with a 'sticky' region
	@objc(QRCodePixelShapeBlob) class Blob: NSObject, QRCodePixelShapeGenerator {
		/// The generator name
		@objc public static let Name: String = "blob"
		/// The generator title
		@objc public static var Title: String { "Blob" }
		/// Create an instance of this path generator with the specified settings
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodePixelShapeGenerator { Blob() }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePixelShapeGenerator { Blob() }
	}
}

public extension QRCode.PixelShape.Blob {
	/// Generate a CGPath from the matrix contents
	/// - Parameters:
	///   - matrix: The matrix to generate
	///   - size: The size of the resulting CGPath
	/// - Returns: A path
	@objc func generatePath(from matrix: BoolMatrix, size: CGSize) -> CGPath {
		let dx = size.width / CGFloat(matrix.dimension)
		let dy = size.height / CGFloat(matrix.dimension)
		let dm = min(dx, dy)

		let xoff = (size.width - (CGFloat(matrix.dimension) * dm)) / 2.0
		let yoff = (size.height - (CGFloat(matrix.dimension) * dm)) / 2.0

		// The scale required to convert our template paths to output path size
		let w = QRCode.PixelShape.RoundedPath.DefaultSize.width
		let scaleTransform = CGAffineTransform(scaleX: dm / w, y: dm / w)

		let path = CGMutablePath()

		let blobbyness = CGSize(dimension: 3)

		for row in 0 ..< matrix.dimension {
			for col in 0 ..< matrix.dimension {
				let translate = CGAffineTransform(translationX: CGFloat(col) * dm + xoff, y: CGFloat(row) * dm + yoff)
				let ne = Neighbours(matrix: matrix, row: row, col: col)
				if matrix[row, col] == false {
					// Attach inner corners if needed
					if ne.leading, ne.top {
						path.addPath(
							Self.templateRoundBottomLeft,
							transform: scaleTransform.concatenating(translate)
						)
					}
					if ne.trailing, ne.top {
						path.addPath(
							Self.templateRoundBottomRight,
							transform: scaleTransform.concatenating(translate)
						)
					}
					if ne.leading, ne.bottom {
						path.addPath(
							Self.templateRoundTopLeft,
							transform: scaleTransform.concatenating(translate)
						)
					}
					if ne.trailing, ne.bottom {
						path.addPath(
							Self.templateRoundTopRight,
							transform: scaleTransform.concatenating(translate)
						)
					}
				}
				else {
					var tl = CGSize(width: 0, height: 0)
					var tr = CGSize(width: 0, height: 0)
					var bl = CGSize(width: 0, height: 0)
					var br = CGSize(width: 0, height: 0)

					if !ne.leading, !ne.top, !ne.topLeading {
						tl = blobbyness
					}
					if !ne.leading, !ne.bottom, !ne.bottomLeading {
						bl = blobbyness
					}
					if !ne.trailing, !ne.top, !ne.topTrailing {
						tr = blobbyness
					}
					if !ne.trailing, !ne.bottom, !ne.bottomTrailing {
						br = blobbyness
					}

					let pth = CGPath.RoundedRect(
						rect: CGRect(x: 0, y: 0, width: 10, height: 10),
						topLeftRadius: tl,
						topRightRadius: tr,
						bottomLeftRadius: bl,
						bottomRightRadius: br
					)
					path.addPath(pth, transform: scaleTransform.concatenating(translate))
				}
			}
		}
		return path
	}
}

// MARK: - Settings

public extension QRCode.PixelShape.Blob {
	/// Does the shape generator support setting values for a particular key?
	@objc func supportsSettingValue(forKey key: String) -> Bool { false }
	/// Returns a storable representation of the shape handler
	@objc func settings() -> [String: Any] { return [:] }
	/// Set a configuration value for a particular setting string
	@objc func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }
}

// MARK: - Shapes

// Inner corner templates

private extension QRCode.PixelShape.Blob {
	static let templateRoundTopLeft =
		CGPath.make {
			$0.move(to: CGPoint(x: 0, y: 5))
			$0.curve(to: CGPoint(x: 1.1, y: 8.8), controlPoint1: CGPoint(x: 0, y: 5), controlPoint2: CGPoint(x: 0, y: 7.6))
			$0.curve(to: CGPoint(x: 5, y: 10), controlPoint1: CGPoint(x: 2.2, y: 10), controlPoint2: CGPoint(x: 5, y: 10))
			$0.line(to: CGPoint(x: 0, y: 10))
			$0.line(to: CGPoint(x: 0, y: 5))
			$0.closeSubpath()
		}

	static let templateRoundTopRight =
		CGPath.make {
			$0.move(to: CGPoint(x: 10, y: 5))
			$0.curve(to: CGPoint(x: 8.9, y: 8.8), controlPoint1: CGPoint(x: 10, y: 5), controlPoint2: CGPoint(x: 10, y: 7.6))
			$0.curve(to: CGPoint(x: 5, y: 10), controlPoint1: CGPoint(x: 7.8, y: 10), controlPoint2: CGPoint(x: 5, y: 10))
			$0.line(to: CGPoint(x: 10, y: 10))
			$0.line(to: CGPoint(x: 10, y: 5))
			$0.closeSubpath()
		}

	static let templateRoundBottomLeft =
		CGPath.make {
			$0.move(to: CGPoint(x: 0, y: 5))
			$0.curve(to: CGPoint(x: 1.1, y: 1.2), controlPoint1: CGPoint(x: 0, y: 5), controlPoint2: CGPoint(x: 0, y: 2.4))
			$0.curve(to: CGPoint(x: 5, y: 0), controlPoint1: CGPoint(x: 2.2, y: 0), controlPoint2: CGPoint(x: 5, y: 0))
			$0.line(to: CGPoint(x: 0, y: 0))
			$0.line(to: CGPoint(x: 0, y: 5))
			$0.closeSubpath()
		}

	static let templateRoundBottomRight =
		CGPath.make {
			$0.move(to: CGPoint(x: 10, y: 5))
			$0.curve(to: CGPoint(x: 8.9, y: 1.2), controlPoint1: CGPoint(x: 10, y: 5), controlPoint2: CGPoint(x: 10, y: 2.4))
			$0.curve(to: CGPoint(x: 5, y: 0), controlPoint1: CGPoint(x: 7.8, y: 0), controlPoint2: CGPoint(x: 5, y: 0))
			$0.line(to: CGPoint(x: 10, y: 0))
			$0.line(to: CGPoint(x: 10, y: 5))
			$0.closeSubpath()
	}
}
