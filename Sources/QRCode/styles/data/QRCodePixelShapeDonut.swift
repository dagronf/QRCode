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
	/// A donut pixel shape
	@objc(QRCodePixelShapeDonut) class Donut: NSObject, QRCodePixelShapeGenerator {
		/// The generator name
		@objc public static let Name: String = "donut"
		/// The generator title
		@objc public static var Title: String { "Donut" }

		/// This pupil generator can be used when generating eye and pupil shapes
		@objc public var canGenerateEyeAndPupilShapes: Bool { true }

		/// Create an instance of this path generator with the specified settings
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodePixelShapeGenerator { Donut() }
		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePixelShapeGenerator { Donut() }

		/// Reset the generator back to defaults
		@objc public func reset() { }
	}
}

public extension QRCode.PixelShape.Donut {
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
					path.addPath(donutsPixelPath__, transform: scaleTransform.concatenating(translate))
				}
			}
		}

		path.closeSubpath()
		return path
	}
}

// MARK: - Settings

public extension QRCode.PixelShape.Donut {
	/// Returns true if the shape supports setting a value for the specified key, false otherwise
	@objc func supportsSettingValue(forKey key: String) -> Bool { false }
	/// Returns the current settings for the shape
	@objc func settings() -> [String: Any] { [:] }
	/// Set a configuration value for a particular setting string
	@objc func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }
}

// MARK: - Pixel creation conveniences

public extension QRCodePixelShapeGenerator where Self == QRCode.PixelShape.Donut {
	/// Create a donut pixel generator
	/// - Returns: A pixel generator
	@inlinable static func donut() -> QRCodePixelShapeGenerator { QRCode.PixelShape.Donut() }
}

// MARK: - Design

private let donutsPixelPath__ = CGPath.make { ch_pixelPath in
	ch_pixelPath.move(to: CGPoint(x: 5, y: 6.5))
	ch_pixelPath.curve(to: CGPoint(x: 3.5, y: 5), controlPoint1: CGPoint(x: 4.17, y: 6.5), controlPoint2: CGPoint(x: 3.5, y: 5.83))
	ch_pixelPath.curve(to: CGPoint(x: 4.72, y: 3.53), controlPoint1: CGPoint(x: 3.5, y: 4.27), controlPoint2: CGPoint(x: 4.03, y: 3.66))
	ch_pixelPath.curve(to: CGPoint(x: 5, y: 3.5), controlPoint1: CGPoint(x: 4.81, y: 3.51), controlPoint2: CGPoint(x: 4.91, y: 3.5))
	ch_pixelPath.curve(to: CGPoint(x: 6.5, y: 5), controlPoint1: CGPoint(x: 5.83, y: 3.5), controlPoint2: CGPoint(x: 6.5, y: 4.17))
	ch_pixelPath.curve(to: CGPoint(x: 5, y: 6.5), controlPoint1: CGPoint(x: 6.5, y: 5.83), controlPoint2: CGPoint(x: 5.83, y: 6.5))
	ch_pixelPath.close()
	ch_pixelPath.move(to: CGPoint(x: 10, y: 5))
	ch_pixelPath.curve(to: CGPoint(x: 5, y: 0), controlPoint1: CGPoint(x: 10, y: 2.24), controlPoint2: CGPoint(x: 7.76, y: 0))
	ch_pixelPath.curve(to: CGPoint(x: 2.04, y: 0.97), controlPoint1: CGPoint(x: 3.89, y: 0), controlPoint2: CGPoint(x: 2.87, y: 0.36))
	ch_pixelPath.curve(to: CGPoint(x: 0, y: 5), controlPoint1: CGPoint(x: 0.8, y: 1.88), controlPoint2: CGPoint(x: 0, y: 3.35))
	ch_pixelPath.curve(to: CGPoint(x: 5, y: 10), controlPoint1: CGPoint(x: 0, y: 7.76), controlPoint2: CGPoint(x: 2.24, y: 10))
	ch_pixelPath.curve(to: CGPoint(x: 10, y: 5), controlPoint1: CGPoint(x: 7.76, y: 10), controlPoint2: CGPoint(x: 10, y: 7.76))
	ch_pixelPath.close()
}
