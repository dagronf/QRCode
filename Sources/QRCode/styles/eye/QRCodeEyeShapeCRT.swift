//
//  QRCodeEyeShapeCRT.swift
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
	@objc(QRCodeEyeShapeCrt) class CRT: NSObject, QRCodeEyeShapeGenerator {
		@objc public static let Name = "crt"
		@objc public static var Title: String { "CRT" }
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodeEyeShapeGenerator {
			return QRCode.EyeShape.CRT()
		}

		@objc public func settings() -> [String: Any] { return [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodeEyeShapeGenerator {
			return Self.Create(self.settings())
		}

		private static let _defaultPupil = QRCode.PupilShape.CRT()
		public func defaultPupil() -> any QRCodePupilShapeGenerator { Self._defaultPupil }
	}
}

public extension QRCode.EyeShape.CRT {
	func eyePath() -> CGPath {
		let crt_eyePath = CGMutablePath()
		crt_eyePath.move(to: CGPoint(x: 45, y: 70))
		crt_eyePath.curve(to: CGPoint(x: 22.14, y: 67.86), controlPoint1: CGPoint(x: 32.5, y: 70), controlPoint2: CGPoint(x: 22.14, y: 67.86))
		crt_eyePath.curve(to: CGPoint(x: 20, y: 45), controlPoint1: CGPoint(x: 22.14, y: 67.86), controlPoint2: CGPoint(x: 20, y: 57.5))
		crt_eyePath.curve(to: CGPoint(x: 22.14, y: 22.14), controlPoint1: CGPoint(x: 20, y: 32.5), controlPoint2: CGPoint(x: 22.14, y: 22.14))
		crt_eyePath.curve(to: CGPoint(x: 45, y: 20), controlPoint1: CGPoint(x: 22.14, y: 22.14), controlPoint2: CGPoint(x: 32.5, y: 20))
		crt_eyePath.curve(to: CGPoint(x: 67.86, y: 22.14), controlPoint1: CGPoint(x: 57.5, y: 20), controlPoint2: CGPoint(x: 67.86, y: 22.14))
		crt_eyePath.curve(to: CGPoint(x: 70, y: 45), controlPoint1: CGPoint(x: 67.86, y: 22.14), controlPoint2: CGPoint(x: 70, y: 32.5))
		crt_eyePath.curve(to: CGPoint(x: 67.86, y: 67.86), controlPoint1: CGPoint(x: 70, y: 57.5), controlPoint2: CGPoint(x: 67.86, y: 67.86))
		crt_eyePath.curve(to: CGPoint(x: 45, y: 70), controlPoint1: CGPoint(x: 67.86, y: 67.86), controlPoint2: CGPoint(x: 57.5, y: 70))
		crt_eyePath.close()
		crt_eyePath.move(to: CGPoint(x: 77, y: 77))
		crt_eyePath.curve(to: CGPoint(x: 80, y: 45), controlPoint1: CGPoint(x: 77, y: 77), controlPoint2: CGPoint(x: 80, y: 62.5))
		crt_eyePath.curve(to: CGPoint(x: 77, y: 13), controlPoint1: CGPoint(x: 80, y: 27.5), controlPoint2: CGPoint(x: 77, y: 13))
		crt_eyePath.curve(to: CGPoint(x: 45, y: 10), controlPoint1: CGPoint(x: 77, y: 13), controlPoint2: CGPoint(x: 62.5, y: 10))
		crt_eyePath.curve(to: CGPoint(x: 13, y: 13), controlPoint1: CGPoint(x: 27.5, y: 10), controlPoint2: CGPoint(x: 13, y: 13))
		crt_eyePath.curve(to: CGPoint(x: 10, y: 45), controlPoint1: CGPoint(x: 13, y: 13), controlPoint2: CGPoint(x: 10, y: 27.5))
		crt_eyePath.curve(to: CGPoint(x: 13, y: 77), controlPoint1: CGPoint(x: 10, y: 62.5), controlPoint2: CGPoint(x: 13, y: 77))
		crt_eyePath.curve(to: CGPoint(x: 45, y: 80), controlPoint1: CGPoint(x: 13, y: 77), controlPoint2: CGPoint(x: 27.5, y: 80))
		crt_eyePath.curve(to: CGPoint(x: 77, y: 77), controlPoint1: CGPoint(x: 62.5, y: 80), controlPoint2: CGPoint(x: 77, y: 77))
		crt_eyePath.line(to: CGPoint(x: 77, y: 77))
		crt_eyePath.close()
		return crt_eyePath
	}
}

public extension QRCode.EyeShape.CRT {
	func eyeBackgroundPath() -> CGPath {
		let crt_backgroundPath = CGMutablePath()
		crt_backgroundPath.move(to: CGPoint(x: 0, y: 45))
		crt_backgroundPath.curve(to: CGPoint(x: 3.86, y: 3.86), controlPoint1: CGPoint(x: 0, y: 22.5), controlPoint2: CGPoint(x: 3.86, y: 3.86))
		crt_backgroundPath.curve(to: CGPoint(x: 45, y: 0), controlPoint1: CGPoint(x: 3.86, y: 3.86), controlPoint2: CGPoint(x: 22.5, y: 0))
		crt_backgroundPath.curve(to: CGPoint(x: 86.14, y: 3.86), controlPoint1: CGPoint(x: 67.5, y: 0), controlPoint2: CGPoint(x: 86.14, y: 3.86))
		crt_backgroundPath.curve(to: CGPoint(x: 90, y: 45), controlPoint1: CGPoint(x: 86.14, y: 3.86), controlPoint2: CGPoint(x: 90, y: 22.5))
		crt_backgroundPath.curve(to: CGPoint(x: 86.14, y: 86.14), controlPoint1: CGPoint(x: 90, y: 67.5), controlPoint2: CGPoint(x: 86.14, y: 86.14))
		crt_backgroundPath.curve(to: CGPoint(x: 45, y: 90), controlPoint1: CGPoint(x: 86.14, y: 86.14), controlPoint2: CGPoint(x: 67.5, y: 90))
		crt_backgroundPath.curve(to: CGPoint(x: 3.86, y: 86.14), controlPoint1: CGPoint(x: 22.5, y: 90), controlPoint2: CGPoint(x: 3.86, y: 86.14))
		crt_backgroundPath.curve(to: CGPoint(x: 0, y: 45), controlPoint1: CGPoint(x: 3.86, y: 86.14), controlPoint2: CGPoint(x: 0, y: 67.5))
		crt_backgroundPath.close()
		return crt_backgroundPath
	}
}
