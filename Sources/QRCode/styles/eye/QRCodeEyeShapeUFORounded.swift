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
	/// A rounded UFO style eye shape
	@objc(QRCodeEyeShapeUFORounded) class UFORounded: NSObject, QRCodeEyeShapeGenerator {
		@objc public static let Name = "ufoRounded"
		@objc public static var Title: String { "UFO Rounded" }
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodeEyeShapeGenerator {
			QRCode.EyeShape.UFORounded(settings: settings)
		}

		/// Flip the pupil shape
		@objc public var flip: QRCode.Flip = .none {
			didSet {
				self.defaultPupil__.flip = flip
			}
		}

		@objc public init(flip: QRCode.Flip = .none) {
			self.flip = flip
			super.init()

			self.defaultPupil__.flip = flip
		}

		@objc public init(settings: [String: Any]?) {
			super.init()
			settings?.forEach { (key: String, value: Any) in
				_ = self.setSettingValue(value, forKey: key)
			}
		}

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodeEyeShapeGenerator {
			return QRCode.EyeShape.UFORounded(flip: self.flip)
		}

		/// Reset the eye shape generator back to defaults
		@objc public func reset() {
			self.flip = .none
		}

		public func eyePath() -> CGPath {
			switch self.flip {
			case .none:
				return eyePath__
			case .vertically:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(eyePath__, transform: .init(scaleX: -1, y: 1).translatedBy(x: -90, y: 0))
				}
			case .horizontally:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(eyePath__, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -90))
				}
			case .both:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(eyePath__, transform: .init(scaleX: -1, y: -1).translatedBy(x: -90, y: -90))
				}
			}
		}

		public func eyeBackgroundPath() -> CGPath {
			switch self.flip {
			case .none:
				return eyeBackgroundPath__
			case .vertically:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(eyeBackgroundPath__, transform: .init(scaleX: -1, y: 1).translatedBy(x: -90, y: 0))
				}
			case .horizontally:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(eyeBackgroundPath__, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -90))
				}
			case .both:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(eyeBackgroundPath__, transform: .init(scaleX: -1, y: -1).translatedBy(x: -90, y: -90))
				}
			}
		}

		private let defaultPupil__ = QRCode.PupilShape.UFORounded()
		public func defaultPupil() -> any QRCodePupilShapeGenerator { defaultPupil__ }
	}
}

public extension QRCode.EyeShape.UFORounded {
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

public extension QRCodeEyeShapeGenerator where Self == QRCode.EyeShape.UFORounded {
	/// Create a UFO eye shape generator
	/// - Parameter isFlipped: if true, flips the generated shape
	/// - Returns: An eye shape generator
	@inlinable static func ufoRounded(flip: QRCode.Flip = .none) -> QRCodeEyeShapeGenerator {
		QRCode.EyeShape.UFORounded(flip: flip)
	}
}

// MARK: - Paths

private let eyePath__: CGPath =
	CGPath.make { eyePath in
		eyePath.move(to: CGPoint(x: 62, y: 70))
		eyePath.line(to: CGPoint(x: 45, y: 70))
		eyePath.curve(to: CGPoint(x: 20, y: 45), controlPoint1: CGPoint(x: 31.19, y: 70), controlPoint2: CGPoint(x: 20, y: 58.81))
		eyePath.line(to: CGPoint(x: 20, y: 28))
		eyePath.curve(to: CGPoint(x: 23.87, y: 21.14), controlPoint1: CGPoint(x: 20, y: 25.09), controlPoint2: CGPoint(x: 21.55, y: 22.55))
		eyePath.curve(to: CGPoint(x: 28, y: 20), controlPoint1: CGPoint(x: 25.08, y: 20.42), controlPoint2: CGPoint(x: 26.49, y: 20))
		eyePath.line(to: CGPoint(x: 45, y: 20))
		eyePath.curve(to: CGPoint(x: 70, y: 45), controlPoint1: CGPoint(x: 58.81, y: 20), controlPoint2: CGPoint(x: 70, y: 31.19))
		eyePath.line(to: CGPoint(x: 70, y: 62))
		eyePath.curve(to: CGPoint(x: 62, y: 70), controlPoint1: CGPoint(x: 70, y: 66.42), controlPoint2: CGPoint(x: 66.42, y: 70))
		eyePath.close()
		eyePath.move(to: CGPoint(x: 80, y: 62.5))
		eyePath.line(to: CGPoint(x: 80, y: 45))
		eyePath.curve(to: CGPoint(x: 45, y: 10), controlPoint1: CGPoint(x: 80, y: 25.67), controlPoint2: CGPoint(x: 64.33, y: 10))
		eyePath.line(to: CGPoint(x: 27.5, y: 10))
		eyePath.curve(to: CGPoint(x: 20.54, y: 11.44), controlPoint1: CGPoint(x: 25.03, y: 10), controlPoint2: CGPoint(x: 22.67, y: 10.51))
		eyePath.curve(to: CGPoint(x: 17.14, y: 13.39), controlPoint1: CGPoint(x: 19.33, y: 11.96), controlPoint2: CGPoint(x: 18.19, y: 12.62))
		eyePath.curve(to: CGPoint(x: 10, y: 27.5), controlPoint1: CGPoint(x: 12.81, y: 16.58), controlPoint2: CGPoint(x: 10, y: 21.71))
		eyePath.line(to: CGPoint(x: 10, y: 45))
		eyePath.curve(to: CGPoint(x: 45, y: 80), controlPoint1: CGPoint(x: 10, y: 64.33), controlPoint2: CGPoint(x: 25.67, y: 80))
		eyePath.line(to: CGPoint(x: 62.5, y: 80))
		eyePath.curve(to: CGPoint(x: 80, y: 62.5), controlPoint1: CGPoint(x: 72.16, y: 80), controlPoint2: CGPoint(x: 80, y: 72.16))
		eyePath.close()
	}

private let eyeBackgroundPath__: CGPath =
	CGPath.make { eyebackgroundPath in
		eyebackgroundPath.move(to: CGPoint(x: 90, y: 67.5))
		eyebackgroundPath.line(to: CGPoint(x: 90, y: 45))
		eyebackgroundPath.curve(to: CGPoint(x: 45, y: 0), controlPoint1: CGPoint(x: 90, y: 20.15), controlPoint2: CGPoint(x: 69.85, y: -0))
		eyebackgroundPath.line(to: CGPoint(x: 22.5, y: 0))
		eyebackgroundPath.curve(to: CGPoint(x: 9.18, y: 4.36), controlPoint1: CGPoint(x: 17.52, y: 0), controlPoint2: CGPoint(x: 12.91, y: 1.62))
		eyebackgroundPath.curve(to: CGPoint(x: 0, y: 22.5), controlPoint1: CGPoint(x: 3.61, y: 8.46), controlPoint2: CGPoint(x: 0, y: 15.06))
		eyebackgroundPath.line(to: CGPoint(x: 0, y: 45))
		eyebackgroundPath.curve(to: CGPoint(x: 45, y: 90), controlPoint1: CGPoint(x: 0, y: 69.85), controlPoint2: CGPoint(x: 20.15, y: 90))
		eyebackgroundPath.line(to: CGPoint(x: 67.5, y: 90))
		eyebackgroundPath.curve(to: CGPoint(x: 90, y: 67.5), controlPoint1: CGPoint(x: 79.93, y: 90), controlPoint2: CGPoint(x: 90, y: 79.93))
		eyebackgroundPath.close()
	}
	.applyingTransform(CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -90))
