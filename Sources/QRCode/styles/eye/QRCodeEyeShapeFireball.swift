//
//  Copyright © 2025 Darren Ford. All rights reserved.
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
	/// A 'Teardrop' style eye design
	@objc(QRCodeEyeShapeFireball) class Fireball: NSObject, QRCodeEyeShapeGenerator {
		@objc public static let Name = "fireball"
		@objc public static var Title: String { "Fireball" }
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodeEyeShapeGenerator {
			return QRCode.EyeShape.Fireball()
		}
		
		@objc public func settings() -> [String: Any] { return [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodeEyeShapeGenerator {
			return Self.Create(self.settings())
		}

		/// Reset the eye shape generator back to defaults
		@objc public func reset() { }

		public func eyePath() -> CGPath {
			coreEyeGenerator__.eyePath()
		}

		public func eyeBackgroundPath() -> CGPath {
			coreEyeGenerator__.eyeBackgroundPath()
		}
		
		public func defaultPupil() -> any QRCodePupilShapeGenerator {
			corePupilGenerator__
		}

		/// The eye generator
		private let coreEyeGenerator__ = QRCode.EyeShape.Eye(eyeInnerStyle: .rightOnly)
		/// The pupil generator
		private let corePupilGenerator__ = QRCode.PupilShape.Teardrop()
	}
}

public extension QRCodeEyeShapeGenerator where Self == QRCode.EyeShape.Fireball {
	/// Create a fireball eye shape generator
	/// - Returns: An eye shape generator
	@inlinable static func fireball() -> QRCodeEyeShapeGenerator { QRCode.EyeShape.Fireball() }
}
