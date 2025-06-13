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
	/// A flame style pupil design
	@objc(QRCodePupilShapeCloudCircle) public class CloudCircle: NSObject, QRCodePupilShapeGenerator {
		/// Generator name
		@objc public static var Name: String { "cloudCircle" }
		/// Generator title
		@objc public static var Title: String { "Cloud Circle" }
		/// Create a hexagon leaf pupil shape, using the specified settings
		@objc public static func Create(_ settings: [String : Any]?) -> any QRCodePupilShapeGenerator { CloudCircle() }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePupilShapeGenerator { CloudCircle() }
		/// Reset the pupil shape generator back to defaults
		@objc public func reset() { }

		@objc public func settings() -> [String: Any] { [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_: Any?, forKey _: String) -> Bool { false }

		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath { pupilPath__ }
	}
}

public extension QRCodePupilShapeGenerator where Self == QRCode.PupilShape.CloudCircle {
	/// Create a flame pupil shape generator
	/// - Returns: A pupil shape generator
	@inlinable static func cloudCircle() -> QRCodePupilShapeGenerator { QRCode.PupilShape.CloudCircle() }
}

// MARK: - Paths

private let pupilPath__ = CGPath.make { bezier2Path in
	bezier2Path.move(to: CGPoint(x: 50.13, y: 57.39))
	bezier2Path.curve(to: CGPoint(x: 55.61, y: 55.6), controlPoint1: CGPoint(x: 52.07, y: 57.69), controlPoint2: CGPoint(x: 54.12, y: 57.1))
	bezier2Path.curve(to: CGPoint(x: 57.4, y: 50.13), controlPoint1: CGPoint(x: 57.1, y: 54.11), controlPoint2: CGPoint(x: 57.69, y: 52.07))
	bezier2Path.curve(to: CGPoint(x: 60, y: 45), controlPoint1: CGPoint(x: 58.98, y: 48.97), controlPoint2: CGPoint(x: 60, y: 47.11))
	bezier2Path.curve(to: CGPoint(x: 57.4, y: 39.86), controlPoint1: CGPoint(x: 60, y: 42.89), controlPoint2: CGPoint(x: 58.98, y: 41.02))
	bezier2Path.curve(to: CGPoint(x: 55.61, y: 34.39), controlPoint1: CGPoint(x: 57.69, y: 37.93), controlPoint2: CGPoint(x: 57.1, y: 35.88))
	bezier2Path.curve(to: CGPoint(x: 50.13, y: 32.6), controlPoint1: CGPoint(x: 54.12, y: 32.9), controlPoint2: CGPoint(x: 52.07, y: 32.3))
	bezier2Path.curve(to: CGPoint(x: 45, y: 30), controlPoint1: CGPoint(x: 48.98, y: 31.02), controlPoint2: CGPoint(x: 47.11, y: 30))
	bezier2Path.curve(to: CGPoint(x: 43.14, y: 30.27), controlPoint1: CGPoint(x: 44.35, y: 30), controlPoint2: CGPoint(x: 43.73, y: 30.09))
	bezier2Path.curve(to: CGPoint(x: 41.6, y: 30.98), controlPoint1: CGPoint(x: 42.6, y: 30.44), controlPoint2: CGPoint(x: 42.08, y: 30.68))
	bezier2Path.curve(to: CGPoint(x: 39.86, y: 32.6), controlPoint1: CGPoint(x: 40.93, y: 31.41), controlPoint2: CGPoint(x: 40.34, y: 31.96))
	bezier2Path.curve(to: CGPoint(x: 34.39, y: 34.39), controlPoint1: CGPoint(x: 37.93, y: 32.3), controlPoint2: CGPoint(x: 35.88, y: 32.9))
	bezier2Path.curve(to: CGPoint(x: 32.6, y: 39.86), controlPoint1: CGPoint(x: 32.9, y: 35.88), controlPoint2: CGPoint(x: 32.31, y: 37.93))
	bezier2Path.curve(to: CGPoint(x: 31.93, y: 40.43), controlPoint1: CGPoint(x: 32.37, y: 40.04), controlPoint2: CGPoint(x: 32.14, y: 40.23))
	bezier2Path.curve(to: CGPoint(x: 30, y: 45), controlPoint1: CGPoint(x: 30.74, y: 41.59), controlPoint2: CGPoint(x: 30, y: 43.21))
	bezier2Path.curve(to: CGPoint(x: 32.6, y: 50.13), controlPoint1: CGPoint(x: 30, y: 47.11), controlPoint2: CGPoint(x: 31.02, y: 48.97))
	bezier2Path.curve(to: CGPoint(x: 34.39, y: 55.6), controlPoint1: CGPoint(x: 32.31, y: 52.07), controlPoint2: CGPoint(x: 32.9, y: 54.11))
	bezier2Path.curve(to: CGPoint(x: 39.87, y: 57.39), controlPoint1: CGPoint(x: 35.88, y: 57.1), controlPoint2: CGPoint(x: 37.93, y: 57.69))
	bezier2Path.curve(to: CGPoint(x: 45, y: 60), controlPoint1: CGPoint(x: 41.02, y: 58.97), controlPoint2: CGPoint(x: 42.89, y: 60))
	bezier2Path.curve(to: CGPoint(x: 50.13, y: 57.39), controlPoint1: CGPoint(x: 47.11, y: 60), controlPoint2: CGPoint(x: 48.98, y: 58.97))
	bezier2Path.close()
}.flippedVertically(height: 90)
