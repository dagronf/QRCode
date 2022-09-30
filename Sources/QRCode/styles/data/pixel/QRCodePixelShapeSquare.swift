//
//  QRCodePixelShapeSquare.swift
//
//  Created by Darren Ford on 3/5/22.
//  Copyright © 2022 Darren Ford. All rights reserved.
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

public extension QRCode.PixelShape {
	/// A square pixel shape
	@objc(QRCodePixelShapeSquare) class Square: NSObject, QRCodePixelShapeGenerator {
		@objc public static var Name: String { "square" }
		private let common: CommonPixelGenerator

		/// Create
		/// - Parameters:
		///   - inset: The inset between each pixel
		@objc public init(inset: CGFloat = 0) {
			self.common = CommonPixelGenerator(pixelType: .square, inset: inset)
			super.init()
		}

		@objc public static func Create(_ settings: [String: Any]?) -> QRCodePixelShapeGenerator {
			let inset = DoubleValue(settings?["inset", default: 0]) ?? 0
			return Square(inset: inset)
		}

		/// Make a copy of this shape
		@objc public func copyShape() -> QRCodePixelShapeGenerator {
			return Square(inset: self.common.inset)
		}

		/// The path representing the 'on' pixels in the qr code
		public func onPath(size: CGSize, data: QRCode, isTemplate: Bool) -> CGPath {
			self.common.onPath(size: size, data: data, isTemplate: isTemplate)
		}

		/// The path representing the 'off' pixels in the qr code
		public func offPath(size: CGSize, data: QRCode, isTemplate: Bool) -> CGPath {
			self.common.offPath(size: size, data: data, isTemplate: isTemplate)
		}

		@objc public var inset: CGFloat { self.common.inset }
	}
}

// MARK: - Settings

public extension QRCode.PixelShape.Square {
	/// Returns true if the shape supports setting a value for the specified key, false otherwise
	@objc func supportsSettingValue(forKey key: String) -> Bool {
		return key == "inset"
	}

	/// Returns the current settings for the shape
	@objc func settings() -> [String: Any] {
		return ["inset": self.common.inset]
	}

	/// Set a configuration value for a particular setting string
	@objc func setSettingValue(_ value: Any?, forKey key: String) -> Bool {
		if key == "inset" {
			guard let v = value else {
				self.common.inset = 0
				return true
			}
			guard let v = DoubleValue(v) else { return false }
			self.common.inset = v
			return true
		}
		return false
	}
}
