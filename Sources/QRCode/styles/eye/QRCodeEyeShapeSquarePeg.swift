//
//  QRCodeEyeStyleSquarePeg.swift
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

public extension QRCode.EyeShape {
	/// A 'saquare peg' (rounded rect with a circular cutout) style eye design
	@objc(QRCodeEyeShapeSquarePeg) class SquarePeg: NSObject, QRCodeEyeShapeGenerator {
		@objc public static let Name = "squarePeg"
		@objc public static var Title: String { "Square Peg" }
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodeEyeShapeGenerator {
			return QRCode.EyeShape.SquarePeg()
		}

		// Has no configurable settings
		@objc public func settings() -> [String: Any] { return [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodeEyeShapeGenerator { SquarePeg() }

		/// Reset the eye shape generator back to defaults
		@objc public func reset() { }

		public func eyePath() -> CGPath {
			let roundedRectEyePath = CGMutablePath()
			roundedRectEyePath.move(to: CGPoint(x: 45, y: 70))
			roundedRectEyePath.curve(to: CGPoint(x: 20, y: 45), controlPoint1: CGPoint(x: 31.19, y: 70), controlPoint2: CGPoint(x: 20, y: 58.81))
			roundedRectEyePath.curve(to: CGPoint(x: 34.91, y: 22.12), controlPoint1: CGPoint(x: 20, y: 34.78), controlPoint2: CGPoint(x: 26.13, y: 26))
			roundedRectEyePath.curve(to: CGPoint(x: 45, y: 20), controlPoint1: CGPoint(x: 37.99, y: 20.76), controlPoint2: CGPoint(x: 41.41, y: 20))
			roundedRectEyePath.curve(to: CGPoint(x: 70, y: 45), controlPoint1: CGPoint(x: 58.81, y: 20), controlPoint2: CGPoint(x: 70, y: 31.19))
			roundedRectEyePath.curve(to: CGPoint(x: 45, y: 70), controlPoint1: CGPoint(x: 70, y: 58.81), controlPoint2: CGPoint(x: 58.81, y: 70))
			roundedRectEyePath.close()
			roundedRectEyePath.move(to: CGPoint(x: 80, y: 70))
			roundedRectEyePath.line(to: CGPoint(x: 80, y: 20))
			roundedRectEyePath.curve(to: CGPoint(x: 70, y: 10), controlPoint1: CGPoint(x: 80, y: 14.48), controlPoint2: CGPoint(x: 75.52, y: 10))
			roundedRectEyePath.line(to: CGPoint(x: 20, y: 10))
			roundedRectEyePath.curve(to: CGPoint(x: 10, y: 20), controlPoint1: CGPoint(x: 14.48, y: 10), controlPoint2: CGPoint(x: 10, y: 14.48))
			roundedRectEyePath.line(to: CGPoint(x: 10, y: 70))
			roundedRectEyePath.curve(to: CGPoint(x: 20, y: 80), controlPoint1: CGPoint(x: 10, y: 75.52), controlPoint2: CGPoint(x: 14.48, y: 80))
			roundedRectEyePath.line(to: CGPoint(x: 70, y: 80))
			roundedRectEyePath.curve(to: CGPoint(x: 80, y: 70), controlPoint1: CGPoint(x: 75.52, y: 80), controlPoint2: CGPoint(x: 80, y: 75.52))
			roundedRectEyePath.close()

			return roundedRectEyePath
		}

		@objc public func eyeBackgroundPath() -> CGPath {
			let backgroundPath = CGMutablePath()
			backgroundPath.move(to: CGPoint(x: 90, y: 77.14))
			backgroundPath.line(to: CGPoint(x: 90, y: 12.86))
			backgroundPath.curve(to: CGPoint(x: 77.14, y: 0), controlPoint1: CGPoint(x: 90, y: 5.76), controlPoint2: CGPoint(x: 84.24, y: -0))
			backgroundPath.line(to: CGPoint(x: 12.86, y: 0))
			backgroundPath.curve(to: CGPoint(x: 0, y: 12.86), controlPoint1: CGPoint(x: 5.76, y: 0), controlPoint2: CGPoint(x: 0, y: 5.76))
			backgroundPath.line(to: CGPoint(x: 0, y: 77.14))
			backgroundPath.curve(to: CGPoint(x: 12.86, y: 90), controlPoint1: CGPoint(x: 0, y: 84.24), controlPoint2: CGPoint(x: 5.76, y: 90))
			backgroundPath.line(to: CGPoint(x: 77.14, y: 90))
			backgroundPath.curve(to: CGPoint(x: 90, y: 77.14), controlPoint1: CGPoint(x: 84.24, y: 90), controlPoint2: CGPoint(x: 90, y: 84.24))
			backgroundPath.close()
			return backgroundPath
		}

		private static let _defaultPupil = QRCode.PupilShape.Squircle()
		public func defaultPupil() -> any QRCodePupilShapeGenerator { Self._defaultPupil }
	}
}

public extension QRCodeEyeShapeGenerator where Self == QRCode.EyeShape.SquarePeg {
	/// Create a square peg eye shape
	/// - Returns: An eye shape generator
	@inlinable static func squarePeg() -> QRCodeEyeShapeGenerator { QRCode.EyeShape.SquarePeg() }
}
