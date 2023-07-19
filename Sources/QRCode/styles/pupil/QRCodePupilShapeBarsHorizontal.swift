//
//  QRCodePupilShapeBarsHorizontal.swift
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
	/// A horizontal bars style pupil design
	@objc(QRCodePupilShapeBarsHorizontal) class BarsHorizontal: NSObject, QRCodePupilShapeGenerator {
		@objc public static var Name: String { "barsHorizontal" }
		/// The generator title
		@objc public static var Title: String { "Horizontal bars" }
		@objc public static func Create(_ settings: [String : Any]?) -> QRCodePupilShapeGenerator {
			BarsHorizontal()
		}

		/// Make a copy of the object
		@objc public func copyShape() -> QRCodePupilShapeGenerator { BarsHorizontal() }

		@objc public func settings() -> [String : Any] { [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath {
			let rectanglePath = CGPath(roundedRect: CGRect(x: 30, y: 30, width: 30, height: 9.33), cornerWidth: 4, cornerHeight: 4, transform: nil)
			let rectangle2Path = CGPath(roundedRect: CGRect(x: 30, y: 40.33, width: 30, height: 9.33), cornerWidth: 4, cornerHeight: 4, transform: nil)
			let rectangle3Path = CGPath(roundedRect: CGRect(x: 30, y: 50.66, width: 30, height: 9.33), cornerWidth: 4, cornerHeight: 4, transform: nil)

			let result = CGMutablePath()
			result.addPath(rectanglePath)
			result.addPath(rectangle2Path)
			result.addPath(rectangle3Path)
			result.close()
			return result
		}
	}
}
