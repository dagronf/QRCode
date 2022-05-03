//
//  QRCodeDataShapeCircle.swift
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

import Foundation
import CoreGraphics

public extension QRCode.DataShape {
	/// A circle pixel shape
	@objc(QRCodeDataShapeCircle) class Circle: NSObject, QRCodeDataShapeGenerator {
		static public var Name: String { "circle" }
		private let common: CommonPixelGenerator

		/// Create
		/// - Parameters:
		///   - inset: The inset between each pixel
		@objc public init(inset: CGFloat = 0) {
			self.common = CommonPixelGenerator(pixelType: .circle, inset: inset)
			super.init()
		}

		public static func Create(_ settings: [String : Any]?) -> QRCodeDataShapeGenerator {
			let inset = DoubleValue(settings?["inset", default: 0]) ?? 0
			return Circle(inset: inset)
		}

		public func copyShape() -> QRCodeDataShapeGenerator {
			return Circle(inset: self.common.inset)
		}

		public func onPath(size: CGSize, data: QRCode, isTemplate: Bool) -> CGPath {
			common.onPath(size: size, data: data, isTemplate: isTemplate)
		}

		public func offPath(size: CGSize, data: QRCode, isTemplate: Bool) -> CGPath {
			common.offPath(size: size, data: data, isTemplate: isTemplate)
		}

		public func settings() -> [String : Any] {
			return [ "inset": self.common.inset ]
		}
	}
}
