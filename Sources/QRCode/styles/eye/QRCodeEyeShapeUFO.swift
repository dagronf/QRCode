//
//  QRCodeEyeShapeUFO.swift
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
	/// A UFO style eye shape
	@objc(QRCodeEyeShapeUFO) class UFO: NSObject, QRCodeEyeShapeGenerator {
		@objc public static let Name = "ufo"
		@objc public static var Title: String { "UFO" }
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodeEyeShapeGenerator {
			if let settings = settings {
				return QRCode.EyeShape.UFO(settings: settings)
			}
			return QRCode.EyeShape.UFO()
		}

		@objc public init(isFlipped: Bool = false) {
			super.init()
			self.isFlipped = isFlipped
		}

		@objc public init(settings: [String: Any]) {
			super.init()
			settings.forEach { (key: String, value: Any) in
				_ = self.setSettingValue(value, forKey: key)
			}
		}

		@objc public func settings() -> [String: Any] {
			[QRCode.SettingsKey.isFlipped: self.isFlipped]
		}
		@objc public func supportsSettingValue(forKey key: String) -> Bool {
			key == QRCode.SettingsKey.isFlipped
		}
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool {
			if key == QRCode.SettingsKey.isFlipped {
				self.isFlipped = BoolValue(value) ?? false
			}
			return false
		}

		/// Is the eye shape flipped?
		@objc public var isFlipped = false

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodeEyeShapeGenerator {
			return QRCode.EyeShape.UFO(isFlipped: self.isFlipped)
		}
		
		public func eyePath() -> CGPath {
			let eyePath = CGMutablePath()
			eyePath.move(to: CGPoint(x: 70, y: 70))
			eyePath.line(to: CGPoint(x: 45, y: 70))
			eyePath.curve(to: CGPoint(x: 20, y: 45), controlPoint1: CGPoint(x: 31.19, y: 70), controlPoint2: CGPoint(x: 20, y: 58.81))
			eyePath.line(to: CGPoint(x: 20, y: 20))
			eyePath.line(to: CGPoint(x: 45, y: 20))
			eyePath.curve(to: CGPoint(x: 70, y: 45), controlPoint1: CGPoint(x: 58.81, y: 20), controlPoint2: CGPoint(x: 70, y: 31.19))
			eyePath.curve(to: CGPoint(x: 70, y: 58.44), controlPoint1: CGPoint(x: 70, y: 45), controlPoint2: CGPoint(x: 70, y: 51.89))
			eyePath.curve(to: CGPoint(x: 70, y: 70), controlPoint1: CGPoint(x: 70, y: 64.36), controlPoint2: CGPoint(x: 70, y: 70))
			eyePath.close()
			eyePath.move(to: CGPoint(x: 80, y: 80))
			eyePath.curve(to: CGPoint(x: 80, y: 74.22), controlPoint1: CGPoint(x: 80, y: 80), controlPoint2: CGPoint(x: 80, y: 77.67))
			eyePath.curve(to: CGPoint(x: 80, y: 45), controlPoint1: CGPoint(x: 80, y: 64.28), controlPoint2: CGPoint(x: 80, y: 45))
			eyePath.curve(to: CGPoint(x: 45, y: 10), controlPoint1: CGPoint(x: 80, y: 25.67), controlPoint2: CGPoint(x: 64.33, y: 10))
			eyePath.line(to: CGPoint(x: 10, y: 10))
			eyePath.line(to: CGPoint(x: 10, y: 45))
			eyePath.curve(to: CGPoint(x: 45, y: 80), controlPoint1: CGPoint(x: 10, y: 64.33), controlPoint2: CGPoint(x: 25.67, y: 80))
			eyePath.line(to: CGPoint(x: 80, y: 80))
			eyePath.line(to: CGPoint(x: 80, y: 80))
			eyePath.close()
			if isFlipped {
				let n = CGMutablePath()
				n.addPath(eyePath, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -90))
				return n
			}
			return eyePath
		}

		public func eyeBackgroundPath() -> CGPath {
			let safeZonePath = CGMutablePath()
			safeZonePath.move(to: CGPoint(x: 90, y: 90))
			safeZonePath.curve(to: CGPoint(x: 90, y: 45), controlPoint1: CGPoint(x: 90, y: 90), controlPoint2: CGPoint(x: 90, y: 45))
			safeZonePath.curve(to: CGPoint(x: 45, y: 0), controlPoint1: CGPoint(x: 90, y: 20.15), controlPoint2: CGPoint(x: 69.85, y: 0))
			safeZonePath.line(to: CGPoint(x: 0, y: 0))
			safeZonePath.line(to: CGPoint(x: 0, y: 45))
			safeZonePath.curve(to: CGPoint(x: 45, y: 90), controlPoint1: CGPoint(x: 0, y: 69.85), controlPoint2: CGPoint(x: 20.15, y: 90))
			safeZonePath.line(to: CGPoint(x: 90, y: 90))
			safeZonePath.line(to: CGPoint(x: 90, y: 90))
			safeZonePath.close()

			if !isFlipped {
				let n = CGMutablePath()
				n.addPath(safeZonePath, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -90))
				return n
			}
			return safeZonePath
		}
		
		public func defaultPupil() -> any QRCodePupilShapeGenerator {
			QRCode.PupilShape.UFO(isFlipped: self.isFlipped)
		}
	}
}
