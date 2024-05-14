//
//  QRCodeShape.swift
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

// SwiftUI Shape implementation

import SwiftUI

/// A QRCode SwiftUI `Shape` object for generating a shape path from component(s) of the QR Code.
@available(macOS 11, iOS 13.0, tvOS 13.0, *)
public struct QRCodeShape: Shape {
	/// Create a QRCode shape using the specified data
	/// - Parameters:
	///   - data: The data to contain within the QR Code
	///   - errorCorrection: The error correction level
	///   - components: The components of the QR Code to include within the Shape path
	///   - shape: The shape object to describle the style of the generated path
	///   - generator: The generator to use when creating the Shape path
	public init(
		data: Data,
		errorCorrection: QRCode.ErrorCorrection = .low,
		components: QRCode.Components = .all,
		shape: QRCode.Shape = QRCode.Shape(),
		logoTemplate: QRCode.LogoTemplate? = nil,
		engine: (any QRCodeEngine)? = nil
	) {
		do {
			self.content__ = .data(data)
			self.errorCorrection__ = errorCorrection
			self.components__ = components
			self.shape__ = shape
			self.logoTemplate__ = logoTemplate
			if let e = engine {
				self.qrCodeGenerator__.engine = e
			}
			try self.qrCodeGenerator__.update(data: data, errorCorrection: errorCorrection)
		}
		catch {
			Swift.print("QRCodeShape: Error creating shape. Error was '\(error)'")
		}
	}

	/// Create a QRCode shape using the specified text
	/// - Parameters:
	///   - text: The text content to contain within the QR Code
	///   - errorCorrection: The error correction level
	///   - components: The components of the QR Code to include within the Shape path
	///   - shape: The shape object to describle the style of the generated path
	///   - generator: The generator to use when creating the Shape path
	///
	/// Throws an error if the text cannot be converted to the specified string encoding
	public init(
		text: String,
		errorCorrection: QRCode.ErrorCorrection = .low,
		components: QRCode.Components = .all,
		shape: QRCode.Shape = QRCode.Shape(),
		logoTemplate: QRCode.LogoTemplate? = nil,
		engine: (any QRCodeEngine)? = nil
	) throws {
		do {
			self.content__ = .text(text)
			self.errorCorrection__ = errorCorrection
			self.components__ = components
			self.shape__ = shape
			self.logoTemplate__ = logoTemplate
			if let e = engine {
				self.qrCodeGenerator__.engine = e
			}
			try self.qrCodeGenerator__.update(content: self.content__, errorCorrection: errorCorrection)
		}
		catch {
			Swift.print("QRCodeShape: Error creating shape. Error was '\(error)'")
		}
	}

	/// Create a QRCode shape using the specified message formatter
	/// - Parameters:
	///   - message: The message formatter for generating the content to be contained within the QR Code
	///   - errorCorrection: The error correction level
	///   - components: The components of the QR Code to include within the Shape path
	///   - shape: The shape object to describle the style of the generated path
	///   - logoTemplate: The logo to apply to the QR code
	///   - engine: The engine to use when creating the Shape path
	public init(
		message: any QRCodeMessageFormatter,
		errorCorrection: QRCode.ErrorCorrection = .low,
		components: QRCode.Components = .all,
		shape: QRCode.Shape = QRCode.Shape(),
		logoTemplate: QRCode.LogoTemplate? = nil,
		engine: (any QRCodeEngine)? = nil
	) {
		self.init(
			data: message.data,
			errorCorrection: errorCorrection,
			components: components,
			shape: shape,
			logoTemplate: logoTemplate,
			engine: engine
		)
	}

	/// Create a QRCode shape using the specified data
	/// - Parameters:
	///   - content: The content
	///   - errorCorrection: The error correction level
	///   - components: The components of the QR Code to include within the Shape path
	///   - shape: The shape object to describle the style of the generated path
	///   - generator: The generator to use when creating the Shape path
	internal init(
		content: QRCode.Content,
		errorCorrection: QRCode.ErrorCorrection = .low,
		components: QRCode.Components = .all,
		shape: QRCode.Shape = QRCode.Shape(),
		logoTemplate: QRCode.LogoTemplate? = nil,
		engine: (any QRCodeEngine)? = nil
	) {
		do {
			self.content__ = content
			self.errorCorrection__ = errorCorrection
			self.components__ = components
			self.shape__ = shape
			self.logoTemplate__ = logoTemplate
			if let e = engine {
				self.qrCodeGenerator__.engine = e
			}
			try self.qrCodeGenerator__.update(content: self.content__, errorCorrection: errorCorrection)
		}
		catch {
			Swift.print("QRCodeShape: Error creating shape. Error was '\(error)'")
		}
	}

	// Private
	private let content__: QRCode.Content
	private let shape__: QRCode.Shape
	private let components__: QRCode.Components
	private let errorCorrection__: QRCode.ErrorCorrection
	private let logoTemplate__: QRCode.LogoTemplate?
	private let qrCodeGenerator__ = QRCode()
}

// MARK: - Modifiers

@available(macOS 11, iOS 13.0, tvOS 13.0, *)
public extension QRCodeShape {
	/// Returns a copy of the qrcode using the specified error correction level
	func errorCorrection(_ errorCorrection: QRCode.ErrorCorrection) -> QRCodeShape {
		return QRCodeShape(
			content: self.content__,
			errorCorrection: errorCorrection,
			components: self.components__,
			shape: self.shape__.copyShape(),
			logoTemplate: self.logoTemplate__?.copyLogoTemplate(),
			engine: self.qrCodeGenerator__.engine
		)
	}

	/// Returns a copy of the qrcode using only the specified components being generated.
	func components(_ components: QRCode.Components) -> QRCodeShape {
		return QRCodeShape(
			content: self.content__,
			errorCorrection: self.errorCorrection__,
			components: components,
			shape: self.shape__.copyShape(),
			logoTemplate: self.logoTemplate__?.copyLogoTemplate(),
			engine: self.qrCodeGenerator__.engine
		)
	}

	/// Returns a copy of the qrcode Shape using the specified QRCode shape object
	func shape(_ shape: QRCode.Shape) -> QRCodeShape {
		return QRCodeShape(
			content: self.content__,
			errorCorrection: self.errorCorrection__,
			components: self.components__,
			shape: shape.copyShape(),
			logoTemplate: self.logoTemplate__?.copyLogoTemplate(),
			engine: self.qrCodeGenerator__.engine
		)
	}

	/// Change the 'on' pixel shape
	func onPixelShape(_ pixelShape: any QRCodePixelShapeGenerator) -> QRCodeShape {
		let shape = self.shape__.copyShape()
		shape.onPixels = pixelShape
		return QRCodeShape(
			content: self.content__,
			errorCorrection: self.errorCorrection__,
			components: self.components__,
			shape: shape,
			logoTemplate: self.logoTemplate__?.copyLogoTemplate(),
			engine: self.qrCodeGenerator__.engine
		)
	}

	/// Change the 'off' pixel shape
	func offPixelShape(_ pixelShape: any QRCodePixelShapeGenerator) -> QRCodeShape {
		let shape = self.shape__.copyShape()
		shape.offPixels = pixelShape
		return QRCodeShape(
			content: self.content__,
			errorCorrection: self.errorCorrection__,
			components: self.components__,
			shape: shape,
			logoTemplate: self.logoTemplate__?.copyLogoTemplate(),
			engine: self.qrCodeGenerator__.engine
		)
	}

	/// Change the eye shape to another shape
	func eyeShape(_ eyeShape: any QRCodeEyeShapeGenerator) -> QRCodeShape {
		let shape = self.shape__.copyShape()
		shape.eye = eyeShape
		return QRCodeShape(
			content: self.content__,
			errorCorrection: self.errorCorrection__,
			components: self.components__,
			shape: shape,
			logoTemplate: self.logoTemplate__?.copyLogoTemplate(),
			engine: self.qrCodeGenerator__.engine
		)
	}

	/// Change the shape of the pupil in the shape
	func pupilShape(_ pupilShape: any QRCodePupilShapeGenerator) -> QRCodeShape {
		let shape = self.shape__.copyShape()
		shape.pupil = pupilShape
		return QRCodeShape(
			content: self.content__,
			errorCorrection: self.errorCorrection__,
			components: self.components__,
			shape: shape,
			logoTemplate: self.logoTemplate__?.copyLogoTemplate(),
			engine: self.qrCodeGenerator__.engine
		)
	}

	/// Set the logo template for the shape
	func logoTemplate(_ logoTemplate: QRCode.LogoTemplate) -> QRCodeShape {
		return QRCodeShape(
			content: self.content__,
			errorCorrection: self.errorCorrection__,
			components: self.components__,
			shape: self.shape__.copyShape(),
			logoTemplate: logoTemplate,
			engine: self.qrCodeGenerator__.engine
		)
	}
}

// MARK: - Deprecated

@available(macOS 11, iOS 13.0, tvOS 13.0, *)
public extension QRCodeShape {
	/// Deprecated. Use `pixelShape` instead.
	@available(*, deprecated, renamed: "onPixelShape")
	func dataShape(_ dataShape: any QRCodePixelShapeGenerator) -> QRCodeShape {
		self.pixelShape(dataShape)
	}

	/// Change the 'on' pixel shape
	@available(*, deprecated, renamed: "onPixelShape")
	@inlinable func pixelShape(_ pixelShape: any QRCodePixelShapeGenerator) -> QRCodeShape {
		self.onPixelShape(pixelShape)
	}

	/// Returns a copy of the qrcode using the specified shape (both eye and data)
	@available(*, deprecated, renamed: "shape")
	@inlinable func contentShape(_ shape: QRCode.Shape) -> QRCodeShape {
		self.shape(shape)
	}
}

// MARK: - Paths

@available(macOS 11, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension QRCodeShape {
	/// Returns the path for the qr code
	func path(in rect: CGRect) -> Path {
		let path = self.qrCodeGenerator__.path(rect.size, components: self.components__, shape: self.shape__, logoTemplate: self.logoTemplate__)
		return Path(path)
	}
}

// MARK: - Previews

#if DEBUG

fileprivate let DemoContent = "https://goo.gl/maps/Z4d9uVV87gVifrZKA".data(using: .utf8)!
fileprivate let DemoContent2 = "Harness the power of Quartz technology to perform lightweight 2D rendering with high-fidelity output. Handle path-based drawing, antialiased rendering, gradients, images, color management, PDF documents, and more.".data(using: .utf8)!
fileprivate let textData = "Hello there how are you".data(using: .utf8)!

//
// Unfortunately, there is no point in creating more previews as XCode simply refuses to display them
//

@available(macOS 11, iOS 14, tvOS 14, watchOS 6.0, *)
#Preview("QRCodeShape") {
	VStack {
		Text("QRCode").font(.headline).bold()
		HStack {
			QRCodeShape(data: DemoContent, errorCorrection: .low)
				.components(.all)
				.onPixelShape(try! QRCodePixelShapeFactory.shared.named("circle"))
			QRCodeShape(data: DemoContent2, errorCorrection: .medium)
		}

		VStack {
			Divider()
			Text("Components").font(.headline).bold()
			HStack {
				VStack {
					ZStack {
						QRCodeShape(data: textData, errorCorrection: .high)
							.eyeShape(QRCode.EyeShape.RoundedOuter())
							.components(.eyeBackground)
							.fill(Color(hue: 0.0, saturation: 1, brightness: 0))
						QRCodeShape(data: textData, errorCorrection: .high)
							.eyeShape(QRCode.EyeShape.RoundedOuter())
							.components(.eyePupil)
							.fill(Color(hue: 0.2, saturation: 1, brightness: 1))
						QRCodeShape(data: textData, errorCorrection: .high)
							.eyeShape(QRCode.EyeShape.RoundedOuter())
							.components(.eyeOuter)
							.fill(Color(hue: 0.4, saturation: 1, brightness: 1))
						QRCodeShape(data: textData, errorCorrection: .high)
							.components(.onPixels)
							.fill(Color(hue: 0.6, saturation: 1, brightness: 1))
						QRCodeShape(data: textData, errorCorrection: .high)
							.components(.offPixels)
							.fill(Color(hue: 0.8, saturation: 1, brightness: 1))
					}
					Text("components")
				}
				VStack {
					QRCodeShape(data: textData, errorCorrection: .high)
						.components(.onPixels)
						.fill(Color(hue: 0.6, saturation: 1, brightness: 1))
					Text("'on' pixels only")
				}
				VStack {
					QRCodeShape(data: textData, errorCorrection: .high)
						.components(.offPixels)
						.fill(Color(hue: 0.8, saturation: 1, brightness: 1))
					Text("'off' pixels only")
				}
			}
			HStack {
				VStack {
					QRCodeShape(data: textData, errorCorrection: .high)
						.eyeShape(QRCode.EyeShape.RoundedOuter())
						.components(.eyeOuter)
						.fill(Color(hue: 0.4, saturation: 1, brightness: 1))
					Text("eye outer only")
				}
				VStack {
					QRCodeShape(data: textData, errorCorrection: .high)
						.eyeShape(QRCode.EyeShape.RoundedOuter())
						.components(.eyePupil)
						.fill(Color(hue: 0.2, saturation: 1, brightness: 1))
					Text("pupil only")
				}
				VStack {
					QRCodeShape(data: textData, errorCorrection: .high)
						.eyeShape(QRCode.EyeShape.RoundedOuter())
						.components(.eyeBackground)
						.fill(Color(hue: 0.0, saturation: 1, brightness: 0))
					Text("eye components")
				}
			}
		}

		VStack {

			let logoTemplate1: QRCode.LogoTemplate = {
				QRCode.LogoTemplate(
					image: try! CGColor(gray: 0.5, alpha: 1).swatch(),
					path: CGPath(ellipseIn: CGRect(x: 0.30, y: 0.30, width: 0.40, height: 0.40), transform: nil),
					inset: 0
				)
			}()

			let logoTemplate2: QRCode.LogoTemplate = {
				QRCode.LogoTemplate(
					image: try! CGColor(gray: 0.2, alpha: 1).swatch(),
					path: CGPath(rect: CGRect(x: 0.40, y: 0.60, width: 0.55, height: 0.30), transform: nil),
					inset: 0
				)
			}()

			Divider()
			Text("Masking").font(.headline).bold()
			HStack {
				ZStack {
					QRCodeShape(data: textData, errorCorrection: .high)
						.logoTemplate(logoTemplate1)
						.components([.onPixels, .eyeAll])
						.onPixelShape(QRCode.PixelShape.CurvePixel())
						.frame(width: 200, height: 200)
					Circle()
						.fill(.green)
						.frame(width: 60, height: 60)
				}
				ZStack {
					QRCodeShape(data: textData, errorCorrection: .high)
						.logoTemplate(logoTemplate2)
						.components([.onPixels, .eyeAll])
						.onPixelShape(QRCode.PixelShape.Vertical(insetFraction: 0.1, cornerRadiusFraction: 1))
						.eyeShape(QRCode.EyeShape.Squircle())
						.frame(width: 200, height: 200)
					Rectangle()
						.fill(.red)
						.position(x: 82, y: 77)
						.frame(width: 100, height: 50)
				}
			}
		}
	}
	.frame(height: 800)
}

#endif
