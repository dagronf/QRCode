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
				self.regenerateNoThrow()
			}
		}

		/// Binary data to display in the QR code
		@objc public var data: Data? {
			get {
				if case .data(let data) = self.content {
					return data
				}
				return nil
			}
			set {
				self.content = .data(newValue ?? Data())
			}
		}

		/// Text (utf8 encoded) to display in the QR code.
		///
		/// If you need string content using a different encoding, use the `data` property instead
		@objc public var utf8String: String? {
			get {
				if case .text(let text) = self.content {
					return text
				}
				return nil
			}
			set {
				self.content = .text(newValue ?? "")
			}
		}

		/// Returns the content of the QR code as raw text
		///
		/// If the qr code contains binary data, returns the base64 encoded data
		@objc public var decodedText: String {
			self.utf8String ?? self.data?.base64EncodedString() ?? "<unable to decode>"
		}

		/// The style to use when drawing the qr code
		@objc public var design = QRCode.Design() {
			didSet { self.regenerateNoThrow() }
		}

		/// A logo template
		@objc public var logoTemplate: QRCode.LogoTemplate? {
			didSet { self.regenerateNoThrow() }
		}

		/// The engine used to generate the QR code
		@objc public var engine: (any QRCodeEngine)? {
			get { self.qrcode.engine }
			set {
				self.qrcode.engine = newValue ?? QRCode.DefaultEngine()
				self.regenerateNoThrow()
			}
		}

		/// Create a QR code
		@objc override public init() {
			self.content = .data(Data())
			self.errorCorrection = .default
			self.qrcode = try! QRCode(Data(), errorCorrection: self.errorCorrection)
			super.init()
		}

		/// Create a QRCode document with default settings
		@objc public convenience init(engine: (any QRCodeEngine)?) throws {
			try self.init(data: Data(), errorCorrection: .default, engine: engine)
		}

		/// Create a QRCode document
		/// - Parameters:
		///   - data: The data to encode
		///   - errorCorrection: The error correction level
		///   - engine: The engine to use when creating the QR code. Defaults to Core Image
		@objc public init(
			data: Data,
			errorCorrection: QRCode.ErrorCorrection = .default,
			engine: (any QRCodeEngine)? = nil
		) throws {
			self.content = .data(Data())
			self.errorCorrection = errorCorrection
			self.qrcode = try QRCode(data, errorCorrection: errorCorrection, engine: engine)
			super.init()
		}

		/// Create a QRCode document containing `text`
		/// - Parameters:
		///   - utf8String: The utf8 string to encode
		///   - errorCorrection: The error correction level
		///   - engine: The engine to use when creating the QR code. Defaults to Core Image
		@objc public init(
			utf8String: String,
			errorCorrection: QRCode.ErrorCorrection = .default,
			engine: (any QRCodeEngine)? = nil
		) throws {
			self.content = .text(utf8String)
			self.errorCorrection = errorCorrection
			self.qrcode = try QRCode(utf8String: utf8String, errorCorrection: errorCorrection, engine: engine)
			super.init()
		}

		/// Create a QRCode document using a message formatter
		/// - Parameters:
		///   - message: The message formatter
		///   - errorCorrection: The error correction level
		///   - engine: The engine to use when creating the QR code. Defaults to Core Image
		@objc public convenience init(
			message: any QRCodeMessageFormatter,
			errorCorrection: QRCode.ErrorCorrection = .default,
			engine: (any QRCodeEngine)? = nil
		) throws {
			if let text = message.text {
				try self.init(utf8String: text, errorCorrection: errorCorrection, engine: engine)
			}
			else {
				try self.init(data: message.data, errorCorrection: errorCorrection, engine: engine)
			}
		}

		/// The qrcode content.
		internal let qrcode: QRCode

		/// The content to display
		private var content: Content {
			didSet {
				self.regenerateNoThrow()
			}
		}
	}
}

// MARK: - Swift-only convenience initializers

public extension QRCode.Document {
	/// Create a QRCode document
	/// - Parameters:
	///   - data: The data to encode
	///   - errorCorrection: The error correction level
	///   - engine: The engine to use when creating the QR code
	@inlinable convenience init(
		_ data: Data,
		errorCorrection: QRCode.ErrorCorrection = .default,
		engine: (any QRCodeEngine)? = nil
	) throws {
		try self.init(data: data, errorCorrection: errorCorrection, engine: engine)
	}

	/// Create a QRCode document containing a url
	/// - Parameters:
	///   - url: The url to encode
	///   - errorCorrection: The error correction level
	///   - engine: The engine to use when creating the QR code
	@inlinable convenience init(
		_ url: URL,
		errorCorrection: QRCode.ErrorCorrection = .default,
		engine: (any QRCodeEngine)? = nil
	) throws {
		try self.init(
			utf8String: url.absoluteString,
			errorCorrection: errorCorrection,
			engine: engine
		)
	}

	/// Create a QRCode document containing a url
	/// - Parameters:
	///   - message: The formatted message to encode
	///   - errorCorrection: The error correction level
	///   - engine: The engine to use when creating the QR code
	/// - Returns: nil if the url could not be encoded in utf8
	@inlinable convenience init(
		_ message: any QRCodeMessageFormatter,
		errorCorrection: QRCode.ErrorCorrection = .default,
		engine: (any QRCodeEngine)? = nil
	) throws {
		try self.init(message: message, errorCorrection: errorCorrection, engine: engine)
	}
}

public extension QRCode.Document {
	/// Set the text to encode in the document
	/// - Parameters:
	///   - text: The text
	/// - Returns: True if the text was successfully set, false otherwise
	func setText(_ text: String) throws {
		self.content = .text(text)
		try self.regenerate()
	}

	/// Set the content of the QR code to the specified URL
	/// - Parameters:
	///   - url: The url to encode
	func setURL(_ url: URL) throws {
		self.content = .text(url.absoluteString)
		try self.regenerate()
	}

	/// Set the QR code data using a message formatter
	@objc func setMessage(_ message: any QRCodeMessageFormatter) throws {
		if let text = message.text {
			try self.setText(text)
		}
		else {
			self.content = .data(message.data)
		}
	}

	/// Make a copy of this document
	@objc func copyDocument() throws -> QRCode.Document {
		let c = QRCode.Document()
		c.content = self.content
		c.design = try self.design.copyDesign()
		c.logoTemplate = self.logoTemplate?.copyLogoTemplate()
		c.errorCorrection = self.errorCorrection
		return c
	}
}

// MARK: - Update

public extension QRCode.Document {
	/// Build the QR Code using the given data and error correction
	@objc func update(data: Data, errorCorrection: QRCode.ErrorCorrection) throws {
		self.data = data
		try self.qrcode.update(data: data, errorCorrection: errorCorrection)
	}

	/// Set the QRCode content
	/// - Parameters:
	///   - text: The utf8 text
	///   - errorCorrection: Error correction
	@objc func update(text: String, errorCorrection: QRCode.ErrorCorrection = .default) throws {
		try self.qrcode.update(text: text, errorCorrection: errorCorrection)
	}

	/// Set the QRCode content
	/// - Parameters:
	///   - message: The message
	///   - errorCorrection: Error correction
	@objc func update(message: any QRCodeMessageFormatter, errorCorrection: QRCode.ErrorCorrection = .default) throws {
		try self.qrcode.update(message: message, errorCorrection: errorCorrection)
	}
}

internal extension QRCode.Document {
	/// Regenerates the QR Code representation
	func regenerate() throws {
		switch self.content {
		case .data(let data):
			try self.qrcode.update(data: data, errorCorrection: self.errorCorrection)
		case .text(let text):
			try self.qrcode.update(text: text, errorCorrection: self.errorCorrection)
		}
	}

	/// Regenerates the QR Code representation
	func regenerateNoThrow() {
		do {
			try self.regenerate()
		}
		catch {
			Swift.print("QRCode.Document: Could not regenerate. Error was '\(error)'")
		}
	}
}

// MARK: - Raw data

public extension QRCode.Document {
	/// Returns a boolean matrix representation of the current QR code data
	@objc var boolMatrix: BoolMatrix { self.qrcode.boolMatrix }
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
