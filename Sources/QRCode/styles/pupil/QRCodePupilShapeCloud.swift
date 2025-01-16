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
	/// An cloud pupil design
	@objc(QRCodePupilShapeCloud) public class Cloud: NSObject, QRCodePupilShapeGenerator {
		/// Generator name
		@objc public static var Name: String { "cloud" }
		/// Generator title
		@objc public static var Title: String { "Cloud" }
		/// Create a  leaf pupil shape, using the specified settings
		@objc public static func Create(_ settings: [String : Any]?) -> any QRCodePupilShapeGenerator { Cloud() }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePupilShapeGenerator { Cloud() }
		/// Reset the pupil shape generator back to defaults
		@objc public func reset() { }

		@objc public func settings() -> [String: Any] { [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_: Any?, forKey _: String) -> Bool { false }

		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath { pupilPath__ }
	}
}

private let pupilPath__: CGPath =
	CGPath.make { pupilPath in
		pupilPath.move(to: CGPoint(x: 60, y: 55))
		pupilPath.curve(to: CGPoint(x: 58.57, y: 51.5), controlPoint1: CGPoint(x: 60, y: 53.64), controlPoint2: CGPoint(x: 59.45, y: 52.4))
		pupilPath.curve(to: CGPoint(x: 60, y: 48), controlPoint1: CGPoint(x: 59.45, y: 50.6), controlPoint2: CGPoint(x: 60, y: 49.36))
		pupilPath.curve(to: CGPoint(x: 59, y: 45), controlPoint1: CGPoint(x: 60, y: 46.87), controlPoint2: CGPoint(x: 59.63, y: 45.84))
		pupilPath.curve(to: CGPoint(x: 60, y: 42), controlPoint1: CGPoint(x: 59.63, y: 44.16), controlPoint2: CGPoint(x: 60, y: 43.13))
		pupilPath.curve(to: CGPoint(x: 58.57, y: 38.5), controlPoint1: CGPoint(x: 60, y: 40.64), controlPoint2: CGPoint(x: 59.45, y: 39.4))
		pupilPath.curve(to: CGPoint(x: 60, y: 35), controlPoint1: CGPoint(x: 59.45, y: 37.6), controlPoint2: CGPoint(x: 60, y: 36.36))
		pupilPath.curve(to: CGPoint(x: 55, y: 30), controlPoint1: CGPoint(x: 60, y: 32.24), controlPoint2: CGPoint(x: 57.76, y: 30))
		pupilPath.curve(to: CGPoint(x: 51.75, y: 31.2), controlPoint1: CGPoint(x: 53.76, y: 30), controlPoint2: CGPoint(x: 52.62, y: 30.45))
		pupilPath.curve(to: CGPoint(x: 48.5, y: 30), controlPoint1: CGPoint(x: 50.88, y: 30.45), controlPoint2: CGPoint(x: 49.74, y: 30))
		pupilPath.curve(to: CGPoint(x: 46.7, y: 30.33), controlPoint1: CGPoint(x: 47.87, y: 30), controlPoint2: CGPoint(x: 47.26, y: 30.12))
		pupilPath.curve(to: CGPoint(x: 45, y: 31.43), controlPoint1: CGPoint(x: 46.06, y: 30.58), controlPoint2: CGPoint(x: 45.48, y: 30.96))
		pupilPath.curve(to: CGPoint(x: 41.5, y: 30), controlPoint1: CGPoint(x: 44.1, y: 30.55), controlPoint2: CGPoint(x: 42.86, y: 30))
		pupilPath.curve(to: CGPoint(x: 40.33, y: 30.14), controlPoint1: CGPoint(x: 41.1, y: 30), controlPoint2: CGPoint(x: 40.71, y: 30.05))
		pupilPath.curve(to: CGPoint(x: 38.25, y: 31.2), controlPoint1: CGPoint(x: 39.55, y: 30.32), controlPoint2: CGPoint(x: 38.84, y: 30.69))
		pupilPath.curve(to: CGPoint(x: 35, y: 30), controlPoint1: CGPoint(x: 37.38, y: 30.45), controlPoint2: CGPoint(x: 36.24, y: 30))
		pupilPath.curve(to: CGPoint(x: 34.56, y: 30.02), controlPoint1: CGPoint(x: 34.85, y: 30), controlPoint2: CGPoint(x: 34.7, y: 30.01))
		pupilPath.curve(to: CGPoint(x: 33.23, y: 30.32), controlPoint1: CGPoint(x: 34.09, y: 30.06), controlPoint2: CGPoint(x: 33.65, y: 30.16))
		pupilPath.curve(to: CGPoint(x: 30, y: 35), controlPoint1: CGPoint(x: 31.34, y: 31.04), controlPoint2: CGPoint(x: 30, y: 32.86))
		pupilPath.curve(to: CGPoint(x: 31.43, y: 38.5), controlPoint1: CGPoint(x: 30, y: 36.36), controlPoint2: CGPoint(x: 30.55, y: 37.6))
		pupilPath.curve(to: CGPoint(x: 30, y: 42), controlPoint1: CGPoint(x: 30.55, y: 39.4), controlPoint2: CGPoint(x: 30, y: 40.64))
		pupilPath.curve(to: CGPoint(x: 31, y: 45), controlPoint1: CGPoint(x: 30, y: 43.13), controlPoint2: CGPoint(x: 30.37, y: 44.16))
		pupilPath.curve(to: CGPoint(x: 30, y: 48), controlPoint1: CGPoint(x: 30.37, y: 45.84), controlPoint2: CGPoint(x: 30, y: 46.87))
		pupilPath.curve(to: CGPoint(x: 31.43, y: 51.5), controlPoint1: CGPoint(x: 30, y: 49.36), controlPoint2: CGPoint(x: 30.55, y: 50.6))
		pupilPath.curve(to: CGPoint(x: 30, y: 55), controlPoint1: CGPoint(x: 30.55, y: 52.4), controlPoint2: CGPoint(x: 30, y: 53.64))
		pupilPath.curve(to: CGPoint(x: 35, y: 60), controlPoint1: CGPoint(x: 30, y: 57.76), controlPoint2: CGPoint(x: 32.24, y: 60))
		pupilPath.curve(to: CGPoint(x: 38.25, y: 58.8), controlPoint1: CGPoint(x: 36.24, y: 60), controlPoint2: CGPoint(x: 37.38, y: 59.55))
		pupilPath.curve(to: CGPoint(x: 41.5, y: 60), controlPoint1: CGPoint(x: 39.12, y: 59.55), controlPoint2: CGPoint(x: 40.26, y: 60))
		pupilPath.curve(to: CGPoint(x: 45, y: 58.57), controlPoint1: CGPoint(x: 42.86, y: 60), controlPoint2: CGPoint(x: 44.1, y: 59.45))
		pupilPath.curve(to: CGPoint(x: 48.5, y: 60), controlPoint1: CGPoint(x: 45.9, y: 59.45), controlPoint2: CGPoint(x: 47.14, y: 60))
		pupilPath.curve(to: CGPoint(x: 51.75, y: 58.8), controlPoint1: CGPoint(x: 49.74, y: 60), controlPoint2: CGPoint(x: 50.88, y: 59.55))
		pupilPath.curve(to: CGPoint(x: 55, y: 60), controlPoint1: CGPoint(x: 52.62, y: 59.55), controlPoint2: CGPoint(x: 53.76, y: 60))
		pupilPath.curve(to: CGPoint(x: 60, y: 55), controlPoint1: CGPoint(x: 57.76, y: 60), controlPoint2: CGPoint(x: 60, y: 57.76))
		pupilPath.close()
	}

public extension QRCodePupilShapeGenerator where Self == QRCode.PupilShape.Cloud {
	/// Create an orbits pupil shape generator
	/// - Returns: A pupil shape generator
	@inlinable static func cloud() -> QRCodePupilShapeGenerator { QRCode.PupilShape.Cloud() }
}
