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
	/// A 'rounded pointing out' eye shape
	@objc(QRCodeEyeShapeRoundedPointingOut) class RoundedPointingOut: NSObject, QRCodeEyeShapeGenerator {
		@objc public static let Name = "roundedPointingOut"
		@objc public static var Title: String { "Rounded pointing out" }
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodeEyeShapeGenerator {
			return QRCode.EyeShape.RoundedPointingOut()
		}

		@objc public func settings() -> [String: Any] { return [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodeEyeShapeGenerator { RoundedPointingOut() }

		/// Reset the eye shape generator back to defaults
		@objc public func reset() { }

		/// Eye shape path
		public func eyePath() -> CGPath { coreEyeGenerator__.eyePath() }
		/// Eye background path
		public func eyeBackgroundPath() -> CGPath { coreEyeGenerator__.eyeBackgroundPath() }
		/// Default pupil shape
		public func defaultPupil() -> any QRCodePupilShapeGenerator { corePupilGenerator__ }

		// private

		/// The eye generator
		private let coreEyeGenerator__ = QRCode.EyeShape.RoundedPointingIn(flip: .both)
		/// The pupil generator
		private let corePupilGenerator__ = QRCode.PupilShape.RoundedPointingOut()
	}
}

public extension QRCodeEyeShapeGenerator where Self == QRCode.EyeShape.Peacock {
	/// Create a peacock eye shape generator
	/// - Returns: An eye shape generator
	@inlinable static func roundedPointingOut() -> QRCodeEyeShapeGenerator { QRCode.EyeShape.RoundedPointingOut() }
}
