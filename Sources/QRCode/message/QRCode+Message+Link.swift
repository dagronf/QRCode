//
//  QRCode+Message+Link.swift
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

import Foundation

public extension QRCode.Message {
	/// A formattter for a generating a QRCode with a url (link)
	@objc(QRCodeMessageLink) class Link: NSObject, QRCodeMessageFormatter {
		public let data: Foundation.Data
		/// Create using a url
		@objc public init(_ url: URL) {
			let msg = url.absoluteString
			self.data = msg.data(using: .utf8) ?? Foundation.Data()
		}

		/// Create using the string representation of a URL
		@objc public init?(string: String) {
			guard
				let url = URL(string: string),
				let msg = url.absoluteString.data(using: .utf8)
			else {
				return nil
			}
			self.data = msg
		}
	}
}
