//
//  QRCode+Message+Event.swift
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

/*
 BEGIN:VEVENT
 SUMMARY:event-title
 LOCATION:event-location
 DTSTART:20240608T173600
 DTEND:20240608T173600
 END:VEVENT
 */

private let _formatString = "yyyyMMdd'T'HHmmss'Z'"

public extension QRCode.Message {
	/// A formattter for a generating a basic event QRCode
	@objc(QRCodeMessageEvent) class Event: NSObject, QRCodeMessageFormatter {
		/// The encoded data
		public let data: Foundation.Data
		/// The content to be displayed in the qr code
		public let text: String?

		/// Create a message containing an event
		/// - Parameters:
		///   - summary: The event summary
		///   - location: The event's location
		///   - start: The start time
		///   - end: The end time
		@objc public init(summary: String, location: String, start: Date, end: Date) throws {

			let summary = summary.removing(charactersIn: "\r\n")
			let location = location.removing(charactersIn: "\r\n")

			var msg = "BEGIN:VEVENT\r\n"
			msg += "SUMMARY:\(summary)\r\n"
			msg += "LOCATION:\(location)\r\n"

			// Convert dates to UTC
			//19980119T070000Z


			let df = DateFormatter()
			df.timeZone = TimeZone(abbreviation: "UTC")
			df.dateFormat = _formatString

			let dtstart = df.string(from: start)
			msg += "DTSTART:\(dtstart)\r\n"
			let dtend = df.string(from: end)
			msg += "DTEND:\(dtend)\r\n"

			msg += "END:VEVENT"

			self.text = msg
			guard let msgData = self.text?.data(using: .utf8) else {
				throw QRCodeError.unableToConvertTextToRequestedEncoding
			}
			self.data = msgData
		}
	}
}
