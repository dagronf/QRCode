//
//  QRCodePupilShapeEdges.swift
//
//  Copyright © 2023 Darren Ford. All rights reserved.
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
	@objc(QRCodePupilShapeEdges) class Edges: NSObject, QRCodePupilShapeGenerator {
		@objc public static var Name: String { "edges" }
		/// The generator title
		@objc public static var Title: String { "Edges" }

		@objc public static func Create(_ settings: [String : Any]?) -> QRCodePupilShapeGenerator {
			let radius = DoubleValue(settings?[QRCode.SettingsKey.cornerRadiusFraction]) ?? 1
			return Edges(cornerRadiusFraction: radius)
		}

		private var _actualCornerRadius: CGFloat = 0

		/// The fractional corner radius (0 ... 1) for the edge bars
		@objc public var cornerRadiusFraction: CGFloat = 0 {
			didSet {
				self._actualCornerRadius = self.cornerRadiusFraction.unitClamped() * 5.0
			}
		}

		@objc public init(cornerRadiusFraction: CGFloat = 0) {
			self.cornerRadiusFraction = cornerRadiusFraction
			self._actualCornerRadius = cornerRadiusFraction * 5.0
		}

		/// Make a copy of the object
		@objc public func copyShape() -> QRCodePupilShapeGenerator {
			Edges(cornerRadiusFraction: self.cornerRadiusFraction)
		}

		@objc public func settings() -> [String: Any] {
			[ QRCode.SettingsKey.cornerRadiusFraction: self.cornerRadiusFraction ]
		}
		@objc public func supportsSettingValue(forKey key: String) -> Bool { key == QRCode.SettingsKey.cornerRadiusFraction }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool {
			if key == QRCode.SettingsKey.cornerRadiusFraction, let value = DoubleValue(value) {
				self.cornerRadiusFraction = value.unitClamped()
				return true
			}
			return false
		}

		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath {
			CGPath(
				roundedRect: CGRect(x: 30, y: 30, width: 30, height: 30),
				cornerWidth: self._actualCornerRadius,
				cornerHeight: self._actualCornerRadius,
				transform: nil)
		}
	}
}
