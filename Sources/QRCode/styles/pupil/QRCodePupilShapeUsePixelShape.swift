//
//  QRCodePupilShapeUsePixelShape.swift
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

// MARK: - Pupil shape

private let _PupilTemplate = BoolMatrix(dimension: 6, rawFlattenedInt: [
	0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0,
	0, 0, 0, 1, 1, 1,
	0, 0, 0, 1, 1, 1,
	0, 0, 0, 1, 1, 1,
])

public extension QRCode.PupilShape {
	/// A pupil style that uses the currently set onPixel style
	@objc(QRCodePupilShapeUsePixelShape) class UsePixelShape: NSObject, QRCodePupilShapeGenerator {
		@objc public static var Name: String { "usePixelShape" }
		/// The generator title
		@objc public static var Title: String { "Use Pixel Shape" }
		@objc public static func Create(_ settings: [String : Any]?) -> any QRCodePupilShapeGenerator { UsePixelShape() }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePupilShapeGenerator { UsePixelShape() }

		@objc public func settings() -> [String : Any] { [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath {
			let generator = pixelShape ?? QRCode.PixelShape.Square()
			return generator.generatePath(from: _PupilTemplate, size: CGSize(width: 60, height: 60))
		}

		/// The pixel shape generator assigned to the qr code.
		internal weak var pixelShape: (any QRCodePixelShapeGenerator)?
	}
}

extension QRCode.PupilShape.UsePixelShape {
	func previewPath() -> CGPath {
		let pth = CGMutablePath(rect: CGRect(x: 30, y: 50, width: 30, height: 10), transform: nil)
		pth.addRect(CGRect(x: 30, y: 30, width: 30, height: 10))
		return pth
	}
}
