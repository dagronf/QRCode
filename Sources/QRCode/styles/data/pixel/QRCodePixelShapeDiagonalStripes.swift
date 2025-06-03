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
	@objc(QRCodePixelShapeDiagonalStripes) class DiagonalStripes: NSObject, QRCodePixelShapeGenerator {
		/// The generator name
		@objc public static let Name: String = "diagonalStripes"
		/// The generator title
		@objc public static var Title: String { "DiagonalStripes" }

		/// This pupil generator can be used when generating eye and pupil shapes
		@objc public var canGenerateEyeAndPupilShapes: Bool { true }

		/// Create a donut pixel shape
		@objc public override init() {
			self.common = CommonPixelGenerator(pixelType: .diagonalStripes)
			super.init()
		}

		/// Create an instance of this path generator with the specified settings
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodePixelShapeGenerator { DiagonalStripes() }
		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePixelShapeGenerator { DiagonalStripes() }

		/// Reset the generator back to defaults
		@objc public func reset() { }

		/// Generate a CGPath from the matrix contents
		/// - Parameters:
		///   - matrix: The matrix to generate
		///   - size: The size of the resulting CGPath
		/// - Returns: A path
		public func generatePath(from matrix: BoolMatrix, size: CGSize) -> CGPath {
			self.common.generatePath(from: matrix, size: size)
		}

		// private

		private let common: CommonPixelGenerator
	}
}

// MARK: - Settings

public extension QRCode.PixelShape.DiagonalStripes {
	/// Returns true if the shape supports setting a value for the specified key, false otherwise
	@objc func supportsSettingValue(forKey key: String) -> Bool { false }
	/// Returns the current settings for the shape
	@objc func settings() -> [String: Any] { [:] }
	/// Set a configuration value for a particular setting string
	@objc func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }
}

// MARK: - Pixel creation conveniences

public extension QRCodePixelShapeGenerator where Self == QRCode.PixelShape.DiagonalStripes {
	/// Create a donut pixel generator
	/// - Returns: A pixel generator
	@inlinable static func diagonalStripes() -> QRCodePixelShapeGenerator { QRCode.PixelShape.DiagonalStripes() }
}

// MARK: - Design

internal extension QRCode.PixelShape.DiagonalStripes {
	// A 10x10 'pixel' representation
	static let pixelShape_ = CGPath.make { pixelPath in
		pixelPath.move(to: CGPoint(x: 0, y: 7.56))
		pixelPath.curve(to: CGPoint(x: 0, y: 8.81), controlPoint1: CGPoint(x: 0, y: 8.03), controlPoint2: CGPoint(x: 0, y: 8.45))
		pixelPath.curve(to: CGPoint(x: 1.57, y: 10), controlPoint1: CGPoint(x: 0.52, y: 9.2), controlPoint2: CGPoint(x: 1.04, y: 9.6))
		pixelPath.line(to: CGPoint(x: 3.23, y: 10))
		pixelPath.curve(to: CGPoint(x: 0, y: 7.56), controlPoint1: CGPoint(x: 2.15, y: 9.18), controlPoint2: CGPoint(x: 1.04, y: 8.35))
		pixelPath.close()
		pixelPath.move(to: CGPoint(x: 0, y: 5.06))
		pixelPath.curve(to: CGPoint(x: 0, y: 6.31), controlPoint1: CGPoint(x: 0, y: 5.48), controlPoint2: CGPoint(x: 0, y: 5.9))
		pixelPath.curve(to: CGPoint(x: 4.9, y: 10), controlPoint1: CGPoint(x: 1.54, y: 7.47), controlPoint2: CGPoint(x: 3.29, y: 8.79))
		pixelPath.line(to: CGPoint(x: 6.56, y: 10))
		pixelPath.curve(to: CGPoint(x: 0, y: 5.06), controlPoint1: CGPoint(x: 4.49, y: 8.44), controlPoint2: CGPoint(x: 2, y: 6.57))
		pixelPath.close()
		pixelPath.move(to: CGPoint(x: 4.08, y: 5.63))
		pixelPath.curve(to: CGPoint(x: -0, y: 2.55), controlPoint1: CGPoint(x: 2.6, y: 4.51), controlPoint2: CGPoint(x: 1.16, y: 3.42))
		pixelPath.curve(to: CGPoint(x: 0, y: 3.81), controlPoint1: CGPoint(x: 0, y: 2.95), controlPoint2: CGPoint(x: 0, y: 3.37))
		pixelPath.curve(to: CGPoint(x: 6.08, y: 8.39), controlPoint1: CGPoint(x: 1.77, y: 5.14), controlPoint2: CGPoint(x: 4.04, y: 6.85))
		pixelPath.curve(to: CGPoint(x: 8.22, y: 10), controlPoint1: CGPoint(x: 6.84, y: 8.96), controlPoint2: CGPoint(x: 7.56, y: 9.51))
		pixelPath.line(to: CGPoint(x: 9.88, y: 10))
		pixelPath.curve(to: CGPoint(x: 4.08, y: 5.63), controlPoint1: CGPoint(x: 8.36, y: 8.86), controlPoint2: CGPoint(x: 6.19, y: 7.22))
		pixelPath.close()
		pixelPath.move(to: CGPoint(x: 10, y: 7.59))
		pixelPath.curve(to: CGPoint(x: 0.08, y: 0.11), controlPoint1: CGPoint(x: 6.92, y: 5.27), controlPoint2: CGPoint(x: 2.34, y: 1.81))
		pixelPath.line(to: CGPoint(x: 0, y: 0.05))
		pixelPath.curve(to: CGPoint(x: 0, y: 1.3), controlPoint1: CGPoint(x: 0, y: 0.2), controlPoint2: CGPoint(x: 0, y: 0.66))
		pixelPath.curve(to: CGPoint(x: 2.08, y: 2.87), controlPoint1: CGPoint(x: 0.6, y: 1.75), controlPoint2: CGPoint(x: 1.31, y: 2.29))
		pixelPath.curve(to: CGPoint(x: 10, y: 8.84), controlPoint1: CGPoint(x: 4.61, y: 4.78), controlPoint2: CGPoint(x: 7.82, y: 7.19))
		pixelPath.curve(to: CGPoint(x: 10, y: 7.59), controlPoint1: CGPoint(x: 10, y: 8.48), controlPoint2: CGPoint(x: 10, y: 8.05))
		pixelPath.close()
		pixelPath.move(to: CGPoint(x: 10, y: 1.32))
		pixelPath.curve(to: CGPoint(x: 10, y: 0.07), controlPoint1: CGPoint(x: 10, y: 0.7), controlPoint2: CGPoint(x: 10, y: 0.24))
		pixelPath.line(to: CGPoint(x: 9.9, y: 0))
		pixelPath.line(to: CGPoint(x: 8.24, y: 0))
		pixelPath.curve(to: CGPoint(x: 10, y: 1.32), controlPoint1: CGPoint(x: 8.83, y: 0.44), controlPoint2: CGPoint(x: 9.42, y: 0.89))
		pixelPath.close()
		pixelPath.move(to: CGPoint(x: 10, y: 3.83))
		pixelPath.curve(to: CGPoint(x: 10, y: 2.58), controlPoint1: CGPoint(x: 10, y: 3.39), controlPoint2: CGPoint(x: 10, y: 2.97))
		pixelPath.curve(to: CGPoint(x: 6.58, y: -0), controlPoint1: CGPoint(x: 8.88, y: 1.73), controlPoint2: CGPoint(x: 7.7, y: 0.84))
		pixelPath.line(to: CGPoint(x: 4.92, y: 0))
		pixelPath.curve(to: CGPoint(x: 10, y: 3.83), controlPoint1: CGPoint(x: 6.53, y: 1.21), controlPoint2: CGPoint(x: 8.35, y: 2.59))
		pixelPath.close()
		pixelPath.move(to: CGPoint(x: 10, y: 5.08))
		pixelPath.curve(to: CGPoint(x: 3.26, y: -0), controlPoint1: CGPoint(x: 7.84, y: 3.45), controlPoint2: CGPoint(x: 5.27, y: 1.51))
		pixelPath.line(to: CGPoint(x: 1.6, y: 0))
		pixelPath.curve(to: CGPoint(x: 10, y: 6.33), controlPoint1: CGPoint(x: 3.85, y: 1.7), controlPoint2: CGPoint(x: 7.35, y: 4.33))
		pixelPath.curve(to: CGPoint(x: 10, y: 5.08), controlPoint1: CGPoint(x: 10, y: 5.92), controlPoint2: CGPoint(x: 10, y: 5.5))
		pixelPath.close()
	}
}
