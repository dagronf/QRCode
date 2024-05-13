//
//  QRCode+Message+Data.swift
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

// MARK: - Raw data

public extension QRCode.Message {
	/// Simple data
	@objc(QRCodeMessageData) class Data: NSObject, QRCodeMessageFormatter {
		/// The encoded data
		public let data: Foundation.Data

		/// A raw binary data message
		/// - Parameter data: The data
		@objc public init(_ data: Foundation.Data) {
			self.data = data
		}
	}
}

// MARK: - Base64 encoded binary data

public extension QRCode.Message {
	/// Simple data encoded using base 64
	@objc(QRCodeMessageDataBase64) class DataBase64: NSObject, QRCodeMessageFormatter {
		/// The encoded data
		public let data: Foundation.Data
		/// The content to be displayed in the qr code
		public let content: String

		/// Create a message containing base64-encoded binary data
		/// - Parameters:
		///   - data: The data
		@objc public convenience init(_ data: Foundation.Data) throws {
			try self.init(data, textEncoding: .utf8)
		}

		/// Create a message containing base64-encoded binary data
		/// - Parameters:
		///   - data: The data
		///   - textEncoding: The string encoding to use
		public init(_ data: Foundation.Data, textEncoding: String.Encoding) throws {
			self.content = data.base64EncodedString()
			guard let msgData = self.content.data(using: textEncoding) else {
				throw QRCodeError.unableToConvertTextToRequestedEncoding
			}
			self.data = msgData
		}
	}
}
