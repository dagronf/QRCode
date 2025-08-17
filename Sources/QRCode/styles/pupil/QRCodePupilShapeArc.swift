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
	/// An arc pupil design
	@objc(QRCodePupilShapeArc) public class Arc: NSObject, QRCodePupilShapeGenerator {
		/// Generator name
		@objc public static var Name: String { "arc" }
		/// Generator title
		@objc public static var Title: String { "Arc" }
		/// Create an arc pupil shape, using the specified settings
		@objc public static func Create(_ settings: [String : Any]?) -> any QRCodePupilShapeGenerator { Arc() }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePupilShapeGenerator { Arc() }
		/// Reset the pupil shape generator back to defaults
		@objc public func reset() { }

		@objc public func settings() -> [String: Any] { [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_: Any?, forKey _: String) -> Bool { false }

		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath { pupilPath__ }
	}
}

public extension QRCodePupilShapeGenerator where Self == QRCode.PupilShape.Arc {
	/// Create an arc pupil shape generator with curved insets
	/// - Returns: A pupil shape generator
	@inlinable static func arc() -> QRCodePupilShapeGenerator { QRCode.PupilShape.Arc() }
}

// MARK: - Paths

private let pupilPath__: CGPath =
	CGPath.make { arcpupilPath in
		arcpupilPath.move(to: CGPoint(x: 30, y: 37))
		arcpupilPath.line(to: CGPoint(x: 30, y: 32))
		arcpupilPath.curve(to: CGPoint(x: 32, y: 30), controlPoint1: CGPoint(x: 30, y: 30.9), controlPoint2: CGPoint(x: 30.9, y: 30))
		arcpupilPath.line(to: CGPoint(x: 57, y: 30))
		arcpupilPath.curve(to: CGPoint(x: 60, y: 33), controlPoint1: CGPoint(x: 58.66, y: 30), controlPoint2: CGPoint(x: 60, y: 31.34))
		arcpupilPath.curve(to: CGPoint(x: 60, y: 52), controlPoint1: CGPoint(x: 60, y: 33), controlPoint2: CGPoint(x: 60, y: 44.97))
		arcpupilPath.curve(to: CGPoint(x: 60, y: 57), controlPoint1: CGPoint(x: 60, y: 52), controlPoint2: CGPoint(x: 60, y: 55.29))
		arcpupilPath.curve(to: CGPoint(x: 60, y: 58), controlPoint1: CGPoint(x: 60, y: 57.6), controlPoint2: CGPoint(x: 60, y: 58))
		arcpupilPath.curve(to: CGPoint(x: 58, y: 60), controlPoint1: CGPoint(x: 60, y: 59.1), controlPoint2: CGPoint(x: 59.1, y: 60))
		arcpupilPath.line(to: CGPoint(x: 54, y: 60))
		arcpupilPath.curve(to: CGPoint(x: 53.78, y: 59.99), controlPoint1: CGPoint(x: 53.92, y: 60), controlPoint2: CGPoint(x: 53.85, y: 60))
		arcpupilPath.curve(to: CGPoint(x: 53, y: 60), controlPoint1: CGPoint(x: 53.52, y: 60), controlPoint2: CGPoint(x: 53.26, y: 60))
		arcpupilPath.curve(to: CGPoint(x: 30, y: 37), controlPoint1: CGPoint(x: 40.3, y: 60), controlPoint2: CGPoint(x: 30, y: 49.7))
		arcpupilPath.close()
	}
	.flippedVertically(height: 90)
