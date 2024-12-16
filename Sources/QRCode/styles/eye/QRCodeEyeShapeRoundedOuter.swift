//
//  QRCodeEyeStyleRoundedOuter.swift
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
	/// A 'square with a rounded outer corner' style eye design
	@objc(QRCodeEyeShapeRoundedOuter) class RoundedOuter: NSObject, QRCodeEyeShapeGenerator {
		@objc public static let Name = "roundedOuter"
		@objc public static var Title: String { "Rounded outer" }
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodeEyeShapeGenerator {
			return QRCode.EyeShape.RoundedOuter(settings: settings)
		}

		/// Create a roundedOuter eye shape
		/// - Parameter flip: The flip state for the eye
		@objc public init(flip: QRCode.Flip = .none) {
			self.flip = flip
			super.init()

			// Push the setting down to the
			self._defaultPupil.flip = self.flip
		}

		/// Create a pupil shape using the specified settings
		@objc public init(settings: [String: Any]?) {
			super.init()
			settings?.forEach { (key: String, value: Any) in
				_ = self.setSettingValue(value, forKey: key)
			}
		}

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodeEyeShapeGenerator {
			return QRCode.EyeShape.RoundedOuter(flip: self.flip)
		}

		/// Reset the eye shape generator back to defaults
		@objc public func reset() { self.flip = .none }

		/// Flip the eye shape
		@objc public var flip: QRCode.Flip = .none {
			didSet {
				_ = self.defaultPupil().setSettingValue(self.flip.rawValue, forKey: QRCode.SettingsKey.flip)
			}
		}

		public func eyePath() -> CGPath {
			let roundedSharpOuterPath = CGMutablePath()
			roundedSharpOuterPath.move(to: CGPoint(x: 20, y: 70))
			roundedSharpOuterPath.line(to: CGPoint(x: 70, y: 70))
			roundedSharpOuterPath.line(to: CGPoint(x: 70, y: 20))
			roundedSharpOuterPath.line(to: CGPoint(x: 31, y: 20))
			roundedSharpOuterPath.curve(to: CGPoint(x: 20, y: 31), controlPoint1: CGPoint(x: 24.92, y: 20), controlPoint2: CGPoint(x: 20, y: 24.92))
			roundedSharpOuterPath.line(to: CGPoint(x: 20, y: 70))
			roundedSharpOuterPath.close()
			roundedSharpOuterPath.move(to: CGPoint(x: 10, y: 80))
			roundedSharpOuterPath.curve(to: CGPoint(x: 10, y: 30), controlPoint1: CGPoint(x: 10, y: 80), controlPoint2: CGPoint(x: 10, y: 30))
			roundedSharpOuterPath.curve(to: CGPoint(x: 30, y: 10), controlPoint1: CGPoint(x: 10, y: 18.95), controlPoint2: CGPoint(x: 18.95, y: 10))
			roundedSharpOuterPath.line(to: CGPoint(x: 80, y: 10))
			roundedSharpOuterPath.curve(to: CGPoint(x: 80, y: 80), controlPoint1: CGPoint(x: 80, y: 10.34), controlPoint2: CGPoint(x: 80, y: 80))
			roundedSharpOuterPath.line(to: CGPoint(x: 10, y: 80))
			roundedSharpOuterPath.line(to: CGPoint(x: 10, y: 80))
			roundedSharpOuterPath.close()

			switch self.flip {
			case .none:
				return roundedSharpOuterPath
			case .vertically:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(roundedSharpOuterPath, transform: .init(scaleX: -1, y: 1).translatedBy(x: -90, y: 0))
				}
			case .horizontally:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(roundedSharpOuterPath, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -90))
				}
			case .both:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(roundedSharpOuterPath, transform: .init(scaleX: -1, y: -1).translatedBy(x: -90, y: -90))
				}
			}
		}

		@objc public func eyeBackgroundPath() -> CGPath {
			let roundedRectEye2Path = CGMutablePath()
			roundedRectEye2Path.move(to: CGPoint(x: 0, y: 0))
			roundedRectEye2Path.curve(to: CGPoint(x: 0, y: 64.29), controlPoint1: CGPoint(x: 0, y: 0), controlPoint2: CGPoint(x: 0, y: 64.29))
			roundedRectEye2Path.curve(to: CGPoint(x: 25.71, y: 90), controlPoint1: CGPoint(x: 0, y: 78.49), controlPoint2: CGPoint(x: 11.51, y: 90))
			roundedRectEye2Path.line(to: CGPoint(x: 90, y: 90))
			roundedRectEye2Path.curve(to: CGPoint(x: 90, y: 0), controlPoint1: CGPoint(x: 90, y: 89.56), controlPoint2: CGPoint(x: 90, y: 0))
			roundedRectEye2Path.line(to: CGPoint(x: 0, y: 0))
			roundedRectEye2Path.line(to: CGPoint(x: 0, y: 0))
			roundedRectEye2Path.close()

			switch self.flip {
			case .none:
				return roundedRectEye2Path
			case .vertically:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(roundedRectEye2Path, transform: .init(scaleX: -1, y: 1).translatedBy(x: -90, y: 0))
				}
			case .horizontally:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(roundedRectEye2Path, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -90))
				}
			case .both:
				return CGPath.make(forceClosePath: true) { n in
					n.addPath(roundedRectEye2Path, transform: .init(scaleX: -1, y: -1).translatedBy(x: -90, y: -90))
				}
			}
		}
		
		private let _defaultPupil = QRCode.PupilShape.RoundedOuter()
		public func defaultPupil() -> any QRCodePupilShapeGenerator { self._defaultPupil }
	}
}

public extension QRCode.EyeShape.RoundedOuter {
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

public extension QRCodeEyeShapeGenerator where Self == QRCode.EyeShape.RoundedOuter {
	/// Create a 'sqaure with outer corner rounded' eye shape generator
	/// - Returns: An eye shape generator
	@inlinable static func roundedOuter() -> QRCodeEyeShapeGenerator { QRCode.EyeShape.RoundedOuter() }
}
