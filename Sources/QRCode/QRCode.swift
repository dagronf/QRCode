//
//  QRCode.swift
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

// Some helpful links
// - https://digitash.com/technology/how-does-qr-code-technology-work/

// QR Code Generator

import CoreGraphics
import Foundation

/// A QRCode generator class.
///
/// Note that while this can be used on any thread, it is not in itself thread-safe.
@objc public final class QRCode: NSObject, @unchecked Sendable {
	/// The generator to use when generating the QR code.
	@objc public var engine: any QRCodeEngine = QRCode.DefaultEngine()

	/// Create a blank QRCode
	@objc override public init() {
		super.init()
	}

	/// Create a blank QRCode with a custom QR code generation engine
	/// - Parameters:
	///   - engine: The QR engine to use. Specify nil to use the default generator.
	@objc public init(engine: any QRCodeEngine) throws {
		self.engine = engine
		super.init()
		try self.update(data: Data(), errorCorrection: self.currentErrorCorrection)
	}

	/// Create a QRCode with the given data and error correction
	/// - Parameters:
	///   - data: The initial data to display
	///   - errorCorrection: The initial error correction to use
	///   - engine: The QR engine to use. Specify nil to use the default generator.
	@objc public init(
		_ data: Data,
		errorCorrection: ErrorCorrection = .default,
		engine: (any QRCodeEngine)? = nil
	) throws {
		if let engine = engine { self.engine = engine }
		super.init()
		try self.update(data: data, errorCorrection: errorCorrection)
	}

	/// Create a QRCode
	/// - Parameters:
	///   - utf8String: The text to encode
	///   - errorCorrection: The error correction to apply
	///   - engine: A qr code engine, or nil to use the default generator
	@objc public init(
		utf8String: String,
		errorCorrection: ErrorCorrection = .default,
		engine: (any QRCodeEngine)? = nil
	) throws {
		if let engine = engine { self.engine = engine }
		super.init()
		try self.update(text: utf8String, errorCorrection: errorCorrection)
	}

	/// Create a QRCode with the given message and error correction
	/// - Parameters:
	///   - message: The message to encode
	///   - errorCorrection: The error correction to apply
	///   - engine: A qr code engine, or nil to use the default generator
	@objc public init(
		message: any QRCodeMessageFormatter,
		errorCorrection: ErrorCorrection = .default,
		engine: (any QRCodeEngine)? = nil
	) throws {
		if let engine = engine { self.engine = engine }
		super.init()
		try self.update(message: message, errorCorrection: errorCorrection)
	}

	/// The QR code content as a 2D array of bool values
	public internal(set) var current = BoolMatrix()

	/// Returns a copy of the boolean matrix representation of the current QR code data
	@objc var boolMatrix: BoolMatrix { self.current }

	// The mask represents the pixels that are NOT drawn
	internal var currentMask: BoolMatrix? = nil
	internal var currentErrorCorrection: ErrorCorrection = .default
}

// MARK: - Cell information

public extension QRCode {
	/// This is the number of cells along any edge of the qr code
	@objc var cellDimension: Int { return self.current.dimension }

	/// The dimension for an individual cell for the given image dimension
	@objc func cellSize(forImageDimension dimension: Int) -> CGFloat {
		CGFloat(dimension) / CGFloat(self.cellDimension)
	}
}

// MARK: - Copying

extension QRCode: NSCopying {
	/// Return a copy of the QR Code
	@objc public func copy(with zone: NSZone? = nil) -> Any {
		let c = QRCode()
		c.current = self.current
		return c
	}
}

// MARK: - Update the QR Code

public extension QRCode {
	/// Build the QR Code using the given data and error correction
	@objc func update(data: Data, errorCorrection: ErrorCorrection) throws {
		self.current = try self.engine.generate(data: data, errorCorrection: errorCorrection)
		self.currentErrorCorrection = errorCorrection
	}

	/// Build the QR Code using the given message formatter and error correction
	@objc func update(message: any QRCodeMessageFormatter, errorCorrection: ErrorCorrection = .default) throws {
		try self.update(data: message.data, errorCorrection: errorCorrection)
	}

	/// Build the QR Code using the given text and error correction
	@objc func update(text: String, errorCorrection: ErrorCorrection = .default) throws {
		try self.update(text: text, textEncoding: .utf8, errorCorrection: errorCorrection)
	}

	/// Build the QR Code using the given text and error correction
	func update(text: String, textEncoding: String.Encoding, errorCorrection: ErrorCorrection = .default) throws {
		self.current = try self.engine.generate(text: text, errorCorrection: errorCorrection)
		self.currentErrorCorrection = errorCorrection
	}

	/// Build the QR Code using the given data and error correction
	internal func update(content: QRCode.Content, errorCorrection: ErrorCorrection) throws {
		switch content {
		case .data(let d):
			self.current = try self.engine.generate(data: d, errorCorrection: errorCorrection)
		case .text(let t):
			self.current = try self.engine.generate(text: t, errorCorrection: errorCorrection)
		}
		self.currentErrorCorrection = errorCorrection
	}
}

// MARK: - Eye positioning/paths

internal extension QRCode {
	// Is the row/col within an 'eye' of the qr code?
	func isEyePixel(_ row: Int, _ col: Int) -> Bool {
		if row < 9 {
			if col < 9 {
				return true
			}
			if col >= (self.cellDimension - 9) {
				return true
			}
		}
		else if row >= (self.cellDimension - 9), col < 9 {
			return true
		}
		return false
	}
}

// MARK: - Simple validation routines

public extension QRCode {
	@objc static func canGenerateQRCode(
		data: Data,
		errorCorrection: QRCode.ErrorCorrection,
		engine: (any QRCodeEngine)? = nil
	) -> Bool {
		do {
			_ = try QRCode(data, errorCorrection: errorCorrection, engine: engine)
			return true
		}
		catch {
			return false
		}
	}

	@objc static func canGenerateQRCode(
		text: String,
		errorCorrection: QRCode.ErrorCorrection,
		engine: (any QRCodeEngine)? = nil
	) -> Bool {
		do {
			_ = try QRCode(utf8String: text, errorCorrection: errorCorrection)
			return true
		}
		catch {
			return false
		}
	}
}
