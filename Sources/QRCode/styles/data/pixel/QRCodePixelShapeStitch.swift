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

import CoreGraphics
import Foundation

public extension QRCode.PixelShape {
	/// A donut pixel shape
	@objc(QRCodePixelShapeStitch) class Stitch: NSObject, QRCodePixelShapeGenerator {
		/// The generator name
		@objc public static let Name: String = "stitch"
		/// The generator title
		@objc public static var Title: String { "Stitch" }

		/// This pupil generator can be used when generating eye and pupil shapes
		@objc public var canGenerateEyeAndPupilShapes: Bool { true }

		/// Create a donut pixel shape
		@objc public override init() {
			self.common = CommonPixelGenerator(pixelType: .stitch)
			super.init()
		}

		/// Create an instance of this path generator with the specified settings
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodePixelShapeGenerator { Stitch() }
		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePixelShapeGenerator { Stitch() }

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

public extension QRCode.PixelShape.Stitch {
	/// Returns true if the shape supports setting a value for the specified key, false otherwise
	@objc func supportsSettingValue(forKey key: String) -> Bool { false }
	/// Returns the current settings for the shape
	@objc func settings() -> [String: Any] { [:] }
	/// Set a configuration value for a particular setting string
	@objc func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }
}

// MARK: - Pixel creation conveniences

public extension QRCodePixelShapeGenerator where Self == QRCode.PixelShape.Stitch {
	/// Create a donut pixel generator
	/// - Returns: A pixel generator
	@inlinable static func stitch() -> QRCodePixelShapeGenerator { QRCode.PixelShape.Stitch() }
}

// MARK: - Design

internal extension QRCode.PixelShape.Stitch {
	// A 10x10 'pixel' representation
	static let pixelShape_: CGPath =
	CGPath.make { a in
		a.move(to: NSPoint(x: 5, y: 4.77))
		a.curve(to: NSPoint(x: 5, y: 0.9), controlPoint1: NSPoint(x: 5, y: 4.77), controlPoint2: NSPoint(x: 5, y: 1.3))
		a.curve(to: NSPoint(x: 4.63, y: 0.5), controlPoint1: NSPoint(x: 5, y: 0.5), controlPoint2: NSPoint(x: 4.63, y: 0.5))
		a.curve(to: NSPoint(x: 0.5, y: 5.72), controlPoint1: NSPoint(x: 2.35, y: 0.5), controlPoint2: NSPoint(x: 0.5, y: 2.84))
		a.curve(to: NSPoint(x: 0.55, y: 9.6), controlPoint1: NSPoint(x: 0.5, y: 5.72), controlPoint2: NSPoint(x: 0.55, y: 9.2))
		a.curve(to: NSPoint(x: 0.88, y: 10), controlPoint1: NSPoint(x: 0.55, y: 10), controlPoint2: NSPoint(x: 0.88, y: 10))
		a.curve(to: NSPoint(x: 5, y: 4.77), controlPoint1: NSPoint(x: 3.15, y: 10), controlPoint2: NSPoint(x: 5, y: 7.66))
		a.close()
		a.move(to: NSPoint(x: 5.5, y: 4.77))
		a.curve(to: NSPoint(x: 5.5, y: 0.9), controlPoint1: NSPoint(x: 5.5, y: 4.77), controlPoint2: NSPoint(x: 5.5, y: 1.3))
		a.curve(to: NSPoint(x: 5.87, y: 0.5), controlPoint1: NSPoint(x: 5.5, y: 0.5), controlPoint2: NSPoint(x: 5.87, y: 0.5))
		a.curve(to: NSPoint(x: 10, y: 5.72), controlPoint1: NSPoint(x: 8.15, y: 0.5), controlPoint2: NSPoint(x: 10, y: 2.84))
		a.curve(to: NSPoint(x: 9.95, y: 9.6), controlPoint1: NSPoint(x: 10, y: 5.72), controlPoint2: NSPoint(x: 9.95, y: 9.2))
		a.curve(to: NSPoint(x: 9.62, y: 10), controlPoint1: NSPoint(x: 9.95, y: 10), controlPoint2: NSPoint(x: 9.62, y: 10))
		a.curve(to: NSPoint(x: 5.5, y: 4.77), controlPoint1: NSPoint(x: 7.35, y: 10), controlPoint2: NSPoint(x: 5.5, y: 7.66))
		a.close()
	}
}
