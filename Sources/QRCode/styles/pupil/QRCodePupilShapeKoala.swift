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
	/// A Koala-node style pupil shape
	@objc(QRCodePupilShapeKoala) class Koala: NSObject, QRCodePupilShapeGenerator {
		@objc public static var Name: String { "koala" }
		/// The generator title
		@objc public static var Title: String { "Koala" }
		@objc public static func Create(_ settings: [String : Any]?) -> any QRCodePupilShapeGenerator {
			Koala(settings: settings)
		}

		/// The flip transform to apply to the pupil shape
		@objc public var flip: QRCode.Flip = .none

		/// Create a koala-node style pupil generator
		@objc public override init() {
			self.flip = .none
			super.init()
		}

		/// Create a koala-node style pupil generator with a transform
		/// - Parameter flip: The flip transform to apply to the pupil
		@objc public init(flip: QRCode.Flip) {
			self.flip = flip
			super.init()
		}

		/// Create a koala pupil shape generator using the specified settings
		@objc public init(settings: [String: Any]?) {
			super.init()
			settings?.forEach { (key: String, value: Any) in
				_ = self.setSettingValue(value, forKey: key)
			}
		}

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePupilShapeGenerator {
			Koala(flip: self.flip)
		}
		/// Reset the pupil shape generator back to defaults
		@objc public func reset() {
			self.flip = .none
		}

		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath {
			switch self.flip {
			case .none:
				return pupilShape__
			case .horizontally:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(pupilShape__, transform: .init(scaleX: -1, y: 1).translatedBy(x: -90, y: 0))
				}
			case .vertically:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(pupilShape__, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -90))
				}
			case .both:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(pupilShape__, transform: .init(scaleX: -1, y: -1).translatedBy(x: -90, y: -90))
				}
			}
		}
	}
}

// MARK: - Settings

public extension QRCode.PupilShape.Koala {
	/// Retrieve the settings for this pupil generator
	/// - Returns: A dictionary of settings
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

// MARK: - Conveniences

public extension QRCodePupilShapeGenerator where Self == QRCode.PupilShape.Koala {
	/// Create a koala pupil shape generator
	/// - Parameter flip: The flip transform to apply to the pupil
	/// - Returns: A pupil shape generator
	@inlinable static func koala(flip: QRCode.Flip = .none) -> QRCodePupilShapeGenerator {
		QRCode.PupilShape.Koala(flip: flip)
	}
}

// MARK: - Designs

private let pupilShape__: CGPath =
	CGPath.make { koalapupilPath in
		koalapupilPath.move(to: CGPoint(x: 31.62, y: 58.38))
		koalapupilPath.curve(to: CGPoint(x: 59.77, y: 49.43), controlPoint1: CGPoint(x: 36.42, y: 63.18), controlPoint2: CGPoint(x: 57.53, y: 56.46))
		koalapupilPath.curve(to: CGPoint(x: 40.57, y: 30.23), controlPoint1: CGPoint(x: 62, y: 42.39), controlPoint2: CGPoint(x: 47.61, y: 28))
		koalapupilPath.curve(to: CGPoint(x: 31.62, y: 58.38), controlPoint1: CGPoint(x: 33.54, y: 32.47), controlPoint2: CGPoint(x: 26.82, y: 53.58))
		koalapupilPath.close()
	}
	.flippedVertically(height: 90)
