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
	/// A 'rounded rect' style eye design
	@objc(QRCodeEyeShapeRoundedRect) class RoundedRect: NSObject, QRCodeEyeShapeGenerator {
		/// The generator name
		@objc public static let Name = "roundedRect"
		/// The generator title
		@objc public static var Title: String { "Rounded rectangle" }

		/// Create an eye rounded rect shape from settings
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodeEyeShapeGenerator {
			let value = DoubleValue(settings?[QRCode.SettingsKey.cornerRadiusFraction]) ?? QRCode.EyeShape.RoundedRect.DefaultRadius
			return QRCode.EyeShape.RoundedRect(cornerRadiusFraction: value)
		}

		/// The default corner radius for the eye
		@objc public static let DefaultRadius: CGFloat = 0.3

		/// The fractional  corner radius (clamped to 0.0 ... 1.0)
		@objc public var cornerRadiusFraction: CGFloat {
			get { self._cornerRadiusFraction }
			set {
				self._cornerRadiusFraction = newValue.unitClamped()

				// Pass the value down to the default pupil shape
				_ = self._defaultPupil.cornerRadiusFraction = self._cornerRadiusFraction
			}
		}

		/// Create a rounded rect eye shape
		/// - Parameter cornerRadiusFraction: The fractional corner radius
		@objc public init(cornerRadiusFraction: CGFloat = QRCode.EyeShape.RoundedRect.DefaultRadius) {
			self._cornerRadiusFraction = cornerRadiusFraction.unitClamped()
			self._defaultPupil.cornerRadiusFraction = cornerRadiusFraction.unitClamped()
		}

		// MARK: - Generator support

		/// Make a copy of the generator
		@objc public func copyShape() -> any QRCodeEyeShapeGenerator {
			QRCode.EyeShape.RoundedRect(cornerRadiusFraction: self._cornerRadiusFraction)
		}

		/// Reset the eye shape generator back to defaults
		@objc public func reset() {
			self._cornerRadiusFraction = QRCode.EyeShape.RoundedRect.DefaultRadius
		}

		/// The default pupil shape to use with this eye shape
		public func defaultPupil() -> any QRCodePupilShapeGenerator { self._defaultPupil }

		// MARK: - Settings support

		/// The eye generator settings
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
				let value = DoubleValue(value)
			{
				self.cornerRadiusFraction = value
				_ = self.defaultPupil().setSettingValue(value, forKey: QRCode.SettingsKey.cornerRadiusFraction)
			}
			return false
		}

		// MARK: - Path generation

		private let _hFlipTransform = CGAffineTransform(scaleX: -1, y: 1)
			.concatenating(CGAffineTransform.init(translationX: 90, y: 0))

		/// The eye's path definition
		public func eyePath() -> CGPath {
			CGPath.make { path in
				// The outer
				let outer = CGRect(x: 10, y: 10, width: 70, height: 70)
				let maxOuterRadius = outer.width / 2.0
				let expectedOuterRadius = maxOuterRadius * self._cornerRadiusFraction
				let outerRadius = expectedOuterRadius.clamped(to: 0 ... maxOuterRadius)

				let outerPath = CGPath(roundedRect: outer, cornerWidth: outerRadius, cornerHeight: outerRadius, transform: nil)
				path.addPath(outerPath)

				// The inner
				let inner = CGRect(x: 20, y: 20, width: 50, height: 50)
				let maxInnerRadius = inner.width / 2.0
				let expectedInnerRadius = outerRadius - 7.5

				// Make sure we clamp to the maximum radius allowed (half of the rect) or else older versions can barf
				let innerRadius = expectedInnerRadius.clamped(to: 0 ... maxInnerRadius)
				let innerPath = CGPath(roundedRect: inner, cornerWidth: innerRadius, cornerHeight: innerRadius, transform: nil)

				// This needs to be order reversed so that it 'cuts out' the inner from the outer (eoFill)
				// Easiest way to do this -- flip the inner path vertically and move back into place.
				// This method only works because the shape is completely symmetrical
				path.addPath(innerPath, transform: _hFlipTransform)

				path.closeSubpath()
			}
		}

		/// The background path for the eye
		@objc public func eyeBackgroundPath() -> CGPath {
			CGPath.make { path in
				let outerRadius = (90.0 / 2.0) * _cornerRadiusFraction.unitClamped()
				let outer = CGRect(x: 0, y: 0, width: 90, height: 90)
				let outerPath = CGPath(roundedRect: outer, cornerWidth: outerRadius, cornerHeight: outerRadius, transform: nil)
				path.addPath(outerPath)
			}
		}

		// MARK: - private
		// The fractional corner radius (0.0 ... 1.0)
		private var _cornerRadiusFraction: CGFloat = QRCode.EyeShape.RoundedRect.DefaultRadius
		// The default pupil shape for this eye
		private let _defaultPupil = QRCode.PupilShape.RoundedRect()
	}
}

public extension QRCodeEyeShapeGenerator where Self == QRCode.EyeShape.RoundedRect {
	/// Create a rounded rectangle eye shape generator
	/// - Returns: An eye shape generator
	@inlinable static func roundedRect() -> QRCodeEyeShapeGenerator { QRCode.EyeShape.RoundedRect() }
}
