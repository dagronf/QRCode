//
//  QRCode+Shape.swift
//
//  Created by Darren Ford on 29/11/21.
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

// MARK: - The shape

public extension QRCode {
	/// Represents the shape when generating the qr code
	@objc(QRCodeShape) class Shape: NSObject {

		/// Convenience initializer for objc
		@objc public static func create() -> Shape { return Shape() }

		/// The shape of the pixels.
		///
		/// Defaults to simple square 'pixels'
		@objc public var data: QRCodeDataShapeGenerator = QRCode.DataShape.Square()

		/// The shape for drawing the non-drawn sections of the qr code.
		@objc public var dataInverted: QRCodeDataShapeGenerator?

		/// The style of eyes to display
		///
		/// Defaults to a simple square eye
		@objc public var eye: QRCodeEyeShapeGenerator = QRCode.EyeShape.Square()

		/// Make a copy of the content shape
		public func copyShape() -> Shape {
			let c = Shape()
			c.data = self.data.copyShape()
			c.dataInverted = self.dataInverted?.copyShape()
			c.eye = self.eye.copyShape()
			return c
		}
	}
}

// MARK: - Load/Save

public extension QRCode.Shape {

	@objc func settings() -> [String: Any] {
		var result: [String: Any] = [:]

		result["data"] = data.coreSettings()
		result["eye"] = eye.coreSettings()

		if let dataInverted = dataInverted {
			result["dataInverted"] = dataInverted.coreSettings()
		}
		return result
	}

	@objc static func Create(settings: [String: Any]) -> QRCode.Shape? {
		let result = QRCode.Shape()

		if let data = settings["data"] as? [String: Any],
			let shape = QRCodeDataShapeFactory.shared.create(settings: data)
		{
			result.data = shape
		}

		if let eye = settings["eye"] as? [String: Any],
			let shape = QRCodeEyeShapeFactory.shared.create(settings: eye)
		{
			result.eye = shape
		}

		if let data = settings["dataInverted"] as? [String: Any],
			let shape = QRCodeDataShapeFactory.shared.create(settings: data)
		{
			result.dataInverted = shape
		}

		return result
	}

}
