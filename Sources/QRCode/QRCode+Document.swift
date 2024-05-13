//
//  QRCode+Document.swift
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

#if canImport(SwiftUI)
import SwiftUI
#endif

public extension QRCode {
	/// A QR Code document
	@objc(QRCodeDocument) class Document: NSObject {
		/// The correction level to use when generating the QR code
		@objc public var errorCorrection: QRCode.ErrorCorrection = .quantize {
			didSet {
				self.regenerate()
			}
		}

		/// Binary data to display in the QR code
		@objc public var data: Data? {
			get {
				self.content.data
			}
			set {
				self.content.data = newValue ?? Data()
				self.regenerate()
			}
		}

		/// Text (utf8 encoded) to display in the QR code.
		///
		/// If you need string content using a different encoding, use the `data` property instead
		@objc public var utf8String: String? {
			get {
				self.content.utf8
			}
			set {
				self.content.utf8 = newValue ?? ""
				self.regenerate()
			}
		}

		/// The style to use when drawing the qr code
		@objc public var design = QRCode.Design() {
			didSet { self.regenerate() }
		}

		/// A logo template
		@objc public var logoTemplate: QRCode.LogoTemplate? {
			didSet { self.regenerate() }
		}

		/// The engine used to generate the QR code
		@objc public var generator: (any QRCodeEngine)? {
			get { self.qrcode.generator }
			set {
				self.qrcode.generator = newValue ?? QRCode.DefaultEngine()
				self.regenerate()
			}
		}

		/// Create a QR code
		@objc override public init() {
			self.content = Content()
			self.errorCorrection = .default
			self.qrcode = QRCode(Data(), errorCorrection: self.errorCorrection, generator: nil)
			super.init()
		}

		/// Create a QRCode document with default settings
		@objc public init(generator: (any QRCodeEngine)?) {
			self.content = Content()
			self.errorCorrection = .default
			self.qrcode = QRCode(Data(), errorCorrection: self.errorCorrection, generator: generator)
			super.init()
		}

		/// Create a QRCode document
		/// - Parameters:
		///   - data: The data to encode
		///   - errorCorrection: The error correction level
		///   - generator: The generator to use when creating the QR code. Defaults to Core Image
		@objc public init(
			data: Data,
			errorCorrection: QRCode.ErrorCorrection = .default,
			generator: (any QRCodeEngine)? = nil
		) {
			self.content = Content(data)
			self.errorCorrection = errorCorrection
			self.qrcode = QRCode(
				data,
				errorCorrection: errorCorrection,
				generator: generator
			)
			super.init()
		}

		/// Create a QRCode document containing `text`
		/// - Parameters:
		///   - utf8String: The utf8 string to encode
		///   - errorCorrection: The error correction level
		///   - generator: The generator to use when creating the QR code. Defaults to Core Image
		@objc public init(
			utf8String: String,
			errorCorrection: QRCode.ErrorCorrection = .default,
			generator: (any QRCodeEngine)? = nil
		) {
			self.content = Content(utf8String)
			self.errorCorrection = errorCorrection
			self.qrcode = QRCode(
				utf8String: utf8String,
				errorCorrection: errorCorrection,
				generator: generator
			)
			super.init()
		}

		/// Create a QRCode document containing the contents of a message formatter
		/// - Parameters:
		///   - message: The message formatter
		///   - errorCorrection: The error correction level
		///   - generator: The generator to use when creating the QR code. Defaults to Core Image
		@objc public init(
			message: any QRCodeMessageFormatter,
			errorCorrection: QRCode.ErrorCorrection = .default,
			generator: (any QRCodeEngine)? = nil
		) {
			self.content = Content(message.data)
			self.errorCorrection = errorCorrection
			self.qrcode = QRCode(
				message.data,
				errorCorrection: errorCorrection,
				generator: generator
			)
			super.init()
		}

		/// The qrcode content.
		internal let qrcode: QRCode

		/// The content to display
		internal let content: Content
	}
}

// MARK: - Swift-only convenience initializers

public extension QRCode.Document {
	/// Create a QRCode document
	/// - Parameters:
	///   - data: The data to encode
	///   - errorCorrection: The error correction level
	///   - generator: The generator to use when creating the QR code
	@inlinable convenience init(
		_ data: Data,
		errorCorrection: QRCode.ErrorCorrection = .default,
		generator: (any QRCodeEngine)? = nil
	) {
		self.init(data: data, errorCorrection: errorCorrection, generator: generator)
	}

	/// Create a QRCode document
	/// - Parameters:
	///   - text: The text to encode
	///   - textEncoding: The text encoding to use (eg. .utf8)
	///   - errorCorrection: The error correction level
	///   - generator: The generator to use when creating the QR code
	convenience init(
		_ text: String,
		textEncoding: String.Encoding = .utf8,
		errorCorrection: QRCode.ErrorCorrection = .default,
		generator: (any QRCodeEngine)? = nil
	) throws {
		guard let data = text.data(using: textEncoding) else {
			throw QRCodeError.unableToConvertTextToRequestedEncoding
		}

		self.init(
			data: data,
			errorCorrection: errorCorrection,
			generator: generator
		)
	}

	/// Create a QRCode document containing a url
	/// - Parameters:
	///   - url: The url to encode
	///   - textEncoding: The text encoding to use for the URL
	///   - errorCorrection: The error correction level
	///   - generator: The generator to use when creating the QR code
	@inlinable convenience init(
		_ url: URL,
		textEncoding: String.Encoding = .utf8,
		errorCorrection: QRCode.ErrorCorrection = .default,
		generator: (any QRCodeEngine)? = nil
	) throws {
		try self.init(
			url.absoluteString,
			textEncoding: textEncoding,
			errorCorrection: errorCorrection,
			generator: generator
		)
	}

	/// Create a QRCode document containing a url
	/// - Parameters:
	///   - message: The formatted message to encode
	///   - errorCorrection: The error correction level
	///   - generator: The generator to use when creating the QR code
	/// - Returns: nil if the url could not be encoded in utf8
	@inlinable convenience init?(
		_ message: any QRCodeMessageFormatter,
		errorCorrection: QRCode.ErrorCorrection = .default,
		generator: (any QRCodeEngine)? = nil
	) {
		self.init(
			message: message,
			errorCorrection: errorCorrection,
			generator: generator
		)
	}
}

// MARK: - Cell information

public extension QRCode.Document {
	/// This is the number of cells along any edge of the qr code
	@objc var cellDimension: Int { self.qrcode.cellDimension }

	/// The dimension for an individual cell for the given image dimension
	@objc func cellSize(forImageDimension dimension: Int) -> CGFloat {
		self.qrcode.cellSize(forImageDimension: dimension)
	}
}

public extension QRCode.Document {
	/// Set the text to encode in the document
	/// - Parameters:
	///   - text: The text
	///   - textEncoding: The text encoding to use
	/// - Returns: True if the text was successfully set, false otherwise
	func setText(_ text: String, textEncoding: String.Encoding = .utf8) throws {
		guard let data = text.data(using: textEncoding) else {
			throw QRCodeError.unableToConvertTextToRequestedEncoding
		}
		self.data = data
	}

	/// Set the content of the QR code to the specified URL
	/// - Parameters:
	///   - url: The url to encode
	///   - textEncoding: The string encoding to use
	func setURL(_ url: URL, textEncoding: String.Encoding = .utf8) throws {
		try self.setText(url.absoluteString, textEncoding: textEncoding)
	}

	/// Set the QR code data using a message formatter
	@objc func setMessage(_ message: any QRCodeMessageFormatter) {
		self.data = message.data
	}

	/// Make a copy of the document
	@objc func copyDocument() -> QRCode.Document {
		let c = QRCode.Document()
		c.data = self.data
		c.utf8String = self.utf8String
		c.design = self.design.copyDesign()
		c.logoTemplate = self.logoTemplate?.copyLogoTemplate()
		c.errorCorrection = self.errorCorrection
		return c
	}
}

// MARK: - Load

public extension QRCode.Document {
	/// Create a QRCode document using the QRCode settings defined in `jsonData`
	/// - Parameters:
	///   - jsonData: The data to display (json format)
	///   - generator: The generator to use when creating the QR code. Defaults to Core Image
	@objc convenience init(jsonData: Data, generator: (any QRCodeEngine)? = nil) throws {
		self.init(generator: generator)
		try self.load(jsonData: jsonData)
	}

	/// Create a QRCode document using the QRCode settings defined in `dictionary`
	/// - Parameters:
	///   - settings: The dictionary of settings to apply to the document
	///   - generator: The qr code generator to use, or `nil` to use default
	@objc convenience init(settings: [String: Any], generator: (any QRCodeEngine)? = nil) throws {
		self.init(generator: generator)
		try self.load(settings: settings)
	}

	/// Load the QRCode content from the specified JSON data
	@objc func load(jsonData: Data) throws {
		let s = try JSONSerialization.jsonObject(with: jsonData, options: [])
		guard let settings = s as? [String: Any] else {
			throw NSError(domain: "QRCodeDocument", code: -1, userInfo: [
				NSLocalizedDescriptionKey: "Unable to decode object",
			])
		}
		try self.load(settings: settings)
	}

	/// Load the QRCode content from the specified dictionary
	@objc func load(settings: [String: Any]) throws {
		if let value = settings["data"] as? String,
			let data = Data(base64Encoded: value)
		{
			self.data = data
		}
		else if let text = settings["text"] as? String {
			self.utf8String = text
		}
		else {
			self.data = Data()
		}

		let ec: QRCode.ErrorCorrection = {
			if let value = settings["correction"] as? String,
				let first = value.first,
				let ec = QRCode.ErrorCorrection.Create(first)
			{
				return ec
			}
			return .quantize
		}()
		self.errorCorrection = ec

		if let design = settings["design"] as? [String: Any],
			let d = try? QRCode.Design.Create(settings: design)
		{
			self.design = d
		}

		// Restore the mask

		if let maskSettings = settings["logoTemplate"] as? [String: Any],
			let l = QRCode.LogoTemplate(settings: maskSettings)
		{
			self.logoTemplate = l
		}

		self.regenerate()
	}

	/// Create a QRCode.Document object from the specified settings
	/// - Parameters:
	///   - settings: The dictionary of settings to apply to the document
	///   - generator: The generator to use, or nil to use the default (watchOS requires QRCode
	/// - Returns: A QRCode document
	@objc static func Create(settings: [String: Any], generator: (any QRCodeEngine)? = nil) throws -> QRCode.Document {
		let doc = QRCode.Document(generator: generator)
		try doc.load(settings: settings)
		return doc
	}

	/// Create a QRCode document from the provided json formatted data
	/// - Parameters:
	///   - jsonData: The json formatted qr code to load
	///   - generator: The generator to use, or nil to use the default (watchOS requires QRCode
	/// - Returns: A QRCode document
	@objc static func Create(jsonData: Data, generator: (any QRCodeEngine)? = nil) throws -> QRCode.Document {
		let s = try JSONSerialization.jsonObject(with: jsonData, options: [])

		guard let settings = s as? [String: Any] else {
			throw NSError(domain: "QRCodeDocument", code: -1, userInfo: [
				NSLocalizedDescriptionKey: "Unable to decode object",
			])
		}
		return try QRCode.Document.Create(settings: settings, generator: generator)
	}
}

// MARK: - Save

public extension QRCode.Document {
	/// The current settings for the data, shape and design for the QRCode
	@objc func settings() -> [String: Any] {
		var settings: [String: Any] = [
			"correction": errorCorrection.ECLevel,
			"design": self.design.settings(),
		]
		if let data = self.data {
			settings["data"] = data.base64EncodedString()
		}
		else if let text = self.utf8String {
			settings["text"] = text
		}
		if let l = self.logoTemplate {
			settings["logoTemplate"] = l.settings()
		}
		return settings
	}

	/// Generate a JSON string representation of the document.
	@objc func jsonData() throws -> Data {
		let dict = self.settings()
		return try JSONSerialization.data(withJSONObject: dict)
	}

	/// Generate a pretty-printed JSON string representation of the document.
	@objc func jsonStringFormatted() -> String? {
		let dict = self.settings()
		if #available(macOS 10.13, *) {
			if let data = try? JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted, .sortedKeys]) {
				return String(data: data, encoding: .utf8)
			}
		}
		else {
			if let data = try? JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted]) {
				return String(data: data, encoding: .utf8)
			}
		}
		return nil
	}
}

// MARK: - Update

public extension QRCode.Document {
	/// Build the QR Code using the given data and error correction
	@objc func update(data: Data, errorCorrection: QRCode.ErrorCorrection) {
		self.qrcode.update(data: data, errorCorrection: errorCorrection)
	}

	/// Build the QR Code using the given text and error correction
	@objc func update(text: String, errorCorrection: QRCode.ErrorCorrection = .default) {
		self.qrcode.update(text: text, errorCorrection: errorCorrection)
	}

	/// Build the QR Code using the given message formatter and error correction
	@objc func update(message: any QRCodeMessageFormatter, errorCorrection: QRCode.ErrorCorrection = .default) {
		self.qrcode.update(message: message, errorCorrection: errorCorrection)
	}
}

// MARK: - Draw

public extension QRCode.Document {
	/// Draw the current qrcode document into the specified context and rect
	/// - Parameters:
	///   - ctx: The drawing context to draw into
	///   - rect: The bounds within the context to draw into
	@objc func draw(ctx: CGContext, rect: CGRect) {
		self.qrcode.draw(
			ctx: ctx,
			rect: rect,
			design: self.design,
			logoTemplate: self.logoTemplate
		)
	}
}

// MARK: - Path

public extension QRCode.Document {
	/// Generate a path containing the QR Code components for the current QRCode shape
	/// - Parameters:
	///   - size: The size of the generated path
	///   - components: The components of the QR code to include in the path
	/// - Returns: A path containing the components
	@objc func path(_ size: CGSize, components: QRCode.Components = .all) -> CGPath {
		/// The size of each pixel in the output
		let additionalQuietSpacePixels = CGFloat(design.additionalQuietZonePixels)
		let dm: CGFloat = CGFloat(size.width) / (CGFloat(self.cellDimension) + (2.0 * additionalQuietSpacePixels))
		let additionalQuietSpace = dm * additionalQuietSpacePixels

		// Factor in the additional quiet space in the result
		guard (2 * additionalQuietSpace) < size.width else {
			Swift.print("additionalQuietSpace too large")
			return CGMutablePath()
		}

		var components = components
		if self.design.shape.negatedOnPixelsOnly {
			components.insert(.negative)
		}

		return self.qrcode.path(
			CGSize(
				width: size.width - (2 * additionalQuietSpace),
				height: size.height - (2 * additionalQuietSpace)
			),
			components: components,
			shape: self.design.shape,
			additionalQuietSpace: additionalQuietSpace
		)
	}

	/// Generate a path containing the QR Code components for the current QRCode shape
	/// - Parameters:
	///   - dimension: The dimension of the generated path
	///   - components: The components of the QR code to include in the path
	/// - Returns: A path containing the components
	@objc func path(dimension: Int, components: QRCode.Components = .all) -> CGPath {
		return self.qrcode.path(
			CGSize(dimension: dimension),
			components: components,
			shape: self.design.shape
		)
	}
}

// MARK: SVG

public extension QRCode.Document {
	/// Returns an SVG utf8 string representation of the QR code
	/// - Parameters:
	///   - dimension: The dimension of the output svg
	/// - Returns: An SVG representation of the QR code
	///
	/// The string always uses Unix newlines (\n), regardless of the platform.
	@objc func svg(dimension: Int) throws -> String {
		try self.qrcode.svg(dimension: dimension, design: self.design, logoTemplate: self.logoTemplate)
	}

	/// Returns an SVG data representation of the QR Code.
	/// - Parameters:
	///   - dimension: The dimension of the output svg
	/// - Returns: A UTF8 encoded SVG representation of the QR code
	///
	/// The string always uses Unix newlines (\n), regardless of the platform.
	@objc func svgData(dimension: Int) throws -> Data {
		try self.qrcode.svgData(dimension: dimension, design: design, logoTemplate: logoTemplate)
	}
}

// MARK: Imaging

public extension QRCode.Document {
	/// Returns a CGImage representation of the qr code
	/// - Parameters:
	///   - dimension: The dimension of the image to create
	/// - Returns: The image, or nil if an error occurred
	@objc func cgImage(dimension: Int) throws -> CGImage {
		try self.qrcode.cgImage(
			CGSize(dimension: dimension),
			design: self.design,
			logoTemplate: self.logoTemplate
		)
	}

	/// Returns a CGImage representation of the qr code
	/// - Parameters:
	///   - width: The pixel width of the image to generate
	///   - height: The pixel height of the image to generate
	/// - Returns: The image, or nil if an error occurred
	@objc func cgImage(width: CGFloat, height: CGFloat) -> CGImage? {
		self.cgImage(CGSize(width: width, height: height))
	}

	/// Returns a CGImage representation of the qr code
	/// - Parameters:
	///   - size: The pixel size of the image to generate
	/// - Returns: The image, or nil if an error occurred
	@objc func cgImage(_ size: CGSize) throws -> CGImage {
		try self.qrcode.cgImage(
			size,
			design: self.design,
			logoTemplate: self.logoTemplate
		)
	}
}

public extension QRCode.Document {
	/// The supported exportable image types
	enum ExportType {
		/// PNG export
		case png(dpi: CGFloat = 72.0)
		/// JPEG export. Default compression value is 0.75
		case jpg(dpi: CGFloat = 72.0, compression: CGFloat = 0.75)
		/// TIFF export
		case tiff(dpi: CGFloat = 72.0)
		/// PDF export
		case pdf(pdfResolution: CGFloat = 72.0)
		/// Binary representation of an SVG file
		case svg

		/// Returns the extension for the export type
		var fileExtension: String {
			switch self {
			case .png: return "png"
			case .jpg: return "jpg"
			case .tiff: return "tiff"
			case .pdf: return "pdf"
			case .svg: return "svg"
			}
		}
	}

	/// Returns the QRCode document as an image
	/// - Parameters:
	///   - type: The type of image
	///   - dimension: The size of the resulting image
	/// - Returns: Data representation of the image
	@inlinable func imageData(_ type: ExportType, dimension: Int) throws -> Data {
		switch type {
		case let .png(dpi):
			return try self.pngData(dimension: dimension, dpi: dpi)
		case let .jpg(dpi, compression):
			return try self.jpegData(dimension: dimension, dpi: dpi, compression: compression)
		case let .pdf(resolution):
			return try self.pdfData(dimension: dimension, pdfResolution: resolution)
		case .svg:
			return try self.svgData(dimension: dimension)
		case let .tiff(dpi):
			return try self.tiffData(dimension: dimension, dpi: dpi)
		}
	}
}

// MARK: PDF generation

public extension QRCode.Document {
	/// Returns a pdf representation of the qr code document
	/// - Parameters:
	///   - dimension: The dimension of the generated PDF
	///   - pdfResolution: The resolution of the pdf output
	/// - Returns: A data object containing the PDF representation of the QR code
	@objc func pdfData(dimension: Int, pdfResolution: CGFloat = 72.0) throws -> Data {
		try self.pdfData(CGSize(dimension: dimension), pdfResolution: pdfResolution)
	}

	/// Returns a pdf representation of the qr code document
	/// - Parameters:
	///   - width: The page width of the generated PDF
	///   - height: The page height of the generated PDF
	///   - pdfResolution: The resolution of the pdf output
	/// - Returns: A data object containing the PDF representation of the QR code
	@objc func pdfData(width: CGFloat, height: CGFloat, pdfResolution: CGFloat = 72.0) -> Data? {
		self.pdfData(CGSize(width: width, height: height), pdfResolution: pdfResolution)
	}

	/// Returns a pdf representation of the qr code document
	/// - Parameters:
	///   - size: The page size of the generated PDF
	///   - pdfResolution: The resolution of the pdf output
	/// - Returns: A data object containing the PDF representation of the QR code
	@objc func pdfData(_ size: CGSize, pdfResolution: CGFloat = 72.0) throws -> Data {
		try self.qrcode.pdfData(
			size,
			pdfResolution: pdfResolution,
			design: self.design,
			logoTemplate: self.logoTemplate
		)
	}

	/// Returns a PNG representation of the QRCode
	/// - Parameters:
	///   - dimension: The size of the QR code
	/// - Returns: The PNG data
	@objc func pngData(dimension: Int, dpi: CGFloat = 72.0) throws -> Data {
		try self.qrcode.pngData(
			dimension: dimension,
			dpi: dpi,
			design: self.design,
			logoTemplate: self.logoTemplate
		)
	}

	/// Returns a JPEG representation of the QRCode
	/// - Parameter
	///   - dimension: The size of the QR code
	///   - dpi: The DPI of the resulting image
	///   - compression: The compression level to use when generating the JPEG (0.0 -> 1.0)
	/// - Returns: The PNG data
	@objc func jpegData(dimension: Int, dpi: CGFloat = 72.0, compression: Double = 0.9) throws -> Data {
		try self.qrcode.jpegData(
			dimension: dimension,
			dpi: dpi,
			design: self.design,
			logoTemplate: self.logoTemplate,
			compression: compression.clamped(to: 0.0 ... 1.0)
		)
	}

	/// Return a TIFF representation of the QR code
	/// - Parameters:
	///   - dimension: The dimensions of the image to create
	///   - dpi: The DPI of the resulting image
	/// - Returns: The TIFF data
	@objc func tiffData(dimension: Int, dpi: CGFloat = 72.0) throws -> Data {
		try self.qrcode.tiffData(
			dimension: dimension,
			dpi: dpi,
			design: self.design,
			logoTemplate: self.logoTemplate
		)
	}

#if os(macOS)
	/// Returns a platform specific representation of the qr code document
	/// - Parameters:
	///   - dimension: The pixel dimension of the image to generate
	///   - dpi: The DPI of the resulting image
	/// - Returns: The image, or nil if an error occurred
	@objc func platformImage(dimension: Int, dpi: CGFloat = 72.0) throws -> DSFImage {
		try self.qrcode.nsImage(
			CGSize(dimension: dimension),
			dpi: dpi,
			design: self.design,
			logoTemplate: self.logoTemplate
		)
	}

	/// Returns an NSImage representation of the qr code document
	/// - Parameters:
	///   - dimension: The pixel dimension of the image to generate
	///   - dpi: The DPI of the resulting image
	/// - Returns: The image, or nil if an error occurred
	@objc func nsImage(dimension: Int, dpi: CGFloat = 72.0) throws -> NSImage {
		try self.qrcode.nsImage(
			CGSize(dimension: dimension),
			dpi: dpi,
			design: self.design,
			logoTemplate: self.logoTemplate
		)
	}

	/// Returns an NSImage representation of the qr code document
	/// - Parameters:
	///   - size: The pixel size of the image to generate
	///   - dpi: The DPI of the resulting image
	/// - Returns: The image, or nil if an error occurred
	@objc func nsImage(_ size: CGSize, dpi: CGFloat = 72.0) throws -> NSImage {
		try self.qrcode.nsImage(
			size,
			dpi: dpi,
			design: self.design,
			logoTemplate: self.logoTemplate
		)
	}

#elseif os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
	/// Returns a platform specific representation of the qr code document
	/// - Parameters:
	///   - dimension: The pixel dimension of the image to generate
	///   - dpi: The DPI of the resulting image
	/// - Returns: The image, or nil if an error occurred
	@objc func platformImage(dimension: Int, dpi: CGFloat = 72.0) throws -> DSFImage {
		try self.qrcode.uiImage(
			CGSize(dimension: dimension),
			dpi: dpi,
			design: self.design,
			logoTemplate: self.logoTemplate
		)
	}

	/// Returns a UIImage representation of the qr code document
	/// - Parameters:
	///   - dimension: The pixel dimension of the image to generate
	///   - dpi: The DPI of the resulting image
	/// - Returns: The image, or nil if an error occurred
	@objc func uiImage(dimension: Int, dpi: CGFloat) throws -> UIImage {
		try self.uiImage(CGSize(dimension: dimension), dpi: dpi)
	}

	/// Returns a UIImage representation of the qr code document
	/// - Parameters:
	///   - dimension: The size of the image to generate
	///   - scale: The scale factor for the image, with a value like 1.0, 2.0, or 3.0.
	/// - Returns: The image, or nil if an error occurred
	@objc func uiImage(dimension: Int, scale: CGFloat = 1) throws -> UIImage {
		try self.uiImage(CGSize(dimension: dimension), dpi: scale * 72.0)
	}

	/// Returns a UIImage representation of the qr code document
	/// - Parameters:
	///   - size: The pixel size of the image to generate
	///   - dpi: The DPI of the resulting image
	/// - Returns: The image, or nil if an error occurred
	@objc func uiImage(_ size: CGSize, dpi: CGFloat = 72.0) throws -> UIImage {
		let scale = dpi / 72.0
		let qrImage = try self.qrcode.cgImage(
			size * scale,
			design: self.design,
			logoTemplate: self.logoTemplate
		)
		return UIImage(cgImage: qrImage, scale: scale, orientation: .up)
	}

#endif

#if canImport(SwiftUI)
	/// Create a SwiftUI Image object for the QR code
	/// - Parameters:
	///   - size: The pixel size of the image to generate
	///   - dpi: The DPI of the resulting image
	///   - label: The label associated with the image. SwiftUI uses the label for accessibility.
	/// - Returns: An image, or nil if an error occurred
	@available(macOS 11, iOS 13, tvOS 13, *)
	func imageUI(_ size: CGSize, dpi: CGFloat = 72.0, label: Text) throws -> SwiftUI.Image {
		try self.qrcode.imageUI(
			size,
			dpi: dpi,
			design: self.design,
			logoTemplate: self.logoTemplate,
			label: label
		)
	}
#endif
}

// MARK: - Raw data

public extension QRCode.Document {
	/// Returns a boolean matrix representation of the current QR code data
	@objc var boolMatrix: BoolMatrix { self.qrcode.boolMatrix }
}

// MARK: - ASCII representation

public extension QRCode.Document {
	/// A simple ASCII representation of the core QRCode data.
	///
	/// Example output (data is "testing")
	/// ```
	///  ██████████████    ██  ████  ██████████████
	///  ██          ██  ████  ██    ██          ██
	///  ██  ██████  ██  ████    ██  ██  ██████  ██
	///  ██  ██████  ██    ██  ██    ██  ██████  ██
	///  ██  ██████  ██  ██      ██  ██  ██████  ██
	///  ██          ██  ██    ████  ██          ██
	///  ██████████████  ██  ██  ██  ██████████████
	///                  ██████████
	///  ████  ██    ████  ████      ██████  ████
	///  ██  ████████      ██        ████      ████
	///  ████████    ████    ██  ████      ████  ██
	///  ████  ████    ██  ██  ██        ████  ████
	///  ████  ████  ██      ██  ██  ████████  ████
	///                  ████  ██      ██  ██  ████
	///  ██████████████  ████      ██  ████    ██
	///  ██          ██      ████████  ████      ██
	///  ██  ██████  ██        ██    ████████    ██
	///  ██  ██████  ██  ██  ████      ██████  ████
	///  ██  ██████  ██      ██  ██    ████  ██  ██
	///  ██          ██  ██  ██    ████  ██
	///  ██████████████  ██  ██████        ██  ██
	///
	/// ```
	@objc var asciiRepresentation: String { return self.qrcode.asciiRepresentation() }

	/// A simple smaller ASCII representation of the core QRCode data
	///
	/// Example output (data is "testing")
	/// ```
	///  ▄▄▄▄▄▄▄  ▄ ▄▄ ▄▄▄▄▄▄▄
	///  █ ▄▄▄ █ ██ ▀▄ █ ▄▄▄ █
	///  █ ███ █ ▄▀ ▀▄ █ ███ █
	///  █▄▄▄▄▄█ █ ▄▀█ █▄▄▄▄▄█
	///  ▄▄ ▄  ▄▄▀██▀▀ ▄▄▄ ▄▄
	///  █▄██▀▀▄▄ ▀▄ ▄▄▀▀ ▄▄▀█
	///  ██ ██ ▄▀ ▀▄▀▄ ▄▄██ ██
	///  ▄▄▄▄▄▄▄ ██ ▀ ▄ █▄▀ █▀
	///  █ ▄▄▄ █   ▀█▀▀▄██▄  █
	///  █ ███ █ ▀ █▀▄  ██▀▄▀█
	///  █▄▄▄▄▄█ █ █▄▄▀▀ ▀▄ ▄
	///
	/// ```
	@objc var smallAsciiRepresentation: String { return self.qrcode.smallAsciiRepresentation() }
}

// MARK: - Templating conveniences

public extension QRCode.Document {
	/// Return a new document using the style and design supplied by the template data with the specified text
	@objc static func UsingTemplate(templateJSONData: Data, text: String) throws -> QRCode.Document {
		let doc = try QRCode.Document(jsonData: templateJSONData)
		doc.utf8String = text
		return doc
	}

	/// Return an image using the style and design supplied by the template data with the specified text
	@objc @inlinable static func PNGUsingTemplate(templateJSONData: Data, text: String, dimension: Int) throws -> Data {
		let doc = try Self.UsingTemplate(templateJSONData: templateJSONData, text: text)
		return try doc.pngData(dimension: dimension)
	}

	/// Return a pdf using the style and design supplied by the template data with the specified text
	@objc @inlinable static func PDFUsingTemplate(
		templateJSONData: Data,
		text: String,
		dimension: Int,
		resolution: CGFloat = 72.0
	) throws -> Data {
		let doc = try Self.UsingTemplate(templateJSONData: templateJSONData, text: text)
		return try doc.pdfData(dimension: dimension, pdfResolution: resolution)
	}
}

extension QRCode.Document {
	// Build up the qr representation
	private func regenerate() {
		if let data = self.data {
			self.qrcode.update(data: data, errorCorrection: self.errorCorrection)
		}
		else if let text = self.utf8String {
			self.qrcode.update(text: text, errorCorrection: self.errorCorrection)
		}
		else {
			Swift.print("QRCode.Document: No data specified")
		}
	}
}

// MARK: - SwiftUI extensions

#if canImport(Combine)
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension QRCode.Document: ObservableObject {
	/// A convenience for marking a document as having been updated.
	///
	/// The core QRCode.Document class needs to support OSes that don't support Combine.
	/// As such, we can't litter the QRCode.Document with `Published` types to detect automatically reflect changes
	/// within the QRCode document. One day when these old OS versions are not supported anymore, we can
	/// refactor the document to automatically handle combine.
	@inlinable public func setHasChanged() {
		self.objectWillChange.send()
	}
}

#endif
