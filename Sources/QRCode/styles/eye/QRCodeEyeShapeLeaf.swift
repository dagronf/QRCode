//
//  QRCodeEyeShapeLeaf.swift
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
	/// A 'leaf' style eye design
	@objc(QRCodeEyeShapeLeaf) class Leaf: NSObject, QRCodeEyeShapeGenerator {
		@objc public static let Name = "leaf"
		@objc public static var Title: String { "Leaf" }
		@objc public static func Create(_ settings: [String: Any]?) -> QRCodeEyeShapeGenerator {
			return QRCode.EyeShape.Leaf()
		}
		
		@objc public func settings() -> [String: Any] { return [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		/// Make a copy of the object
		@objc public func copyShape() -> QRCodeEyeShapeGenerator {
			return Self.Create(self.settings())
		}
		
		public func eyePath() -> CGPath {
			let eyePath = CGMutablePath()
			eyePath.move(to: CGPoint(x: 20, y: 20))
			eyePath.addLine(to: CGPoint(x: 60, y: 20))
			eyePath.addCurve(to: CGPoint(x: 70, y: 30), control1: CGPoint(x: 65.52, y: 20), control2: CGPoint(x: 70, y: 24.48))
			eyePath.addLine(to: CGPoint(x: 70, y: 70))
			eyePath.addLine(to: CGPoint(x: 30, y: 70))
			eyePath.addCurve(to: CGPoint(x: 20, y: 60), control1: CGPoint(x: 24.48, y: 70), control2: CGPoint(x: 20, y: 65.52))
			eyePath.addLine(to: CGPoint(x: 20, y: 20))
			eyePath.close()
			eyePath.move(to: CGPoint(x: 10, y: 10))
			eyePath.addCurve(to: CGPoint(x: 10, y: 60), control1: CGPoint(x: 10, y: 10), control2: CGPoint(x: 10, y: 60))
			eyePath.addCurve(to: CGPoint(x: 30, y: 80), control1: CGPoint(x: 10, y: 71.05), control2: CGPoint(x: 18.95, y: 80))
			eyePath.addLine(to: CGPoint(x: 80, y: 80))
			eyePath.addLine(to: CGPoint(x: 80, y: 30))
			eyePath.addCurve(to: CGPoint(x: 60, y: 10), control1: CGPoint(x: 80, y: 18.95), control2: CGPoint(x: 71.05, y: 10))
			eyePath.addLine(to: CGPoint(x: 10, y: 10))
			eyePath.addLine(to: CGPoint(x: 10, y: 10))
			eyePath.close()
			return eyePath
		}

		public func eyeBackgroundPath() -> CGPath {
			let eye2Path = CGMutablePath()
			eye2Path.move(to: CGPoint(x: 90, y: 0))
			eye2Path.curve(to: CGPoint(x: 90, y: 64.29), controlPoint1: CGPoint(x: 90, y: -0), controlPoint2: CGPoint(x: 90, y: 64.29))
			eye2Path.curve(to: CGPoint(x: 64.29, y: 90), controlPoint1: CGPoint(x: 90, y: 78.49), controlPoint2: CGPoint(x: 78.49, y: 90))
			eye2Path.line(to: CGPoint(x: 0, y: 90))
			eye2Path.line(to: CGPoint(x: 0, y: 25.71))
			eye2Path.curve(to: CGPoint(x: 25.71, y: 0), controlPoint1: CGPoint(x: 0, y: 11.51), controlPoint2: CGPoint(x: 11.51, y: 0))
			eye2Path.line(to: CGPoint(x: 90, y: 0))
			eye2Path.line(to: CGPoint(x: 90, y: 0))
			eye2Path.close()
			return eye2Path
		}
		
		private static let _defaultPupil = QRCode.PupilShape.Leaf()
		public func defaultPupil() -> QRCodePupilShapeGenerator { Self._defaultPupil }
	}
}
