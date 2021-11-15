//
//  File.swift
//  
//
//  Created by Darren Ford on 10/11/21.
//

import Foundation


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

		// // mailto:blah%40noodle.com?subject=This%20is%20a%20test&cc=zomb%40att.com&bcc=catpirler%40superbalh.eu&body=Noodles%20and%20fish%21
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
	}

	// Post Office Address; Extended Address; Street; Locality; Region; Postal Code; Country
	@objc(QRCodeContactAddress) public class Address: NSObject {
		public let postOfficeAddress: String?
		public let extendedAddress: String?
		public let street: String?
		public let locality: String?
		public let region: String?
		public let postalCode: String?
		public let country: String?
		@objc public init(
			postOfficeAddress: String? = nil,
			extendedAddress: String? = nil,
			street: String? = nil,
			locality: String? = nil,
			region: String? = nil,
			postalCode: String? = nil,
			country: String? = nil
		) {
			self.postOfficeAddress = postOfficeAddress
			self.extendedAddress = extendedAddress
			self.street = street
			self.locality = locality
			self.region = region
			self.postalCode = postalCode
			self.country = country
		}
	}

	public let data: Data
	@objc public init(
		name: QRCodeContact.Name,
		formattedName: String,                  // Name as it is presented to the user
		address: QRCodeContact.Address? = nil,  // User's address
		organization: String?,
		title: String? = nil,                   // Job title, functional position or function
		telephone: [String] = [],
		email: [String] = [],
		url: URL? = nil,
		note: String? = nil)
	{

		var msg: String = "BEGIN:VCARD\nVERSION:3.0\n"

		// name (semicolon separated: LASTNAME; FIRSTNAME; ADDITIONAL NAME; NAME PREFIX(Mr.,Mrs.); NAME SUFFIX) (*required)
		msg += "N:\(name.lastName ?? "");\(name.firstName ?? "");\(name.additionalName ?? "");\(name.namePrefix ?? "");\(name.nameSuffix ?? "")\n"

		// formatted name (The way that the name is to be displayed. It can contain desired honorific prefixes, suffixes, titles.)	(*required)
		msg += "FN:\(formattedName)\n"

		if let a = address {
			msg += "N:\(a.postOfficeAddress ?? "");\(a.extendedAddress ?? "");\(a.street ?? "");\(a.locality ?? "");\(a.region ?? "");\(a.postalCode ?? "");\(a.country ?? "")\n"
		}

		if let o = organization {
			msg += "ORG:\(o)\n"
		}

		for e in email {
			msg += "EMAIL:\(e)\n"
		}
		for t in telephone {
			msg += "TEL:\(t)\n"
		}

		if let u = url {
			msg += "URL:\(u.absoluteString)\n"
		}

		if let n = note {
			msg += "NOTE:\(n)\n"
		}

		msg += "END:VCARD"

		self.data = msg.data(using: .utf8) ?? Data()
	}
}
