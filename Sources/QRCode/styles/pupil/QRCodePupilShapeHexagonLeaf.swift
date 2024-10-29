//
//  QRCodePupilShapeHexagonLeaf.swift
//
//  Copyright © 2024 Darren Ford, Aydin Aghayev. All rights reserved.
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
	/// A hexagonal leaf pupil design
	@objc(QRCodePupilShapeHexagonLeaf) public class HexagonLeaf: NSObject, QRCodePupilShapeGenerator {
		/// Generator name
		@objc public static var Name: String { "hexagonLeaf" }
		/// Generator title
		@objc public static var Title: String { "Hexagon Leaf" }
		/// Create a hexagon leaf pupil shape, using the specified settings
		@objc public static func Create(_ settings: [String : Any]?) -> any QRCodePupilShapeGenerator {
			if let settings = settings {
				return HexagonLeaf(settings: settings)
			}
			return HexagonLeaf()
		}

		/// Is the pupil shape flipped?
		@objc public var isFlipped: Bool = false

		@objc public init(isFlipped: Bool = false) {
			self.isFlipped = isFlipped
			super.init()
		}

		/// Create a navigator pupil shape using the specified settings
		@objc public init(settings: [String: Any]) {
			super.init()
			settings.forEach { (key: String, value: Any) in
				_ = self.setSettingValue(value, forKey: key)
			}
		}

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePupilShapeGenerator {
			HexagonLeaf(isFlipped: self.isFlipped)
		}
		/// Reset the pupil shape generator back to defaults
		@objc public func reset() {
			self.isFlipped = false
		}

		@objc public func settings() -> [String: Any] {
			[QRCode.SettingsKey.isFlipped: self.isFlipped]
		}
		@objc public func supportsSettingValue(forKey key: String) -> Bool {
			key == QRCode.SettingsKey.isFlipped
		}
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool {
			if key == QRCode.SettingsKey.isFlipped {
				self.isFlipped = BoolValue(value) ?? false
			}
			return false
		}

		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath {
			let pupilPath = CGPath.RoundedHexagon(
				rect: CGRect(x: 30, y: 30, width: 30, height: 30),
				cornerRadius: 3,
				byRoundingCorners: [.topMiddle, .rightMiddle, .bottomMiddle, .leftMiddle]
			)

			if isFlipped {
				let flipped = CGMutablePath()
				flipped.addPath(pupilPath, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -90))
				return flipped
			}
			return pupilPath
		}
	}
}

public extension QRCodePupilShapeGenerator where Self == QRCode.PupilShape.HexagonLeaf {
	/// Create a hexagonal leaf pupil shape generator
	/// - Returns: A pupil shape generator
	@inlinable static func hexagonLeaf(isFlipped: Bool = false) -> QRCodePupilShapeGenerator {
		QRCode.PupilShape.HexagonLeaf(isFlipped: isFlipped)
	}
}
