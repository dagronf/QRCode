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
	/// An orbits leaf pupil design
	@objc(QRCodePupilShapeOrbits) public class Orbits: NSObject, QRCodePupilShapeGenerator {
		/// Generator name
		@objc public static var Name: String { "orbits" }
		/// Generator title
		@objc public static var Title: String { "Orbits" }
		/// Create a  leaf pupil shape, using the specified settings
		@objc public static func Create(_ settings: [String : Any]?) -> any QRCodePupilShapeGenerator { Orbits() }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePupilShapeGenerator { Orbits() }
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
	CGPath.make { pupilorbitsPath in
		pupilorbitsPath.move(to: CGPoint(x: 52, y: 53))
		pupilorbitsPath.curve(to: CGPoint(x: 52, y: 52), controlPoint1: CGPoint(x: 52, y: 53), controlPoint2: CGPoint(x: 52, y: 52.63))
		pupilorbitsPath.line(to: CGPoint(x: 53, y: 52))
		pupilorbitsPath.curve(to: CGPoint(x: 60, y: 45), controlPoint1: CGPoint(x: 56.87, y: 52), controlPoint2: CGPoint(x: 60, y: 48.87))
		pupilorbitsPath.curve(to: CGPoint(x: 53, y: 38), controlPoint1: CGPoint(x: 60, y: 41.13), controlPoint2: CGPoint(x: 56.87, y: 38))
		pupilorbitsPath.line(to: CGPoint(x: 52, y: 38))
		pupilorbitsPath.curve(to: CGPoint(x: 52, y: 37), controlPoint1: CGPoint(x: 52, y: 37.37), controlPoint2: CGPoint(x: 52, y: 37))
		pupilorbitsPath.curve(to: CGPoint(x: 45, y: 30), controlPoint1: CGPoint(x: 52, y: 33.13), controlPoint2: CGPoint(x: 48.87, y: 30))
		pupilorbitsPath.curve(to: CGPoint(x: 38, y: 37), controlPoint1: CGPoint(x: 41.13, y: 30), controlPoint2: CGPoint(x: 38, y: 33.13))
		pupilorbitsPath.curve(to: CGPoint(x: 38, y: 38), controlPoint1: CGPoint(x: 38, y: 37), controlPoint2: CGPoint(x: 38, y: 37.37))
		pupilorbitsPath.line(to: CGPoint(x: 37, y: 38))
		pupilorbitsPath.curve(to: CGPoint(x: 30, y: 45), controlPoint1: CGPoint(x: 33.13, y: 38), controlPoint2: CGPoint(x: 30, y: 41.13))
		pupilorbitsPath.curve(to: CGPoint(x: 37, y: 52), controlPoint1: CGPoint(x: 30, y: 48.87), controlPoint2: CGPoint(x: 33.13, y: 52))
		pupilorbitsPath.line(to: CGPoint(x: 38, y: 52))
		pupilorbitsPath.curve(to: CGPoint(x: 38, y: 53), controlPoint1: CGPoint(x: 38, y: 52.63), controlPoint2: CGPoint(x: 38, y: 53))
		pupilorbitsPath.curve(to: CGPoint(x: 45, y: 60), controlPoint1: CGPoint(x: 38, y: 56.87), controlPoint2: CGPoint(x: 41.13, y: 60))
		pupilorbitsPath.curve(to: CGPoint(x: 52, y: 53), controlPoint1: CGPoint(x: 48.87, y: 60), controlPoint2: CGPoint(x: 52, y: 56.87))
		pupilorbitsPath.close()
	}

public extension QRCodePupilShapeGenerator where Self == QRCode.PupilShape.Orbits {
	/// Create an orbits pupil shape generator
	/// - Returns: A pupil shape generator
	@inlinable static func orbits() -> QRCodePupilShapeGenerator { QRCode.PupilShape.Orbits() }
}
