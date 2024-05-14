//
//  QRCode+Message+SMS.swift
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
	/// A formattter for a generating a QRCode with an SMS
	///
	/// SMSTO:+401274159:This is the message
	@objc(QRCodeMessageSMS) class SMS: NSObject, QRCodeMessageFormatter {
		/// The encoded data
		public let data: Foundation.Data
		/// The content to be displayed in the qr code
		public let text: String?

		/// Create a message containing an SMS message
		/// - Parameters:
		///   - mobileNumber: The mobile number in the format `(+)12342341234`
		///   - message: The message to encode
		public init(_ mobileNumber: String, message: String) throws {
			let numbersOnly = mobileNumber.filter { $0.isNumber || $0 == "+" }
			// TEL:(+)12342341234
			self.text = "SMSTO:\(numbersOnly):\(message)"

			guard let msgData = self.text?.data(using: .utf8) else {
				throw QRCodeError.unableToConvertTextToRequestedEncoding
			}

			self.data = msgData
		}
	}
}
