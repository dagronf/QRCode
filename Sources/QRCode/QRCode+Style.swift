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
	/// QR Code styler
	@objc(QRCodeStyle) class Style: NSObject {
		@objc public var foregroundStyle: QRCodeFillStyleGenerator = QRCode.FillStyle.Solid(CGColor(gray: 0.0, alpha: 1.0))
		@objc public var backgroundStyle: QRCodeFillStyleGenerator = QRCode.FillStyle.Solid(CGColor(gray: 1.0, alpha: 1.0))
		@objc public var shape = QRCode.Shape()

		/// Copy the style
		public func copyStyle() -> Style {
			let c = Style()
			c.shape = self.shape.copyShape()
			c.foregroundStyle = self.foregroundStyle.copyStyle()
			c.backgroundStyle = self.backgroundStyle.copyStyle()
			return c
		}
	}

	/// Represents the shape when generating the qr code
	@objc(QRCodeShape) class Shape: NSObject {
		/// The shape of the pixels.
		///
		/// Defaults to simple square 'pixels'
		@objc public var dataShape: QRCodeDataShapeHandler = QRCode.DataShape.Pixel(pixelType: .square)
		/// The style of eyes to display
		///
		/// Defaults to a simple square eye
		@objc public var eyeShape: QRCodeEyeShapeHandler = QRCode.EyeShape.Square()
		/// Make a copy of the content shape
		public func copyShape() -> Shape {
			let c = Shape()
			c.dataShape = self.dataShape.copyShape()
			c.eyeShape = self.eyeShape.copyShape()
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

// MARK: - Eye shape

public extension QRCode {
	/// The shape of an 'eye' within the qr code
	@objc(QRCodeEyeShape) class EyeShape: NSObject {}
}

/// A protocol for wrapping generating the eye shapes for a path
@objc public protocol QRCodeEyeShapeHandler {
	func copyShape() -> QRCodeEyeShapeHandler
	func eyePath() -> CGPath
	func pupilPath() -> CGPath
}

// MARK: - Data shape

public extension QRCode {
	/// The shape of the data within the qr code.
	@objc(QRCodeDataShape) class DataShape: NSObject {}
}

/// A protocol for wrapping generating the data shape for a path
@objc public protocol QRCodeDataShapeHandler {
	func copyShape() -> QRCodeDataShapeHandler
	func onPath(size: CGSize, data: QRCode) -> CGPath
	func offPath(size: CGSize, data: QRCode) -> CGPath
}
