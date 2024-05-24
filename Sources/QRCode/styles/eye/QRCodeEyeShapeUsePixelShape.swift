//
//  QRCodeEyeStyleRoundedRect.swift
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

private let _EyeTemplate = BoolMatrix(dimension: 9, rawFlattenedInt: [
	0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 1, 1, 1, 1, 1, 1, 1, 0,
	0, 1, 0, 0, 0, 0, 0, 1, 0,
	0, 1, 0, 0, 0, 0, 0, 1, 0,
	0, 1, 0, 0, 0, 0, 0, 1, 0,
	0, 1, 0, 0, 0, 0, 0, 1, 0,
	0, 1, 0, 0, 0, 0, 0, 1, 0,
	0, 1, 1, 1, 1, 1, 1, 1, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0,
])

public extension QRCode.EyeShape {
	/// An eye shape that uses the qrcode's onPixel shape to generate the eye pattern
	@objc(QRCodeEyeShapeUsePixelShape) class UsePixelShape: NSObject, QRCodeEyeShapeGenerator {

		public func copyShape() -> any QRCodeEyeShapeGenerator {
			QRCode.EyeShape.UsePixelShape()
		}

		public func eyePath() -> CGPath {
			let generator = pixelShape ?? QRCode.PixelShape.Square()
			return generator.generatePath(from: _EyeTemplate, size: CGSize(width: 90, height: 90))
		}

		public func eyeBackgroundPath() -> CGPath {
			CGPath(rect: CGRect(origin: .zero, size: CGSize(width: 90, height: 90)), transform: nil)
		}

		public func defaultPupil() -> any QRCodePupilShapeGenerator {
			QRCode.PupilShape.UsePixelShape()
		}

		@objc public func settings() -> [String : Any] { [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		@objc public static let Name = "usePixelShape"
		@objc public static var Title: String { "Use Pixel Shape" }
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodeEyeShapeGenerator {
			return QRCode.EyeShape.UsePixelShape()
		}

		/// The pixel shape generator assigned to the qr code.
		weak var pixelShape: (any QRCodePixelShapeGenerator)?
	}
}

extension QRCode.EyeShape.UsePixelShape {
	func previewPath() -> CGPath {
		let pth = CGMutablePath(rect: CGRect(x: 10, y: 70, width: 70, height: 10), transform: nil)
		pth.addRect(CGRect(x: 10, y: 10, width: 70, height: 10))
		return pth
	}
}
