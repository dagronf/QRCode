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
	/// An circular-saw blade pupil design
	@objc(QRCodePupilShapeBlade) public class Blade: NSObject, QRCodePupilShapeGenerator {
		/// Generator name
		@objc public static var Name: String { "blade" }
		/// Generator title
		@objc public static var Title: String { "Blade" }
		/// Create a  leaf pupil shape, using the specified settings
		@objc public static func Create(_ settings: [String : Any]?) -> any QRCodePupilShapeGenerator { Blade() }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePupilShapeGenerator { Blade() }
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
	CGPath.make { pupilbladePath in
		pupilbladePath.move(to: CGPoint(x: 60, y: 39))
		pupilbladePath.curve(to: CGPoint(x: 57, y: 51), controlPoint1: CGPoint(x: 60, y: 42.46), controlPoint2: CGPoint(x: 57, y: 47))
		pupilbladePath.curve(to: CGPoint(x: 60, y: 57), controlPoint1: CGPoint(x: 57, y: 53.94), controlPoint2: CGPoint(x: 60, y: 57))
		pupilbladePath.curve(to: CGPoint(x: 51, y: 60), controlPoint1: CGPoint(x: 60, y: 57), controlPoint2: CGPoint(x: 57, y: 60))
		pupilbladePath.curve(to: CGPoint(x: 39, y: 57), controlPoint1: CGPoint(x: 47.75, y: 60), controlPoint2: CGPoint(x: 42.91, y: 57))
		pupilbladePath.curve(to: CGPoint(x: 33, y: 60), controlPoint1: CGPoint(x: 35.7, y: 57), controlPoint2: CGPoint(x: 33, y: 60))
		pupilbladePath.curve(to: CGPoint(x: 30, y: 51), controlPoint1: CGPoint(x: 33, y: 60), controlPoint2: CGPoint(x: 30, y: 57))
		pupilbladePath.curve(to: CGPoint(x: 33, y: 39), controlPoint1: CGPoint(x: 30, y: 47.76), controlPoint2: CGPoint(x: 33, y: 42.91))
		pupilbladePath.curve(to: CGPoint(x: 30, y: 33), controlPoint1: CGPoint(x: 33, y: 35.67), controlPoint2: CGPoint(x: 30, y: 33))
		pupilbladePath.curve(to: CGPoint(x: 39, y: 30), controlPoint1: CGPoint(x: 30, y: 33), controlPoint2: CGPoint(x: 33, y: 30))
		pupilbladePath.curve(to: CGPoint(x: 51, y: 33), controlPoint1: CGPoint(x: 42.21, y: 30), controlPoint2: CGPoint(x: 47.11, y: 33))
		pupilbladePath.curve(to: CGPoint(x: 57, y: 30), controlPoint1: CGPoint(x: 54.37, y: 33), controlPoint2: CGPoint(x: 57, y: 30))
		pupilbladePath.curve(to: CGPoint(x: 60, y: 39), controlPoint1: CGPoint(x: 57, y: 30), controlPoint2: CGPoint(x: 60, y: 33))
		pupilbladePath.close()
	}

public extension QRCodePupilShapeGenerator where Self == QRCode.PupilShape.Blade {
	/// Create an blade pupil shape generator
	/// - Returns: A pupil shape generator
	@inlinable static func blade() -> QRCodePupilShapeGenerator { QRCode.PupilShape.Blade() }
}
