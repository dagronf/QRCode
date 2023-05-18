//
//  QRCode+Content.swift
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

extension QRCode {
	/// Content class for wrapping QR code 'data'
	internal class Content: Codable {
		@inlinable var data: Data {
			get { _data }
			set { self._data = newValue }
		}

		@inlinable var utf8: String? {
			get {
				String(data: _data, encoding: .utf8)
			}
			set {
				_data = newValue?.data(using: .utf8) ?? Data()
			}
		}

		@inlinable init(_ data: Data = Data()) {
			self._data = data
		}

		@inlinable init(_ utf8Text: String) {
			self._data = utf8Text.data(using: .utf8) ?? Data()
		}

		private var _data: Data

		// MARK: Codable

		enum CodingKeys: CodingKey {
			case data
			case text
		}

		public required init(from decoder: Decoder) throws {
			let container = try decoder.container(keyedBy: Self.CodingKeys)
			if let data = try container.decodeIfPresent(Data.self, forKey: .data) {
				self._data = data
			}
			else if let text = try container.decodeIfPresent(String.self, forKey: .text) {
				self._data = text.data(using: .utf8) ?? Data()
			}
			else {
				self._data = Data()
			}
		}

		public func encode(to encoder: Encoder) throws {
			var container = encoder.container(keyedBy: Self.CodingKeys)
			if let text = self.utf8 {
				try container.encode(text, forKey: .text)
			}
			else {
				try container.encode(_data, forKey: .data)
			}
		}
	}
}
