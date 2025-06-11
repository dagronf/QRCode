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
	@objc(QRCodePupilShapeFlame) public class Flame: NSObject, QRCodePupilShapeGenerator {
		/// Generator name
		@objc public static var Name: String { "flame" }
		/// Generator title
		@objc public static var Title: String { "Flame" }
		/// Create a hexagon leaf pupil shape, using the specified settings
		@objc public static func Create(_ settings: [String : Any]?) -> any QRCodePupilShapeGenerator { Flame() }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePupilShapeGenerator { Flame() }
		/// Reset the pupil shape generator back to defaults
		@objc public func reset() { }

		@objc public func settings() -> [String: Any] { [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_: Any?, forKey _: String) -> Bool { false }

		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath { pupilPath__ }
	}
}

public extension QRCodePupilShapeGenerator where Self == QRCode.PupilShape.Flame {
	/// Create a flame pupil shape generator
	/// - Returns: A pupil shape generator
	@inlinable static func flame() -> QRCodePupilShapeGenerator { QRCode.PupilShape.Flame() }
}

// MARK: - Paths

private let pupilPath__ = CGPath.make { flamepupilPath in
	flamepupilPath.move(to: CGPoint(x: 32.62, y: 34.67))
	flamepupilPath.curve(to: CGPoint(x: 37.13, y: 30), controlPoint1: CGPoint(x: 32.93, y: 30.97), controlPoint2: CGPoint(x: 33, y: 30.07))
	flamepupilPath.line(to: CGPoint(x: 60.01, y: 30))
	flamepupilPath.line(to: CGPoint(x: 60.01, y: 53.59))
	flamepupilPath.curve(to: CGPoint(x: 55.5, y: 58.33), controlPoint1: CGPoint(x: 60.02, y: 57.35), controlPoint2: CGPoint(x: 59.21, y: 57.98))
	flamepupilPath.line(to: CGPoint(x: 31.01, y: 60))
	flamepupilPath.line(to: CGPoint(x: 32.62, y: 34.67))
	flamepupilPath.close()
}.flippedVertically(height: 90)
