//
//  Copyright © 2025 Darren Ford. All rights reserved.
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
	@objc(QRCodePixelShapeVortex) class Vortex: NSObject, QRCodePixelShapeGenerator {
		/// The generator name
		@objc public static let Name: String = "vortex"
		/// The generator title
		@objc public static var Title: String { "Vortex" }

		/// This pupil generator can be used when generating eye and pupil shapes
		@objc public var canGenerateEyeAndPupilShapes: Bool { false }

		/// Create an instance of this path generator with the specified settings
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodePixelShapeGenerator {
			QRCode.PixelShape.Vortex()
		}

		static let DefaultSize = CGSize(width: 10, height: 10)
		static let DefaultRect = CGRect(origin: .zero, size: DefaultSize)

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePixelShapeGenerator { Vortex() }

		/// Reset the generator back to defaults
		@objc public func reset() { }
	}
}

public extension QRCode.PixelShape.Vortex {
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

		let maxInset = matrix.dimension / 2

		for inset in 0 ..< maxInset {
			// Top triangle
			for col in inset ..< matrix.dimension - inset {
				let row = inset
				guard matrix[row, col] == true else { continue }
				let translate = CGAffineTransform(translationX: CGFloat(col) * dm + xoff, y: CGFloat(row) * dm + yoff)
				let n = Neighbours(matrix: matrix, row: row, col: col)

				if col == inset {
					// Left 'corner'
					if n.trailing, n.bottom {
						path.addPath(templateTopLeft(), transform: scaleTransform.concatenating(translate))
					}
					else if n.trailing {
						path.addPath(templateLeft(), transform: scaleTransform.concatenating(translate))
					}
					else if n.bottom {
						path.addPath(templateTop(), transform: scaleTransform.concatenating(translate))
					}
					else {
						path.addPath(templateIsolated(), transform: scaleTransform.concatenating(translate))
					}
				}
				else if col == matrix.dimension - inset - 1 {
					// Right 'corner'
					if n.leading, n.bottom {
						path.addPath(templateTopRight(), transform: scaleTransform.concatenating(translate))
					}
					else if n.leading {
						path.addPath(templateRight(), transform: scaleTransform.concatenating(translate))
					}
					else if n.bottom {
						path.addPath(templateTop(), transform: scaleTransform.concatenating(translate))
					}
					else {
						path.addPath(templateIsolated(), transform: scaleTransform.concatenating(translate))
					}
				}
				else {
					if !n.leading, !n.trailing {
						path.addPath(templateIsolated(), transform: scaleTransform.concatenating(translate))
					}
					else if !n.trailing {
						path.addPath(templateRight(), transform: scaleTransform.concatenating(translate))
					}
					else if !n.leading {
						path.addPath(templateLeft(), transform: scaleTransform.concatenating(translate))
					}
					else {
						path.addPath(templateHorizontal(), transform: scaleTransform.concatenating(translate))
					}
				}
			}

			// Bottom triangle
			for col in inset ..< matrix.dimension - inset {
				let row = matrix.dimension - 1 - inset
				guard matrix[row, col] == true else { continue }
				let translate = CGAffineTransform(translationX: CGFloat(col) * dm + xoff, y: CGFloat(row) * dm + yoff)
				let n = Neighbours(matrix: matrix, row: row, col: col)

				if col == inset {
					// Left 'corner'
					if n.trailing, n.top {
						path.addPath(templateBottomLeft(), transform: scaleTransform.concatenating(translate))
					}
					else if n.top {
						path.addPath(templateBottom(), transform: scaleTransform.concatenating(translate))
					}
					else if n.trailing {
						path.addPath(templateLeft(), transform: scaleTransform.concatenating(translate))
					}
					else {
						path.addPath(templateIsolated(), transform: scaleTransform.concatenating(translate))
					}
				}
				else if col == matrix.dimension - inset - 1 {
					// Right 'corner'
					if n.leading, n.top {
						path.addPath(templateBottomRight(), transform: scaleTransform.concatenating(translate))
					}
					else if n.top {
						path.addPath(templateBottom(), transform: scaleTransform.concatenating(translate))
					}
					else if n.leading {
						path.addPath(templateRight(), transform: scaleTransform.concatenating(translate))
					}
					else {
						path.addPath(templateIsolated(), transform: scaleTransform.concatenating(translate))
					}
				}
				else {
					if n.leading, n.trailing {
						path.addPath(templateHorizontal(), transform: scaleTransform.concatenating(translate))
					}
					else if n.leading {
						path.addPath(templateRight(), transform: scaleTransform.concatenating(translate))
					}
					else if n.trailing {
						path.addPath(templateLeft(), transform: scaleTransform.concatenating(translate))
					}
					else {
						path.addPath(templateIsolated(), transform: scaleTransform.concatenating(translate))
					}
				}
			}

			// Left triangle
			for row in inset ..< matrix.dimension - inset - 1 {
				let col = inset
				guard matrix[row, col] == true else { continue }
				let translate = CGAffineTransform(translationX: CGFloat(col) * dm + xoff, y: CGFloat(row) * dm + yoff)
				let n = Neighbours(matrix: matrix, row: row, col: col)

				if row == col {
					continue
				}
				else if n.top, n.bottom {
					path.addPath(templateVertical(), transform: scaleTransform.concatenating(translate))
				}
				else if n.top {
					path.addPath(templateBottom(), transform: scaleTransform.concatenating(translate))
				}
				else if n.bottom {
					path.addPath(templateTop(), transform: scaleTransform.concatenating(translate))
				}
				else {
					path.addPath(templateIsolated(), transform: scaleTransform.concatenating(translate))
				}
			}

			// Right triangle
			for row in inset + 1 ..< matrix.dimension - inset {
				let col = matrix.dimension - inset - 1
				guard matrix[row, col] == true else { continue }
				let translate = CGAffineTransform(translationX: CGFloat(col) * dm + xoff, y: CGFloat(row) * dm + yoff)
				let n = Neighbours(matrix: matrix, row: row, col: col)

				if row == col {
					continue
				}
				else if n.top, n.bottom {
					path.addPath(templateVertical(), transform: scaleTransform.concatenating(translate))
				}
				else if n.top {
					path.addPath(templateBottom(), transform: scaleTransform.concatenating(translate))
				}
				else if n.bottom {
					path.addPath(templateTop(), transform: scaleTransform.concatenating(translate))
				}
				else {
					path.addPath(templateIsolated(), transform: scaleTransform.concatenating(translate))
				}
			}

			// And make sure that the very center pixel is set correctly IF the dimension is odd
			if matrix.dimension.isOdd {
				let row = matrix.dimension / 2
				let col = row
				if matrix[row, col] == true {
					let translate = CGAffineTransform(translationX: CGFloat(col) * dm + xoff, y: CGFloat(row) * dm + yoff)
					path.addPath(templateIsolated(), transform: scaleTransform.concatenating(translate))
				}
			}
		}
		return path
	}
}

// MARK: - Settings

public extension QRCode.PixelShape.Vortex {
	/// Does the shape generator support setting values for a particular key?
	@objc func supportsSettingValue(forKey key: String) -> Bool { false }

	/// Returns a storable representation of the shape handler
	@objc func settings() -> [String: Any] {
		return [:]
	}

	/// Set a configuration value for a particular setting string
	@objc func setSettingValue(_ value: Any?, forKey key: String) -> Bool {
		return false
	}
}

// MARK: - Pixel creation conveniences

public extension QRCodePixelShapeGenerator where Self == QRCode.PixelShape.Vortex {
	/// Create a pointy pixel generator
	/// - Returns: A pixel generator
	@inlinable static func vortex() -> QRCodePixelShapeGenerator {
		QRCode.PixelShape.Vortex()
	}
}


extension QRCode.PixelShape.Vortex {

	func templateTopLeft() -> CGPath {
		let vortexTopLeftPath = CGMutablePath()
		vortexTopLeftPath.move(to: CGPoint(x: 1, y: 1))
		vortexTopLeftPath.line(to: CGPoint(x: 10, y: 1))
		vortexTopLeftPath.line(to: CGPoint(x: 10, y: 9))
		vortexTopLeftPath.line(to: CGPoint(x: 5, y: 9))
		vortexTopLeftPath.curve(to: CGPoint(x: 1, y: 5), controlPoint1: CGPoint(x: 2.79, y: 9), controlPoint2: CGPoint(x: 1, y: 7.21))
		vortexTopLeftPath.line(to: CGPoint(x: 1, y: 1))
		vortexTopLeftPath.close()
		vortexTopLeftPath.move(to: CGPoint(x: 1, y: 0))
		vortexTopLeftPath.line(to: CGPoint(x: 9, y: 0))
		vortexTopLeftPath.line(to: CGPoint(x: 9, y: 1))
		vortexTopLeftPath.line(to: CGPoint(x: 1, y: 1))
		vortexTopLeftPath.line(to: CGPoint(x: 1, y: 0))
		vortexTopLeftPath.close()

		let flipped = CGMutablePath()
		flipped.addPath(vortexTopLeftPath, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -10))
		return flipped
	}

	func templateTopRight() -> CGPath {
		let vortexTopRightPath = CGMutablePath()
		vortexTopRightPath.move(to: CGPoint(x: 9, y: 1))
		vortexTopRightPath.line(to: CGPoint(x: 0, y: 1))
		vortexTopRightPath.line(to: CGPoint(x: 0, y: 9))
		vortexTopRightPath.line(to: CGPoint(x: 5, y: 9))
		vortexTopRightPath.curve(to: CGPoint(x: 9, y: 5), controlPoint1: CGPoint(x: 7.21, y: 9), controlPoint2: CGPoint(x: 9, y: 7.21))
		vortexTopRightPath.line(to: CGPoint(x: 9, y: 1))
		vortexTopRightPath.close()
		vortexTopRightPath.move(to: CGPoint(x: 9, y: 0))
		vortexTopRightPath.line(to: CGPoint(x: 1, y: 0))
		vortexTopRightPath.line(to: CGPoint(x: 1, y: 1))
		vortexTopRightPath.line(to: CGPoint(x: 9, y: 1))
		vortexTopRightPath.line(to: CGPoint(x: 9, y: 0))
		vortexTopRightPath.close()

		let flipped = CGMutablePath()
		flipped.addPath(vortexTopRightPath, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -10))
		return flipped
	}

	func templateBottomLeft() -> CGPath {
		let vortexBottomLeftPath = CGMutablePath()
		vortexBottomLeftPath.move(to: CGPoint(x: 1, y: 9))
		vortexBottomLeftPath.line(to: CGPoint(x: 10, y: 9))
		vortexBottomLeftPath.line(to: CGPoint(x: 10, y: 1))
		vortexBottomLeftPath.line(to: CGPoint(x: 5, y: 1))
		vortexBottomLeftPath.curve(to: CGPoint(x: 1, y: 5), controlPoint1: CGPoint(x: 2.79, y: 1), controlPoint2: CGPoint(x: 1, y: 2.79))
		vortexBottomLeftPath.line(to: CGPoint(x: 1, y: 9))
		vortexBottomLeftPath.close()
		vortexBottomLeftPath.move(to: CGPoint(x: 1, y: 10))
		vortexBottomLeftPath.line(to: CGPoint(x: 9, y: 10))
		vortexBottomLeftPath.line(to: CGPoint(x: 9, y: 9))
		vortexBottomLeftPath.line(to: CGPoint(x: 1, y: 9))
		vortexBottomLeftPath.line(to: CGPoint(x: 1, y: 10))
		vortexBottomLeftPath.close()

		let flipped = CGMutablePath()
		flipped.addPath(vortexBottomLeftPath, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -10))
		return flipped
	}

	func templateBottomRight() -> CGPath {
		let vortexBottomRightPath = CGMutablePath()
		vortexBottomRightPath.move(to: CGPoint(x: 9, y: 9))
		vortexBottomRightPath.line(to: CGPoint(x: 0, y: 9))
		vortexBottomRightPath.line(to: CGPoint(x: 0, y: 1))
		vortexBottomRightPath.line(to: CGPoint(x: 5, y: 1))
		vortexBottomRightPath.curve(to: CGPoint(x: 9, y: 5), controlPoint1: CGPoint(x: 7.21, y: 1), controlPoint2: CGPoint(x: 9, y: 2.79))
		vortexBottomRightPath.line(to: CGPoint(x: 9, y: 9))
		vortexBottomRightPath.close()
		vortexBottomRightPath.move(to: CGPoint(x: 9, y: 10))
		vortexBottomRightPath.line(to: CGPoint(x: 1, y: 10))
		vortexBottomRightPath.line(to: CGPoint(x: 1, y: 9))
		vortexBottomRightPath.line(to: CGPoint(x: 9, y: 9))
		vortexBottomRightPath.line(to: CGPoint(x: 9, y: 10))
		vortexBottomRightPath.close()

		let flipped = CGMutablePath()
		flipped.addPath(vortexBottomRightPath, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -10))
		return flipped
	}

	func templateTop() -> CGPath {
		let vortexTopPath = CGMutablePath()
		vortexTopPath.move(to: CGPoint(x: 1, y: 0))
		vortexTopPath.line(to: CGPoint(x: 9, y: 0))
		vortexTopPath.line(to: CGPoint(x: 9, y: 5))
		vortexTopPath.curve(to: CGPoint(x: 5, y: 9), controlPoint1: CGPoint(x: 9, y: 7.21), controlPoint2: CGPoint(x: 7.21, y: 9))
		vortexTopPath.line(to: CGPoint(x: 5, y: 9))
		vortexTopPath.curve(to: CGPoint(x: 1, y: 5), controlPoint1: CGPoint(x: 2.79, y: 9), controlPoint2: CGPoint(x: 1, y: 7.21))
		vortexTopPath.line(to: CGPoint(x: 1, y: 0))
		vortexTopPath.close()

		let flipped = CGMutablePath()
		flipped.addPath(vortexTopPath, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -10))
		return flipped
	}

	func templateBottom() -> CGPath {
		let vortexBottomPath = CGMutablePath()
		vortexBottomPath.move(to: CGPoint(x: 1, y: 5))
		vortexBottomPath.curve(to: CGPoint(x: 5, y: 1), controlPoint1: CGPoint(x: 1, y: 2.79), controlPoint2: CGPoint(x: 2.79, y: 1))
		vortexBottomPath.line(to: CGPoint(x: 5, y: 1))
		vortexBottomPath.curve(to: CGPoint(x: 9, y: 5), controlPoint1: CGPoint(x: 7.21, y: 1), controlPoint2: CGPoint(x: 9, y: 2.79))
		vortexBottomPath.line(to: CGPoint(x: 9, y: 10))
		vortexBottomPath.line(to: CGPoint(x: 1, y: 10))
		vortexBottomPath.line(to: CGPoint(x: 1, y: 5))
		vortexBottomPath.close()

		let flipped = CGMutablePath()
		flipped.addPath(vortexBottomPath, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -10))
		return flipped
	}

	func templateVertical() -> CGPath {
		CGPath.make { vortexVerticalPath in
			vortexVerticalPath.move(to: CGPoint(x: 1, y: 0))
			vortexVerticalPath.line(to: CGPoint(x: 9, y: 0))
			vortexVerticalPath.line(to: CGPoint(x: 9, y: 10))
			vortexVerticalPath.line(to: CGPoint(x: 1, y: 10))
			vortexVerticalPath.line(to: CGPoint(x: 1, y: 0))
			vortexVerticalPath.close()
		}
	}

	func templateHorizontal() -> CGPath {
		CGPath.make { vortexHorizontalPath in
			vortexHorizontalPath.move(to: CGPoint(x: 0, y: 1))
			vortexHorizontalPath.line(to: CGPoint(x: 10, y: 1))
			vortexHorizontalPath.line(to: CGPoint(x: 10, y: 9))
			vortexHorizontalPath.line(to: CGPoint(x: 0, y: 9))
			vortexHorizontalPath.line(to: CGPoint(x: 0, y: 1))
			vortexHorizontalPath.close()
		}
	}

	func templateLeft() -> CGPath {
		CGPath.make { vortexLeftPath in
			vortexLeftPath.move(to: CGPoint(x: 1, y: 5))
			vortexLeftPath.curve(to: CGPoint(x: 5, y: 1), controlPoint1: CGPoint(x: 1, y: 2.79), controlPoint2: CGPoint(x: 2.79, y: 1))
			vortexLeftPath.line(to: CGPoint(x: 10, y: 1))
			vortexLeftPath.line(to: CGPoint(x: 10, y: 9))
			vortexLeftPath.line(to: CGPoint(x: 5, y: 9))
			vortexLeftPath.curve(to: CGPoint(x: 1, y: 5), controlPoint1: CGPoint(x: 2.79, y: 9), controlPoint2: CGPoint(x: 1, y: 7.21))
			vortexLeftPath.close()
		}
	}

	func templateRight() -> CGPath {
		CGPath.make { vortexRightPath in
			vortexRightPath.move(to: CGPoint(x: 0, y: 1))
			vortexRightPath.line(to: CGPoint(x: 5, y: 1))
			vortexRightPath.curve(to: CGPoint(x: 9, y: 5), controlPoint1: CGPoint(x: 7.21, y: 1), controlPoint2: CGPoint(x: 9, y: 2.79))
			vortexRightPath.line(to: CGPoint(x: 9, y: 5))
			vortexRightPath.curve(to: CGPoint(x: 5, y: 9), controlPoint1: CGPoint(x: 9, y: 7.21), controlPoint2: CGPoint(x: 7.21, y: 9))
			vortexRightPath.line(to: CGPoint(x: 0, y: 9))
			vortexRightPath.line(to: CGPoint(x: 0, y: 1))
			vortexRightPath.close()
		}
	}

	func templateIsolated() -> CGPath {
		CGPath.make { vortexIsolatedPath in
			vortexIsolatedPath.move(to: CGPoint(x: 9, y: 5))
			vortexIsolatedPath.curve(to: CGPoint(x: 5, y: 1), controlPoint1: CGPoint(x: 9, y: 2.79), controlPoint2: CGPoint(x: 7.21, y: 1))
			vortexIsolatedPath.curve(to: CGPoint(x: 1, y: 5), controlPoint1: CGPoint(x: 2.79, y: 1), controlPoint2: CGPoint(x: 1, y: 2.79))
			vortexIsolatedPath.curve(to: CGPoint(x: 5, y: 9), controlPoint1: CGPoint(x: 1, y: 7.21), controlPoint2: CGPoint(x: 2.79, y: 9))
			vortexIsolatedPath.curve(to: CGPoint(x: 9, y: 5), controlPoint1: CGPoint(x: 7.21, y: 9), controlPoint2: CGPoint(x: 9, y: 7.21))
			vortexIsolatedPath.close()
		}
	}
}
