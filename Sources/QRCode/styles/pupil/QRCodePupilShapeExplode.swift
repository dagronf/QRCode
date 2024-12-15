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

extension QRCode.PupilShape {
	/// An explode pupil design
	@objc(QRCodePupilShapeExplode) public class Explode: NSObject, QRCodePupilShapeGenerator {
		/// Generator name
		@objc public static var Name: String { "explode" }
		/// Generator title
		@objc public static var Title: String { "Explode" }
		/// Create a hexagon leaf pupil shape, using the specified settings
		@objc public static func Create(_ settings: [String : Any]?) -> any QRCodePupilShapeGenerator { Explode() }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePupilShapeGenerator { Explode() }
		/// Reset the pupil shape generator back to defaults
		@objc public func reset() { }

		@objc public func settings() -> [String: Any] { [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_: Any?, forKey _: String) -> Bool { false }

		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath { _path() }
	}
}

private func _path() -> CGPath {
	CGPath.make { explodeeyepupilPath in
		explodeeyepupilPath.move(to: CGPoint(x: 32.5, y: 45.5))
		explodeeyepupilPath.curve(to: CGPoint(x: 30, y: 30), controlPoint1: CGPoint(x: 32.5, y: 38), controlPoint2: CGPoint(x: 30, y: 30))
		explodeeyepupilPath.curve(to: CGPoint(x: 45, y: 32.5), controlPoint1: CGPoint(x: 30, y: 30), controlPoint2: CGPoint(x: 37.5, y: 32.5))
		explodeeyepupilPath.curve(to: CGPoint(x: 60, y: 30), controlPoint1: CGPoint(x: 52.5, y: 32.5), controlPoint2: CGPoint(x: 60, y: 30))
		explodeeyepupilPath.curve(to: CGPoint(x: 57.5, y: 45), controlPoint1: CGPoint(x: 60, y: 30), controlPoint2: CGPoint(x: 57.5, y: 37.5))
		explodeeyepupilPath.curve(to: CGPoint(x: 60, y: 60), controlPoint1: CGPoint(x: 57.5, y: 52.5), controlPoint2: CGPoint(x: 60, y: 60))
		explodeeyepupilPath.curve(to: CGPoint(x: 45, y: 57.5), controlPoint1: CGPoint(x: 60, y: 60), controlPoint2: CGPoint(x: 52.5, y: 57.5))
		explodeeyepupilPath.curve(to: CGPoint(x: 30, y: 60), controlPoint1: CGPoint(x: 37.5, y: 57.5), controlPoint2: CGPoint(x: 30, y: 60))
		explodeeyepupilPath.curve(to: CGPoint(x: 32.5, y: 45.5), controlPoint1: CGPoint(x: 30, y: 60), controlPoint2: CGPoint(x: 32.5, y: 53))
		explodeeyepupilPath.close()
	}
}

public extension QRCodePupilShapeGenerator where Self == QRCode.PupilShape.Explode {
	/// Create an explode pupil shape generator
	/// - Returns: A pupil shape generator
	@inlinable static func explode() -> QRCodePupilShapeGenerator { QRCode.PupilShape.Explode() }
}