//
//  QRCode+Document.swift
//
//  Created by Darren Ford on 17/11/21.
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

		/// Create a QRCode document with the default settings
		@objc public override init() {
			super.init()
		}

		/// Create a QRCode document using the QRCode settings defined in `jsonData`
		@objc public init(jsonData: Data) throws {
			super.init()
			try self.load(jsonData: jsonData)
		}

		/// Create a QRCode document using the QRCode settings defined in `dictionary`
		@objc public init(dictionary: [String: Any]) throws {
			super.init()
			try self.load(settings: dictionary)
		}

		/// The style to use when drawing the qr code
		@objc public var design = QRCode.Design()

		/// This is the pixel dimension for the current QR Code.
		@objc public var pixelSize: Int { return self.qrcode.pixelSize }

		/// A simple ASCII representation of the core QRCode data.
		///
		/// Example output (data is "testing")
		///```
		///  ██████████████    ██  ████  ██████████████
		///  ██          ██  ████  ██    ██          ██
		///  ██  ██████  ██  ████    ██  ██  ██████  ██
		///  ██  ██████  ██    ██  ██    ██  ██████  ██
		///  ██  ██████  ██  ██      ██  ██  ██████  ██
		///  ██          ██  ██    ████  ██          ██
		///  ██████████████  ██  ██  ██  ██████████████
		///  ██████████
		///  ████  ██    ████  ████      ██████  ████
		///  ██  ████████      ██        ████      ████
		///  ████████    ████    ██  ████      ████  ██
		///  ████  ████    ██  ██  ██        ████  ████
		///  ████  ████  ██      ██  ██  ████████  ████
		///  ████  ██      ██  ██  ████
		///  ██████████████  ████      ██  ████    ██
		///  ██          ██      ████████  ████      ██
		///  ██  ██████  ██        ██    ████████    ██
		///  ██  ██████  ██  ██  ████      ██████  ████
		///  ██  ██████  ██      ██  ██    ████  ██  ██
		///  ██          ██  ██  ██    ████  ██
		///  ██████████████  ██  ██████        ██  ██
		///
		///```
		@objc public var asciiRepresentation: String { return self.qrcode.asciiRepresentation() }

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
		@objc public var smallAsciiRepresentation: String { return self.qrcode.smallAsciiRepresentation() }

		// The qrcode content generator
		private let qrcode = QRCode()

		// Build up the qr representation
		private func regenerate() {
			self.qrcode.update(self.data, errorCorrection: self.errorCorrection)
		}
	}
}

// MARK: - Save/Load

public extension QRCode.Document {
	/// The current settings for the data, shape and design for the QRCode
	@objc func settings() -> [String: Any] {
		return [
			"correction": errorCorrection.ECLevel,
			"data": data.base64EncodedString(),
			"design": self.design.settings(),
		]
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

	@objc static func Create(settings: [String: Any]) throws -> QRCode.Document {
		let doc = QRCode.Document()
		try doc.load(settings: settings)
		return doc
	}
}

public extension QRCode.Document {
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
	@objc func draw(ctx: CGContext, rect: CGRect) {
		self.qrcode.draw(ctx: ctx, rect: rect, design: self.design)
	}
}

// MARK: Imaging

public extension QRCode.Document {
	/// Returns a CGImage representation of the qr code
	/// - Parameters:
	///   - size: The pixel size of the image to generate
	///   - scale: The scale
	/// - Returns: The image, or nil if an error occurred
	@objc func cgImage(
		_ size: CGSize,
		scale: CGFloat = 1
	) -> CGImage? {
		self.qrcode.cgImage(size, scale: scale, design: design)
	}

	/// Returns a pdf representation of the qr code
	/// - Parameters:
	///   - size: The page size of the generated PDF
	///   - pdfResolution: The resolution of the pdf output
	/// - Returns: A data object containing the PDF representation of the QR code
	@objc func pdfData(_ size: CGSize, pdfResolution: CGFloat = 72.0) -> Data? {
		self.qrcode.pdfData(size, pdfResolution: pdfResolution, design: self.design)
	}
}
