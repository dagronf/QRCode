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

import CoreGraphics
import Foundation

public extension QRCode.PixelShape {
	/// A connected circles pixel shape
	@objc(QRCodePixelShapeDripHorizontal) class DripHorizontal: NSObject, QRCodePixelShapeGenerator {
		/// The generator name
		@objc public static let Name: String = "dripHorizontal"
		/// The generator title
		@objc public static var Title: String { "Drip Horizontal" }

		/// This pupil generator can be used when generating eye and pupil shapes
		@objc public var canGenerateEyeAndPupilShapes: Bool { true }

		/// Do the drips go vertically or horizontally?
		@objc public var isVertical: Bool = true

		/// Create an instance of this path generator with the specified settings
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodePixelShapeGenerator { DripHorizontal() }
		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePixelShapeGenerator { DripHorizontal() }

		/// Reset the generator back to defaults
		@objc public func reset() { }
	}
}

public extension QRCode.PixelShape.DripHorizontal {
	/// Generate a CGPath from the matrix contents
	/// - Parameters:
	///   - matrix: The matrix to generate
	///   - size: The size of the resulting CGPath
	/// - Returns: A path
	func generatePath(from matrix: BoolMatrix, size: CGSize) -> CGPath {
		let dx = size.width / CGFloat(matrix.dimension)
		let dy = size.height / CGFloat(matrix.dimension)
		let dm = min(dx, dy)

		let xoff = (size.width - (CGFloat(matrix.dimension) * dm)) / 2.0
		let yoff = (size.height - (CGFloat(matrix.dimension) * dm)) / 2.0

		// The scale required to convert our template paths to output path size
		let w = QRCode.PixelShape.RoundedPath.DefaultSize.width
		let scaleTransform = CGAffineTransform(scaleX: dm / w, y: dm / w)

		let path = CGMutablePath()

		for row in 0 ..< matrix.dimension {
			for col in 0 ..< matrix.dimension {
				let translate = CGAffineTransform(translationX: CGFloat(col) * dm + xoff, y: CGFloat(row) * dm + yoff)
				if matrix[row, col] == true {
					let ne = Neighbours(matrix: matrix, row: row, col: col)
					if !ne.leading, ne.trailing {
						path.addPath(dripPixelPathTrailing__, transform: scaleTransform.concatenating(translate))
					}
					else if ne.leading, ne.trailing {
						path.addPath(dripPixelPathBoth__, transform: scaleTransform.concatenating(translate))
					}
					else if ne.leading, !ne.trailing {
						path.addPath(dripPixelPathLeading__, transform: scaleTransform.concatenating(translate))
					}
					else {
						path.addPath(dripPixelPathNone__, transform: scaleTransform.concatenating(translate))
					}
				}
			}
		}

		path.closeSubpath()
		return path
	}
}

// MARK: - Settings

public extension QRCode.PixelShape.DripHorizontal {
	/// Returns true if the shape supports setting a value for the specified key, false otherwise
	@objc func supportsSettingValue(forKey key: String) -> Bool { false }
	/// Returns the current settings for the shape
	@objc func settings() -> [String: Any] { [:] }
	/// Set a configuration value for a particular setting string
	@objc func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }
}

// MARK: - Pixel creation conveniences

public extension QRCodePixelShapeGenerator where Self == QRCode.PixelShape.DripHorizontal {
	/// Create a donut pixel generator
	/// - Returns: A pixel generator
	@inlinable static func dripHorizontal() -> QRCodePixelShapeGenerator { QRCode.PixelShape.DripHorizontal() }
}

// MARK: - Design

private let dripPixelPathNone__ = CGPath.make { dripnonePath in
	dripnonePath.move(to: CGPoint(x: 9.5, y: 5))
	dripnonePath.curve(to: CGPoint(x: 5, y: 0.5), controlPoint1: CGPoint(x: 9.5, y: 2.51), controlPoint2: CGPoint(x: 7.49, y: 0.5))
	dripnonePath.curve(to: CGPoint(x: 0.5, y: 5), controlPoint1: CGPoint(x: 2.51, y: 0.5), controlPoint2: CGPoint(x: 0.5, y: 2.51))
	dripnonePath.curve(to: CGPoint(x: 5, y: 9.5), controlPoint1: CGPoint(x: 0.5, y: 7.49), controlPoint2: CGPoint(x: 2.51, y: 9.5))
	dripnonePath.curve(to: CGPoint(x: 9.5, y: 5), controlPoint1: CGPoint(x: 7.49, y: 9.5), controlPoint2: CGPoint(x: 9.5, y: 7.49))
	dripnonePath.close()
}

private let dripPixelPathTrailing__ = CGPath.make { driptrailingPath in
	driptrailingPath.move(to: CGPoint(x: 5, y: 9.5))
	driptrailingPath.curve(to: CGPoint(x: 8.88, y: 7.28), controlPoint1: CGPoint(x: 6.65, y: 9.5), controlPoint2: CGPoint(x: 8.1, y: 8.61))
	driptrailingPath.curve(to: CGPoint(x: 9.11, y: 7.09), controlPoint1: CGPoint(x: 8.95, y: 7.21), controlPoint2: CGPoint(x: 9.03, y: 7.15))
	driptrailingPath.curve(to: CGPoint(x: 10, y: 6.9), controlPoint1: CGPoint(x: 9.55, y: 6.79), controlPoint2: CGPoint(x: 10, y: 6.9))
	driptrailingPath.line(to: CGPoint(x: 10, y: 3.17))
	driptrailingPath.curve(to: CGPoint(x: 9.11, y: 2.91), controlPoint1: CGPoint(x: 10, y: 3.17), controlPoint2: CGPoint(x: 9.55, y: 3.22))
	driptrailingPath.curve(to: CGPoint(x: 8.89, y: 2.73), controlPoint1: CGPoint(x: 9.03, y: 2.86), controlPoint2: CGPoint(x: 8.96, y: 2.8))
	driptrailingPath.curve(to: CGPoint(x: 8.74, y: 2.5), controlPoint1: CGPoint(x: 8.84, y: 2.65), controlPoint2: CGPoint(x: 8.79, y: 2.58))
	driptrailingPath.curve(to: CGPoint(x: 5, y: 0.5), controlPoint1: CGPoint(x: 7.93, y: 1.29), controlPoint2: CGPoint(x: 6.56, y: 0.5))
	driptrailingPath.curve(to: CGPoint(x: 0.5, y: 5), controlPoint1: CGPoint(x: 2.51, y: 0.5), controlPoint2: CGPoint(x: 0.5, y: 2.51))
	driptrailingPath.curve(to: CGPoint(x: 5, y: 9.5), controlPoint1: CGPoint(x: 0.5, y: 7.49), controlPoint2: CGPoint(x: 2.51, y: 9.5))
	driptrailingPath.close()
}.flippedVertically(height: 10)

private let dripPixelPathBoth__ = CGPath.make { dripbothPath in
	dripbothPath.move(to: CGPoint(x: 10.01, y: 3.1))
	dripbothPath.curve(to: CGPoint(x: 9.11, y: 2.91), controlPoint1: CGPoint(x: 10.01, y: 3.1), controlPoint2: CGPoint(x: 9.56, y: 3.21))
	dripbothPath.curve(to: CGPoint(x: 8.89, y: 2.72), controlPoint1: CGPoint(x: 9.04, y: 2.85), controlPoint2: CGPoint(x: 8.96, y: 2.79))
	dripbothPath.curve(to: CGPoint(x: 5.01, y: 0.5), controlPoint1: CGPoint(x: 8.1, y: 1.39), controlPoint2: CGPoint(x: 6.66, y: 0.5))
	dripbothPath.curve(to: CGPoint(x: 1.13, y: 2.72), controlPoint1: CGPoint(x: 3.36, y: 0.5), controlPoint2: CGPoint(x: 1.91, y: 1.39))
	dripbothPath.curve(to: CGPoint(x: 0.9, y: 2.91), controlPoint1: CGPoint(x: 1.05, y: 2.79), controlPoint2: CGPoint(x: 0.98, y: 2.85))
	dripbothPath.curve(to: CGPoint(x: 0.01, y: 3.1), controlPoint1: CGPoint(x: 0.45, y: 3.21), controlPoint2: CGPoint(x: 0.01, y: 3.1))
	dripbothPath.line(to: CGPoint(x: 0.01, y: 6.83))
	dripbothPath.curve(to: CGPoint(x: 0.9, y: 7.09), controlPoint1: CGPoint(x: 0.01, y: 6.83), controlPoint2: CGPoint(x: 0.45, y: 6.78))
	dripbothPath.curve(to: CGPoint(x: 1.12, y: 7.27), controlPoint1: CGPoint(x: 0.97, y: 7.14), controlPoint2: CGPoint(x: 1.05, y: 7.2))
	dripbothPath.curve(to: CGPoint(x: 1.27, y: 7.5), controlPoint1: CGPoint(x: 1.17, y: 7.35), controlPoint2: CGPoint(x: 1.21, y: 7.42))
	dripbothPath.curve(to: CGPoint(x: 5.01, y: 9.5), controlPoint1: CGPoint(x: 2.07, y: 8.71), controlPoint2: CGPoint(x: 3.45, y: 9.5))
	dripbothPath.curve(to: CGPoint(x: 8.89, y: 7.27), controlPoint1: CGPoint(x: 6.67, y: 9.5), controlPoint2: CGPoint(x: 8.11, y: 8.6))
	dripbothPath.curve(to: CGPoint(x: 9.11, y: 7.09), controlPoint1: CGPoint(x: 8.97, y: 7.2), controlPoint2: CGPoint(x: 9.04, y: 7.14))
	dripbothPath.curve(to: CGPoint(x: 10.01, y: 6.83), controlPoint1: CGPoint(x: 9.56, y: 6.78), controlPoint2: CGPoint(x: 10.01, y: 6.83))
	dripbothPath.line(to: CGPoint(x: 10.01, y: 3.1))
	dripbothPath.line(to: CGPoint(x: 10.01, y: 3.1))
	dripbothPath.close()
}.flippedVertically(height: 10)

private let dripPixelPathLeading__ = CGPath.make { dripleadingPath in
	dripleadingPath.move(to: CGPoint(x: 5, y: 9.5))
	dripleadingPath.curve(to: CGPoint(x: 1.12, y: 7.28), controlPoint1: CGPoint(x: 3.35, y: 9.5), controlPoint2: CGPoint(x: 1.9, y: 8.61))
	dripleadingPath.curve(to: CGPoint(x: 0.89, y: 7.09), controlPoint1: CGPoint(x: 1.05, y: 7.21), controlPoint2: CGPoint(x: 0.97, y: 7.15))
	dripleadingPath.curve(to: CGPoint(x: 0, y: 6.9), controlPoint1: CGPoint(x: 0.45, y: 6.79), controlPoint2: CGPoint(x: 0, y: 6.9))
	dripleadingPath.line(to: CGPoint(x: 0, y: 3.17))
	dripleadingPath.curve(to: CGPoint(x: 0.89, y: 2.91), controlPoint1: CGPoint(x: 0, y: 3.17), controlPoint2: CGPoint(x: 0.45, y: 3.22))
	dripleadingPath.curve(to: CGPoint(x: 1.11, y: 2.73), controlPoint1: CGPoint(x: 0.97, y: 2.86), controlPoint2: CGPoint(x: 1.04, y: 2.8))
	dripleadingPath.curve(to: CGPoint(x: 1.26, y: 2.5), controlPoint1: CGPoint(x: 1.16, y: 2.65), controlPoint2: CGPoint(x: 1.21, y: 2.58))
	dripleadingPath.curve(to: CGPoint(x: 5, y: 0.5), controlPoint1: CGPoint(x: 2.07, y: 1.29), controlPoint2: CGPoint(x: 3.44, y: 0.5))
	dripleadingPath.curve(to: CGPoint(x: 9.5, y: 5), controlPoint1: CGPoint(x: 7.49, y: 0.5), controlPoint2: CGPoint(x: 9.5, y: 2.51))
	dripleadingPath.curve(to: CGPoint(x: 5, y: 9.5), controlPoint1: CGPoint(x: 9.5, y: 7.49), controlPoint2: CGPoint(x: 7.49, y: 9.5))
	dripleadingPath.close()
}.flippedVertically(height: 10)
