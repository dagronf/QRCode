//
//  QRCodeEyeShapeBarsSharp.swift
//
//  Copyright © 2022 Darren Ford. All rights reserved.
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
	/// An eye with vertical bars as the pupil
	@objc(QRCodeEyeStyleBarsSharp) class Sharp: NSObject, QRCodeEyeShapeGenerator {
		@objc public static let Name = "sharp"
		@objc public static func Create(_ settings: [String: Any]?) -> QRCodeEyeShapeGenerator {
			return QRCode.EyeShape.Sharp()
		}

		// Has no configurable settings
		@objc public func settings() -> [String: Any] { return [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		public func copyShape() -> QRCodeEyeShapeGenerator {
			return Self.Create(self.settings())
		}

		public func eyePath() -> CGPath {
			let squareEye2Path = CGMutablePath()
			squareEye2Path.move(to: CGPoint(x: 67, y: 45))
			squareEye2Path.curve(to: CGPoint(x: 70, y: 70), controlPoint1: CGPoint(x: 67, y: 57.5), controlPoint2: CGPoint(x: 70, y: 70))
			squareEye2Path.curve(to: CGPoint(x: 45, y: 67), controlPoint1: CGPoint(x: 70, y: 70), controlPoint2: CGPoint(x: 57.5, y: 67))
			squareEye2Path.curve(to: CGPoint(x: 20, y: 70), controlPoint1: CGPoint(x: 32.5, y: 67), controlPoint2: CGPoint(x: 20, y: 70))
			squareEye2Path.curve(to: CGPoint(x: 23, y: 45), controlPoint1: CGPoint(x: 20, y: 70), controlPoint2: CGPoint(x: 23, y: 57.5))
			squareEye2Path.curve(to: CGPoint(x: 20, y: 20), controlPoint1: CGPoint(x: 23, y: 32.5), controlPoint2: CGPoint(x: 20, y: 20))
			squareEye2Path.curve(to: CGPoint(x: 45, y: 23), controlPoint1: CGPoint(x: 20, y: 20), controlPoint2: CGPoint(x: 32.5, y: 23))
			squareEye2Path.curve(to: CGPoint(x: 70, y: 20), controlPoint1: CGPoint(x: 57.5, y: 23), controlPoint2: CGPoint(x: 70, y: 20))
			squareEye2Path.curve(to: CGPoint(x: 67, y: 45), controlPoint1: CGPoint(x: 70, y: 20), controlPoint2: CGPoint(x: 67, y: 32.5))
			squareEye2Path.close()
			squareEye2Path.move(to: CGPoint(x: 80, y: 80))
			squareEye2Path.curve(to: CGPoint(x: 75, y: 45), controlPoint1: CGPoint(x: 80, y: 80), controlPoint2: CGPoint(x: 75, y: 62.43))
			squareEye2Path.curve(to: CGPoint(x: 80, y: 10), controlPoint1: CGPoint(x: 75, y: 27.43), controlPoint2: CGPoint(x: 80, y: 10))
			squareEye2Path.curve(to: CGPoint(x: 45, y: 15), controlPoint1: CGPoint(x: 80, y: 10), controlPoint2: CGPoint(x: 62.5, y: 15))
			squareEye2Path.curve(to: CGPoint(x: 10, y: 10), controlPoint1: CGPoint(x: 27.5, y: 15), controlPoint2: CGPoint(x: 10, y: 10))
			squareEye2Path.curve(to: CGPoint(x: 15, y: 45), controlPoint1: CGPoint(x: 10, y: 10), controlPoint2: CGPoint(x: 15, y: 27.5))
			squareEye2Path.curve(to: CGPoint(x: 10, y: 80), controlPoint1: CGPoint(x: 15, y: 62.5), controlPoint2: CGPoint(x: 10, y: 80))
			squareEye2Path.curve(to: CGPoint(x: 45, y: 75), controlPoint1: CGPoint(x: 10, y: 80), controlPoint2: CGPoint(x: 27.5, y: 75))
			squareEye2Path.curve(to: CGPoint(x: 80, y: 80), controlPoint1: CGPoint(x: 62.5, y: 75), controlPoint2: CGPoint(x: 80, y: 80))
			squareEye2Path.line(to: CGPoint(x: 80, y: 80))
			squareEye2Path.close()

			return squareEye2Path
		}

		private static let _defaultPupil = QRCode.PupilShape.Sharp()
		public func defaultPupil() -> QRCodePupilShapeGenerator {
			Self._defaultPupil
		}
	}
}

// MARK: - Pupil shape

public extension QRCode.PupilShape {
	/// A horizontal bars style pupil design
	@objc(QRCodePupilShapeSharp) class Sharp: NSObject, QRCodePupilShapeGenerator {
		@objc public static var Name: String { "sharp" }
		@objc public static func Create(_ settings: [String : Any]?) -> QRCodePupilShapeGenerator {
			Sharp()
		}
		@objc public func copyShape() -> QRCodePupilShapeGenerator { Sharp() }

		@objc public func settings() -> [String : Any] { [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath {
			let squarePupilPath = CGMutablePath()
			squarePupilPath.move(to: CGPoint(x: 31, y: 45))
			squarePupilPath.curve(to: CGPoint(x: 30, y: 30), controlPoint1: CGPoint(x: 31, y: 37.5), controlPoint2: CGPoint(x: 30, y: 30))
			squarePupilPath.curve(to: CGPoint(x: 45, y: 31), controlPoint1: CGPoint(x: 30, y: 30), controlPoint2: CGPoint(x: 37.5, y: 31))
			squarePupilPath.curve(to: CGPoint(x: 60, y: 30), controlPoint1: CGPoint(x: 52.5, y: 31), controlPoint2: CGPoint(x: 60, y: 30))
			squarePupilPath.curve(to: CGPoint(x: 59, y: 45), controlPoint1: CGPoint(x: 60, y: 30), controlPoint2: CGPoint(x: 59, y: 37.5))
			squarePupilPath.curve(to: CGPoint(x: 60, y: 60), controlPoint1: CGPoint(x: 59, y: 52.5), controlPoint2: CGPoint(x: 60, y: 60))
			squarePupilPath.curve(to: CGPoint(x: 45, y: 59), controlPoint1: CGPoint(x: 60, y: 60), controlPoint2: CGPoint(x: 52.5, y: 59))
			squarePupilPath.curve(to: CGPoint(x: 30, y: 60), controlPoint1: CGPoint(x: 37.5, y: 59), controlPoint2: CGPoint(x: 30, y: 60))
			squarePupilPath.curve(to: CGPoint(x: 31, y: 45), controlPoint1: CGPoint(x: 30, y: 60), controlPoint2: CGPoint(x: 31, y: 52.5))
			squarePupilPath.close()
			return squarePupilPath
		}
	}
}
