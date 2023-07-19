//
//  QRCodeEyeStyleLeaf.swift
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

import CoreGraphics
import Foundation

public extension QRCode.EyeShape {
	/// A 'rounded rect with a pointy bit facing inwards' style eye design
	@objc(QRCodeEyeShapeRoundedPointingIn) class RoundedPointingIn: NSObject, QRCodeEyeShapeGenerator {
		@objc public static let Name = "roundedPointingIn"
		@objc public static var Title: String { "Rounded pointing in" }
		@objc public static func Create(_ settings: [String: Any]?) -> QRCodeEyeShapeGenerator {
			return QRCode.EyeShape.RoundedPointingIn()
		}
		
		@objc public func settings() -> [String: Any] { return [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		/// Make a copy of the object
		@objc public func copyShape() -> QRCodeEyeShapeGenerator {
			return Self.Create(self.settings())
		}
		
		public func eyePath() -> CGPath {
			let tearEyePath = CGMutablePath()
			tearEyePath.move(to: CGPoint(x: 57, y: 20))
			tearEyePath.addLine(to: CGPoint(x: 33, y: 20))
			tearEyePath.addCurve(to: CGPoint(x: 20, y: 33), control1: CGPoint(x: 25.82, y: 20), control2: CGPoint(x: 20, y: 25.82))
			tearEyePath.addLine(to: CGPoint(x: 20, y: 57))
			tearEyePath.addCurve(to: CGPoint(x: 33, y: 70), control1: CGPoint(x: 20, y: 64.18), control2: CGPoint(x: 25.82, y: 70))
			tearEyePath.addLine(to: CGPoint(x: 70, y: 70))
			tearEyePath.addLine(to: CGPoint(x: 70, y: 33))
			tearEyePath.addCurve(to: CGPoint(x: 57, y: 20), control1: CGPoint(x: 70, y: 25.82), control2: CGPoint(x: 64.18, y: 20))
			tearEyePath.close()
			tearEyePath.move(to: CGPoint(x: 80, y: 33))
			tearEyePath.addLine(to: CGPoint(x: 80, y: 80))
			tearEyePath.addLine(to: CGPoint(x: 33, y: 80))
			tearEyePath.addCurve(to: CGPoint(x: 10, y: 57), control1: CGPoint(x: 20.3, y: 80), control2: CGPoint(x: 10, y: 69.7))
			tearEyePath.addLine(to: CGPoint(x: 10, y: 33))
			tearEyePath.addCurve(to: CGPoint(x: 33, y: 10), control1: CGPoint(x: 10, y: 20.3), control2: CGPoint(x: 20.3, y: 10))
			tearEyePath.addLine(to: CGPoint(x: 57, y: 10))
			tearEyePath.addCurve(to: CGPoint(x: 80, y: 33), control1: CGPoint(x: 69.7, y: 10), control2: CGPoint(x: 80, y: 20.3))
			tearEyePath.close()
			return tearEyePath
		}

		@objc public func eyeBackgroundPath() -> CGPath {
			let tearEye2Path = CGMutablePath()
			tearEye2Path.move(to: CGPoint(x: 90, y: 60.43))
			tearEye2Path.line(to: CGPoint(x: 90, y: 0))
			tearEye2Path.line(to: CGPoint(x: 29.57, y: 0))
			tearEye2Path.curve(to: CGPoint(x: 0, y: 29.57), controlPoint1: CGPoint(x: 13.24, y: 0), controlPoint2: CGPoint(x: 0, y: 13.24))
			tearEye2Path.line(to: CGPoint(x: 0, y: 60.43))
			tearEye2Path.curve(to: CGPoint(x: 29.57, y: 90), controlPoint1: CGPoint(x: 0, y: 76.76), controlPoint2: CGPoint(x: 13.24, y: 90))
			tearEye2Path.line(to: CGPoint(x: 60.43, y: 90))
			tearEye2Path.curve(to: CGPoint(x: 90, y: 60.43), controlPoint1: CGPoint(x: 76.76, y: 90), controlPoint2: CGPoint(x: 90, y: 76.76))
			tearEye2Path.close()
			return tearEye2Path
		}

		private static let generator_ = QRCode.PupilShape.RoundedPointingIn()
		public func defaultPupil() -> QRCodePupilShapeGenerator { Self.generator_ }
	}
}
