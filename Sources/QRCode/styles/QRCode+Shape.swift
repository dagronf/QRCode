//
//  QRCode+Shape.swift
//
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

		/// The shape of the 'on' pixels. Defaults to simple square 'pixels'
		@objc public var onPixels: QRCodePixelShapeGenerator = QRCode.PixelShape.Square()

		/// Deprecated. Use `onPixels` instead.
		@available(*, deprecated, renamed: "onPixels")
		@objc public var data: QRCodePixelShapeGenerator {
			get { onPixels }
			set { onPixels = newValue }
		}

		/// The shape for drawing the non-drawn sections of the qr code.
		@objc public var offPixels: QRCodePixelShapeGenerator?

		/// Deprecated. Use `offPixels` instead.
		@available(*, deprecated, renamed: "offPixels")
		@objc public var dataInverted: QRCodePixelShapeGenerator? {
			get { offPixels }
			set { offPixels = newValue }
		}

		/// The style of eyes to display
		///
		/// Defaults to a simple square eye
		@objc public var eye: QRCodeEyeShapeGenerator = QRCode.EyeShape.Square() {
			didSet {
				// Reset the pupil shape to match the eye shape
				pupil = nil
			}
		}

		/// The shape of the pupil. If nil, uses the default pupil shape as defined by the eye
		@objc public var pupil: QRCodePupilShapeGenerator? = nil

		/// Make a copy of the content shape
		public func copyShape() -> Shape {
			let c = Shape()
			c.onPixels = self.onPixels.copyShape()
			c.offPixels = self.offPixels?.copyShape()
			c.eye = self.eye.copyShape()
			c.pupil = self.pupil?.copyShape()
			return c
		}
	}
}

// MARK: - Load/Save

public extension QRCode.Shape {

	@objc func settings() -> [String: Any] {
		var result: [String: Any] = [:]

		// The 'on' pixel shape settings
		result["onPixels"] = onPixels.coreSettings()

		// The 'off' pixels shape settings if they are defined
		if let offPixels = offPixels {
			result["offPixels"] = offPixels.coreSettings()
		}

		// The 'eye' pixel shape settings
		result["eye"] = eye.coreSettings()

		if let pupil = pupil {
			result["pupil"] = pupil.coreSettings()
		}

		return result
	}

	@objc static func Create(settings: [String: Any]) -> QRCode.Shape? {
		let result = QRCode.Shape()

		// The on-pixels

		// Backwards compatibility. Upgrade from old data type
		if let data = settings["data"] as? [String: Any],
			let shape = QRCodePixelShapeFactory.shared.create(settings: data)
		{
			result.onPixels = shape
		}
		else if let data = settings["onPixels"] as? [String: Any],
				  let shape = QRCodePixelShapeFactory.shared.create(settings: data)
		{
			result.onPixels = shape
		}

		// The eye

		if let eye = settings["eye"] as? [String: Any],
			let shape = QRCodeEyeShapeFactory.shared.create(settings: eye)
		{
			result.eye = shape
		}

		// The off-pixels

		// Load from the old version if it is available
		if let data = settings["dataInverted"] as? [String: Any],
			let shape = QRCodePixelShapeFactory.shared.create(settings: data)
		{
			result.offPixels = shape
		}
		else if let data = settings["offPixels"] as? [String: Any],
				  let shape = QRCodePixelShapeFactory.shared.create(settings: data)
		{
			result.offPixels = shape
		}

		if let data = settings["pupil"] as? [String: Any],
			let pupil = QRCodePupilShapeFactory.shared.create(settings: data)
		{
			result.pupil = pupil
		}

		return result
	}

}
