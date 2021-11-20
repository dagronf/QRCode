//
//  QRCode+Style.swift
//
//  Created by Darren Ford on 16/11/21.
//  Copyright © 2021 Darren Ford. All rights reserved.
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

public extension QRCode {
	/// The design for the qr code output
	@objc(QRCodeDesign) class Design: NSObject {

		/// Convenience for objc
		@objc public static func create() -> Design { return Design() }

		/// The display style for the qr code.
		@objc public var style = QRCode.Style()

		/// The drawing shape for the qr code.
		@objc public var shape = QRCode.Shape()

		/// Copy the design
		public func copyDesign() -> Design {
			let c = Design()
			c.shape = self.shape.copyShape()
			c.style = self.style.copyStyle()
			return c
		}
	}

	/// Represents the shape when generating the qr code
	@objc(QRCodeStyle) class Style: NSObject {

		/// Convenience for objc
		@objc public static func create() -> Style { return Style() }

		/// The style for the data component QR code
		@objc public var data: QRCodeFillStyleGenerator = QRCode.FillStyle.Solid(CGColor(gray: 0.0, alpha: 1.0))
		/// The style for drawing the non-drawn sections of the qr code.
		@objc public var dataInverted: QRCodeFillStyleGenerator?

		/// The background style for the QR code. If nil, no background is drawn
		@objc public var background: QRCodeFillStyleGenerator? = QRCode.FillStyle.Solid(CGColor(gray: 1.0, alpha: 1.0))

		/// The border around the eye.  By default, this is the same color as the data
		@objc public var eye: QRCodeFillStyleGenerator?

		/// The pupil of the eye. By default, this is the same color as the eye, and failing that the data
		@objc public var pupil: QRCodeFillStyleGenerator?

		/// Copy the style
		public func copyStyle() -> Style {
			let c = Style()
			c.data = self.data.copyStyle()
			c.background = self.background?.copyStyle()
			c.eye = self.eye?.copyStyle()
			c.pupil = self.pupil?.copyStyle()
			return c
		}
	}

	/// Represents the shape when generating the qr code
	@objc(QRCodeShape) class Shape: NSObject {

		/// Convenience for objc
		@objc public static func create() -> Shape { return Shape() }

		/// The shape of the pixels.
		///
		/// Defaults to simple square 'pixels'
		@objc public var data: QRCodeDataShapeHandler = QRCode.DataShape.Pixel(pixelType: .square)

		/// The shape for drawing the non-drawn sections of the qr code.
		@objc public var dataInverted: QRCodeDataShapeHandler?

		/// The style of eyes to display
		///
		/// Defaults to a simple square eye
		@objc public var eye: QRCodeEyeShapeHandler = QRCode.EyeShape.Square()
		/// Make a copy of the content shape
		public func copyShape() -> Shape {
			let c = Shape()
			c.data = self.data.copyShape()
			c.eye = self.eye.copyShape()
			return c
		}
	}
}

// MARK: - Fill style support

public extension QRCode {
	@objc(QRCodeFillStyle) class FillStyle: NSObject {}
}

/// A protocol for wrapping fill styles for image generation
@objc public protocol QRCodeFillStyleGenerator {
	func copyStyle() -> QRCodeFillStyleGenerator
	func fill(ctx: CGContext, rect: CGRect)
	func fill(ctx: CGContext, rect: CGRect, path: CGPath)
}
