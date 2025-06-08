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

extension QRCode.PupilShape {
	/// A (bulky) arrow pupil design
	@objc(QRCodePupilShapeArrow) public class Arrow: NSObject, QRCodePupilShapeGenerator {
		/// Generator name
		@objc public static var Name: String { "arrow" }
		/// Generator title
		@objc public static var Title: String { "Arrow" }
		/// Create a hexagon leaf pupil shape, using the specified settings
		@objc public static func Create(_ settings: [String : Any]?) -> any QRCodePupilShapeGenerator {
			Arrow(settings: settings)
		}

		/// Flip the pupil shape
		@objc public var flip: QRCode.Flip = .none

		/// Create a pupil
		/// - Parameter flip: The flip state for the eye
		@objc public init(flip: QRCode.Flip = .none) {
			self.flip = flip
			super.init()
		}

		/// Create a pupil shape using the specified settings
		@objc public init(settings: [String: Any]?) {
			super.init()
			settings?.forEach { (key: String, value: Any) in
				_ = self.setSettingValue(value, forKey: key)
			}
		}

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePupilShapeGenerator { Arrow(flip: self.flip) }
		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath {
			switch self.flip {
			case .none:
				return pupilPath__
			case .horizontally:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(pupilPath__, transform: .init(scaleX: -1, y: 1).translatedBy(x: -90, y: 0))
				}
			case .vertically:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(pupilPath__, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -90))
				}
			case .both:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(pupilPath__, transform: .init(scaleX: -1, y: -1).translatedBy(x: -90, y: -90))
				}
			}
		}

	}
}

public extension QRCode.PupilShape.Arrow {

	/// Reset the pupil shape generator back to defaults
	@objc func reset() { self.flip = .none }

	/// Returns the current settings for the generqtor
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

public extension QRCodePupilShapeGenerator where Self == QRCode.PupilShape.Arrow {
	/// Create a blobby pupil shape generator
	/// - Returns: A pupil shape generator
	@inlinable static func arrow() -> QRCodePupilShapeGenerator {
		QRCode.PupilShape.Arrow()
	}
}

// MARK: - Paths

private let pupilPath__: CGPath =
	CGPath.make { bezierPath in
		bezierPath.move(to: CGPoint(x: 60, y: 52.5))
		bezierPath.curve(to: CGPoint(x: 52.5, y: 45), controlPoint1: CGPoint(x: 60, y: 48.36), controlPoint2: CGPoint(x: 56.64, y: 45))
		bezierPath.curve(to: CGPoint(x: 46, y: 45), controlPoint1: CGPoint(x: 52.5, y: 45), controlPoint2: CGPoint(x: 46.49, y: 45.01))
		bezierPath.curve(to: CGPoint(x: 45.33, y: 44.66), controlPoint1: CGPoint(x: 45.51, y: 44.99), controlPoint2: CGPoint(x: 45.33, y: 44.66))
		bezierPath.curve(to: CGPoint(x: 45, y: 44), controlPoint1: CGPoint(x: 45.33, y: 44.66), controlPoint2: CGPoint(x: 45, y: 44.34))
		bezierPath.curve(to: CGPoint(x: 45, y: 37.5), controlPoint1: CGPoint(x: 45, y: 40.62), controlPoint2: CGPoint(x: 45, y: 37.5))
		bezierPath.curve(to: CGPoint(x: 37.5, y: 30), controlPoint1: CGPoint(x: 45, y: 33.36), controlPoint2: CGPoint(x: 41.64, y: 30))
		bezierPath.curve(to: CGPoint(x: 30, y: 37.5), controlPoint1: CGPoint(x: 33.36, y: 30), controlPoint2: CGPoint(x: 30, y: 33.36))
		bezierPath.line(to: CGPoint(x: 30, y: 52.5))
		bezierPath.line(to: CGPoint(x: 30, y: 52.69))
		bezierPath.line(to: CGPoint(x: 30.01, y: 52.89))
		bezierPath.line(to: CGPoint(x: 30.02, y: 53.08))
		bezierPath.line(to: CGPoint(x: 30.04, y: 53.27))
		bezierPath.line(to: CGPoint(x: 30.06, y: 53.46))
		bezierPath.line(to: CGPoint(x: 30.09, y: 53.64))
		bezierPath.line(to: CGPoint(x: 30.12, y: 53.83))
		bezierPath.line(to: CGPoint(x: 30.15, y: 54.01))
		bezierPath.line(to: CGPoint(x: 30.19, y: 54.19))
		bezierPath.line(to: CGPoint(x: 30.24, y: 54.37))
		bezierPath.line(to: CGPoint(x: 30.28, y: 54.55))
		bezierPath.line(to: CGPoint(x: 30.34, y: 54.73))
		bezierPath.line(to: CGPoint(x: 30.39, y: 54.91))
		bezierPath.line(to: CGPoint(x: 30.46, y: 55.08))
		bezierPath.line(to: CGPoint(x: 30.52, y: 55.25))
		bezierPath.line(to: CGPoint(x: 30.59, y: 55.42))
		bezierPath.line(to: CGPoint(x: 30.66, y: 55.59))
		bezierPath.line(to: CGPoint(x: 30.74, y: 55.75))
		bezierPath.line(to: CGPoint(x: 30.82, y: 55.91))
		bezierPath.line(to: CGPoint(x: 30.91, y: 56.07))
		bezierPath.line(to: CGPoint(x: 30.99, y: 56.23))
		bezierPath.line(to: CGPoint(x: 31.09, y: 56.39))
		bezierPath.line(to: CGPoint(x: 31.18, y: 56.54))
		bezierPath.line(to: CGPoint(x: 31.28, y: 56.69))
		bezierPath.line(to: CGPoint(x: 31.38, y: 56.84))
		bezierPath.line(to: CGPoint(x: 31.49, y: 56.99))
		bezierPath.line(to: CGPoint(x: 31.6, y: 57.13))
		bezierPath.line(to: CGPoint(x: 31.71, y: 57.27))
		bezierPath.line(to: CGPoint(x: 31.83, y: 57.41))
		bezierPath.line(to: CGPoint(x: 31.95, y: 57.54))
		bezierPath.line(to: CGPoint(x: 32.07, y: 57.67))
		bezierPath.line(to: CGPoint(x: 32.2, y: 57.8))
		bezierPath.line(to: CGPoint(x: 32.33, y: 57.93))
		bezierPath.line(to: CGPoint(x: 32.46, y: 58.05))
		bezierPath.line(to: CGPoint(x: 32.59, y: 58.17))
		bezierPath.line(to: CGPoint(x: 32.73, y: 58.29))
		bezierPath.line(to: CGPoint(x: 32.87, y: 58.4))
		bezierPath.line(to: CGPoint(x: 33.01, y: 58.51))
		bezierPath.line(to: CGPoint(x: 33.16, y: 58.62))
		bezierPath.line(to: CGPoint(x: 33.31, y: 58.72))
		bezierPath.line(to: CGPoint(x: 33.46, y: 58.82))
		bezierPath.line(to: CGPoint(x: 33.61, y: 58.91))
		bezierPath.line(to: CGPoint(x: 33.77, y: 59.01))
		bezierPath.line(to: CGPoint(x: 33.93, y: 59.09))
		bezierPath.line(to: CGPoint(x: 34.09, y: 59.18))
		bezierPath.line(to: CGPoint(x: 34.25, y: 59.26))
		bezierPath.line(to: CGPoint(x: 34.41, y: 59.34))
		bezierPath.line(to: CGPoint(x: 34.58, y: 59.41))
		bezierPath.line(to: CGPoint(x: 34.75, y: 59.48))
		bezierPath.line(to: CGPoint(x: 34.92, y: 59.54))
		bezierPath.line(to: CGPoint(x: 35.09, y: 59.61))
		bezierPath.line(to: CGPoint(x: 35.27, y: 59.66))
		bezierPath.line(to: CGPoint(x: 35.45, y: 59.72))
		bezierPath.line(to: CGPoint(x: 35.63, y: 59.76))
		bezierPath.line(to: CGPoint(x: 35.81, y: 59.81))
		bezierPath.line(to: CGPoint(x: 35.99, y: 59.85))
		bezierPath.line(to: CGPoint(x: 36.17, y: 59.88))
		bezierPath.line(to: CGPoint(x: 36.36, y: 59.91))
		bezierPath.line(to: CGPoint(x: 36.54, y: 59.94))
		bezierPath.line(to: CGPoint(x: 36.73, y: 59.96))
		bezierPath.line(to: CGPoint(x: 36.92, y: 59.98))
		bezierPath.line(to: CGPoint(x: 37.11, y: 59.99))
		bezierPath.line(to: CGPoint(x: 37.31, y: 60))
		bezierPath.line(to: CGPoint(x: 37.5, y: 60))
		bezierPath.line(to: CGPoint(x: 52.5, y: 60))
		bezierPath.curve(to: CGPoint(x: 60, y: 52.5), controlPoint1: CGPoint(x: 56.64, y: 60), controlPoint2: CGPoint(x: 60, y: 56.64))
	}
	.flippedVertically(height: 90)
