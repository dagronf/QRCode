//
//  QRCodePupilShapePinch.swift
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

extension QRCode.PupilShape {
	/// A 'rounded pointing out' pupil shape
	@objc(QRCodePupilShapeRoundedPointingOut) public class RoundedPointingOut: NSObject, QRCodePupilShapeGenerator {
		/// Generator name
		@objc public static var Name: String { "roundedPointingOut" }
		/// Generator title
		@objc public static var Title: String { "Rounded pointing out" }
		/// Create a hexagon leaf pupil shape, using the specified settings
		@objc public static func Create(_ settings: [String : Any]?) -> any QRCodePupilShapeGenerator {
			RoundedPointingOut()
		}

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePupilShapeGenerator { RoundedPointingOut() }
		/// Reset the pupil shape generator back to defaults
		@objc public func reset() { }

		@objc public func settings() -> [String: Any] { [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_: Any?, forKey _: String) -> Bool { false }

		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath { self.pupilShape.pupilPath() }

		// Pupil shape is just a flipped RoundedPointingIn generator
		private let pupilShape = QRCode.PupilShape.RoundedPointingIn(flip: .both)
	}
}

public extension QRCodePupilShapeGenerator where Self == QRCode.PupilShape.RoundedPointingOut {
	/// Create a pinch pupil shape generator
	/// - Returns: A pupil shape generator
	@inlinable static func roundedPointingOut() -> QRCodePupilShapeGenerator { QRCode.PupilShape.RoundedPointingOut() }
}
