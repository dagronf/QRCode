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

// MARK: - Pupil shape

public extension QRCode.PupilShape {
	/// A 'rounded rect' style pupil design
	@objc(QRCodePupilShapeRoundedRect) class RoundedRect: NSObject, QRCodePupilShapeGenerator {
		/// The generator name
		@objc public static var Name: String { "roundedRect" }
		/// The generator title
		@objc public static var Title: String { "Rounded rectangle" }

		/// Create an eye rounded rect shape from settings
		@objc public static func Create(_ settings: [String : Any]?) -> any QRCodePupilShapeGenerator {
			let value = DoubleValue(settings?[QRCode.SettingsKey.cornerRadiusFraction]) ?? QRCode.PupilShape.RoundedRect.DefaultRadius
			return QRCode.PupilShape.RoundedRect(cornerRadiusFraction: value)
		}

		/// Default corner radius
		@objc public static let DefaultRadius: CGFloat = 0.3

		/// The fractional  corner radius (clamped to 0.0 ... 1.0)
		@objc public var cornerRadiusFraction: CGFloat {
			get { self._cornerRadiusFraction }
			set { self._cornerRadiusFraction = newValue.unitClamped() }
		}

		/// Create a pupil shape generator
		/// - Parameter cornerRadiusFraction: The corner radius to apply to the pupil shape
		@objc public init(cornerRadiusFraction: Double = QRCode.PupilShape.RoundedRect.DefaultRadius) {
			self._cornerRadiusFraction = cornerRadiusFraction.unitClamped()
		}

		// MARK: - Generator support

		/// Make a copy of the generator
		@objc public func copyShape() -> any QRCodePupilShapeGenerator {
			RoundedRect(cornerRadiusFraction: self._cornerRadiusFraction)
		}
		/// Reset the pupil shape generator back to defaults
		@objc public func reset() {
			self._cornerRadiusFraction = QRCode.PupilShape.RoundedRect.DefaultRadius
		}

		// MARK: - Settings support

		// Return the pupil's settings
		@objc public func settings() -> [String: Any] {[
			QRCode.SettingsKey.cornerRadiusFraction: self.cornerRadiusFraction,
		]}

		/// Returns true if this generator supports the keyed setting
		@objc public func supportsSettingValue(forKey key: String) -> Bool {
			return key == QRCode.SettingsKey.cornerRadiusFraction
		}

		/// Set the value for the setting defined by `key`
		/// - Parameters:
		///   - value: The value for the setting
		///   - key: The key defining the setting
		/// - Returns: True if the setting was successful, false otherwise
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool {
			if key == QRCode.SettingsKey.cornerRadiusFraction,
				let radius = DoubleValue(value)
			{
				self.cornerRadiusFraction = radius
				return true
			}
			return false
		}

		// MARK: - Path generation

		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath {
			return CGPath(
				roundedRect: CGRect(x: 30, y: 30, width: 30, height: 30),
				cornerWidth: 15 * cornerRadiusFraction * 0.9,
				cornerHeight: 15 * cornerRadiusFraction * 0.9,
				transform: nil
			)
		}

		// MARK: - private

		/// Unit radius value
		private var _cornerRadiusFraction = QRCode.PupilShape.RoundedRect.DefaultRadius
	}
}

public extension QRCodePupilShapeGenerator where Self == QRCode.PupilShape.RoundedRect {
	/// Create a rounded rectangle pupil shape generator
	/// - Returns: A pupil shape generator
	@inlinable static func roundedRect() -> QRCodePupilShapeGenerator { QRCode.PupilShape.RoundedRect() }
}
