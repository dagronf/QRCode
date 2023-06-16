//
//  QRCode+Conveniences.swift
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

// Some conveniences for creating and detecting QR codes

import Foundation
import CoreGraphics

public extension CGImage {
	/// Create a CGImage containing a qr code
	/// - Parameters:
	///   - text: The text to encode in the qr code
	///   - dimension: The size in pixels of the output image
	///   - errorCorrection: The error correction
	///   - shape: The shape to use, or nil for default
	///   - style: The style to use, or nil for default
	/// - Returns: The image representation of the qr code, or nil if an error occurred
	static func qrCode(
		_ text: String,
		dimension: Int,
		errorCorrection: QRCode.ErrorCorrection = .high,
		shape: QRCode.Shape? = nil,
		style: QRCode.Style? = nil
	) -> CGImage? {
		let doc = QRCode.Document(utf8String: text, errorCorrection: errorCorrection)
		if let shape = shape { doc.design.shape = shape }
		if let style = style { doc.design.style = style }
		return doc.cgImage(dimension: dimension)
	}

	/// Create a CGImage containing a qr code
	/// - Parameters:
	///   - text: The text to encode in the qr code
	///   - dimension: The size in pixels of the output image
	///   - foregroundColor: The foreground color
	///   - foregroundColor: The background color, or nil for default
	///   - errorCorrection: The error correction
	/// - Returns: The image representation of the qr code, or nil if an error occurred
	static func qrCode(
		_ text: String,
		dimension: Int,
		foregroundColor: CGColor,
		backgroundColor: CGColor? = nil,
		errorCorrection: QRCode.ErrorCorrection = .high,
		shape: QRCode.Style? = nil
	) -> CGImage? {
		let doc = QRCode.Document(utf8String: text, errorCorrection: errorCorrection)
		doc.design.foregroundColor(foregroundColor)
		doc.design.backgroundColor(backgroundColor)
		return doc.cgImage(dimension: dimension)
	}
}

public extension CGPath {
	/// Simple convenience for creating a CGPath representation of a qr code
	/// - Parameters:
	///   - text: The text to encode in the qr code
	///   - dimension: The size in pixels of the output image
	///   - errorCorrection: The error correction
	///   - shape: The shape to use, or nil for default
	/// - Returns: The path representation of the qr code, or nil if an error occurred
	static func qrCode(
		_ text: String,
		dimension: Int,
		errorCorrection: QRCode.ErrorCorrection = .high,
		shape: QRCode.Shape? = nil
	) -> CGPath? {
		let doc = QRCode.Document(utf8String: text, errorCorrection: errorCorrection)
		if let shape = shape { doc.design.shape = shape }
		return doc.path(dimension: dimension)
	}
}

#if !os(watchOS)
public extension CGImage {
	/// Returns all qrcode messages that were encoded in this image
	/// - Returns: An array of detected qr code strings
	func qrCodedMessages() -> [String] {
		let features = QRCode.DetectQRCodes(self)
		return features.compactMap { $0.messageString }
	}
}
#endif
