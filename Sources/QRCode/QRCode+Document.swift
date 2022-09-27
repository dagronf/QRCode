//
//  QRCode+Document.swift
//
//  Created by Darren Ford on 17/11/21.
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
		@objc public var data = Data() {
			didSet {
				self.regenerate()
			}
		}

		/// A UTF8 string to display in the QR code
		@objc public var utf8String: String? {
			get {
				String(data: self.data, encoding: .utf8)
			}
			set {
				self.data = newValue?.data(using: .utf8) ?? Data()
			}
		}

		/// The style to use when drawing the qr code
		@objc public var design = QRCode.Design() {
			didSet { self.regenerate() }
		}

		@objc public func copyDocument() -> Document {
			let c = Document()
			c.data = self.data
			c.design = self.design.copyDesign()
			c.errorCorrection = self.errorCorrection
			return c
		}

		/// Create a QRCode document with default settings
		@objc public override init() {
			self.qrcode = QRCode()
			super.init()
		}

		/// Create a QRCode document
		/// - Parameter errorCorrection: The error correction to use
		@objc public init(errorCorrection: QRCode.ErrorCorrection) {
			self.qrcode = QRCode()
			self.errorCorrection = errorCorrection
			super.init()
		}

		/// Create a QRCode document
		/// - Parameters:
		///   - data: The data to encode
		///   - errorCorrection: The error correction level
		@objc public init(data: Data, errorCorrection: QRCode.ErrorCorrection = .default) {
			self.qrcode = QRCode()
			super.init()
			self.data = data
			self.errorCorrection = errorCorrection
			self.regenerate()
		}

		/// Create a QRCode document containing `utf8String`
		/// - Parameters:
		///   - utf8String: The UTF8 string to encode
		///   - errorCorrection: The error correction level
		@objc public init(utf8String: String, errorCorrection: QRCode.ErrorCorrection = .default) {
			self.qrcode = QRCode()
			super.init()
			self.setString(utf8String)
			self.errorCorrection = errorCorrection
			self.regenerate()
		}

		/// Create a QRCode document containing the contents of a message formatter
		/// - Parameters:
		///   - message: The message formatter
		///   - errorCorrection: The error correction level
		@objc public init(message: QRCodeMessageFormatter, errorCorrection: QRCode.ErrorCorrection = .default) {
			self.qrcode = QRCode()
			super.init()
			self.data = message.data
			self.errorCorrection = errorCorrection
			self.regenerate()
		}

		/// Create a QRCode document with the default settings using the specified generator
		/// - Parameters:
		///   - generator: The generator to use when creating the QR code
		///   - data: The data to encode
		///   - errorCorrection: The error correction to use
		@objc public init(generator: QRCodeEngine, data: Data? = nil, errorCorrection: QRCode.ErrorCorrection = .default) {
			self.qrcode = QRCode(generator: generator)
			super.init()
			if let d = data { self.data = d }
			self.errorCorrection = errorCorrection
			self.regenerate()
		}

		/// Create a QRCode document with the default settings using the specified generator
		/// - Parameters:
		///   - generator: The generator to use when creating the QR code
		///   - utf8String: The UTF8 string to encode
		///   - errorCorrection: The error correction to use
		@objc public init(generator: QRCodeEngine, utf8String: String, errorCorrection: QRCode.ErrorCorrection = .default) {
			self.qrcode = QRCode(generator: generator)
			super.init()
			self.setString(utf8String)
			self.errorCorrection = errorCorrection
			self.regenerate()
		}

		/// This is the pixel dimension for the current QR Code.
		@objc public var pixelSize: Int { self.qrcode.pixelSize }

		// The qrcode content.
		internal let qrcode: QRCode
	}
}

public extension QRCode.Document {
	/// Convenience for setting a string
	/// - Parameters:
	///   - string: The string to store in the qr code
	///   - encoding: The encoding to use
	///   - allowLossyConversion: Allow losing characters during conversion
	/// - Returns: true if the conversion succeeded and the data was set, false otherwise
	@discardableResult
	func setString(
		_ string: String,
		encoding: String.Encoding = .utf8,
		allowLossyConversion: Bool = false
	) -> Bool {
		if let d = string.data(
			using: encoding,
			allowLossyConversion: allowLossyConversion
		) {
			self.data = d
			return true
		}
		return false
	}

	/// Set the QR code data using a message formatter
	@objc func setMessage(_ message: QRCodeMessageFormatter) {
		self.data = message.data
	}
}

private extension QRCode.Document {
	// Build up the qr representation
	private func regenerate() {
		self.qrcode.update(self.data, errorCorrection: self.errorCorrection)
	}
}

// MARK: - Load

public extension QRCode.Document {
	/// Create a QRCode document using the QRCode settings defined in `jsonData`
	@objc convenience init(jsonData: Data) throws {
		self.init()
		try self.load(jsonData: jsonData)
	}

	/// Create a QRCode document using the QRCode settings defined in `dictionary`
	@objc convenience init(dictionary: [String: Any]) throws {
		self.init()
		try self.load(settings: dictionary)
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
		let data: Data = {
			if let value = settings["data"] as? String,
				let data = Data(base64Encoded: value)
			{
				return data
			}
			return Data()
		}()
		self.data = data

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
			let d = QRCode.Design.Create(settings: design)
		{
			self.design = d
		}

		self.regenerate()
	}

	/// Create a QRCode.Document object from the specified settings
	@objc static func Create(settings: [String: Any]) throws -> QRCode.Document {
		let doc = QRCode.Document()
		try doc.load(settings: settings)
		return doc
	}

	/// Create a QRCode document from the provided json formatted data
	@objc static func Create(jsonData: Data) throws -> QRCode.Document {
		let s = try JSONSerialization.jsonObject(with: jsonData, options: [])

		guard let settings = s as? [String: Any] else {
			throw NSError(domain: "QRCodeDocument", code: -1, userInfo: [
				NSLocalizedDescriptionKey: "Unable to decode object",
			])
		}
		return try QRCode.Document.Create(settings: settings)
	}
}

// MARK: - Save

public extension QRCode.Document {
	/// The current settings for the data, shape and design for the QRCode
	@objc func settings() -> [String: Any] {
		return [
			"correction": errorCorrection.ECLevel,
			"data": data.base64EncodedString(),
			"design": self.design.settings(),
		]
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
	@objc func update(_ data: Data, errorCorrection: QRCode.ErrorCorrection) {
		self.qrcode.update(data, errorCorrection: errorCorrection)
	}

	/// Build the QR Code using the given text and error correction
	@objc func update(text: String, errorCorrection: QRCode.ErrorCorrection = .default) {
		self.qrcode.update(text: text, errorCorrection: errorCorrection)
	}

	/// Build the QR Code using the given message formatter and error correction
	@objc func update(message: QRCodeMessageFormatter, errorCorrection: QRCode.ErrorCorrection = .default) {
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
		self.qrcode.draw(ctx: ctx, rect: rect, design: self.design)
	}
}

// MARK: - Path

public extension QRCode.Document {
	/// Generate a path containing the QR Code components for the current QRCode shape
	/// - Parameters:
	///   - size: The dimensions of the generated path
	///   - components: The components of the QR code to include in the path
	/// - Returns: A path containing the components
	@objc func path(
		_ size: CGSize,
		components: QRCode.Components = .all
	) -> CGPath {
		return self.qrcode.path(size, components: components, shape: self.design.shape)
	}

	/// Returns a string of SVG code for an image depicting this QR Code, with the given number of border modules.
	/// - Parameters:
	///   - outputDimension: The dimension of the output svg
	///   - border: The number of pixels for the border to the svg qrcode
	///   - foreground: The foreground color
	///   - background: The background color
	/// - Returns: An SVG representation of the QR code
	///
	/// Currently doesn't support any of the design formatting other than foreground and background colors.
	///
	/// The string always uses Unix newlines (\n), regardless of the platform.
	@objc func svg(
		outputDimension: UInt = 0,
		border: UInt = 1,
		foreground: CGColor = CGColor(gray: 0, alpha: 1),
		background: CGColor? = nil
	) -> String {
		self.qrcode.svg(outputDimension: outputDimension, border: border, foreground: foreground, background: background)
	}
}

// MARK: Imaging

public extension QRCode.Document {
	/// Returns a CGImage representation of the qr code
	/// - Parameters:
	///   - dimension: The dimension of the image to create
	/// - Returns: The image, or nil if an error occurred
	@objc func cgImage(
		dimension: CGFloat
	) -> CGImage? {
		self.qrcode.cgImage(CGSize(dimension: dimension), design: self.design)
	}

	/// Returns a CGImage representation of the qr code
	/// - Parameters:
	///   - size: The pixel size of the image to generate
	/// - Returns: The image, or nil if an error occurred
	@objc func cgImage(
		_ size: CGSize
	) -> CGImage? {
		self.qrcode.cgImage(size, design: self.design)
	}
}

// MARK: PDF generation

public extension QRCode.Document {
	/// Returns a pdf representation of the qr code document
	/// - Parameters:
	///   - dimension: The dimension of the generated PDF
	///   - pdfResolution: The resolution of the pdf output
	/// - Returns: A data object containing the PDF representation of the QR code
	@objc func pdfData(dimension: CGFloat, pdfResolution: CGFloat = 72.0) -> Data? {
		self.pdfData(CGSize(dimension: dimension), pdfResolution: pdfResolution)
	}

	/// Returns a pdf representation of the qr code document
	/// - Parameters:
	///   - size: The page size of the generated PDF
	///   - pdfResolution: The resolution of the pdf output
	/// - Returns: A data object containing the PDF representation of the QR code
	@objc func pdfData(_ size: CGSize, pdfResolution: CGFloat = 72.0) -> Data? {
		self.qrcode.pdfData(size, pdfResolution: pdfResolution, design: self.design)
	}

	/// Returns a PNG representation of the QRCode
	/// - Parameter dimension: The size of the QR code
	/// - Returns: The PNG data
	func pngData(dimension: CGFloat) -> Data? {
		return self.qrcode.pngData(dimension: dimension, design: self.design)
	}

#if os(macOS)
	/// Returns an NSImage representation of the qr code document
	/// - Parameters:
	///   - dimension: The pixel dimension of the image to generate
	///   - scale: The scale factor for the image, with a value like 1.0, 2.0, or 3.0.
	/// - Returns: The image, or nil if an error occurred
	@objc func nsImage(
		dimension: CGFloat,
		scale: CGFloat = 1
	) -> NSImage? {
		return self.qrcode.nsImage(CGSize(dimension: dimension), scale: scale, design: self.design)
	}

	/// Returns an NSImage representation of the qr code document
	/// - Parameters:
	///   - size: The pixel size of the image to generate
	///   - scale: The scale factor for the image, with a value like 1.0, 2.0, or 3.0.
	/// - Returns: The image, or nil if an error occurred
	@objc func nsImage(
		_ size: CGSize,
		scale: CGFloat = 1
	) -> NSImage? {
		return self.qrcode.nsImage(size, scale: scale, design: self.design)
	}
#elseif os(iOS) || os(tvOS) || os(watchOS)
	/// Returns a UIImage representation of the qr code document
	/// - Parameters:
	///   - dimension: The pixel dimension of the image to generate
	///   - scale: The scale factor for the image, with a value like 1.0, 2.0, or 3.0.
	/// - Returns: The image, or nil if an error occurred
	@objc func uiImage(
		dimension: CGFloat,
		scale: CGFloat = 1
	) -> UIImage? {
		self.uiImage(CGSize(dimension: dimension), scale: scale)
	}

	/// Returns a UIImage representation of the qr code document
	/// - Parameters:
	///   - size: The pixel size of the image to generate
	///   - scale: The scale factor for the image, with a value like 1.0, 2.0, or 3.0.
	/// - Returns: The image, or nil if an error occurred
	@objc func uiImage(
		_ size: CGSize,
		scale: CGFloat = 1
	) -> UIImage? {
		let coreSize = size * scale
		guard let qrImage = self.qrcode.cgImage(coreSize, design: self.design) else { return nil }
		return UIImage(cgImage: qrImage, scale: scale, orientation: .up)
	}
#endif

#if canImport(SwiftUI)
	/// Create a SwiftUI Image object for the QR code
	/// - Parameters:
	///   - size: The pixel size of the image to generate
	///   - scale: The scale factor for the image, with a value like 1.0, 2.0, or 3.0.
	///   - label: The label associated with the image. SwiftUI uses the label for accessibility.
	/// - Returns: An image, or nil if an error occurred
	@available(macOS 11, iOS 13, tvOS 13, *)
	func imageUI(
		_ size: CGSize,
		scale: CGFloat = 1,
		label: Text
	) -> SwiftUI.Image? {
		return self.qrcode.imageUI(size, scale: scale, design: self.design, label: label)
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
