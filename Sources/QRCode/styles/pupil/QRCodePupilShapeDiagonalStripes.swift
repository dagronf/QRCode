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

extension QRCode.PupilShape {
	/// An explode pupil design
	@objc(QRCodePupilShapeDiagonalStripes) public class DiagonalStripes: NSObject, QRCodePupilShapeGenerator {
		/// Generator name
		@objc public static var Name: String { "diagonalStripes" }
		/// Generator title
		@objc public static var Title: String { "Diagonal Stripes" }
		/// Create a hexagon leaf pupil shape, using the specified settings
		@objc public static func Create(_ settings: [String : Any]?) -> any QRCodePupilShapeGenerator { DiagonalStripes() }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePupilShapeGenerator { DiagonalStripes() }
		/// Reset the pupil shape generator back to defaults
		@objc public func reset() { }

		@objc public func settings() -> [String: Any] { [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_: Any?, forKey _: String) -> Bool { false }

		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath { pupilPath__ }
	}
}

public extension QRCodePupilShapeGenerator where Self == QRCode.PupilShape.DiagonalStripes {
	/// Create an explode pupil shape generator
	/// - Returns: A pupil shape generator
	@inlinable static func diagonalStripes() -> QRCodePupilShapeGenerator { QRCode.PupilShape.DiagonalStripes() }
}

// MARK: - Paths

private let pupilPath__: CGPath =
	CGPath.make { eyePupilPath in
		eyePupilPath.move(to: CGPoint(x: 33.36, y: 56.98))
		eyePupilPath.curve(to: CGPoint(x: 30, y: 53.62), controlPoint1: CGPoint(x: 32.23, y: 55.86), controlPoint2: CGPoint(x: 31.11, y: 54.74))
		eyePupilPath.curve(to: CGPoint(x: 30, y: 56), controlPoint1: CGPoint(x: 30, y: 55.08), controlPoint2: CGPoint(x: 30, y: 56))
		eyePupilPath.curve(to: CGPoint(x: 30.01, y: 56.2), controlPoint1: CGPoint(x: 30, y: 56.07), controlPoint2: CGPoint(x: 30, y: 56.14))
		eyePupilPath.curve(to: CGPoint(x: 33.79, y: 59.99), controlPoint1: CGPoint(x: 31.27, y: 57.46), controlPoint2: CGPoint(x: 32.53, y: 58.73))
		eyePupilPath.curve(to: CGPoint(x: 34, y: 60), controlPoint1: CGPoint(x: 33.86, y: 60), controlPoint2: CGPoint(x: 33.93, y: 60))
		eyePupilPath.line(to: CGPoint(x: 36.37, y: 60))
		eyePupilPath.curve(to: CGPoint(x: 33.36, y: 56.98), controlPoint1: CGPoint(x: 35.37, y: 58.99), controlPoint2: CGPoint(x: 34.36, y: 57.99))
		eyePupilPath.close()
		eyePupilPath.move(to: CGPoint(x: 30, y: 49.07))
		eyePupilPath.curve(to: CGPoint(x: 30, y: 51.64), controlPoint1: CGPoint(x: 30, y: 49.98), controlPoint2: CGPoint(x: 30, y: 50.85))
		eyePupilPath.line(to: CGPoint(x: 31.03, y: 52.67))
		eyePupilPath.curve(to: CGPoint(x: 38.35, y: 60), controlPoint1: CGPoint(x: 33.46, y: 55.11), controlPoint2: CGPoint(x: 35.92, y: 57.57))
		eyePupilPath.line(to: CGPoint(x: 40.93, y: 60))
		eyePupilPath.curve(to: CGPoint(x: 30, y: 49.07), controlPoint1: CGPoint(x: 37.31, y: 56.38), controlPoint2: CGPoint(x: 33.61, y: 52.68))
		eyePupilPath.close()
		eyePupilPath.move(to: CGPoint(x: 38.89, y: 53.4))
		eyePupilPath.curve(to: CGPoint(x: 34.19, y: 48.71), controlPoint1: CGPoint(x: 37.32, y: 51.84), controlPoint2: CGPoint(x: 35.75, y: 50.27))
		eyePupilPath.curve(to: CGPoint(x: 30, y: 44.51), controlPoint1: CGPoint(x: 32.78, y: 47.3), controlPoint2: CGPoint(x: 31.38, y: 45.9))
		eyePupilPath.curve(to: CGPoint(x: 30, y: 47.09), controlPoint1: CGPoint(x: 30, y: 45.37), controlPoint2: CGPoint(x: 30, y: 46.24))
		eyePupilPath.curve(to: CGPoint(x: 42.9, y: 60), controlPoint1: CGPoint(x: 34.26, y: 51.35), controlPoint2: CGPoint(x: 38.65, y: 55.74))
		eyePupilPath.line(to: CGPoint(x: 45.48, y: 60))
		eyePupilPath.curve(to: CGPoint(x: 38.89, y: 53.4), controlPoint1: CGPoint(x: 43.31, y: 57.83), controlPoint2: CGPoint(x: 41.1, y: 55.62))
		eyePupilPath.close()
		eyePupilPath.move(to: CGPoint(x: 30, y: 39.96))
		eyePupilPath.curve(to: CGPoint(x: 30, y: 42.53), controlPoint1: CGPoint(x: 30, y: 40.78), controlPoint2: CGPoint(x: 30, y: 41.64))
		eyePupilPath.curve(to: CGPoint(x: 34.14, y: 46.68), controlPoint1: CGPoint(x: 31.36, y: 43.9), controlPoint2: CGPoint(x: 32.75, y: 45.28))
		eyePupilPath.curve(to: CGPoint(x: 45.04, y: 57.58), controlPoint1: CGPoint(x: 37.74, y: 50.28), controlPoint2: CGPoint(x: 41.43, y: 53.97))
		eyePupilPath.curve(to: CGPoint(x: 47.46, y: 60), controlPoint1: CGPoint(x: 45.85, y: 58.39), controlPoint2: CGPoint(x: 46.65, y: 59.2))
		eyePupilPath.line(to: CGPoint(x: 50.03, y: 60))
		eyePupilPath.curve(to: CGPoint(x: 30, y: 39.96), controlPoint1: CGPoint(x: 43.46, y: 53.42), controlPoint2: CGPoint(x: 36.43, y: 46.39))
		eyePupilPath.close()
		eyePupilPath.move(to: CGPoint(x: 49.75, y: 55.17))
		eyePupilPath.curve(to: CGPoint(x: 30, y: 35.4), controlPoint1: CGPoint(x: 43.16, y: 48.57), controlPoint2: CGPoint(x: 36.23, y: 41.64))
		eyePupilPath.curve(to: CGPoint(x: 30, y: 37.98), controlPoint1: CGPoint(x: 30, y: 36.07), controlPoint2: CGPoint(x: 30, y: 36.96))
		eyePupilPath.line(to: CGPoint(x: 30.15, y: 38.13))
		eyePupilPath.curve(to: CGPoint(x: 32.33, y: 40.31), controlPoint1: CGPoint(x: 30.87, y: 38.85), controlPoint2: CGPoint(x: 31.6, y: 39.58))
		eyePupilPath.curve(to: CGPoint(x: 52.01, y: 60), controlPoint1: CGPoint(x: 38.74, y: 46.72), controlPoint2: CGPoint(x: 45.63, y: 53.62))
		eyePupilPath.line(to: CGPoint(x: 54.58, y: 60))
		eyePupilPath.curve(to: CGPoint(x: 49.75, y: 55.17), controlPoint1: CGPoint(x: 53.01, y: 58.42), controlPoint2: CGPoint(x: 51.39, y: 56.81))
		eyePupilPath.close()
		eyePupilPath.move(to: CGPoint(x: 58.36, y: 59.23))
		eyePupilPath.curve(to: CGPoint(x: 53.9, y: 54.76), controlPoint1: CGPoint(x: 56.91, y: 57.77), controlPoint2: CGPoint(x: 55.42, y: 56.28))
		eyePupilPath.line(to: CGPoint(x: 53.71, y: 54.57))
		eyePupilPath.curve(to: CGPoint(x: 50.18, y: 51.04), controlPoint1: CGPoint(x: 52.55, y: 53.41), controlPoint2: CGPoint(x: 51.37, y: 52.23))
		eyePupilPath.line(to: CGPoint(x: 49.98, y: 50.84))
		eyePupilPath.curve(to: CGPoint(x: 33.79, y: 34.64), controlPoint1: CGPoint(x: 44.57, y: 45.42), controlPoint2: CGPoint(x: 38.99, y: 39.84))
		eyePupilPath.line(to: CGPoint(x: 33.6, y: 34.45))
		eyePupilPath.curve(to: CGPoint(x: 30.78, y: 31.63), controlPoint1: CGPoint(x: 32.65, y: 33.5), controlPoint2: CGPoint(x: 31.7, y: 32.55))
		eyePupilPath.curve(to: CGPoint(x: 30.04, y: 33.46), controlPoint1: CGPoint(x: 30.39, y: 32.15), controlPoint2: CGPoint(x: 30.13, y: 32.78))
		eyePupilPath.curve(to: CGPoint(x: 35.65, y: 39.07), controlPoint1: CGPoint(x: 31.85, y: 35.28), controlPoint2: CGPoint(x: 33.73, y: 37.16))
		eyePupilPath.curve(to: CGPoint(x: 52.4, y: 55.83), controlPoint1: CGPoint(x: 41.14, y: 44.57), controlPoint2: CGPoint(x: 46.93, y: 50.36))
		eyePupilPath.curve(to: CGPoint(x: 56.53, y: 59.97), controlPoint1: CGPoint(x: 53.8, y: 57.24), controlPoint2: CGPoint(x: 55.18, y: 58.62))
		eyePupilPath.curve(to: CGPoint(x: 58.36, y: 59.23), controlPoint1: CGPoint(x: 57.21, y: 59.88), controlPoint2: CGPoint(x: 57.83, y: 59.62))
		eyePupilPath.close()
		eyePupilPath.move(to: CGPoint(x: 59.33, y: 58.22))
		eyePupilPath.curve(to: CGPoint(x: 59.99, y: 56.3), controlPoint1: CGPoint(x: 59.7, y: 57.66), controlPoint2: CGPoint(x: 59.94, y: 57))
		eyePupilPath.curve(to: CGPoint(x: 33.72, y: 30.01), controlPoint1: CGPoint(x: 51.65, y: 47.95), controlPoint2: CGPoint(x: 42.06, y: 38.36))
		eyePupilPath.curve(to: CGPoint(x: 31.79, y: 30.66), controlPoint1: CGPoint(x: 33.01, y: 30.06), controlPoint2: CGPoint(x: 32.35, y: 30.29))
		eyePupilPath.curve(to: CGPoint(x: 59.33, y: 58.22), controlPoint1: CGPoint(x: 40.5, y: 39.37), controlPoint2: CGPoint(x: 50.63, y: 49.51))
		eyePupilPath.close()
		eyePupilPath.move(to: CGPoint(x: 60, y: 36.11))
		eyePupilPath.curve(to: CGPoint(x: 60, y: 34), controlPoint1: CGPoint(x: 60, y: 34.81), controlPoint2: CGPoint(x: 60, y: 34))
		eyePupilPath.curve(to: CGPoint(x: 59.97, y: 33.5), controlPoint1: CGPoint(x: 60, y: 33.83), controlPoint2: CGPoint(x: 59.99, y: 33.67))
		eyePupilPath.curve(to: CGPoint(x: 56.5, y: 30.03), controlPoint1: CGPoint(x: 58.81, y: 32.35), controlPoint2: CGPoint(x: 57.65, y: 31.19))
		eyePupilPath.curve(to: CGPoint(x: 56, y: 30), controlPoint1: CGPoint(x: 56.33, y: 30.01), controlPoint2: CGPoint(x: 56.17, y: 30))
		eyePupilPath.line(to: CGPoint(x: 53.89, y: 30))
		eyePupilPath.curve(to: CGPoint(x: 60, y: 36.11), controlPoint1: CGPoint(x: 55.92, y: 32.03), controlPoint2: CGPoint(x: 57.96, y: 34.07))
		eyePupilPath.close()
		eyePupilPath.move(to: CGPoint(x: 60, y: 40.67))
		eyePupilPath.curve(to: CGPoint(x: 60, y: 38.09), controlPoint1: CGPoint(x: 60, y: 39.75), controlPoint2: CGPoint(x: 60, y: 38.88))
		eyePupilPath.curve(to: CGPoint(x: 51.91, y: 30), controlPoint1: CGPoint(x: 57.32, y: 35.41), controlPoint2: CGPoint(x: 54.6, y: 32.69))
		eyePupilPath.line(to: CGPoint(x: 49.34, y: 30))
		eyePupilPath.curve(to: CGPoint(x: 60, y: 40.67), controlPoint1: CGPoint(x: 52.87, y: 33.53), controlPoint2: CGPoint(x: 56.47, y: 37.14))
		eyePupilPath.close()
		eyePupilPath.move(to: CGPoint(x: 60, y: 42.65))
		eyePupilPath.curve(to: CGPoint(x: 47.36, y: 30), controlPoint1: CGPoint(x: 55.82, y: 38.46), controlPoint2: CGPoint(x: 51.52, y: 34.16))
		eyePupilPath.line(to: CGPoint(x: 44.79, y: 30))
		eyePupilPath.curve(to: CGPoint(x: 60, y: 45.22), controlPoint1: CGPoint(x: 49.77, y: 34.98), controlPoint2: CGPoint(x: 54.99, y: 40.21))
		eyePupilPath.curve(to: CGPoint(x: 60, y: 42.65), controlPoint1: CGPoint(x: 60, y: 44.36), controlPoint2: CGPoint(x: 60, y: 43.49))
		eyePupilPath.close()
		eyePupilPath.move(to: CGPoint(x: 60, y: 47.2))
		eyePupilPath.curve(to: CGPoint(x: 48.89, y: 36.08), controlPoint1: CGPoint(x: 56.36, y: 43.56), controlPoint2: CGPoint(x: 52.6, y: 39.79))
		eyePupilPath.curve(to: CGPoint(x: 42.81, y: 30), controlPoint1: CGPoint(x: 46.84, y: 34.03), controlPoint2: CGPoint(x: 44.8, y: 31.99))
		eyePupilPath.line(to: CGPoint(x: 40.24, y: 30))
		eyePupilPath.curve(to: CGPoint(x: 60, y: 49.78), controlPoint1: CGPoint(x: 46.61, y: 36.38), controlPoint2: CGPoint(x: 53.54, y: 43.31))
		eyePupilPath.curve(to: CGPoint(x: 60, y: 47.2), controlPoint1: CGPoint(x: 60, y: 48.95), controlPoint2: CGPoint(x: 60, y: 48.09))
		eyePupilPath.close()
		eyePupilPath.move(to: CGPoint(x: 60, y: 51.76))
		eyePupilPath.curve(to: CGPoint(x: 38.26, y: 30), controlPoint1: CGPoint(x: 52.89, y: 44.65), controlPoint2: CGPoint(x: 45.19, y: 36.94))
		eyePupilPath.line(to: CGPoint(x: 35.68, y: 30))
		eyePupilPath.curve(to: CGPoint(x: 60, y: 54.33), controlPoint1: CGPoint(x: 43.35, y: 37.67), controlPoint2: CGPoint(x: 52.11, y: 46.43))
		eyePupilPath.curve(to: CGPoint(x: 60, y: 51.76), controlPoint1: CGPoint(x: 60, y: 53.64), controlPoint2: CGPoint(x: 60, y: 52.76))
		eyePupilPath.close()
	}
