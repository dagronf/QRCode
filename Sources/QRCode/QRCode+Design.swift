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

// MARK: - The design

public extension QRCode {
	/// The design for the qr code output.
	///
	/// This combines :-
	/// * a 'shape' (the outline shape of the component of the qr code), and
	/// * a 'style' (the fill styles for each component of the qr code)
	@objc(QRCodeDesign) class Design: NSObject {

		/// Convenience initializer for objc
		@objc public static func create() -> Design { return Design() }

		/// The drawing shape for the qr code.
		@objc public var shape = QRCode.Shape()
		
		/// The display style for the qr code.
		@objc public var style = QRCode.Style()

		/// Basic initializer for the default style
		@objc public override init() {
			super.init()
		}

		/// Convenience creator for a simple background and foreground color
		/// - Parameters:
		///   - foregroundColor: The color to use for the foreground
		///   - backgroundColor: (Optional) The color to use for the background.
		@objc public init(foregroundColor: CGColor, backgroundColor: CGColor? = nil) {
			super.init()
			self.foregroundColor(foregroundColor)
				.backgroundColor(backgroundColor)
		}

		/// Copy the design
		public func copyDesign() -> Design {
			let c = Design()
			c.shape = self.shape.copyShape()
			c.style = self.style.copyStyle()
			return c
		}
	}
}

// MARK: Some conveniences on the design object

public extension QRCode.Design {
	/// Set the foreground color for the design
	/// - Parameter color: The color to set
	/// - Returns: This design object
	@discardableResult
	@objc func foregroundColor(_ color: CGColor) -> QRCode.Design {
		self.style.data = QRCode.FillStyle.Solid(color)
		return self
	}

	/// Set the background color for the design
	/// - Parameter color: The color to set. If nil, the background color is set to clear
	/// - Returns: This design object
	@discardableResult
	@objc func backgroundColor(_ color: CGColor?) -> QRCode.Design {
		self.style.background = color.unwrapping { QRCode.FillStyle.Solid($0) } ?? QRCode.FillStyle.Solid(.clear)
		return self
	}
}

// MARK: - The style

public extension QRCode {
	/// Represents the style when drawing the qr code
	@objc(QRCodeStyle) class Style: NSObject {

		/// Convenience initializer for objc
		@objc public static func create() -> Style { return Style() }

		/// The background style for the QR code. If nil, no background is drawn
		@objc public var background: QRCodeFillStyleGenerator? = QRCode.FillStyle.Solid(CGColor(gray: 1.0, alpha: 1.0))

		/// The style for the data component for the QR code
		@objc public var data: QRCodeFillStyleGenerator = QRCode.FillStyle.Solid(CGColor(gray: 0.0, alpha: 1.0))
		/// The style for drawing the non-drawn sections for the qr code.
		@objc public var dataInverted: QRCodeFillStyleGenerator?

		/// The border around the eye. By default, this is the same color as the data
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
}

// MARK: - The shape

public extension QRCode {
	/// Represents the shape when generating the qr code
	@objc(QRCodeShape) class Shape: NSObject {

		/// Convenience initializer for objc
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
			c.dataInverted = self.dataInverted?.copyShape()
			c.eye = self.eye.copyShape()
			return c
		}
	}
}

// MARK: - Fill style support

public extension QRCode {
	@objc(QRCodeFillStyle) class FillStyle: NSObject {
		/// Simple convenience for a clear fill
		@objc public static let clear = FillStyle.Solid(.clear)
	}
}

/// A protocol for wrapping fill styles for image generation
@objc public protocol QRCodeFillStyleGenerator {
	func copyStyle() -> QRCodeFillStyleGenerator
	func fill(ctx: CGContext, rect: CGRect)
	func fill(ctx: CGContext, rect: CGRect, path: CGPath)
}
