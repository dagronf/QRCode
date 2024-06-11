//
//  QRCode+FormattedContent.swift
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

import Foundation

// A Swift-y convenience for creating a QR Code with different QR Code formatting

// MARK: Swift Initializer convenience

public extension QRCode.Document {
	/// Formatted content
	enum FormattedContent {
		/// A basic string
		case text(String)
		/// Data encoded as Base64
		case base64(Data)
		/// Raw data
		case rawData(Data)
		/// A link (url)
		case link(URL)
		/// A map location (latitude/longitude)
		case location(lat: Double, long: Double)
		/// A phone number
		case phone(phoneNumber: String)
		/// An SMS message
		case sms(mobileNumber: String, message: String)
		/// An event
		case event(summary: String, location: String, start: Date, end: Date)
	}

	/// A convenience initializer for handling specific formatted messages
	/// - Parameters:
	///   - formattedContent: The content to be formatted
	///   - errorCorrection: The error correction level
	///   - engine: The engine to use when creating the QR code
	convenience init(
		_ formattedContent: QRCode.Document.FormattedContent,
		errorCorrection: QRCode.ErrorCorrection = .default,
		engine: (any QRCodeEngine)? = nil
	) throws {
		// Create a basic QR Code with no data
		try self.init(data: Data(), errorCorrection: errorCorrection, engine: engine)
		// Update the formatted content
		try self.setFormattedContent(formattedContent)
	}

	/// Set the QRCode content
	/// - Parameters:
	///   - formattedContent: The formatted content
	///   - errorCorrection: Error correction
	func update(_ formattedContent: FormattedContent, errorCorrection: QRCode.ErrorCorrection = .default) throws {
		self.errorCorrection = errorCorrection
		try self.setFormattedContent(formattedContent)
	}
}

internal extension QRCode.Document {
	/// Create a document using a formatter
	/// - Parameter formattedContent: The formatted content
	func setFormattedContent(_ formattedContent: QRCode.Document.FormattedContent) throws {
		switch formattedContent {
		case .text(let msg):
			self.utf8String = msg
		case .rawData(let data):
			self.data = data
		case .base64(let data):
			self.utf8String = data.base64EncodedString()
		case .link(let url):
			self.utf8String = try QRCode.Message.Link(url).text
		case .location(let lat, let long):
			self.utf8String = try QRCode.Message.Location(latitude: lat, longitude: long).text
		case .phone(let phoneNumber):
			self.utf8String = try QRCode.Message.Phone(phoneNumber).text
		case .sms(let mobileNumber, let message):
			self.utf8String = try QRCode.Message.SMS(mobileNumber, message: message).text
		case .event(let summary, let location, let start, let end):
			self.utf8String = try QRCode.Message.Event(
				summary: summary,
				location: location,
				start: start,
				end: end
			).text
		}
	}
}
