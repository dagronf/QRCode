//
//  QRCode+Message+Mail.swift
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
	/// A formattter for a generating a QRCode containing a link for generating an email
	@objc(QRCodeMessageMail) class Mail: NSObject, QRCodeMessageFormatter {
		public let data: Foundation.Data
		@objc public init?(mailTo: String, subject: String? = nil, body: String? = nil) {
			// mailto:blah%40noodle.com?subject=This%20is%20a%20test&cc=zomb%40att.com&bcc=catpirler%40superbalh.eu&body=Noodles%20and%20fish%21
			guard let mt = mailTo.urlQuerySafe else { return nil }
			var msg = "mailto:\(mt)"

			var queryItems: [URLQueryItem] = []
			if let s = subject?.urlQuerySafe { queryItems.append(URLQueryItem(name: "subject", value: s)) }
			if let b = body?.urlQuerySafe { queryItems.append(URLQueryItem(name: "body", value: b)) }

			var u = URLComponents()
			u.queryItems = queryItems
			if let q = u.query, q.count > 0 {
				msg += "?\(q)"
			}
			self.data = msg.data(using: .utf8) ?? Foundation.Data()
		}
	}
}
