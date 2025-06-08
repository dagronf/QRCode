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
	@objc(QRCodePixelShapeDripVertical) class DripVertical: NSObject, QRCodePixelShapeGenerator {
		/// The generator name
		@objc public static let Name: String = "dripVertical"
		/// The generator title
		@objc public static var Title: String { "Drip Vertical" }

		/// This pupil generator can be used when generating eye and pupil shapes
		@objc public var canGenerateEyeAndPupilShapes: Bool { true }

		/// Do the drips go vertically or horizontally?
		@objc public var isVertical: Bool = true

		/// Create an instance of this path generator with the specified settings
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodePixelShapeGenerator { DripVertical() }
		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePixelShapeGenerator { DripVertical() }

		/// Reset the generator back to defaults
		@objc public func reset() { }
	}
}

public extension QRCode.PixelShape.DripVertical {
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
					if !ne.top, ne.bottom {
						path.addPath(dripPixelPathBottom__, transform: scaleTransform.concatenating(translate))
					}
					else if ne.top, ne.bottom {
						path.addPath(dripPixelPathMid__, transform: scaleTransform.concatenating(translate))
					}
					else if ne.top, !ne.bottom {
						path.addPath(dripPixelPathTop__, transform: scaleTransform.concatenating(translate))
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

public extension QRCode.PixelShape.DripVertical {
	/// Returns true if the shape supports setting a value for the specified key, false otherwise
	@objc func supportsSettingValue(forKey key: String) -> Bool { false }
	/// Returns the current settings for the shape
	@objc func settings() -> [String: Any] { [:] }
	/// Set a configuration value for a particular setting string
	@objc func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }
}

// MARK: - Pixel creation conveniences

public extension QRCodePixelShapeGenerator where Self == QRCode.PixelShape.DripVertical {
	/// Create a donut pixel generator
	/// - Returns: A pixel generator
	@inlinable static func dripVertical() -> QRCodePixelShapeGenerator { QRCode.PixelShape.DripVertical() }
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

private let dripPixelPathTop__ = CGPath.make { driptopPath in
	driptopPath.move(to: CGPoint(x: 9.5, y: 5))
	driptopPath.curve(to: CGPoint(x: 7.28, y: 8.88), controlPoint1: CGPoint(x: 9.5, y: 6.65), controlPoint2: CGPoint(x: 8.61, y: 8.1))
	driptopPath.curve(to: CGPoint(x: 7.09, y: 9.11), controlPoint1: CGPoint(x: 7.21, y: 8.95), controlPoint2: CGPoint(x: 7.15, y: 9.03))
	driptopPath.curve(to: CGPoint(x: 6.9, y: 10), controlPoint1: CGPoint(x: 6.79, y: 9.55), controlPoint2: CGPoint(x: 6.9, y: 10))
	driptopPath.line(to: CGPoint(x: 3.17, y: 10))
	driptopPath.curve(to: CGPoint(x: 2.91, y: 9.11), controlPoint1: CGPoint(x: 3.17, y: 10), controlPoint2: CGPoint(x: 3.22, y: 9.55))
	driptopPath.curve(to: CGPoint(x: 2.73, y: 8.89), controlPoint1: CGPoint(x: 2.86, y: 9.03), controlPoint2: CGPoint(x: 2.8, y: 8.96))
	driptopPath.curve(to: CGPoint(x: 2.5, y: 8.74), controlPoint1: CGPoint(x: 2.65, y: 8.84), controlPoint2: CGPoint(x: 2.58, y: 8.79))
	driptopPath.curve(to: CGPoint(x: 0.5, y: 5), controlPoint1: CGPoint(x: 1.29, y: 7.93), controlPoint2: CGPoint(x: 0.5, y: 6.56))
	driptopPath.curve(to: CGPoint(x: 5, y: 0.5), controlPoint1: CGPoint(x: 0.5, y: 2.51), controlPoint2: CGPoint(x: 2.51, y: 0.5))
	driptopPath.curve(to: CGPoint(x: 9.5, y: 5), controlPoint1: CGPoint(x: 7.49, y: 0.5), controlPoint2: CGPoint(x: 9.5, y: 2.51))
	driptopPath.close()
}.flippedVertically(height: 10)

private let dripPixelPathMid__ = CGPath.make { dripmidPath in
	dripmidPath.move(to: CGPoint(x: 6.91, y: 10))
	dripmidPath.curve(to: CGPoint(x: 7.1, y: 9.11), controlPoint1: CGPoint(x: 6.91, y: 10), controlPoint2: CGPoint(x: 6.79, y: 9.55))
	dripmidPath.curve(to: CGPoint(x: 7.29, y: 8.88), controlPoint1: CGPoint(x: 7.15, y: 9.03), controlPoint2: CGPoint(x: 7.22, y: 8.95))
	dripmidPath.curve(to: CGPoint(x: 9.51, y: 5), controlPoint1: CGPoint(x: 8.62, y: 8.1), controlPoint2: CGPoint(x: 9.51, y: 6.65))
	dripmidPath.curve(to: CGPoint(x: 7.29, y: 1.12), controlPoint1: CGPoint(x: 9.51, y: 3.35), controlPoint2: CGPoint(x: 8.62, y: 1.9))
	dripmidPath.curve(to: CGPoint(x: 7.1, y: 0.89), controlPoint1: CGPoint(x: 7.22, y: 1.05), controlPoint2: CGPoint(x: 7.15, y: 0.97))
	dripmidPath.curve(to: CGPoint(x: 6.91, y: 0), controlPoint1: CGPoint(x: 6.79, y: 0.45), controlPoint2: CGPoint(x: 6.91, y: 0))
	dripmidPath.line(to: CGPoint(x: 3.18, y: 0))
	dripmidPath.curve(to: CGPoint(x: 2.92, y: 0.89), controlPoint1: CGPoint(x: 3.18, y: 0), controlPoint2: CGPoint(x: 3.23, y: 0.45))
	dripmidPath.curve(to: CGPoint(x: 2.74, y: 1.11), controlPoint1: CGPoint(x: 2.87, y: 0.97), controlPoint2: CGPoint(x: 2.81, y: 1.04))
	dripmidPath.curve(to: CGPoint(x: 2.51, y: 1.26), controlPoint1: CGPoint(x: 2.66, y: 1.16), controlPoint2: CGPoint(x: 2.58, y: 1.21))
	dripmidPath.curve(to: CGPoint(x: 0.51, y: 5), controlPoint1: CGPoint(x: 1.3, y: 2.07), controlPoint2: CGPoint(x: 0.51, y: 3.44))
	dripmidPath.curve(to: CGPoint(x: 2.74, y: 8.89), controlPoint1: CGPoint(x: 0.51, y: 6.66), controlPoint2: CGPoint(x: 1.4, y: 8.11))
	dripmidPath.curve(to: CGPoint(x: 2.92, y: 9.11), controlPoint1: CGPoint(x: 2.81, y: 8.96), controlPoint2: CGPoint(x: 2.87, y: 9.03))
	dripmidPath.curve(to: CGPoint(x: 3.18, y: 10), controlPoint1: CGPoint(x: 3.23, y: 9.55), controlPoint2: CGPoint(x: 3.18, y: 10))
	dripmidPath.line(to: CGPoint(x: 6.91, y: 10))
	dripmidPath.line(to: CGPoint(x: 6.91, y: 10))
	dripmidPath.close()
}.flippedVertically(height: 10)

private let dripPixelPathBottom__ = CGPath.make { dripbottomPath in
	dripbottomPath.move(to: CGPoint(x: 9.51, y: 5))
	dripbottomPath.curve(to: CGPoint(x: 7.29, y: 1.12), controlPoint1: CGPoint(x: 9.51, y: 3.35), controlPoint2: CGPoint(x: 8.62, y: 1.9))
	dripbottomPath.curve(to: CGPoint(x: 7.1, y: 0.89), controlPoint1: CGPoint(x: 7.22, y: 1.05), controlPoint2: CGPoint(x: 7.15, y: 0.97))
	dripbottomPath.curve(to: CGPoint(x: 6.91, y: 0), controlPoint1: CGPoint(x: 6.79, y: 0.45), controlPoint2: CGPoint(x: 6.91, y: 0))
	dripbottomPath.line(to: CGPoint(x: 3.18, y: 0))
	dripbottomPath.curve(to: CGPoint(x: 2.92, y: 0.89), controlPoint1: CGPoint(x: 3.18, y: 0), controlPoint2: CGPoint(x: 3.23, y: 0.45))
	dripbottomPath.curve(to: CGPoint(x: 2.74, y: 1.11), controlPoint1: CGPoint(x: 2.87, y: 0.97), controlPoint2: CGPoint(x: 2.81, y: 1.04))
	dripbottomPath.curve(to: CGPoint(x: 2.51, y: 1.26), controlPoint1: CGPoint(x: 2.66, y: 1.16), controlPoint2: CGPoint(x: 2.58, y: 1.21))
	dripbottomPath.curve(to: CGPoint(x: 0.51, y: 5), controlPoint1: CGPoint(x: 1.3, y: 2.07), controlPoint2: CGPoint(x: 0.51, y: 3.44))
	dripbottomPath.curve(to: CGPoint(x: 5.01, y: 9.5), controlPoint1: CGPoint(x: 0.51, y: 7.49), controlPoint2: CGPoint(x: 2.52, y: 9.5))
	dripbottomPath.curve(to: CGPoint(x: 9.51, y: 5), controlPoint1: CGPoint(x: 7.49, y: 9.5), controlPoint2: CGPoint(x: 9.51, y: 7.49))
	dripbottomPath.close()
}.flippedVertically(height: 10)
