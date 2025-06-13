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
	@objc(QRCodePupilShapeGear) public class Gear: NSObject, QRCodePupilShapeGenerator {
		/// Generator name
		@objc public static var Name: String { "gear" }
		/// Generator title
		@objc public static var Title: String { "Gear" }
		/// Create a hexagon leaf pupil shape, using the specified settings
		@objc public static func Create(_ settings: [String : Any]?) -> any QRCodePupilShapeGenerator { Gear() }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePupilShapeGenerator { Gear() }
		/// Reset the pupil shape generator back to defaults
		@objc public func reset() { }

		@objc public func settings() -> [String: Any] { [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_: Any?, forKey _: String) -> Bool { false }

		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath { pupilPath__ }
	}
}

public extension QRCodePupilShapeGenerator where Self == QRCode.PupilShape.Gear {
	/// Create a flame pupil shape generator
	/// - Returns: A pupil shape generator
	@inlinable static func gear() -> QRCodePupilShapeGenerator { QRCode.PupilShape.Gear() }
}

// MARK: - Paths

private let pupilPath__ = CGPath.make { gearpupilPath in
	gearpupilPath.move(to: CGPoint(x: 60, y: 46.54))
	gearpupilPath.curve(to: CGPoint(x: 59.16, y: 47.53), controlPoint1: CGPoint(x: 59.99, y: 47.02), controlPoint2: CGPoint(x: 59.64, y: 47.43))
	gearpupilPath.line(to: CGPoint(x: 56.61, y: 47.98))
	gearpupilPath.curve(to: CGPoint(x: 56.47, y: 47.98), controlPoint1: CGPoint(x: 56.56, y: 47.98), controlPoint2: CGPoint(x: 56.52, y: 47.98))
	gearpupilPath.curve(to: CGPoint(x: 55.22, y: 51), controlPoint1: CGPoint(x: 56.2, y: 49.04), controlPoint2: CGPoint(x: 55.78, y: 50.06))
	gearpupilPath.curve(to: CGPoint(x: 55.31, y: 51.11), controlPoint1: CGPoint(x: 55.25, y: 51.03), controlPoint2: CGPoint(x: 55.28, y: 51.07))
	gearpupilPath.line(to: CGPoint(x: 56.8, y: 53.23))
	gearpupilPath.curve(to: CGPoint(x: 56.69, y: 54.52), controlPoint1: CGPoint(x: 57.07, y: 53.63), controlPoint2: CGPoint(x: 57.03, y: 54.17))
	gearpupilPath.line(to: CGPoint(x: 54.52, y: 56.69))
	gearpupilPath.curve(to: CGPoint(x: 53.22, y: 56.81), controlPoint1: CGPoint(x: 54.17, y: 57.03), controlPoint2: CGPoint(x: 53.63, y: 57.07))
	gearpupilPath.line(to: CGPoint(x: 51.1, y: 55.31))
	gearpupilPath.curve(to: CGPoint(x: 51, y: 55.22), controlPoint1: CGPoint(x: 51.07, y: 55.28), controlPoint2: CGPoint(x: 51.03, y: 55.25))
	gearpupilPath.curve(to: CGPoint(x: 47.98, y: 56.47), controlPoint1: CGPoint(x: 50.06, y: 55.78), controlPoint2: CGPoint(x: 49.04, y: 56.2))
	gearpupilPath.curve(to: CGPoint(x: 47.97, y: 56.61), controlPoint1: CGPoint(x: 47.98, y: 56.52), controlPoint2: CGPoint(x: 47.98, y: 56.56))
	gearpupilPath.line(to: CGPoint(x: 47.53, y: 59.16))
	gearpupilPath.curve(to: CGPoint(x: 46.54, y: 60), controlPoint1: CGPoint(x: 47.44, y: 59.64), controlPoint2: CGPoint(x: 47.02, y: 59.98))
	gearpupilPath.line(to: CGPoint(x: 43.46, y: 60))
	gearpupilPath.curve(to: CGPoint(x: 42.47, y: 59.16), controlPoint1: CGPoint(x: 42.97, y: 59.98), controlPoint2: CGPoint(x: 42.56, y: 59.64))
	gearpupilPath.line(to: CGPoint(x: 42.02, y: 56.61))
	gearpupilPath.curve(to: CGPoint(x: 42.01, y: 56.48), controlPoint1: CGPoint(x: 42.02, y: 56.57), controlPoint2: CGPoint(x: 42.01, y: 56.52))
	gearpupilPath.curve(to: CGPoint(x: 38.99, y: 55.22), controlPoint1: CGPoint(x: 40.95, y: 56.2), controlPoint2: CGPoint(x: 39.94, y: 55.78))
	gearpupilPath.curve(to: CGPoint(x: 38.89, y: 55.31), controlPoint1: CGPoint(x: 38.96, y: 55.25), controlPoint2: CGPoint(x: 38.93, y: 55.28))
	gearpupilPath.line(to: CGPoint(x: 36.78, y: 56.8))
	gearpupilPath.curve(to: CGPoint(x: 35.48, y: 56.69), controlPoint1: CGPoint(x: 36.37, y: 57.07), controlPoint2: CGPoint(x: 35.83, y: 57.02))
	gearpupilPath.line(to: CGPoint(x: 33.31, y: 54.52))
	gearpupilPath.curve(to: CGPoint(x: 33.19, y: 53.22), controlPoint1: CGPoint(x: 32.97, y: 54.16), controlPoint2: CGPoint(x: 32.93, y: 53.63))
	gearpupilPath.line(to: CGPoint(x: 34.69, y: 51.1))
	gearpupilPath.curve(to: CGPoint(x: 34.78, y: 51), controlPoint1: CGPoint(x: 34.71, y: 51.06), controlPoint2: CGPoint(x: 34.74, y: 51.03))
	gearpupilPath.curve(to: CGPoint(x: 33.53, y: 47.98), controlPoint1: CGPoint(x: 34.22, y: 50.06), controlPoint2: CGPoint(x: 33.8, y: 49.04))
	gearpupilPath.curve(to: CGPoint(x: 33.39, y: 47.97), controlPoint1: CGPoint(x: 33.48, y: 47.98), controlPoint2: CGPoint(x: 33.44, y: 47.98))
	gearpupilPath.line(to: CGPoint(x: 30.84, y: 47.53))
	gearpupilPath.curve(to: CGPoint(x: 30, y: 46.54), controlPoint1: CGPoint(x: 30.36, y: 47.43), controlPoint2: CGPoint(x: 30.02, y: 47.02))
	gearpupilPath.line(to: CGPoint(x: 30, y: 43.46))
	gearpupilPath.curve(to: CGPoint(x: 30.84, y: 42.47), controlPoint1: CGPoint(x: 30.02, y: 42.97), controlPoint2: CGPoint(x: 30.36, y: 42.56))
	gearpupilPath.line(to: CGPoint(x: 33.39, y: 42.02))
	gearpupilPath.curve(to: CGPoint(x: 33.53, y: 42.01), controlPoint1: CGPoint(x: 33.44, y: 42.02), controlPoint2: CGPoint(x: 33.48, y: 42.01))
	gearpupilPath.curve(to: CGPoint(x: 34.78, y: 39), controlPoint1: CGPoint(x: 33.8, y: 40.96), controlPoint2: CGPoint(x: 34.22, y: 39.94))
	gearpupilPath.curve(to: CGPoint(x: 34.69, y: 38.89), controlPoint1: CGPoint(x: 34.74, y: 38.96), controlPoint2: CGPoint(x: 34.71, y: 38.93))
	gearpupilPath.line(to: CGPoint(x: 33.19, y: 36.77))
	gearpupilPath.curve(to: CGPoint(x: 33.31, y: 35.48), controlPoint1: CGPoint(x: 32.93, y: 36.37), controlPoint2: CGPoint(x: 32.97, y: 35.83))
	gearpupilPath.line(to: CGPoint(x: 35.48, y: 33.31))
	gearpupilPath.curve(to: CGPoint(x: 36.78, y: 33.19), controlPoint1: CGPoint(x: 35.83, y: 32.97), controlPoint2: CGPoint(x: 36.37, y: 32.93))
	gearpupilPath.line(to: CGPoint(x: 38.9, y: 34.69))
	gearpupilPath.curve(to: CGPoint(x: 39, y: 34.78), controlPoint1: CGPoint(x: 38.93, y: 34.71), controlPoint2: CGPoint(x: 38.97, y: 34.74))
	gearpupilPath.curve(to: CGPoint(x: 42.02, y: 33.53), controlPoint1: CGPoint(x: 39.94, y: 34.22), controlPoint2: CGPoint(x: 40.96, y: 33.8))
	gearpupilPath.curve(to: CGPoint(x: 42.03, y: 33.39), controlPoint1: CGPoint(x: 42.02, y: 33.48), controlPoint2: CGPoint(x: 42.02, y: 33.43))
	gearpupilPath.line(to: CGPoint(x: 42.47, y: 30.84))
	gearpupilPath.curve(to: CGPoint(x: 43.46, y: 30), controlPoint1: CGPoint(x: 42.56, y: 30.36), controlPoint2: CGPoint(x: 42.98, y: 30.01))
	gearpupilPath.line(to: CGPoint(x: 46.54, y: 30))
	gearpupilPath.curve(to: CGPoint(x: 47.53, y: 30.84), controlPoint1: CGPoint(x: 47.02, y: 30.01), controlPoint2: CGPoint(x: 47.43, y: 30.36))
	gearpupilPath.line(to: CGPoint(x: 47.97, y: 33.39))
	gearpupilPath.curve(to: CGPoint(x: 47.98, y: 33.52), controlPoint1: CGPoint(x: 47.98, y: 33.43), controlPoint2: CGPoint(x: 47.98, y: 33.48))
	gearpupilPath.curve(to: CGPoint(x: 51, y: 34.78), controlPoint1: CGPoint(x: 49.04, y: 33.8), controlPoint2: CGPoint(x: 50.06, y: 34.22))
	gearpupilPath.curve(to: CGPoint(x: 51.11, y: 34.69), controlPoint1: CGPoint(x: 51.03, y: 34.74), controlPoint2: CGPoint(x: 51.07, y: 34.72))
	gearpupilPath.line(to: CGPoint(x: 53.22, y: 33.19))
	gearpupilPath.curve(to: CGPoint(x: 54.52, y: 33.3), controlPoint1: CGPoint(x: 53.63, y: 32.93), controlPoint2: CGPoint(x: 54.17, y: 32.97))
	gearpupilPath.line(to: CGPoint(x: 56.69, y: 35.48))
	gearpupilPath.curve(to: CGPoint(x: 56.81, y: 36.77), controlPoint1: CGPoint(x: 57.03, y: 35.83), controlPoint2: CGPoint(x: 57.07, y: 36.37))
	gearpupilPath.line(to: CGPoint(x: 55.31, y: 38.89))
	gearpupilPath.curve(to: CGPoint(x: 55.22, y: 39), controlPoint1: CGPoint(x: 55.29, y: 38.93), controlPoint2: CGPoint(x: 55.26, y: 38.96))
	gearpupilPath.curve(to: CGPoint(x: 56.47, y: 42.01), controlPoint1: CGPoint(x: 55.78, y: 39.94), controlPoint2: CGPoint(x: 56.2, y: 40.95))
	gearpupilPath.curve(to: CGPoint(x: 56.61, y: 42.02), controlPoint1: CGPoint(x: 56.52, y: 42.01), controlPoint2: CGPoint(x: 56.56, y: 42.02))
	gearpupilPath.line(to: CGPoint(x: 59.16, y: 42.47))
	gearpupilPath.curve(to: CGPoint(x: 60, y: 43.46), controlPoint1: CGPoint(x: 59.64, y: 42.56), controlPoint2: CGPoint(x: 59.99, y: 42.97))
	gearpupilPath.line(to: CGPoint(x: 60, y: 46.54))
	gearpupilPath.close()
}.flippedVertically(height: 90)
