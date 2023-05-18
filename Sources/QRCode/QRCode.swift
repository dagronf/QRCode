//
//  QRCode.swift
//
//  Copyright © 2023 Darren Ford. All rights reserved.
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
@objc public class QRCode: NSObject {
	/// The generator to use when generating the QR code.
	@objc public var generator: QRCodeEngine = QRCode.DefaultEngine()

	/// Create a blank QRCode
	@objc override public init() {
		super.init()
	}

	/// Create a blank QRCode with a custom QR code generation engine
	@objc public init(generator: QRCodeEngine) {
		self.generator = generator
		super.init()
		self.update(data: Data(), errorCorrection: .default)
	}

	/// Create a QRCode with the given data and error correction
	/// - Parameters:
	///   - data: The initial data to display
	///   - errorCorrection: The initial error correction to use
	///   - generator: The QR engine to use. Specify nil to use the default generator.
	@objc public init(
		_ data: Data,
		errorCorrection: ErrorCorrection = .default,
		generator: QRCodeEngine? = nil
	) {
		if let generator = generator { self.generator = generator }
		super.init()
		self.update(data: data, errorCorrection: errorCorrection)
	}

	/// Create a QRCode with the given text and error correction
	@objc public init(
		utf8String: String,
		errorCorrection: ErrorCorrection = .default,
		generator: QRCodeEngine? = nil
	) {
		if let generator = generator { self.generator = generator }
		super.init()
		self.update(text: utf8String, errorCorrection: errorCorrection)
	}

	/// Create a QRCode with the given message and error correction
	@objc public init(
		message: QRCodeMessageFormatter,
		errorCorrection: ErrorCorrection = .default,
		generator: QRCodeEngine? = nil
	) {
		if let generator = generator { self.generator = generator }
		super.init()
		self.update(message: message, errorCorrection: errorCorrection)
	}

	/// The QR code content as a 2D array of bool values
	public internal(set) var current = BoolMatrix()

	/// Returns a copy of the boolean matrix representation of the current QR code data
	@objc var boolMatrix: BoolMatrix { self.current }

	// Private
	private let DefaultPDFResolution: CGFloat = 72

	// The pixel design to use for drawing the pixel background color
	internal let onPixelBackgroundDesign: QRCode.Design = {
		let d = QRCode.Design()
		d.shape.offPixels = QRCode.PixelShape.Square()
		return d
	}()

	// The pixel design to use for drawing the pixel background color
	internal let offPixelBackgroundDesign: QRCode.Design = {
		let d = QRCode.Design()
		d.shape.offPixels = QRCode.PixelShape.Square()
		return d
	}()

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
	@objc func update(data: Data, errorCorrection: ErrorCorrection) {
		self.currentErrorCorrection = errorCorrection
		if let result = self.generator.generate(data: data, errorCorrection: errorCorrection) {
			self.current = result
		}
	}

	/// Build the QR Code using the given message formatter and error correction
	@objc func update(message: QRCodeMessageFormatter, errorCorrection: ErrorCorrection = .default) {
		self.update(data: message.data, errorCorrection: errorCorrection)
	}

	/// Build the QR Code using the given text and error correction
	@objc func update(text: String, errorCorrection: ErrorCorrection = .default) {
		self.currentErrorCorrection = errorCorrection
		if let result = self.generator.generate(text: text, errorCorrection: errorCorrection) {
			self.current = result
		}
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
