//
//  QRCodePupilShapeUFO.swift
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

// MARK: - Pupil shape

public extension QRCode.PupilShape {
	/// A UFO style pupil shape
	@objc(QRCodePupilShapeUFO) class UFO: NSObject, QRCodePupilShapeGenerator {
		@objc public static var Name: String { "ufo" }
		/// The generator title
		@objc public static var Title: String { "UFO" }
		@objc public static func Create(_ settings: [String : Any]?) -> any QRCodePupilShapeGenerator {
			if let settings = settings {
				return UFO(settings: settings)
			}
			return UFO()
		}

		@objc public init(isFlipped: Bool = false) {
			self.isFlipped = isFlipped
			super.init()
		}

		/// Create a navigator pupil shape using the specified settings
		@objc public init(settings: [String: Any]) {
			super.init()
			settings.forEach { (key: String, value: Any) in
				_ = self.setSettingValue(value, forKey: key)
			}
		}

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePupilShapeGenerator {
			UFO(isFlipped: self.isFlipped)
		}

		@objc public func settings() -> [String : Any] {
			[QRCode.SettingsKey.isFlipped: self.isFlipped]
		}
		
		/// Does this pupil support this setting?
		/// - Parameter key: The key
		/// - Returns: True if this pupil type supports this settings, false otherwise
		@objc public func supportsSettingValue(forKey key: String) -> Bool {
			key == QRCode.SettingsKey.isFlipped
		}
		
		/// Set the key value for this pupil
		/// - Parameters:
		///   - value: The value to set
		///   - key: The key
		/// - Returns: True if the setting was able to be set, false otherwise
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool {
			if key == QRCode.SettingsKey.isFlipped {
				self.isFlipped = BoolValue(value) ?? false
			}
			return false
		}

		/// Is the pupil shape flipped?
		@objc public var isFlipped: Bool = false

		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath {
			let pupilPath = CGMutablePath()
			pupilPath.move(to: CGPoint(x: 60, y: 60))
			pupilPath.curve(to: CGPoint(x: 60, y: 45), controlPoint1: CGPoint(x: 60, y: 60), controlPoint2: CGPoint(x: 60, y: 45))
			pupilPath.curve(to: CGPoint(x: 45, y: 30), controlPoint1: CGPoint(x: 60, y: 36.72), controlPoint2: CGPoint(x: 53.28, y: 30))
			pupilPath.line(to: CGPoint(x: 30, y: 30))
			pupilPath.line(to: CGPoint(x: 30, y: 45))
			pupilPath.curve(to: CGPoint(x: 45, y: 60), controlPoint1: CGPoint(x: 30, y: 53.28), controlPoint2: CGPoint(x: 36.72, y: 60))
			pupilPath.line(to: CGPoint(x: 60, y: 60))
			pupilPath.line(to: CGPoint(x: 60, y: 60))
			pupilPath.close()

			if isFlipped {
				let n = CGMutablePath()
				n.addPath(pupilPath, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -90))
				return n
			}

			return pupilPath
		}
	}
}
