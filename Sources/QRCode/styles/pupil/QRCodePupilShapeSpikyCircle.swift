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

import Foundation
import CoreGraphics

// MARK: - Pupil shape

public extension QRCode.PupilShape {
	/// A circle style pupil design
	@objc(QRCodePupilShapeSpikyCircle) class SpikyCircle: NSObject, QRCodePupilShapeGenerator {
		@objc public static var Name: String { "spikyCircle" }
		/// The generator title
		@objc public static var Title: String { "Spiky Circle" }
		/// Create a pupil generator with the provided settings
		@objc public static func Create(_ settings: [String : Any]?) -> any QRCodePupilShapeGenerator { SpikyCircle() }

		/// Create a pupil generator
		@objc public override init() {
			super.init()
		}

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePupilShapeGenerator { SpikyCircle() }
		/// Reset the pupil shape generator back to defaults
		@objc public func reset() { }

		@objc public func settings() -> [String : Any] { [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath { pupilGeneratedPath__ }
	}
}

public extension QRCodePupilShapeGenerator where Self == QRCode.PupilShape.SpikyCircle {
	/// Create a circle pupil shape generator
	/// - Returns: A pupil shape generator
	@inlinable static func spikyCircle() -> QRCodePupilShapeGenerator { QRCode.PupilShape.SpikyCircle() }
}

// MARK: - Paths

/// The fixed pupil shape
private let pupilGeneratedPath__: CGPath = {
	CGPath.make { eyepupilPath in
		eyepupilPath.move(to: CGPoint(x: 55.32, y: 33.92))
		eyepupilPath.curve(to: CGPoint(x: 52.61, y: 33.53), controlPoint1: CGPoint(x: 55.32, y: 33.92), controlPoint2: CGPoint(x: 53.3, y: 33.98))
		eyepupilPath.curve(to: CGPoint(x: 51.16, y: 31.21), controlPoint1: CGPoint(x: 51.92, y: 33.08), controlPoint2: CGPoint(x: 51.16, y: 31.21))
		eyepupilPath.curve(to: CGPoint(x: 48.46, y: 31.72), controlPoint1: CGPoint(x: 51.16, y: 31.21), controlPoint2: CGPoint(x: 49.26, y: 31.92))
		eyepupilPath.curve(to: CGPoint(x: 46.34, y: 30), controlPoint1: CGPoint(x: 47.67, y: 31.52), controlPoint2: CGPoint(x: 46.34, y: 30))
		eyepupilPath.curve(to: CGPoint(x: 43.95, y: 31.35), controlPoint1: CGPoint(x: 46.34, y: 30), controlPoint2: CGPoint(x: 44.77, y: 31.28))
		eyepupilPath.curve(to: CGPoint(x: 41.38, y: 30.41), controlPoint1: CGPoint(x: 43.14, y: 31.42), controlPoint2: CGPoint(x: 41.38, y: 30.41))
		eyepupilPath.curve(to: CGPoint(x: 39.57, y: 32.46), controlPoint1: CGPoint(x: 41.38, y: 30.41), controlPoint2: CGPoint(x: 40.32, y: 32.13))
		eyepupilPath.curve(to: CGPoint(x: 36.83, y: 32.41), controlPoint1: CGPoint(x: 38.82, y: 32.79), controlPoint2: CGPoint(x: 36.83, y: 32.41))
		eyepupilPath.curve(to: CGPoint(x: 35.78, y: 34.93), controlPoint1: CGPoint(x: 36.83, y: 32.41), controlPoint2: CGPoint(x: 36.39, y: 34.38))
		eyepupilPath.curve(to: CGPoint(x: 33.18, y: 35.77), controlPoint1: CGPoint(x: 35.18, y: 35.49), controlPoint2: CGPoint(x: 33.18, y: 35.77))
		eyepupilPath.curve(to: CGPoint(x: 33.01, y: 38.49), controlPoint1: CGPoint(x: 33.18, y: 35.77), controlPoint2: CGPoint(x: 33.4, y: 37.77))
		eyepupilPath.curve(to: CGPoint(x: 30.81, y: 40.13), controlPoint1: CGPoint(x: 32.62, y: 39.21), controlPoint2: CGPoint(x: 30.81, y: 40.13))
		eyepupilPath.curve(to: CGPoint(x: 31.54, y: 42.76), controlPoint1: CGPoint(x: 30.81, y: 40.13), controlPoint2: CGPoint(x: 31.68, y: 41.95))
		eyepupilPath.curve(to: CGPoint(x: 30, y: 45.01), controlPoint1: CGPoint(x: 31.41, y: 43.57), controlPoint2: CGPoint(x: 30, y: 45.01))
		eyepupilPath.curve(to: CGPoint(x: 31.55, y: 47.27), controlPoint1: CGPoint(x: 30, y: 45.01), controlPoint2: CGPoint(x: 31.41, y: 46.46))
		eyepupilPath.curve(to: CGPoint(x: 30.82, y: 49.9), controlPoint1: CGPoint(x: 31.68, y: 48.08), controlPoint2: CGPoint(x: 30.82, y: 49.9))
		eyepupilPath.curve(to: CGPoint(x: 33.02, y: 51.53), controlPoint1: CGPoint(x: 30.82, y: 49.9), controlPoint2: CGPoint(x: 32.63, y: 50.81))
		eyepupilPath.curve(to: CGPoint(x: 33.19, y: 54.26), controlPoint1: CGPoint(x: 33.41, y: 52.25), controlPoint2: CGPoint(x: 33.19, y: 54.26))
		eyepupilPath.curve(to: CGPoint(x: 35.8, y: 55.09), controlPoint1: CGPoint(x: 33.19, y: 54.26), controlPoint2: CGPoint(x: 35.2, y: 54.53))
		eyepupilPath.curve(to: CGPoint(x: 36.85, y: 57.61), controlPoint1: CGPoint(x: 36.41, y: 55.64), controlPoint2: CGPoint(x: 36.85, y: 57.61))
		eyepupilPath.curve(to: CGPoint(x: 39.59, y: 57.55), controlPoint1: CGPoint(x: 36.85, y: 57.61), controlPoint2: CGPoint(x: 38.84, y: 57.22))
		eyepupilPath.curve(to: CGPoint(x: 41.41, y: 59.6), controlPoint1: CGPoint(x: 40.35, y: 57.88), controlPoint2: CGPoint(x: 41.41, y: 59.6))
		eyepupilPath.curve(to: CGPoint(x: 43.98, y: 58.65), controlPoint1: CGPoint(x: 41.41, y: 59.6), controlPoint2: CGPoint(x: 43.16, y: 58.59))
		eyepupilPath.curve(to: CGPoint(x: 46.36, y: 60), controlPoint1: CGPoint(x: 44.8, y: 58.72), controlPoint2: CGPoint(x: 46.36, y: 60))
		eyepupilPath.curve(to: CGPoint(x: 48.49, y: 58.28), controlPoint1: CGPoint(x: 46.36, y: 60), controlPoint2: CGPoint(x: 47.69, y: 58.48))
		eyepupilPath.curve(to: CGPoint(x: 51.18, y: 58.78), controlPoint1: CGPoint(x: 49.28, y: 58.07), controlPoint2: CGPoint(x: 51.18, y: 58.78))
		eyepupilPath.curve(to: CGPoint(x: 52.63, y: 56.46), controlPoint1: CGPoint(x: 51.18, y: 58.78), controlPoint2: CGPoint(x: 51.94, y: 56.91))
		eyepupilPath.curve(to: CGPoint(x: 55.34, y: 56.07), controlPoint1: CGPoint(x: 53.32, y: 56.01), controlPoint2: CGPoint(x: 55.34, y: 56.07))
		eyepupilPath.curve(to: CGPoint(x: 55.95, y: 53.4), controlPoint1: CGPoint(x: 55.34, y: 56.07), controlPoint2: CGPoint(x: 55.45, y: 54.05))
		eyepupilPath.curve(to: CGPoint(x: 58.39, y: 52.15), controlPoint1: CGPoint(x: 56.46, y: 52.76), controlPoint2: CGPoint(x: 58.39, y: 52.15))
		eyepupilPath.curve(to: CGPoint(x: 58.1, y: 49.44), controlPoint1: CGPoint(x: 58.39, y: 52.15), controlPoint2: CGPoint(x: 57.84, y: 50.21))
		eyepupilPath.curve(to: CGPoint(x: 60, y: 47.47), controlPoint1: CGPoint(x: 58.37, y: 48.66), controlPoint2: CGPoint(x: 60, y: 47.47))
		eyepupilPath.curve(to: CGPoint(x: 58.84, y: 44.99), controlPoint1: CGPoint(x: 60, y: 47.47), controlPoint2: CGPoint(x: 58.84, y: 45.81))
		eyepupilPath.curve(to: CGPoint(x: 60, y: 42.51), controlPoint1: CGPoint(x: 58.84, y: 44.17), controlPoint2: CGPoint(x: 60, y: 42.51))
		eyepupilPath.curve(to: CGPoint(x: 58.1, y: 40.54), controlPoint1: CGPoint(x: 60, y: 42.51), controlPoint2: CGPoint(x: 58.36, y: 41.32))
		eyepupilPath.curve(to: CGPoint(x: 58.38, y: 37.83), controlPoint1: CGPoint(x: 57.83, y: 39.77), controlPoint2: CGPoint(x: 58.38, y: 37.83))
		eyepupilPath.curve(to: CGPoint(x: 55.94, y: 36.58), controlPoint1: CGPoint(x: 58.38, y: 37.83), controlPoint2: CGPoint(x: 56.44, y: 37.22))
		eyepupilPath.curve(to: CGPoint(x: 55.32, y: 33.92), controlPoint1: CGPoint(x: 55.43, y: 35.93), controlPoint2: CGPoint(x: 55.32, y: 33.92))
		eyepupilPath.close()
	}
}()
