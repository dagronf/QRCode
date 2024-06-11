//
//  QRCode+Builder.swift
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

//  A simple builder for QR codes

/// ```swift
/// let code = try QRCode.build
/// 	.text("https://www.worldwildlife.org/about")
/// 	.background.style(CGColor(srgbRed: 1, green: 1, blue: 0.6, alpha: 1))
/// 	.background.cornerRadius(2)
/// 	.onPixels.shape(QRCode.PixelShape.CurvePixel())
/// 	.offPixels.shape(QRCode.PixelShape.Flower())
/// ```

import CoreGraphics
import Foundation

import SwiftImageReadWrite

#if os(macOS)
import AppKit.NSBezierPath
#else
import UIKit.UIBezierPath
#endif

public extension QRCode {
	/// Create a builder
	static var build: Builder { Builder() }

	/// A QRCode builder
	class Builder {
		/// Errors that can be thrown by the builder
		public enum BuilderError: Error {
			/// Cannot create
			case cannotCreate
			/// The provided text could not be encoded using the specified string encoding
			case unableToEncodeText
		}

		/// Create a builder
		public init() { }

		/// The generated document
		public let document = QRCode.Document()
	}
}

// MARK: - Setting content

public extension QRCode.Builder {
	/// Set a custom generator for the builder
	/// - Parameter engine: The QR code generator
	/// - Returns: self
	@discardableResult func engine(_ engine: any QRCodeEngine) -> QRCode.Builder {
		self.document.engine = engine
		return self
	}

	/// Set the text to encode
	/// - Parameters:
	///   - text: The text
	/// - Returns: self
	@discardableResult func text(_ text: String) throws -> QRCode.Builder {
		try self.content.text(text)
	}

	/// Set data using base64 encoding
	/// - Parameter data: The data
	/// - Returns: self
	@discardableResult func base64(_ data: Data) throws -> QRCode.Builder {
		try self.content.text(data.base64EncodedString())
	}

	/// Set the URL to encode
	/// - Parameters:
	///   - url: The url
	///   - encoding: The string encoding to use when generating the qr code
	/// - Returns: self
	@discardableResult func url(_ url: URL) throws -> QRCode.Builder {
		try self.content.url(url)
	}

	/// Set the formatted content
	/// - Parameter content: The formatted content
	/// - Returns: self
	@discardableResult func content(_ formattedContent: QRCode.Document.FormattedContent) throws -> QRCode.Builder {
		try self.document.setFormattedContent(formattedContent)
		return self
	}

	/// The content settings for the QR Code
	var content: Content { Content(builder: self) }

	/// Content settings for the QR code
	struct Content {
		/// Set the data for the qr code
		/// - Parameter data: The data
		/// - Returns: self
		@discardableResult public func data(_ data: Data) -> QRCode.Builder {
			self.builder.document.data = data
			return self.builder
		}

		/// Set text content
		/// - Parameters:
		///   - text: The text
		/// - Returns: self
		@discardableResult func text(_ text: String) throws -> QRCode.Builder {
			self.builder.document.utf8String = text
			return self.builder
		}

		/// Set the URL to be encoded within the QR code
		/// - Parameters:
		///   - url: The url
		/// - Returns: self
		@discardableResult func url(_ url: URL) throws -> QRCode.Builder {
			try self.text(url.absoluteString)
		}

		/// Set the message for the qr code
		/// - Parameter message: The message
		/// - Returns: self
		@discardableResult public func message(
			_ message: any QRCodeMessageFormatter
		) throws -> QRCode.Builder {
			try self.builder.document.update(message: message)
			return self.builder
		}

		// Private
		fileprivate let builder: QRCode.Builder
		fileprivate init(builder: QRCode.Builder) { self.builder = builder }
	}
}

public extension QRCode.Builder {
	/// Set the error correction
	/// - Parameter errorCorrection: The error correction
	/// - Returns: self
	@discardableResult func errorCorrection(
		_ errorCorrection: QRCode.ErrorCorrection
	) -> Self {
		self.document.errorCorrection = errorCorrection
		return self
	}

	/// The number of quiet zone pixels to apply to the qr code
	/// - Parameter count: The count of pixels to use as a quiet zone
	/// - Returns: self
	@discardableResult func quietZonePixelCount(_ count: UInt) -> Self {
		self.document.design.additionalQuietZonePixels = count
		return self
	}

	/// If set, the QR code draws the cells that AREN'T set within the QR code using the
	/// `onPixel` generator and style. All other styles (offPixels, eye, pupil) are ignored.
	@discardableResult func isNegated(_ isNegated: Bool) -> Self {
		self.document.design.shape.negatedOnPixelsOnly = isNegated
		return self
	}
}

// MARK: - Foreground

public extension QRCode.Builder {
	/// Set the foreground color for the qr code
	/// - Parameter color: The color
	/// - Returns: self
	@discardableResult func foregroundColor(_ color: CGColor) -> Self {
		self.document.design.foregroundColor(color)
		return self
	}

	/// The QR code's foreground settings
	var foreground: Foreground { Foreground(builder: self) }

	/// Available settings for the QR code's foreground
	struct Foreground {
		/// Set the foreground image for the qr code
		/// - Parameter color: The color
		/// - Returns: self
		@discardableResult func style(_ color: CGColor) -> QRCode.Builder {
			self.builder.document.design.style.setForegroundStyle(QRCode.FillStyle.Solid(color))
			return self.builder
		}

		/// Set the foreground image for the qr code
		/// - Parameter color: The color
		/// - Returns: self
		@discardableResult func style(_ image: CGImage) -> QRCode.Builder {
			self.builder.document.design.style.setForegroundStyle(QRCode.FillStyle.Image(image))
			return self.builder
		}

		/// Set a linear gradient as a background fill
		/// - Parameter gradient: The gradient
		/// - Returns: self
		@discardableResult func style(
			_ gradient: any QRCodeFillStyleGenerator
		) -> QRCode.Builder {
			self.builder.document.design.style.setForegroundStyle(gradient)
			return self.builder
		}

		// Private
		fileprivate let builder: QRCode.Builder
		fileprivate init(builder: QRCode.Builder) { self.builder = builder }
	}
}

// MARK: - Background

public extension QRCode.Builder {
	/// Set the background color for the qr code
	/// - Parameter color: The color
	/// - Returns: self
	@discardableResult func backgroundColor(_ color: CGColor) -> Self {
		self.document.design.backgroundColor(color)
		return self
	}

	/// The QR code's background settings
	var background: Background { Background(builder: self) }

	/// Available settings for the QR code's background
	struct Background {
		/// Set the background color for the qr code
		/// - Parameter color: The color
		/// - Returns: self
		@discardableResult public func style(_ color: CGColor) -> QRCode.Builder {
			self.builder.document.design.backgroundColor(color)
			return self.builder
		}

		/// Set a background image for the qr code
		/// - Parameter image: the image
		/// - Returns: self
		@discardableResult public func style(_ image: CGImage) -> QRCode.Builder {
			self.builder.document.design.style.background = QRCode.FillStyle.Image(image)
			return self.builder
		}

		/// Set a fill style as a background fill
		/// - Parameter gradient: The gradient
		/// - Returns: self
		@discardableResult public func style(
			_ fillStyle: any QRCodeFillStyleGenerator
		) -> QRCode.Builder {
			self.builder.document.design.style.background = fillStyle
			return self.builder
		}

		/// A corner radius (in qr pixels) to apply to the background fill
		/// - Parameter pixelCount: The number of pixels to set for the radius
		/// - Returns: self
		@discardableResult public func cornerRadius(
			_ pixelCount: Double
		) -> QRCode.Builder {
			self.builder.document.design.style.backgroundFractionalCornerRadius = pixelCount
			return self.builder
		}

		// Private
		fileprivate let builder: QRCode.Builder
		fileprivate init(builder: QRCode.Builder) { self.builder = builder }
	}
}

// MARK: - On Pixels

public extension QRCode.Builder {
	/// The on-pixels for the QR code
	var onPixels: OnPixels { OnPixels(builder: self) }

	/// Available settings for the QR code's 'on' pixels
	struct OnPixels {
		/// The shape to apply to the on pixels
		/// - Parameter shape: The pixel shape
		/// - Returns: self
		@discardableResult public func shape(
			_ shape: any QRCodePixelShapeGenerator
		) -> QRCode.Builder {
			self.builder.document.design.shape.onPixels = shape
			return self.builder
		}

		/// The flat color to use for the on pixels
		/// - Parameter color: The color
		/// - Returns: self
		@discardableResult public func style(
			_ color: CGColor
		) -> QRCode.Builder {
			self.builder.document.design.style.onPixels = QRCode.FillStyle.Solid(color)
			return self.builder
		}

		/// The style to apply to the on pixels
		/// - Parameter style: The style
		/// - Returns: self
		@discardableResult public func style(
			_ style: any QRCodeFillStyleGenerator
		) -> QRCode.Builder {
			self.builder.document.design.style.onPixels = style
			return self.builder
		}

		/// Set the color behind the on-pixels
		/// - Parameter color: The color
		/// - Returns: self
		@discardableResult public func backgroundColor(
			_ color: CGColor?
		) -> QRCode.Builder {
			self.builder.document.design.style.onPixelsBackground = color
			return self.builder
		}

		// Private
		fileprivate let builder: QRCode.Builder
		fileprivate init(builder: QRCode.Builder) { self.builder = builder }
	}
}

// MARK: - Eye

public extension QRCode.Builder {
	/// The eye for the QR code
	var eye: Eye { Eye(builder: self) }

	/// Available settings for the QR code's eye
	struct Eye {
		/// The shape to use for the eye
		/// - Parameter shape: The eye shape
		/// - Returns: self
		@discardableResult public func shape(
			_ shape: any QRCodeEyeShapeGenerator
		) -> QRCode.Builder {
			self.builder.document.design.shape.eye = shape
			return self.builder
		}

		/// The color to use when drawing the eye
		/// - Parameter color: The color
		/// - Returns: self
		@discardableResult public func style(
			_ color: CGColor
		) -> QRCode.Builder {
			self.builder.document.design.style.eye = QRCode.FillStyle.Solid(color)
			return self.builder
		}

		/// The style to apply to the eye
		/// - Parameter style: The style
		/// - Returns: self
		@discardableResult public func style(
			_ style: any QRCodeFillStyleGenerator
		) -> QRCode.Builder {
			self.builder.document.design.style.eye = style
			return self.builder
		}

		/// The color to draw behind the eye shape
		/// - Parameter color: The color to draw
		/// - Returns: self
		@discardableResult public func backgroundColor(
			_ color: CGColor?
		) -> QRCode.Builder {
			self.builder.document.design.style.eyeBackground = color
			return self.builder
		}

		// Private
		fileprivate let builder: QRCode.Builder
		fileprivate init(builder: QRCode.Builder) { self.builder = builder }
	}
}

// MARK: - Pupil

public extension QRCode.Builder {
	/// The pupil for the QR code
	var pupil: Pupil { Pupil(builder: self) }

	/// Available settings for the QR code's pupil
	struct Pupil {
		/// The shape to use for the pupil
		/// - Parameter shape: The pupil shape
		/// - Returns: self
		@discardableResult public func shape(
			_ shape: any QRCodePupilShapeGenerator
		) -> QRCode.Builder {
			self.builder.document.design.shape.pupil = shape
			return self.builder
		}

		/// The color to use when drawing the pupil
		/// - Parameter color: The color
		/// - Returns: self
		@discardableResult public func style(_ color: CGColor) -> QRCode.Builder {
			self.builder.document.design.style.pupil = QRCode.FillStyle.Solid(color)
			return self.builder
		}

		/// The style to use when drawing the pupil
		/// - Parameter style: The style
		/// - Returns: self
		@discardableResult public func style(
			_ style: any QRCodeFillStyleGenerator
		) -> QRCode.Builder {
			self.builder.document.design.style.pupil = style
			return self.builder
		}

		// Private
		fileprivate let builder: QRCode.Builder
		fileprivate init(builder: QRCode.Builder) { self.builder = builder }
	}
}

// MARK: - Off pixels

public extension QRCode.Builder {
	/// The off-pixels for the QR code
	var offPixels: OffPixels { OffPixels(builder: self) }

	/// Available settings for the QR code's 'off' pixels
	struct OffPixels {
		/// The shape to use for off-pixels
		/// - Parameter shape: The shape
		/// - Returns: self
		@discardableResult public func shape(
			_ shape: any QRCodePixelShapeGenerator
		) -> QRCode.Builder {
			self.builder.document.design.shape.offPixels = shape
			return self.builder
		}

		/// The style to apply to off pixels
		/// - Parameter color: The flat color to apply to off pixels
		/// - Returns: self
		@discardableResult public func style(_ color: CGColor) -> QRCode.Builder {
			self.builder.document.design.style.offPixels = QRCode.FillStyle.Solid(color)
			return self.builder
		}

		/// The style to apply to off pixels
		/// - Parameter style: The style
		/// - Returns: self
		@discardableResult public func style(
			_ style: any QRCodeFillStyleGenerator
		) -> QRCode.Builder {
			self.builder.document.design.style.offPixels = style
			return self.builder
		}

		/// Set the color behind the off-pixels
		/// - Parameter color: The color to draw behind the off-pixels
		/// - Returns: self
		@discardableResult public func backgroundColor(
			_ color: CGColor?
		) -> QRCode.Builder {
			self.builder.document.design.style.offPixelsBackground = color
			return self.builder
		}

		// Private
		fileprivate let builder: QRCode.Builder
		fileprivate init(builder: QRCode.Builder) { self.builder = builder }
	}
}

// MARK: - Logo

public extension QRCode.Builder {
	/// Basic positioning for the logo
	enum LogoPosition {
		case circleCenter(inset: Double = 0)
		case circleBottomRight(inset: Double = 0)
		case squareCenter(inset: Double = 0)
		case squareBottomRight(inset: Double = 0)
	}

	/// The logo to use
	/// - Parameter logotemplate: The logo template
	/// - Returns: self
	@discardableResult func logo(
		_ logotemplate: QRCode.LogoTemplate
	) -> QRCode.Builder {
		self.document.logoTemplate = logotemplate
		return self
	}

	/// Apply a image using a logo and a position
	/// - Parameters:
	///   - image: The image
	///   - position: The position to apply the image
	/// - Returns: self
	@discardableResult func logo(
		_ image: CGImage,
		position: LogoPosition
	) -> QRCode.Builder {
		switch position {
		case let .circleCenter(inset: inset):
			self.logo(QRCode.LogoTemplate.CircleCenter(image: image, inset: inset))
		case let .circleBottomRight(inset: inset):
			self.logo(QRCode.LogoTemplate.CircleBottomRight(image: image, inset: inset))
		case let .squareCenter(inset: inset):
			self.logo(QRCode.LogoTemplate.SquareCenter(image: image, inset: inset))
		case let .squareBottomRight(inset: inset):
			self.logo(QRCode.LogoTemplate.SquareBottomRight(image: image, inset: inset))
		}
		return self
	}

	/// Apply a image
	/// - Parameters:
	///   - image: The logo image
	///   - maskImage: (optional) The mask to apply for the image.
	/// - Returns: self
	@discardableResult func logo(
		image: CGImage,
		maskImage: CGImage? = nil
	) -> QRCode.Builder {
		self.logo(QRCode.LogoTemplate(image: image, maskImage: maskImage))
	}

	/// Apply an image within a Unit rectangle
	/// - Parameters:
	///   - image: The logo image
	///   - unitRect: The destination unit rectangle to position within the qr code
	///   - inset: The inset to the destination
	/// - Returns: self
	@discardableResult func logo(
		image: CGImage,
		unitRect: CGRect,
		inset: Double = 0
	) -> QRCode.Builder {
		self.logo(
			QRCode.LogoTemplate(
				image: image,
				path: CGPath(rect: unitRect, transform: nil),
				inset: inset
			)
		)
	}
}

// MARK: - Generator

public extension QRCode.Builder {
	/// The off-pixels for the QR code
	var generate: Generate { Generate(builder: self) }
	struct Generate {
		// Private
		fileprivate let builder: QRCode.Builder
		fileprivate init(builder: QRCode.Builder) { self.builder = builder }
	}
}

// MARK: Image

public extension QRCode.Builder.Generate {
	/// Generate an image
	/// - Parameter dimension: The dimension of the resulting image
	/// - Returns: The image
	@discardableResult func image(dimension: Int) throws -> CGImage {
		try builder.document.cgImage(dimension: dimension)
	}

	/// Generate an image with a specifed format
	/// - Parameters:
	///   - dimension: The dimension of the image
	///   - representation: The image representation to use when generating the image data
	/// - Returns: Image data
	@discardableResult func image(
		dimension: Int,
		representation: ImageExportType
	) throws -> Data {
		try self.image(dimension: dimension).imageData(for: representation)
	}

	/// Generate a PDF
	/// - Parameters:
	///   - dimension: The dimension of the resulting pdf
	///   - pdfResolution: The resolution to use when generating the pdf
	/// - Returns: pdf data
	@discardableResult func pdf(
		dimension: Int,
		pdfResolution: CGFloat = 72.0
	) throws -> Data {
		try builder.document.pdfData(dimension: dimension, pdfResolution: pdfResolution)
	}

	/// Generate an SVG representation
	/// - Parameter dimension: The dimension of the resulting svg
	/// - Returns: SVG data
	@discardableResult func svg(dimension: Int) throws -> Data {
		try builder.document.svgData(dimension: dimension)
	}
}

// MARK: Path

public extension QRCode.Builder.Generate {
	/// Generate a CGPath
	/// - Parameter dimension: The dimension of the resulting path
	/// - Returns: A path
	@discardableResult func path(dimension: Int) -> CGPath {
		builder.document.path(dimension: dimension)
	}

	#if os(macOS)
	/// Generate an NSBezierPath
	/// - Parameter dimension: The dimension of the resulting path
	/// - Returns: A path
	@discardableResult func nsBezierPath(dimension: Int) -> NSBezierPath {
		NSBezierPath(cgPath: self.path(dimension: dimension))
	}
	#else
	/// Generate a UIBezierPath
	/// - Parameter dimension: The dimension of the resulting path
	/// - Returns: A path
	@discardableResult func uiBezierPath(dimension: Int) -> UIBezierPath {
		UIBezierPath(cgPath: self.path(dimension: dimension))
	}
	#endif
}

// MARK: ASCII

public extension QRCode.Builder.Generate {
	/// An ascii representation for the QR code
	var asciiRepresentation: String { builder.document.asciiRepresentation }

	/// A compact ascii representation for the QR code
	var smallAsciiRepresentation: String { builder.document.smallAsciiRepresentation }
}
