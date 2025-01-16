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
	/// A headlight eye shape
	@objc(QRCodeEyeShapeHeadlight) class Headlight: NSObject, QRCodeEyeShapeGenerator {
		@objc public static let Name = "headlight"
		@objc public static var Title: String { "Headlight" }
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodeEyeShapeGenerator {
			Headlight(settings: settings)
		}

		/// Flip the eye shape
		@objc public var flip: QRCode.Flip = .none

		/// Create a headlight eye generator
		@objc public init(flip: QRCode.Flip = .none) {
			self.flip = flip
			super.init()
		}

		@objc public init(settings: [String: Any]?) {
			super.init()
			settings?.forEach { (key: String, value: Any) in
				_ = self.setSettingValue(value, forKey: key)
			}
		}

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodeEyeShapeGenerator {
			Headlight(flip: self.flip)
		}
		/// Reset the eye shape generator back to defaults
		@objc public func reset() {
			self.flip = .none
		}

		/// The eye path
		@objc public func eyePath() -> CGPath {
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

		/// The background path for the eye
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

		private static let _defaultPupil = QRCode.PupilShape.Circle()
		public func defaultPupil() -> any QRCodePupilShapeGenerator { Self._defaultPupil }
	}
}

public extension QRCode.EyeShape.Headlight {
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

// MARK: - Paths

private let eyeBackgroundPath__: CGPath =
	CGPath.make { headlightEyeBackgroundPath in
		headlightEyeBackgroundPath.move(to: CGPoint(x: 0, y: 0))
		headlightEyeBackgroundPath.line(to: CGPoint(x: 90, y: 0))
		headlightEyeBackgroundPath.line(to: CGPoint(x: 90, y: 90))
		headlightEyeBackgroundPath.line(to: CGPoint(x: 45, y: 90))
		headlightEyeBackgroundPath.curve(to: CGPoint(x: 0, y: 45), controlPoint1: CGPoint(x: 20.15, y: 90), controlPoint2: CGPoint(x: 0, y: 69.85))
		headlightEyeBackgroundPath.line(to: CGPoint(x: 0, y: 0))
		headlightEyeBackgroundPath.close()
	}

private let eyePath__: CGPath = {
	CGPath.make { headlightEyeOuterPath in
		headlightEyeOuterPath.move(to: CGPoint(x: 45, y: 70))
		headlightEyeOuterPath.curve(to: CGPoint(x: 20, y: 45), controlPoint1: CGPoint(x: 31.19, y: 70), controlPoint2: CGPoint(x: 20, y: 58.81))
		headlightEyeOuterPath.curve(to: CGPoint(x: 34.91, y: 22.12), controlPoint1: CGPoint(x: 20, y: 34.78), controlPoint2: CGPoint(x: 26.13, y: 26))
		headlightEyeOuterPath.curve(to: CGPoint(x: 45, y: 20), controlPoint1: CGPoint(x: 37.99, y: 20.76), controlPoint2: CGPoint(x: 41.41, y: 20))
		headlightEyeOuterPath.curve(to: CGPoint(x: 70, y: 45), controlPoint1: CGPoint(x: 58.81, y: 20), controlPoint2: CGPoint(x: 70, y: 31.19))
		headlightEyeOuterPath.curve(to: CGPoint(x: 45, y: 70), controlPoint1: CGPoint(x: 70, y: 58.81), controlPoint2: CGPoint(x: 58.81, y: 70))
		headlightEyeOuterPath.close()
		headlightEyeOuterPath.move(to: CGPoint(x: 80, y: 80))
		headlightEyeOuterPath.curve(to: CGPoint(x: 80, y: 10), controlPoint1: CGPoint(x: 80, y: 80), controlPoint2: CGPoint(x: 80, y: 10))
		headlightEyeOuterPath.line(to: CGPoint(x: 10, y: 10))
		headlightEyeOuterPath.line(to: CGPoint(x: 10, y: 45))
		headlightEyeOuterPath.curve(to: CGPoint(x: 45, y: 80), controlPoint1: CGPoint(x: 10, y: 64.33), controlPoint2: CGPoint(x: 25.67, y: 80))
		headlightEyeOuterPath.line(to: CGPoint(x: 80, y: 80))
		headlightEyeOuterPath.line(to: CGPoint(x: 80, y: 80))
		headlightEyeOuterPath.close()
	}
	.applyingTransform(CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -90))
}()

public extension QRCodeEyeShapeGenerator where Self == QRCode.EyeShape.Headlight {
	/// Create an explode eye shape
	/// - Returns: An eye shape generator
	@inlinable static func headlight() -> QRCodeEyeShapeGenerator { QRCode.EyeShape.Headlight() }
}
