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

import Foundation
import CoreGraphics

// MARK: - Pupil shape

public extension QRCode.PupilShape {
	/// A forest style pupil design
	@objc(QRCodePupilShapeForest) class Forest: NSObject, QRCodePupilShapeGenerator {
		@objc public static var Name: String { "forest" }
		/// The generator title
		@objc public static var Title: String { "Forest" }
		/// Create a pupil generator with the provided settings
		@objc public static func Create(_ settings: [String : Any]?) -> any QRCodePupilShapeGenerator {
			Forest(settings: settings)
		}

		/// Create a pupil generator
		/// - Parameter flip: The flip state for the pupil
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

		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath {
			switch self.flip {
			case .none:
				return pupilGeneratedPath__
			case .vertically:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(pupilGeneratedPath__, transform: .init(scaleX: -1, y: 1).translatedBy(x: -90, y: 0))
				}
			case .horizontally:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(pupilGeneratedPath__, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -90))
				}
			case .both:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(pupilGeneratedPath__, transform: .init(scaleX: -1, y: -1).translatedBy(x: -90, y: -90))
				}
			}
		}

		/// Flip the pupil shape
		@objc public var flip: QRCode.Flip = .none
	}
}

public extension QRCode.PupilShape.Forest {
	/// Make a copy of the object
	@objc func copyShape() -> any QRCodePupilShapeGenerator {
		QRCode.PupilShape.Forest(flip: self.flip)
	}
	/// Reset the pupil shape generator back to defaults
	@objc func reset() {
		self.flip = .none
	}

	/// Available settings for the pupil
	@objc func settings() -> [String : Any] {
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

public extension QRCodePupilShapeGenerator where Self == QRCode.PupilShape.Forest {
	/// Create a circle pupil shape generator
	/// - Returns: A pupil shape generator
	@inlinable static func forest() -> QRCodePupilShapeGenerator { QRCode.PupilShape.Forest() }
}

// MARK: - Paths

/// The fixed pupil shape
private let pupilGeneratedPath__: CGPath = {
	CGPath.make { forestPath in
		let f = CGMutablePath()
		f.move(to: CGPoint(x: 36.68, y: 33.18))
		f.curve(to: CGPoint(x: 30.56, y: 60), controlPoint1: CGPoint(x: 27.26, y: 40.33), controlPoint2: CGPoint(x: 30.56, y: 60))
		f.curve(to: CGPoint(x: 35.74, y: 57.76), controlPoint1: CGPoint(x: 30.56, y: 60), controlPoint2: CGPoint(x: 31.7, y: 57.76))
		f.curve(to: CGPoint(x: 56.45, y: 53.29), controlPoint1: CGPoint(x: 42.33, y: 57.76), controlPoint2: CGPoint(x: 50.33, y: 60))
		f.curve(to: CGPoint(x: 57.86, y: 33.18), controlPoint1: CGPoint(x: 63.51, y: 46.59), controlPoint2: CGPoint(x: 57.86, y: 33.18))
		f.curve(to: CGPoint(x: 36.68, y: 33.18), controlPoint1: CGPoint(x: 57.86, y: 33.18), controlPoint2: CGPoint(x: 46.09, y: 26.03))
		f.close()
		forestPath.addPath(f, transform: CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -90))
		forestPath.close()
	}
}()
