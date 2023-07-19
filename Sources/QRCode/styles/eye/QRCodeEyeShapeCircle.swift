//
//  QRCodeEyeStyleCircle.swift
//
//  Copyright © 2023 Darren Ford. All rights reserved.
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

public extension QRCode.EyeShape {
	@objc(QRCodeEyeShapeCircle) class Circle : NSObject, QRCodeEyeShapeGenerator {
		@objc public static let Name: String = "circle"
		@objc public static var Title: String { "Circle" }

		@objc static public func Create(_ settings: [String: Any]?) -> QRCodeEyeShapeGenerator {
			return QRCode.EyeShape.Circle()
		}

		// Has no configurable settings
		@objc public func settings() -> [String : Any] { return [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		/// Make a copy of the object
		@objc public func copyShape() -> QRCodeEyeShapeGenerator {
			return Self.Create(self.settings())
		}

		public func eyePath() -> CGPath {
			let circleEyePath = CGMutablePath()
			circleEyePath.move(to: CGPoint(x: 45, y: 20))
			circleEyePath.curve(to: CGPoint(x: 20, y: 45), controlPoint1: CGPoint(x: 31.19, y: 20), controlPoint2: CGPoint(x: 20, y: 31.19))
			circleEyePath.curve(to: CGPoint(x: 21.28, y: 52.92), controlPoint1: CGPoint(x: 20, y: 47.77), controlPoint2: CGPoint(x: 20.45, y: 50.43))
			circleEyePath.curve(to: CGPoint(x: 45, y: 70), controlPoint1: CGPoint(x: 24.59, y: 62.85), controlPoint2: CGPoint(x: 33.96, y: 70))
			circleEyePath.curve(to: CGPoint(x: 70, y: 45), controlPoint1: CGPoint(x: 58.81, y: 70), controlPoint2: CGPoint(x: 70, y: 58.81))
			circleEyePath.curve(to: CGPoint(x: 45, y: 20), controlPoint1: CGPoint(x: 70, y: 31.19), controlPoint2: CGPoint(x: 58.81, y: 20))
			circleEyePath.close()
			circleEyePath.move(to: CGPoint(x: 80, y: 45))
			circleEyePath.curve(to: CGPoint(x: 45, y: 80), controlPoint1: CGPoint(x: 80, y: 64.33), controlPoint2: CGPoint(x: 64.33, y: 80))
			circleEyePath.curve(to: CGPoint(x: 11.64, y: 55.61), controlPoint1: CGPoint(x: 29.37, y: 80), controlPoint2: CGPoint(x: 16.13, y: 69.76))
			circleEyePath.curve(to: CGPoint(x: 10, y: 45), controlPoint1: CGPoint(x: 10.57, y: 52.27), controlPoint2: CGPoint(x: 10, y: 48.7))
			circleEyePath.curve(to: CGPoint(x: 45, y: 10), controlPoint1: CGPoint(x: 10, y: 25.67), controlPoint2: CGPoint(x: 25.67, y: 10))
			circleEyePath.curve(to: CGPoint(x: 80, y: 45), controlPoint1: CGPoint(x: 64.33, y: 10), controlPoint2: CGPoint(x: 80, y: 25.67))
			circleEyePath.close()
			return circleEyePath
		}

		@objc public func eyeBackgroundPath() -> CGPath {
			CGPath(ellipseIn: CGRect(origin: .zero, size: CGSize(width: 90, height: 90)), transform: nil)
		}

		private static let _defaultPupil = QRCode.PupilShape.Circle()
		public func defaultPupil() -> QRCodePupilShapeGenerator { Self._defaultPupil }
	}
}
