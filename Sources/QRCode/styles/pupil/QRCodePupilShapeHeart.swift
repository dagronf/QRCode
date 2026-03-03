//
//  Copyright © 2026 Darren Ford. All rights reserved.
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
	/// A heart style pupil design
	@objc(QRCodePupilShapeHeart) public class Heart: NSObject, QRCodePupilShapeGenerator {
		/// Generator name
		@objc public static var Name: String { "heart" }
		/// Generator title
		@objc public static var Title: String { "Heart" }
		/// Create a heart pupil shape, using the specified settings
		@objc public static func Create(_ settings: [String : Any]?) -> any QRCodePupilShapeGenerator { Heart() }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePupilShapeGenerator { Heart() }
		/// Reset the pupil shape generator back to defaults
		@objc public func reset() { }

		@objc public func settings() -> [String: Any] { [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_: Any?, forKey _: String) -> Bool { false }

		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath { pupilPath__ }
	}
}

public extension QRCodePupilShapeGenerator where Self == QRCode.PupilShape.Heart {
	/// Create a heart pupil shape generator
	/// - Returns: A pupil shape generator
	@inlinable static func heart() -> QRCodePupilShapeGenerator { QRCode.PupilShape.Heart() }
}

// MARK: - Paths

private let pupilPath__ = CGPath.make { heartPath in
	heartPath.move(to: CGPoint(x: 60, y: 50.29))
	heartPath.curve(to: CGPoint(x: 45, y: 31), controlPoint1: CGPoint(x: 60, y: 38.45), controlPoint2: CGPoint(x: 45, y: 31))
	heartPath.curve(to: CGPoint(x: 30, y: 50.29), controlPoint1: CGPoint(x: 45, y: 31), controlPoint2: CGPoint(x: 30, y: 38.45))
	heartPath.curve(to: CGPoint(x: 37.67, y: 59), controlPoint1: CGPoint(x: 30, y: 53.35), controlPoint2: CGPoint(x: 31.58, y: 59))
	heartPath.curve(to: CGPoint(x: 45, y: 54.69), controlPoint1: CGPoint(x: 42.55, y: 59), controlPoint2: CGPoint(x: 45, y: 54.69))
	heartPath.curve(to: CGPoint(x: 52.33, y: 59), controlPoint1: CGPoint(x: 45, y: 54.69), controlPoint2: CGPoint(x: 47.45, y: 59))
	heartPath.curve(to: CGPoint(x: 60, y: 50.29), controlPoint1: CGPoint(x: 58.42, y: 59), controlPoint2: CGPoint(x: 60, y: 53.35))
	heartPath.close()
}.flippedVertically(height: 90)
