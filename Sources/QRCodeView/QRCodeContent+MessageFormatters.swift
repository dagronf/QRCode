//
//  QRCodeContent+MessageFormatters.swift
//
//  Created by Darren Ford on 10/11/21.
//  Copyright © 2021 Darren Ford. All rights reserved.
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

/// Protocol for generating data from a formatted QR Code message
@objc public protocol QRCodeMessageFormatter {
	var data: Data { get }
}

// MARK: - Data

@objc public class QRCodeData: NSObject, QRCodeMessageFormatter {
	public let data: Data
	@objc public init(_ data: Data) {
		self.data = data
	}
}

// MARK: - Text

/// A simple text formatter.
@objc public class QRCodeText: NSObject, QRCodeMessageFormatter {
	public let data: Data
	@objc public init?(_ content: String) {
		guard let msg = content.data(using: .utf8) else { return nil }
		self.data = msg
	}
}

// MARK: - Link

/// A formattter for a generating a QRCode with a url (link)
@objc public class QRCodeLink: NSObject, QRCodeMessageFormatter {
	public let data: Data
	/// Create using a url
	@objc public init(_ url: URL) {
		let msg = url.absoluteString
		self.data = msg.data(using: .utf8) ?? Data()
	}
	/// Create using the string representation of a URL
	@objc public init?(string: String) {
		guard
			let url = URL(string: string),
			let msg = url.absoluteString.data(using: .utf8) else
		{
			return nil
		}
		self.data = msg
	}
}

// MARK: - Email

/// A formattter for a generating a QRCode containing a link for generating an email
@objc public class QRCodeMail: NSObject, QRCodeMessageFormatter {
	public let data: Data
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
		self.data = msg.data(using: .utf8) ?? Data()
	}
}

// MARK: - Phone

/// A formattter for a generating a QRCode with a telephone number
@objc public class QRCodePhone: NSObject, QRCodeMessageFormatter {
	public let data: Data
	@objc public init(_ phoneNumber: String) {
		let numbersOnly = phoneNumber.filter { $0.isNumber || $0 == "+" }
		// TEL:(+)12342341234
		let msg = "TEL:\(numbersOnly)"
		self.data = msg.data(using: .utf8) ?? Data()
	}
}

// MARK: - VCARD

/*

 BEGIN:VCARD
 VERSION:3.0
 N:qwer;aside
 FN:aside qwer
 ORG:SperNoddle
 TITLE:Zoo Exciter
 ADR:;;123 Happy Street;NoodleVille;Wyoming;123124;Zooperland
 TEL:23452345
 TEL:765474567
 TEL:867585698
 EMAIL:n@1.com
 EMAIL:b@2.com
 EMAIL:x@3.com
 URL:http://kombucha.org
 END:VCARD

 */

/// A formattter for a generating a QRCode with a VCard attached
///
/// https://www.evenx.com/vcard-3-0-format-specification
@objc public class QRCodeContact: NSObject, QRCodeMessageFormatter {

	@objc(QRCodeContactName) public class Name: NSObject {
		public let lastName: String?
		public let firstName: String?
		public let additionalName: String?
		public let namePrefix: String?        // eg Mr., Mrs., Dr.
		public let nameSuffix: String?
		@objc public init(
			lastName: String? = nil,
			firstName: String? = nil,
			additionalName: String? = nil,
			namePrefix: String? = nil,
			nameSuffix: String? = nil
		) {
			self.lastName = lastName
			self.firstName = firstName
			self.additionalName = additionalName
			self.namePrefix = namePrefix
			self.nameSuffix = nameSuffix
		}

		var vcard: String {
			"N:\(lastName ?? "");\(firstName ?? "");\(additionalName ?? "");\(namePrefix ?? "");\(nameSuffix ?? "")\n"
		}
	}

	// Post Office Address; Extended Address; Street; Locality; Region; Postal Code; Country
	@objc(QRCodeContactAddress) public class Address: NSObject {
		public let type: String
		public let postOfficeAddress: String?
		public let extendedAddress: String?
		public let street: String?
		public let locality: String?
		public let region: String?
		public let postalCode: String?
		public let country: String?

		/// Create an address for a VCARD style QR Code
		/// - Parameters:
		///   - type: The type of address represented (dom(domestic), intl(international), postal, parcel, home, work)
		///   - postOfficeAddress: Post Office Address
		///   - extendedAddress: Extended Address
		///   - street: Street (eg. 123 Main Street)
		///   - locality: Locality (eg. San Francisco)
		///   - region: The region specifier (eg. CA)
		///   - postalCode: Post code (eg. 91921)
		///   - country: Country (eg. USA)
		@objc public init(
			type: String,
			postOfficeAddress: String? = nil,
			extendedAddress: String? = nil,
			street: String? = nil,
			locality: String? = nil,
			region: String? = nil,
			postalCode: String? = nil,
			country: String? = nil
		) {
			self.type = type
			self.postOfficeAddress = postOfficeAddress
			self.extendedAddress = extendedAddress
			self.street = street
			self.locality = locality
			self.region = region
			self.postalCode = postalCode
			self.country = country
		}

		var vcard: String {
			return "ADR;TYPE=\(type):\(postOfficeAddress ?? "");\(extendedAddress ?? "");\(street ?? "");\(locality ?? "");\(region ?? "");\(postalCode ?? "");\(country ?? "")\n"
		}
	}

	public let data: Data

	/// Create a QR Code that contains a VCard
	/// - Parameters:
	///   - name: The name to be used for the card
	///   - formattedName: The name as it is to be displayed
	///   - addresses: User's addresses
	///   - organization: User's organization
	///   - title: Job title, functional position or function
	///   - telephone: An array of phone numbers. Format is (+)number, eg. +61000000000
	///   - email: An array of email addresses (simple text, not validated)
	///   - urls: Associated URLs
	///   - notes: Some text to be attached to the card
	@objc public init?(
		name: QRCodeContact.Name,
		formattedName: String,
		addresses: [QRCodeContact.Address] = [],
		organization: String?,
		title: String? = nil,
		telephone: [String] = [],
		email: [String] = [],
		urls: [URL] = [],
		notes: [String] = [])
	{
		var msg: String = "BEGIN:VCARD\nVERSION:3.0\n"

		// name (semicolon separated: LASTNAME; FIRSTNAME; ADDITIONAL NAME; NAME PREFIX(Mr.,Mrs.); NAME SUFFIX) (*required)
		msg += "N:\(name.lastName ?? "");\(name.firstName ?? "");\(name.additionalName ?? "");\(name.namePrefix ?? "");\(name.nameSuffix ?? "")\n"

		// formatted name (The way that the name is to be displayed. It can contain desired honorific prefixes, suffixes, titles.)(*required)
		msg += "FN:\(formattedName)\n"

		// formatted addresses
		addresses.forEach { msg += $0.vcard }

		// organization
		if let o = organization { msg += "ORG:\(o)\n" }

		// title
		if let t = title { msg += "TITLE:\(t)\n" }

		// Emails
		email.forEach { msg += "EMAIL:\($0)\n" }

		// Telephone numbers
		telephone.forEach { msg += "TEL:\($0)\n" }

		// The urls
		urls.forEach { msg += "URL:\($0.absoluteString)\n" }

		// Notes
		notes.forEach { note in
			// Escape any commas with a backslash
			var n = note.replacingOccurrences(of: ",", with: "\\,")
			// Replace any \n \r etc. with a space
			n = n.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
			msg += "NOTE:\(n)\n"
		}

		msg += "END:VCARD"

		guard let vcardData = msg.data(using: .utf8) else { return nil }
		self.data = vcardData
	}
}
