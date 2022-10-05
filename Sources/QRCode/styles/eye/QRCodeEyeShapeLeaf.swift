//
//  QRCodeEyeStyleLeaf.swift
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
	/// A 'leaf' style eye design
	@objc(QRCodeEyeShapeLeaf) class Leaf: NSObject, QRCodeEyeShapeGenerator {
		@objc public static let Name = "leaf"
		@objc public static func Create(_ settings: [String: Any]?) -> QRCodeEyeShapeGenerator {
			return QRCode.EyeShape.Leaf()
		}
		
		@objc public func settings() -> [String: Any] { return [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		public func copyShape() -> QRCodeEyeShapeGenerator {
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
		
		private static let _defaultPupil = QRCode.PupilShape.Leaf()
		public func defaultPupil() -> QRCodePupilShapeGenerator { Self._defaultPupil }
	}
}

// MARK: - Pupil shape

public extension QRCode.PupilShape {
	/// A 'leaf' style pupil design
	@objc(QRCodePupilShapeLeaf) class Leaf: NSObject, QRCodePupilShapeGenerator {
		@objc public static var Name: String { "leaf" }
		@objc public static func Create(_ settings: [String : Any]?) -> QRCodePupilShapeGenerator {
			Leaf()
		}
		@objc public func copyShape() -> QRCodePupilShapeGenerator { Leaf() }

		@objc public func settings() -> [String : Any] { [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath {
			let roundedPupil = CGPath.RoundedRect(
				rect: CGRect(x: 30, y: 30, width: 30, height: 30),
				cornerRadius: 6,
				byRoundingCorners: [.topRight, .bottomLeft]
			)
			return roundedPupil
		}
	}
}
