//
//  QRCode+Content.swift
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

internal extension QRCode {
	/// QR Code content
	///
	/// Note that data and text are held separately as there are additional compression options
	/// available to text content.
	enum Content: Codable {
		/// Raw binary representation for the QR code
		case data(Data)
		/// Test representation
		case text(String)

		enum CodingKeys: CodingKey {
			case data
			case text
		}

		init(from decoder: any Decoder) throws {
			let container = try decoder.container(keyedBy: QRCode.Content.CodingKeys.self)

			if let data = try container.decodeIfPresent(Data.self, forKey: .data) {
				self = .data(data)
			}
			else if let text = try container.decodeIfPresent(String.self, forKey: .text) {
				self = .text(text)
			}
			else {
				throw QRCodeError.invalidContent
			}
		}

		func encode(to encoder: any Encoder) throws {
			var container = encoder.container(keyedBy: QRCode.Content.CodingKeys.self)
			switch self {
			case let .data(data):
				try container.encode(data, forKey: .data)
			case let .text(text):
				try container.encode(text, forKey: .text)
			}
		}
	}
}
