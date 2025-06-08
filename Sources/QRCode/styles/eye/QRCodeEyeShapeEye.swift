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
	/// An 'eye' style eye design
	@objc(QRCodeEyeShapeEye) class Eye: NSObject, QRCodeEyeShapeGenerator {
		/// The style to use when drawing the outer eye
		@objc(QRCodeEyeShapeEyeStyle) public enum Style: Int {
			/// Corners on both sides of the eye
			case both = 0
			/// Corners only on the left side of the eye
			case leftOnly = 1
			/// Corners only on the right side of the eye
			case rightOnly = 2
		}

		/// Generator name
		@objc public static let Name = "eye"
		/// Generator title
		@objc public static var Title: String { "Eye" }
		/// Create a eye generator using settings
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodeEyeShapeGenerator {
			QRCode.EyeShape.Eye(settings: settings)
		}

		/// Is the eye shape flipped
		@objc public var flip: QRCode.Flip = .none

		/// The inner curve state for the eye
		@objc public var eyeInnerStyle: Style = .both

		/// Create an eye
		/// - Parameters:
		///   - flip: The flip transform to apply to the style
		///   - eyeInnerStyle: The eye's inner style
		@objc public init(flip: QRCode.Flip = .none, eyeInnerStyle: Style = .both) {
			self.flip = flip
			self.eyeInnerStyle = eyeInnerStyle
			super.init()
		}

		/// Create with the specified settings
		@objc public init(settings: [String: Any]?) {
			super.init()
			settings?.forEach { (key: String, value: Any) in
				_ = self.setSettingValue(value, forKey: key)
			}
		}

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodeEyeShapeGenerator {
			return Self.Create(self.settings())
		}

		/// Reset the eye shape generator back to defaults
		@objc public func reset() {
			self.flip = .none
			self.eyeInnerStyle = .both
		}

		/// The eye's path
		@objc public func eyePath() -> CGPath {
			let core: CGPath = {
				switch self.eyeInnerStyle {
				case .both: return self.full()
				case .leftOnly: return self.left()
				case .rightOnly: return self.right()
				}
			}()

			switch self.flip {
			case .none:
				return core
			case .horizontally:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(core, transform: .init(scaleX: -1, y: 1).translatedBy(x: -90, y: 0))
				}
			case .vertically:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(core, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -90))
				}
			case .both:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(core, transform: .init(scaleX: -1, y: -1).translatedBy(x: -90, y: -90))
				}
			}
		}

		/// The eye's background path
		@objc public func eyeBackgroundPath() -> CGPath {
			let core = self.fullBackground()

			switch self.flip {
			case .none:
				return core
			case .horizontally:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(core, transform: .init(scaleX: -1, y: 1).translatedBy(x: -90, y: 0))
				}
			case .vertically:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(core, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -90))
				}
			case .both:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(core, transform: .init(scaleX: -1, y: -1).translatedBy(x: -90, y: -90))
				}
			}
		}

		private static let _defaultPupil = QRCode.PupilShape.Circle()
		@objc public func defaultPupil() -> any QRCodePupilShapeGenerator { Self._defaultPupil }
	}
}

// MARK: - Settings

public extension QRCode.EyeShape.Eye {
	@objc func settings() -> [String: Any] { [
		QRCode.SettingsKey.flip: self.flip.rawValue,
		QRCode.SettingsKey.eyeInnerStyle: self.eyeInnerStyle.rawValue,
	] }

	@objc func supportsSettingValue(forKey key: String) -> Bool {
		key == QRCode.SettingsKey.flip || key == QRCode.SettingsKey.eyeInnerStyle
	}

	@objc func setSettingValue(_ value: Any?, forKey key: String) -> Bool {
		if key == QRCode.SettingsKey.flip,
			let value = IntValue(value) {
			self.flip = QRCode.Flip(rawValue: value) ?? .none
		}
		else if key == QRCode.SettingsKey.eyeInnerStyle {
			let value = IntValue(value) ?? 0
			self.eyeInnerStyle = QRCode.EyeShape.Eye.Style(rawValue: value) ?? .both
		}
		return false
	}
}

// MARK: - Paths

private extension QRCode.EyeShape.Eye {
	func full() -> CGPath {
		CGPath.make { eyePath in
			eyePath.move(to: CGPoint(x: 45, y: 70))
			eyePath.curve(to: CGPoint(x: 20, y: 45), controlPoint1: CGPoint(x: 31.19, y: 70), controlPoint2: CGPoint(x: 20, y: 58.81))
			eyePath.curve(to: CGPoint(x: 34.91, y: 22.12), controlPoint1: CGPoint(x: 20, y: 34.78), controlPoint2: CGPoint(x: 26.13, y: 26))
			eyePath.curve(to: CGPoint(x: 45, y: 20), controlPoint1: CGPoint(x: 37.99, y: 20.76), controlPoint2: CGPoint(x: 41.41, y: 20))
			eyePath.curve(to: CGPoint(x: 70, y: 45), controlPoint1: CGPoint(x: 58.81, y: 20), controlPoint2: CGPoint(x: 70, y: 31.19))
			eyePath.curve(to: CGPoint(x: 45, y: 70), controlPoint1: CGPoint(x: 70, y: 58.81), controlPoint2: CGPoint(x: 58.81, y: 70))
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
		}
	}

	func left() -> CGPath {
		CGPath.make { lefteyePath in
			lefteyePath.move(to: CGPoint(x: 70, y: 70))
			lefteyePath.line(to: CGPoint(x: 45, y: 70))
			lefteyePath.curve(to: CGPoint(x: 20, y: 45), controlPoint1: CGPoint(x: 31.19, y: 70), controlPoint2: CGPoint(x: 20, y: 58.81))
			lefteyePath.curve(to: CGPoint(x: 45, y: 20), controlPoint1: CGPoint(x: 20, y: 31.19), controlPoint2: CGPoint(x: 31.19, y: 20))
			lefteyePath.curve(to: CGPoint(x: 70, y: 45), controlPoint1: CGPoint(x: 58.81, y: 20), controlPoint2: CGPoint(x: 70, y: 31.19))
			lefteyePath.line(to: CGPoint(x: 70, y: 70))
			lefteyePath.close()
			lefteyePath.move(to: CGPoint(x: 80, y: 80))
			lefteyePath.curve(to: CGPoint(x: 80, y: 74.22), controlPoint1: CGPoint(x: 80, y: 80), controlPoint2: CGPoint(x: 80, y: 77.67))
			lefteyePath.curve(to: CGPoint(x: 80, y: 45), controlPoint1: CGPoint(x: 80, y: 64.28), controlPoint2: CGPoint(x: 80, y: 45))
			lefteyePath.curve(to: CGPoint(x: 45, y: 10), controlPoint1: CGPoint(x: 80, y: 25.67), controlPoint2: CGPoint(x: 64.33, y: 10))
			lefteyePath.line(to: CGPoint(x: 10, y: 10))
			lefteyePath.line(to: CGPoint(x: 10, y: 45))
			lefteyePath.curve(to: CGPoint(x: 45, y: 80), controlPoint1: CGPoint(x: 10, y: 64.33), controlPoint2: CGPoint(x: 25.67, y: 80))
			lefteyePath.line(to: CGPoint(x: 80, y: 80))
			lefteyePath.close()
		}
	}

	func right() -> CGPath {
		CGPath.make { righteyePath in
			righteyePath.move(to: CGPoint(x: 45, y: 70))
			righteyePath.curve(to: CGPoint(x: 20, y: 45), controlPoint1: CGPoint(x: 31.19, y: 70), controlPoint2: CGPoint(x: 20, y: 58.81))
			righteyePath.line(to: CGPoint(x: 20, y: 20))
			righteyePath.line(to: CGPoint(x: 45, y: 20))
			righteyePath.curve(to: CGPoint(x: 70, y: 45), controlPoint1: CGPoint(x: 58.81, y: 20), controlPoint2: CGPoint(x: 70, y: 31.19))
			righteyePath.curve(to: CGPoint(x: 45, y: 70), controlPoint1: CGPoint(x: 70, y: 58.81), controlPoint2: CGPoint(x: 58.81, y: 70))
			righteyePath.close()
			righteyePath.move(to: CGPoint(x: 45, y: 80))
			righteyePath.curve(to: CGPoint(x: 80, y: 80), controlPoint1: CGPoint(x: 45, y: 80), controlPoint2: CGPoint(x: 80, y: 80))
			righteyePath.curve(to: CGPoint(x: 80, y: 74.22), controlPoint1: CGPoint(x: 80, y: 80), controlPoint2: CGPoint(x: 80, y: 77.67))
			righteyePath.curve(to: CGPoint(x: 80, y: 45), controlPoint1: CGPoint(x: 80, y: 64.28), controlPoint2: CGPoint(x: 80, y: 45))
			righteyePath.curve(to: CGPoint(x: 45, y: 10), controlPoint1: CGPoint(x: 80, y: 25.67), controlPoint2: CGPoint(x: 64.33, y: 10))
			righteyePath.line(to: CGPoint(x: 10, y: 10))
			righteyePath.line(to: CGPoint(x: 10, y: 45))
			righteyePath.curve(to: CGPoint(x: 45, y: 80), controlPoint1: CGPoint(x: 10, y: 64.33), controlPoint2: CGPoint(x: 25.67, y: 80))
			righteyePath.line(to: CGPoint(x: 45, y: 80))
			righteyePath.close()
		}
	}

	func fullBackground() -> CGPath {
		CGPath.make { safeZonePath in
			safeZonePath.move(to: CGPoint(x: 90, y: 90))
			safeZonePath.curve(to: CGPoint(x: 90, y: 45), controlPoint1: CGPoint(x: 90, y: 90), controlPoint2: CGPoint(x: 90, y: 45))
			safeZonePath.curve(to: CGPoint(x: 45, y: 0), controlPoint1: CGPoint(x: 90, y: 20.15), controlPoint2: CGPoint(x: 69.85, y: 0))
			safeZonePath.line(to: CGPoint(x: 0, y: 0))
			safeZonePath.line(to: CGPoint(x: 0, y: 45))
			safeZonePath.curve(to: CGPoint(x: 45, y: 90), controlPoint1: CGPoint(x: 0, y: 69.85), controlPoint2: CGPoint(x: 20.15, y: 90))
			safeZonePath.line(to: CGPoint(x: 90, y: 90))
			safeZonePath.line(to: CGPoint(x: 90, y: 90))
			safeZonePath.close()
		}
		.applyingTransform(CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -90))
	}
}

public extension QRCodeEyeShapeGenerator where Self == QRCode.EyeShape.Eye {
	/// Create an 'eye' eye shape generator
	/// - Returns: An eye shape generator
	@inlinable static func eye() -> QRCodeEyeShapeGenerator { QRCode.EyeShape.Eye() }
}
