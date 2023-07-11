//
//  QRCode+Message+Contact.swift
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
	@objc(QRCodeMessageContact) class Contact: NSObject, QRCodeMessageFormatter {
		@objc(QRCodeMessageContactName) public class Name: NSObject {
			public let lastName: String?
			public let firstName: String?
			public let additionalName: String?
			public let namePrefix: String? // eg Mr., Mrs., Dr.
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

			/// VCard encoding for a contact name
			///
			/// name (semicolon separated: LASTNAME; FIRSTNAME; ADDITIONAL NAME; NAME PREFIX(Mr.,Mrs.); NAME SUFFIX) (*required)
			@objc public var vcard: String {
				"N:\(self.lastName ?? "");\(self.firstName ?? "");\(self.additionalName ?? "");\(self.namePrefix ?? "");\(self.nameSuffix ?? "")\n"
			}
		}
		
		// Post Office Address; Extended Address; Street; Locality; Region; Postal Code; Country
		@objc(QRCodeMessageContactAddress) public class Address: NSObject {
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

			/// VCard encoding for an address
			@objc public var vcard: String {
				return "ADR;TYPE=\(self.type):\(self.postOfficeAddress ?? "");\(self.extendedAddress ?? "");\(self.street ?? "");\(self.locality ?? "");\(self.region ?? "");\(self.postalCode ?? "");\(self.country ?? "")\n"
			}
		}

		/// The VCard encoding
		@objc public let vcard: String

		/// The VCard utf8 data encoding
		@objc public let data: Foundation.Data
		
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
			name: Contact.Name,
			formattedName: String,
			addresses: [Contact.Address] = [],
			organization: String?,
			title: String? = nil,
			telephone: [String] = [],
			email: [String] = [],
			urls: [URL] = [],
			notes: [String] = []
		) {
			var msg: String = "BEGIN:VCARD\nVERSION:3.0\n"
			
			// name (semicolon separated: LASTNAME; FIRSTNAME; ADDITIONAL NAME; NAME PREFIX(Mr.,Mrs.); NAME SUFFIX) (*required)
			msg += name.vcard
			
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

			self.vcard = msg
			guard let vcardData = msg.data(using: .utf8) else { return nil }
			self.data = vcardData
		}
	}
}
