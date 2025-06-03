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
	@objc(QRCodePupilShapeFabricScissors) public class FabricScissors: NSObject, QRCodePupilShapeGenerator {
		/// Generator name
		@objc public static var Name: String { "fabricScissors" }
		/// Generator title
		@objc public static var Title: String { "Fabric Scissors" }
		/// Create a hexagon leaf pupil shape, using the specified settings
		@objc public static func Create(_ settings: [String : Any]?) -> any QRCodePupilShapeGenerator { FabricScissors() }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePupilShapeGenerator { FabricScissors() }
		/// Reset the pupil shape generator back to defaults
		@objc public func reset() { }

		@objc public func settings() -> [String: Any] { [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_: Any?, forKey _: String) -> Bool { false }

		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath { pupilPath__ }
	}
}

public extension QRCodePupilShapeGenerator where Self == QRCode.PupilShape.FabricScissors {
	/// Create an explode pupil shape generator
	/// - Returns: A pupil shape generator
	@inlinable static func fabricScissors() -> QRCodePupilShapeGenerator { QRCode.PupilShape.FabricScissors() }
}

// MARK: - Paths

private let pupilPath__: CGPath =
	CGPath.make { eyePupilPath in
		eyePupilPath.move(to: CGPoint(x: 34.95, y: 59.9))
		eyePupilPath.curve(to: CGPoint(x: 37.45, y: 57.4), controlPoint1: CGPoint(x: 34.95, y: 59.9), controlPoint2: CGPoint(x: 36.2, y: 58.64))
		eyePupilPath.curve(to: CGPoint(x: 39.95, y: 59.9), controlPoint1: CGPoint(x: 38.7, y: 58.64), controlPoint2: CGPoint(x: 39.95, y: 59.9))
		eyePupilPath.curve(to: CGPoint(x: 42.45, y: 57.4), controlPoint1: CGPoint(x: 39.95, y: 59.9), controlPoint2: CGPoint(x: 41.2, y: 58.64))
		eyePupilPath.curve(to: CGPoint(x: 44.95, y: 59.9), controlPoint1: CGPoint(x: 43.69, y: 58.64), controlPoint2: CGPoint(x: 44.95, y: 59.9))
		eyePupilPath.curve(to: CGPoint(x: 47.45, y: 57.4), controlPoint1: CGPoint(x: 44.95, y: 59.9), controlPoint2: CGPoint(x: 46.2, y: 58.64))
		eyePupilPath.curve(to: CGPoint(x: 49.95, y: 59.9), controlPoint1: CGPoint(x: 48.69, y: 58.64), controlPoint2: CGPoint(x: 49.95, y: 59.9))
		eyePupilPath.curve(to: CGPoint(x: 52.45, y: 57.4), controlPoint1: CGPoint(x: 49.95, y: 59.9), controlPoint2: CGPoint(x: 51.2, y: 58.64))
		eyePupilPath.curve(to: CGPoint(x: 54.95, y: 59.9), controlPoint1: CGPoint(x: 53.7, y: 58.64), controlPoint2: CGPoint(x: 54.95, y: 59.9))
		eyePupilPath.curve(to: CGPoint(x: 59.9, y: 54.95), controlPoint1: CGPoint(x: 54.95, y: 59.9), controlPoint2: CGPoint(x: 59.9, y: 54.95))
		eyePupilPath.curve(to: CGPoint(x: 57.4, y: 52.45), controlPoint1: CGPoint(x: 59.9, y: 54.95), controlPoint2: CGPoint(x: 58.65, y: 53.7))
		eyePupilPath.curve(to: CGPoint(x: 59.9, y: 49.95), controlPoint1: CGPoint(x: 58.65, y: 51.2), controlPoint2: CGPoint(x: 59.9, y: 49.95))
		eyePupilPath.curve(to: CGPoint(x: 57.4, y: 47.45), controlPoint1: CGPoint(x: 59.9, y: 49.95), controlPoint2: CGPoint(x: 58.65, y: 48.7))
		eyePupilPath.curve(to: CGPoint(x: 59.9, y: 44.95), controlPoint1: CGPoint(x: 58.65, y: 46.2), controlPoint2: CGPoint(x: 59.9, y: 44.95))
		eyePupilPath.curve(to: CGPoint(x: 57.4, y: 42.45), controlPoint1: CGPoint(x: 59.9, y: 44.95), controlPoint2: CGPoint(x: 58.65, y: 43.7))
		eyePupilPath.curve(to: CGPoint(x: 59.9, y: 39.95), controlPoint1: CGPoint(x: 58.65, y: 41.2), controlPoint2: CGPoint(x: 59.9, y: 39.95))
		eyePupilPath.curve(to: CGPoint(x: 57.4, y: 37.45), controlPoint1: CGPoint(x: 59.9, y: 39.95), controlPoint2: CGPoint(x: 58.65, y: 38.7))
		eyePupilPath.curve(to: CGPoint(x: 59.9, y: 34.95), controlPoint1: CGPoint(x: 58.65, y: 36.2), controlPoint2: CGPoint(x: 59.9, y: 34.95))
		eyePupilPath.curve(to: CGPoint(x: 59.78, y: 34.83), controlPoint1: CGPoint(x: 59.9, y: 34.95), controlPoint2: CGPoint(x: 59.86, y: 34.91))
		eyePupilPath.curve(to: CGPoint(x: 59.66, y: 34.71), controlPoint1: CGPoint(x: 59.75, y: 34.8), controlPoint2: CGPoint(x: 59.71, y: 34.76))
		eyePupilPath.curve(to: CGPoint(x: 59.4, y: 34.45), controlPoint1: CGPoint(x: 59.59, y: 34.64), controlPoint2: CGPoint(x: 59.5, y: 34.55))
		eyePupilPath.curve(to: CGPoint(x: 56.68, y: 31.73), controlPoint1: CGPoint(x: 58.77, y: 33.82), controlPoint2: CGPoint(x: 57.64, y: 32.69))
		eyePupilPath.curve(to: CGPoint(x: 55.28, y: 30.33), controlPoint1: CGPoint(x: 56.11, y: 31.16), controlPoint2: CGPoint(x: 55.59, y: 30.64))
		eyePupilPath.curve(to: CGPoint(x: 54.95, y: 30), controlPoint1: CGPoint(x: 55.07, y: 30.12), controlPoint2: CGPoint(x: 54.95, y: 30))
		eyePupilPath.curve(to: CGPoint(x: 52.45, y: 32.5), controlPoint1: CGPoint(x: 54.95, y: 30), controlPoint2: CGPoint(x: 53.7, y: 31.25))
		eyePupilPath.curve(to: CGPoint(x: 50.57, y: 30.62), controlPoint1: CGPoint(x: 51.75, y: 31.8), controlPoint2: CGPoint(x: 51.05, y: 31.1))
		eyePupilPath.curve(to: CGPoint(x: 49.95, y: 30), controlPoint1: CGPoint(x: 50.19, y: 30.24), controlPoint2: CGPoint(x: 49.95, y: 30))
		eyePupilPath.curve(to: CGPoint(x: 47.45, y: 32.5), controlPoint1: CGPoint(x: 49.95, y: 30), controlPoint2: CGPoint(x: 48.7, y: 31.25))
		eyePupilPath.curve(to: CGPoint(x: 45.83, y: 30.88), controlPoint1: CGPoint(x: 46.87, y: 31.92), controlPoint2: CGPoint(x: 46.28, y: 31.33))
		eyePupilPath.curve(to: CGPoint(x: 44.95, y: 30), controlPoint1: CGPoint(x: 45.3, y: 30.35), controlPoint2: CGPoint(x: 44.95, y: 30))
		eyePupilPath.curve(to: CGPoint(x: 42.45, y: 32.5), controlPoint1: CGPoint(x: 44.95, y: 30), controlPoint2: CGPoint(x: 43.7, y: 31.25))
		eyePupilPath.curve(to: CGPoint(x: 41.05, y: 31.1), controlPoint1: CGPoint(x: 41.96, y: 32.01), controlPoint2: CGPoint(x: 41.46, y: 31.52))
		eyePupilPath.curve(to: CGPoint(x: 39.95, y: 30), controlPoint1: CGPoint(x: 40.41, y: 30.46), controlPoint2: CGPoint(x: 39.95, y: 30))
		eyePupilPath.curve(to: CGPoint(x: 37.45, y: 32.5), controlPoint1: CGPoint(x: 39.95, y: 30), controlPoint2: CGPoint(x: 38.7, y: 31.25))
		eyePupilPath.curve(to: CGPoint(x: 36.26, y: 31.31), controlPoint1: CGPoint(x: 37.04, y: 32.09), controlPoint2: CGPoint(x: 36.62, y: 31.67))
		eyePupilPath.curve(to: CGPoint(x: 35.86, y: 30.91), controlPoint1: CGPoint(x: 36.12, y: 31.17), controlPoint2: CGPoint(x: 35.98, y: 31.03))
		eyePupilPath.curve(to: CGPoint(x: 35.68, y: 30.73), controlPoint1: CGPoint(x: 35.8, y: 30.85), controlPoint2: CGPoint(x: 35.74, y: 30.79))
		eyePupilPath.curve(to: CGPoint(x: 34.95, y: 30), controlPoint1: CGPoint(x: 35.24, y: 30.29), controlPoint2: CGPoint(x: 34.95, y: 30))
		eyePupilPath.curve(to: CGPoint(x: 32.48, y: 32.47), controlPoint1: CGPoint(x: 34.95, y: 30), controlPoint2: CGPoint(x: 33.71, y: 31.24))
		eyePupilPath.curve(to: CGPoint(x: 30.33, y: 34.62), controlPoint1: CGPoint(x: 31.63, y: 33.32), controlPoint2: CGPoint(x: 30.78, y: 34.17))
		eyePupilPath.curve(to: CGPoint(x: 30, y: 34.95), controlPoint1: CGPoint(x: 30.12, y: 34.83), controlPoint2: CGPoint(x: 30, y: 34.95))
		eyePupilPath.curve(to: CGPoint(x: 32.5, y: 37.45), controlPoint1: CGPoint(x: 30, y: 34.95), controlPoint2: CGPoint(x: 31.25, y: 36.2))
		eyePupilPath.curve(to: CGPoint(x: 30.62, y: 39.33), controlPoint1: CGPoint(x: 31.8, y: 38.15), controlPoint2: CGPoint(x: 31.1, y: 38.85))
		eyePupilPath.curve(to: CGPoint(x: 30, y: 39.95), controlPoint1: CGPoint(x: 30.24, y: 39.71), controlPoint2: CGPoint(x: 30, y: 39.95))
		eyePupilPath.curve(to: CGPoint(x: 32.5, y: 42.45), controlPoint1: CGPoint(x: 30, y: 39.95), controlPoint2: CGPoint(x: 31.25, y: 41.2))
		eyePupilPath.curve(to: CGPoint(x: 31.53, y: 43.42), controlPoint1: CGPoint(x: 32.17, y: 42.78), controlPoint2: CGPoint(x: 31.84, y: 43.11))
		eyePupilPath.curve(to: CGPoint(x: 30.88, y: 44.07), controlPoint1: CGPoint(x: 31.29, y: 43.66), controlPoint2: CGPoint(x: 31.07, y: 43.88))
		eyePupilPath.curve(to: CGPoint(x: 30, y: 44.95), controlPoint1: CGPoint(x: 30.35, y: 44.6), controlPoint2: CGPoint(x: 30, y: 44.95))
		eyePupilPath.curve(to: CGPoint(x: 32.5, y: 47.45), controlPoint1: CGPoint(x: 30, y: 44.95), controlPoint2: CGPoint(x: 31.25, y: 46.2))
		eyePupilPath.curve(to: CGPoint(x: 31.1, y: 48.85), controlPoint1: CGPoint(x: 32.01, y: 47.94), controlPoint2: CGPoint(x: 31.52, y: 48.43))
		eyePupilPath.curve(to: CGPoint(x: 30, y: 49.95), controlPoint1: CGPoint(x: 30.46, y: 49.49), controlPoint2: CGPoint(x: 30, y: 49.95))
		eyePupilPath.curve(to: CGPoint(x: 32.5, y: 52.45), controlPoint1: CGPoint(x: 30, y: 49.95), controlPoint2: CGPoint(x: 31.25, y: 51.2))
		eyePupilPath.curve(to: CGPoint(x: 31.31, y: 53.64), controlPoint1: CGPoint(x: 32.09, y: 52.86), controlPoint2: CGPoint(x: 31.67, y: 53.28))
		eyePupilPath.curve(to: CGPoint(x: 30, y: 54.95), controlPoint1: CGPoint(x: 30.56, y: 54.39), controlPoint2: CGPoint(x: 30, y: 54.95))
		eyePupilPath.line(to: CGPoint(x: 34.95, y: 59.9))
		eyePupilPath.close()
	}
