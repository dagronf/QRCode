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
	/// A 'rounded rect with a pointy bit facing inwards' style eye design
	@objc(QRCodeEyeShapeRoundedPointingIn) class RoundedPointingIn: NSObject, QRCodeEyeShapeGenerator {
		@objc public static let Name = "roundedPointingIn"
		@objc public static var Title: String { "Rounded Pointing In" }
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodeEyeShapeGenerator {
			QRCode.EyeShape.RoundedPointingIn(settings: settings)
		}

		/// Flip the eye shape
		@objc public var flip: QRCode.Flip = .none {
			didSet {
				_ = self.generator_.setSettingValue(self.flip.rawValue, forKey: QRCode.SettingsKey.flip)
			}
		}

		/// Create a roundedPointing eye shape
		/// - Parameter flip: The flip state for the eye
		@objc public init(flip: QRCode.Flip = .none) {
			self.flip = flip
			super.init()

			// Push the setting down to the pupil
			self.generator_.flip = self.flip
		}

		/// Create a eye shape using the specified settings
		@objc public init(settings: [String: Any]?) {
			super.init()
			settings?.forEach { (key: String, value: Any) in
				_ = self.setSettingValue(value, forKey: key)
			}
		}

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodeEyeShapeGenerator {
			RoundedPointingIn(flip: self.flip)
		}

		/// Reset the eye shape generator back to defaults
		@objc public func reset() {
			self.flip = .none
		}

		/// Returns a path representation of the eye outer
		public func eyePath() -> CGPath {
			switch self.flip {
			case .none:
				return eyeShape__
			case .vertically:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(eyeShape__, transform: .init(scaleX: -1, y: 1).translatedBy(x: -90, y: 0))
				}
			case .horizontally:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(eyeShape__, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -90))
				}
			case .both:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(eyeShape__, transform: .init(scaleX: -1, y: -1).translatedBy(x: -90, y: -90))
				}
			}
		}

		@objc public func eyeBackgroundPath() -> CGPath {
			switch self.flip {
			case .none:
				return eyeBackgroundShape__
			case .vertically:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(eyeBackgroundShape__, transform: .init(scaleX: -1, y: 1).translatedBy(x: -90, y: 0))
				}
			case .horizontally:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(eyeBackgroundShape__, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -90))
				}
			case .both:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(eyeBackgroundShape__, transform: .init(scaleX: -1, y: -1).translatedBy(x: -90, y: -90))
				}
			}
		}

		private let generator_ = QRCode.PupilShape.RoundedPointingIn()
		public func defaultPupil() -> any QRCodePupilShapeGenerator { self.generator_ }
	}
}

public extension QRCode.EyeShape.RoundedPointingIn {
	@objc func settings() -> [String: Any] {
		[QRCode.SettingsKey.flip: self.flip.rawValue]
	}

	/// Returns true if the generator supports settings values for the given key
	@objc func supportsSettingValue(forKey key: String) -> Bool {
		key == QRCode.SettingsKey.flip
	}

	/// Set the key's value in the generator
	/// - Parameters:
	///   - value: The value to set
	///   - key: The setting key
	/// - Returns: True if the setting was able to be change, false otherwise
	@objc func setSettingValue(_ value: Any?, forKey key: String) -> Bool {
		if key == QRCode.SettingsKey.flip,
			let which = IntValue(value)
		{
			self.flip = QRCode.Flip(rawValue: which) ?? .none
			return true
		}
		return false
	}
}

public extension QRCodeEyeShapeGenerator where Self == QRCode.EyeShape.RoundedPointingIn {
	/// Create a 'roundedPointingIn' eye shape generator
	/// - Returns: An eye shape generator
	@inlinable static func roundedPointing(flip: QRCode.Flip = .none) -> QRCodeEyeShapeGenerator {
		QRCode.EyeShape.RoundedPointingIn(flip: flip)
	}
}

// MARK: - Paths

private let eyeShape__: CGPath =
	CGPath.make { tearEyePath in
		tearEyePath.move(to: CGPoint(x: 57, y: 20))
		tearEyePath.addLine(to: CGPoint(x: 33, y: 20))
		tearEyePath.addCurve(to: CGPoint(x: 20, y: 33), control1: CGPoint(x: 25.82, y: 20), control2: CGPoint(x: 20, y: 25.82))
		tearEyePath.addLine(to: CGPoint(x: 20, y: 57))
		tearEyePath.addCurve(to: CGPoint(x: 33, y: 70), control1: CGPoint(x: 20, y: 64.18), control2: CGPoint(x: 25.82, y: 70))
		tearEyePath.addLine(to: CGPoint(x: 70, y: 70))
		tearEyePath.addLine(to: CGPoint(x: 70, y: 33))
		tearEyePath.addCurve(to: CGPoint(x: 57, y: 20), control1: CGPoint(x: 70, y: 25.82), control2: CGPoint(x: 64.18, y: 20))
		tearEyePath.close()
		tearEyePath.move(to: CGPoint(x: 80, y: 33))
		tearEyePath.addLine(to: CGPoint(x: 80, y: 80))
		tearEyePath.addLine(to: CGPoint(x: 33, y: 80))
		tearEyePath.addCurve(to: CGPoint(x: 10, y: 57), control1: CGPoint(x: 20.3, y: 80), control2: CGPoint(x: 10, y: 69.7))
		tearEyePath.addLine(to: CGPoint(x: 10, y: 33))
		tearEyePath.addCurve(to: CGPoint(x: 33, y: 10), control1: CGPoint(x: 10, y: 20.3), control2: CGPoint(x: 20.3, y: 10))
		tearEyePath.addLine(to: CGPoint(x: 57, y: 10))
		tearEyePath.addCurve(to: CGPoint(x: 80, y: 33), control1: CGPoint(x: 69.7, y: 10), control2: CGPoint(x: 80, y: 20.3))
		tearEyePath.close()
	}

private let eyeBackgroundShape__: CGPath =
	CGPath.make { tearEye2Path in
		tearEye2Path.move(to: CGPoint(x: 90, y: 60.43))
		tearEye2Path.line(to: CGPoint(x: 90, y: 0))
		tearEye2Path.line(to: CGPoint(x: 29.57, y: 0))
		tearEye2Path.curve(to: CGPoint(x: 0, y: 29.57), controlPoint1: CGPoint(x: 13.24, y: 0), controlPoint2: CGPoint(x: 0, y: 13.24))
		tearEye2Path.line(to: CGPoint(x: 0, y: 60.43))
		tearEye2Path.curve(to: CGPoint(x: 29.57, y: 90), controlPoint1: CGPoint(x: 0, y: 76.76), controlPoint2: CGPoint(x: 13.24, y: 90))
		tearEye2Path.line(to: CGPoint(x: 60.43, y: 90))
		tearEye2Path.curve(to: CGPoint(x: 90, y: 60.43), controlPoint1: CGPoint(x: 76.76, y: 90), controlPoint2: CGPoint(x: 90, y: 76.76))
		tearEye2Path.close()
	}
