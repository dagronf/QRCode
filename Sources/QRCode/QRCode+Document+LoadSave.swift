//
//  QRCode+Document+LoadSave.swift
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

import CoreGraphics
import Foundation

// MARK: - Load

public extension QRCode.Document {
	/// Create a QRCode document using the QRCode settings defined in `jsonData`
	/// - Parameters:
	///   - jsonData: The data to display (json format)
	///   - engine: The engine to use when creating the QR code. Defaults to Core Image
	@objc convenience init(jsonData: Data, engine: (any QRCodeEngine)? = nil) throws {
		try self.init(engine: engine)
		try self.load(jsonData: jsonData)
	}

	/// Create a QRCode document using the QRCode settings defined in `dictionary`
	/// - Parameters:
	///   - settings: The dictionary of settings to apply to the document
	///   - engine: The qr code engine to use, or `nil` to use default
	@objc convenience init(settings: [String: Any], engine: (any QRCodeEngine)? = nil) throws {
		try self.init(engine: engine)
		try self.load(settings: settings)
	}

	/// Load the QRCode content from the specified JSON data
	@objc func load(jsonData: Data) throws {
		let s = try JSONSerialization.jsonObject(with: jsonData, options: [])
		guard let settings = s as? [String: Any] else {
			throw NSError(domain: "QRCodeDocument", code: -1, userInfo: [
				NSLocalizedDescriptionKey: "Unable to decode object",
			])
		}
		try self.load(settings: settings)
	}

	/// Load the QRCode content from the specified dictionary
	@objc func load(settings: [String: Any]) throws {
		if let value = settings["data"] as? String,
			let data = Data(base64Encoded: value)
		{
			self.data = data
		}
		else if let text = settings["text"] as? String {
			self.utf8String = text
		}
		else {
			self.data = Data()
		}

		let ec: QRCode.ErrorCorrection = {
			if let value = settings["correction"] as? String,
				let first = value.first,
				let ec = QRCode.ErrorCorrection.Create(first)
			{
				return ec
			}
			return .quantize
		}()
		self.errorCorrection = ec

		if let design = settings["design"] as? [String: Any],
			let d = try? QRCode.Design.Create(settings: design)
		{
			self.design = d
		}

		// Restore the mask

		if let maskSettings = settings["logoTemplate"] as? [String: Any],
			let l = QRCode.LogoTemplate(settings: maskSettings)
		{
			self.logoTemplate = l
		}

		try self.regenerate()
	}

	/// Create a QRCode.Document object from the specified settings
	/// - Parameters:
	///   - settings: The dictionary of settings to apply to the document
	///   - engine: The engine to use, or nil to use the default
	/// - Returns: A QRCode document
	@objc static func Create(settings: [String: Any], engine: (any QRCodeEngine)? = nil) throws -> QRCode.Document {
		let doc = try QRCode.Document(engine: engine)
		try doc.load(settings: settings)
		return doc
	}

	/// Create a QRCode document from the provided json formatted data
	/// - Parameters:
	///   - jsonData: The json formatted qr code to load
	///   - engine: The engine to use, or nil to use the default (watchOS requires QRCode
	/// - Returns: A QRCode document
	@objc static func Create(jsonData: Data, engine: (any QRCodeEngine)? = nil) throws -> QRCode.Document {
		let s = try JSONSerialization.jsonObject(with: jsonData, options: [])

		guard let settings = s as? [String: Any] else {
			throw NSError(domain: "QRCodeDocument", code: -1, userInfo: [
				NSLocalizedDescriptionKey: "Unable to decode object",
			])
		}
		return try QRCode.Document.Create(settings: settings, engine: engine)
	}
}

// MARK: - Save

public extension QRCode.Document {
	/// The current settings for the data, shape and design for the QRCode
	@objc func settings() throws -> [String: Any] {
		var settings: [String: Any] = [
			"correction": errorCorrection.ECLevel,
			"design": try self.design.settings(),
		]
		if let data = self.data {
			settings["data"] = data.base64EncodedString()
		}
		else if let text = self.utf8String {
			settings["text"] = text
		}
		if let l = self.logoTemplate {
			settings["logoTemplate"] = l.settings()
		}
		return settings
	}

	/// Generate a JSON string representation of the document.
	@objc func jsonData() throws -> Data {
		try JSONSerialization.data(withJSONObject: self.settings())
	}

	/// Generate a pretty-printed JSON string representation of the document.
	@objc func jsonStringFormatted() throws -> String {
		let dict = try self.settings()
		if #available(macOS 10.13, *) {
			let data = try JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted, .sortedKeys])
			guard let str = String(data: data, encoding: .utf8) else {
				throw QRCodeError.cannotGenerateJSON
			}
			return str
		}
		else {
			let data = try JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted])
			guard let str = String(data: data, encoding: .utf8) else {
				throw QRCodeError.cannotGenerateJSON
			}
			return str
		}
	}
}
