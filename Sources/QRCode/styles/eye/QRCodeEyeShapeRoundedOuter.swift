//
//  QRCodeEyeStyleRoundedOuter.swift
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
	/// A 'square with a rounded outer corner' style eye design
	@objc(QRCodeEyeShapeRoundedOuter) class RoundedOuter: NSObject, QRCodeEyeShapeGenerator {
		@objc public static let Name = "roundedOuter"
		@objc public static var Title: String { "Rounded outer" }
		@objc public static func Create(_ settings: [String: Any]?) -> QRCodeEyeShapeGenerator {
			return QRCode.EyeShape.RoundedOuter()
		}
		
		@objc public func settings() -> [String: Any] { return [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		/// Make a copy of the object
		@objc public func copyShape() -> QRCodeEyeShapeGenerator {
			return Self.Create(self.settings())
		}
		
		public func eyePath() -> CGPath {
			let roundedSharpOuterPath = CGMutablePath()
			roundedSharpOuterPath.move(to: CGPoint(x: 20, y: 70))
			roundedSharpOuterPath.line(to: CGPoint(x: 70, y: 70))
			roundedSharpOuterPath.line(to: CGPoint(x: 70, y: 20))
			roundedSharpOuterPath.line(to: CGPoint(x: 31, y: 20))
			roundedSharpOuterPath.curve(to: CGPoint(x: 20, y: 31), controlPoint1: CGPoint(x: 24.92, y: 20), controlPoint2: CGPoint(x: 20, y: 24.92))
			roundedSharpOuterPath.line(to: CGPoint(x: 20, y: 70))
			roundedSharpOuterPath.close()
			roundedSharpOuterPath.move(to: CGPoint(x: 10, y: 80))
			roundedSharpOuterPath.curve(to: CGPoint(x: 10, y: 30), controlPoint1: CGPoint(x: 10, y: 80), controlPoint2: CGPoint(x: 10, y: 30))
			roundedSharpOuterPath.curve(to: CGPoint(x: 30, y: 10), controlPoint1: CGPoint(x: 10, y: 18.95), controlPoint2: CGPoint(x: 18.95, y: 10))
			roundedSharpOuterPath.line(to: CGPoint(x: 80, y: 10))
			roundedSharpOuterPath.curve(to: CGPoint(x: 80, y: 80), controlPoint1: CGPoint(x: 80, y: 10.34), controlPoint2: CGPoint(x: 80, y: 80))
			roundedSharpOuterPath.line(to: CGPoint(x: 10, y: 80))
			roundedSharpOuterPath.line(to: CGPoint(x: 10, y: 80))
			roundedSharpOuterPath.close()
			return roundedSharpOuterPath
		}

		@objc public func eyeBackgroundPath() -> CGPath {
			let roundedRectEye2Path = CGMutablePath()
			roundedRectEye2Path.move(to: CGPoint(x: 0, y: 0))
			roundedRectEye2Path.curve(to: CGPoint(x: 0, y: 64.29), controlPoint1: CGPoint(x: 0, y: 0), controlPoint2: CGPoint(x: 0, y: 64.29))
			roundedRectEye2Path.curve(to: CGPoint(x: 25.71, y: 90), controlPoint1: CGPoint(x: 0, y: 78.49), controlPoint2: CGPoint(x: 11.51, y: 90))
			roundedRectEye2Path.line(to: CGPoint(x: 90, y: 90))
			roundedRectEye2Path.curve(to: CGPoint(x: 90, y: 0), controlPoint1: CGPoint(x: 90, y: 89.56), controlPoint2: CGPoint(x: 90, y: 0))
			roundedRectEye2Path.line(to: CGPoint(x: 0, y: 0))
			roundedRectEye2Path.line(to: CGPoint(x: 0, y: 0))
			roundedRectEye2Path.close()
			return roundedRectEye2Path
		}
		
		private static let _defaultPupil = QRCode.PupilShape.RoundedOuter()
		public func defaultPupil() -> QRCodePupilShapeGenerator { Self._defaultPupil }
	}
}
