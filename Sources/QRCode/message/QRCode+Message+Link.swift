//
//  QRCode+Message+Link.swift
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

public extension QRCode.Message {
	/// A formattter for a generating a QRCode with a url (link)
	@objc(QRCodeMessageLink) class Link: NSObject, QRCodeMessageFormatter {
		/// The encoded data
		public let data: Foundation.Data
		/// The content to be displayed in the qr code
		public let text: String?

		/// Create a message containing a URL
		/// - Parameters:
		///   - url: The URL to encode
		@objc public init(_ url: URL) throws {
			self.text = url.absoluteString
			guard let msgData = self.text?.data(using: .utf8) else {
				throw QRCodeError.unableToConvertTextToRequestedEncoding
			}
			self.data = msgData
		}

		/// Create using the string representation of a URL (utf8 encoded)
		/// - Parameter string: The string representation of the URL to encode
		@objc public convenience init(string: String) throws {
			guard let url = URL(string: string) else {
				throw QRCodeError.invalidURL
			}
			try self.init(url)
		}
	}
}
