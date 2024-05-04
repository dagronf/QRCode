//
//  QRCodeEyeShapePinch.swift
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
	/// A 'pinch' style eye design
	@objc(QRCodeEyeShapePinch) class Pinch: NSObject, QRCodeEyeShapeGenerator {
		@objc public static let Name = "pinch"
		@objc public static var Title: String { "Pinch" }
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodeEyeShapeGenerator {
			return QRCode.EyeShape.Pinch()
		}

		@objc public func settings() -> [String: Any] { return [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodeEyeShapeGenerator {
			return Self.Create(self.settings())
		}

		private static let _defaultPupil = QRCode.PupilShape.Pinch()
		public func defaultPupil() -> any QRCodePupilShapeGenerator { Self._defaultPupil }
	}
}

public extension QRCode.EyeShape.Pinch {
	func eyePath() -> CGPath {
		let pincheyePath = CGMutablePath()
		pincheyePath.move(to: CGPoint(x: 80, y: 80))
		pincheyePath.curve(to: CGPoint(x: 78, y: 45), controlPoint1: CGPoint(x: 80, y: 80), controlPoint2: CGPoint(x: 78, y: 62.5))
		pincheyePath.curve(to: CGPoint(x: 80, y: 10), controlPoint1: CGPoint(x: 78, y: 27.5), controlPoint2: CGPoint(x: 80, y: 10))
		pincheyePath.curve(to: CGPoint(x: 45, y: 12), controlPoint1: CGPoint(x: 80, y: 10), controlPoint2: CGPoint(x: 62.5, y: 12))
		pincheyePath.curve(to: CGPoint(x: 10, y: 10), controlPoint1: CGPoint(x: 27.5, y: 12), controlPoint2: CGPoint(x: 10, y: 10))
		pincheyePath.curve(to: CGPoint(x: 12, y: 45), controlPoint1: CGPoint(x: 10, y: 10), controlPoint2: CGPoint(x: 12, y: 27.5))
		pincheyePath.curve(to: CGPoint(x: 10, y: 80), controlPoint1: CGPoint(x: 12, y: 62.5), controlPoint2: CGPoint(x: 10, y: 80))
		pincheyePath.curve(to: CGPoint(x: 45, y: 78), controlPoint1: CGPoint(x: 10, y: 80), controlPoint2: CGPoint(x: 27.5, y: 78))
		pincheyePath.curve(to: CGPoint(x: 80, y: 80), controlPoint1: CGPoint(x: 62.5, y: 78), controlPoint2: CGPoint(x: 80, y: 80))
		pincheyePath.line(to: CGPoint(x: 80, y: 80))
		pincheyePath.close()
		pincheyePath.move(to: CGPoint(x: 70, y: 70))
		pincheyePath.curve(to: CGPoint(x: 45, y: 68.57), controlPoint1: CGPoint(x: 70, y: 70), controlPoint2: CGPoint(x: 57.5, y: 68.57))
		pincheyePath.curve(to: CGPoint(x: 20, y: 70), controlPoint1: CGPoint(x: 32.5, y: 68.57), controlPoint2: CGPoint(x: 20, y: 70))
		pincheyePath.curve(to: CGPoint(x: 21.43, y: 45), controlPoint1: CGPoint(x: 20, y: 70), controlPoint2: CGPoint(x: 21.43, y: 57.5))
		pincheyePath.curve(to: CGPoint(x: 20, y: 20), controlPoint1: CGPoint(x: 21.43, y: 32.5), controlPoint2: CGPoint(x: 20, y: 20))
		pincheyePath.curve(to: CGPoint(x: 45, y: 21.43), controlPoint1: CGPoint(x: 20, y: 20), controlPoint2: CGPoint(x: 32.5, y: 21.43))
		pincheyePath.curve(to: CGPoint(x: 70, y: 20), controlPoint1: CGPoint(x: 57.5, y: 21.43), controlPoint2: CGPoint(x: 70, y: 20))
		pincheyePath.curve(to: CGPoint(x: 68.57, y: 45), controlPoint1: CGPoint(x: 70, y: 20), controlPoint2: CGPoint(x: 68.57, y: 32.5))
		pincheyePath.curve(to: CGPoint(x: 70, y: 70), controlPoint1: CGPoint(x: 68.57, y: 57.5), controlPoint2: CGPoint(x: 70, y: 70))
		pincheyePath.close()
		return pincheyePath
	}
}

public extension QRCode.EyeShape.Pinch {
	func eyeBackgroundPath() -> CGPath {
		let pincheyebackgroundPath = CGMutablePath()
		pincheyebackgroundPath.move(to: CGPoint(x: 3, y: 45))
		pincheyebackgroundPath.curve(to: CGPoint(x: 0, y: 0), controlPoint1: CGPoint(x: 3, y: 22.5), controlPoint2: CGPoint(x: 0, y: 0))
		pincheyebackgroundPath.curve(to: CGPoint(x: 45, y: 3), controlPoint1: CGPoint(x: 0, y: 0), controlPoint2: CGPoint(x: 22.5, y: 3))
		pincheyebackgroundPath.curve(to: CGPoint(x: 90, y: 0), controlPoint1: CGPoint(x: 67.5, y: 3), controlPoint2: CGPoint(x: 90, y: 0))
		pincheyebackgroundPath.curve(to: CGPoint(x: 87, y: 45), controlPoint1: CGPoint(x: 90, y: 0), controlPoint2: CGPoint(x: 87, y: 22.5))
		pincheyebackgroundPath.curve(to: CGPoint(x: 90, y: 90), controlPoint1: CGPoint(x: 87, y: 67.5), controlPoint2: CGPoint(x: 90, y: 90))
		pincheyebackgroundPath.curve(to: CGPoint(x: 45, y: 87), controlPoint1: CGPoint(x: 90, y: 90), controlPoint2: CGPoint(x: 67.5, y: 87))
		pincheyebackgroundPath.curve(to: CGPoint(x: 0, y: 90), controlPoint1: CGPoint(x: 22.5, y: 87), controlPoint2: CGPoint(x: 0, y: 90))
		pincheyebackgroundPath.curve(to: CGPoint(x: 3, y: 45), controlPoint1: CGPoint(x: 0, y: 90), controlPoint2: CGPoint(x: 3, y: 67.5))
		pincheyebackgroundPath.close()
		return pincheyebackgroundPath
	}
}
