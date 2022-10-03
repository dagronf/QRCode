//
//  QRCode.swift
//
//  Created by Darren Ford on 15/11/21.
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

// QR Code Generator

import CoreGraphics
import Foundation

/// A QRCode generator class
@objc public class QRCode: NSObject {
	/// The generator to use when generating the QR code.
	///
	/// Defaults to CoreImage on macOS/iOS/tvOS, or none on watchOS (import QRCodeExternal for watchOS)
	@objc public var generator: QRCodeEngine = {
#if os(watchOS)
		// You must supply a 3rd party generator for watchOS (see README.md)
		return QRCodeGenerator_None()
#else
		return QRCodeGenerator_CoreImage()
#endif
	}()

	/// Create a blank QRCode
	@objc override public init() {
		super.init()
	}

	/// Create a blank QRCode with a custom QR code generation engine
	@objc public init(generator: QRCodeEngine) {
		self.generator = generator
		super.init()
		self.update(Data(), errorCorrection: .default)
	}

	/// Create a QRCode with the given data and error correction
	@objc public init(
		_ data: Data,
		errorCorrection: ErrorCorrection = .default,
		generator: QRCodeEngine? = nil
	) {
		if let g = generator { self.generator = g }
		super.init()
		self.update(data, errorCorrection: errorCorrection)
	}

	/// Create a QRCode with the given text and error correction
	@objc public init(
		text: String,
		errorCorrection: ErrorCorrection = .default,
		generator: QRCodeEngine? = nil
	) {
		if let g = generator { self.generator = g }
		super.init()
		self.update(text: text, errorCorrection: errorCorrection)
	}

	/// Create a QRCode with the given message and error correction
	@objc public init(
		message: QRCodeMessageFormatter,
		errorCorrection: ErrorCorrection = .default,
		generator: QRCodeEngine? = nil
	) {
		if let g = generator { self.generator = g }
		super.init()
		self.update(message: message, errorCorrection: errorCorrection)
	}

	/// The QR code content as a 2D array of bool values
	public internal(set) var current = BoolMatrix()

	/// This is the pixel dimension for the QR Code.
	@objc public var pixelSize: Int {
		return self.current.dimension
	}

	// Private
	private let DefaultPDFResolution: CGFloat = 72
}

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
	@objc func update(_ data: Data, errorCorrection: ErrorCorrection) {
		if let result = self.generator.generate(data, errorCorrection: errorCorrection) {
			self.current = result
		}
	}

	/// Build the QR Code using the given text and error correction
	@objc func update(text: String, errorCorrection: ErrorCorrection = .default) {
		self.update(text.data(using: .utf8) ?? Data(), errorCorrection: errorCorrection)
	}

	/// Build the QR Code using the given message formatter and error correction
	@objc func update(message: QRCodeMessageFormatter, errorCorrection: ErrorCorrection = .default) {
		self.update(message.data, errorCorrection: errorCorrection)
	}
}

// MARK: - Ascii representations

public extension QRCode {
	/// Return an ASCII representation of the QR code using the extended ASCII code set
	///
	/// Only makes sense if presented using a fixed-width font
	@objc func asciiRepresentation() -> String {
		var result = ""
		for row in 0 ..< self.current.dimension {
			for col in 0 ..< self.current.dimension {
				if self.current[row, col] == true {
					result += "██"
				}
				else {
					result += "  "
				}
			}
			result += "\n"
		}
		return result
	}

	/// Returns an small ASCII representation of the QR code (about 1/2 the regular size) using the extended ASCII code set
	///
	/// Only makes sense if presented using a fixed-width font
	@objc func smallAsciiRepresentation() -> String {
		var result = ""
		for row in stride(from: 0, to: self.current.dimension, by: 2) {
			for col in 0 ..< self.current.dimension {
				let top = self.current[row, col]

				if row <= self.current.dimension - 2 {
					let bottom = self.current[row + 1, col]
					if top,!bottom { result += "▀" }
					if !top, bottom { result += "▄" }
					if top, bottom { result += "█" }
					if !top, !bottom { result += " " }
				}
				else {
					if top { result += "▀" }
					else { result += " " }
				}
			}
			result += "\n"
		}
		return result
	}

	/// Returns a boolean matrix representation of the current QR code data
	@objc var boolMatrix: BoolMatrix {
		self.current
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
			if col >= (self.pixelSize - 9) {
				return true
			}
		}
		else if row >= (self.pixelSize - 9), col < 9 {
			return true
		}
		return false
	}
}
