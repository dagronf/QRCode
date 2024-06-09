//
//  QRCode+Templating.swift
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

// MARK: - Templating conveniences

public extension QRCode.Document {
	/// Apply the design styles from another document to this document
	/// - Parameters:
	///   - document: The document to apply
	///   - includeLogoTemplate: If true, include any logotemplate information
	@objc func applyDesign(from document: QRCode.Document, includeLogoTemplate: Bool = true) throws {
		self.design = try document.design.copyDesign()
		if includeLogoTemplate {
			self.logoTemplate = document.logoTemplate?.copyLogoTemplate()
		}
	}

	/// Create a copy of this document using the design styles from another document
	/// - Parameters:
	///   - document: The document to apply
	///   - includeLogoTemplate: If true, include any logotemplate information
	@objc func applyingDesign(from document: QRCode.Document, includeLogoTemplate: Bool = true) throws -> QRCode.Document {
		let copy = try self.copyDocument()
		try copy.applyDesign(from: document, includeLogoTemplate: includeLogoTemplate)
		return copy
	}
}

public extension QRCode.Document {
	/// Return a new document using the style and design supplied by the template data with the specified text
	@objc static func UsingTemplate(templateJSONData: Data, text: String) throws -> QRCode.Document {
		let doc = try QRCode.Document(jsonData: templateJSONData)
		doc.utf8String = text
		return doc
	}

	/// Return an image using the style and design supplied by the template data with the specified text
	@objc @inlinable static func PNGUsingTemplate(templateJSONData: Data, text: String, dimension: Int) throws -> Data {
		let doc = try Self.UsingTemplate(templateJSONData: templateJSONData, text: text)
		return try doc.pngData(dimension: dimension)
	}

	/// Return a pdf using the style and design supplied by the template data with the specified text
	@objc @inlinable static func PDFUsingTemplate(
		templateJSONData: Data,
		text: String,
		dimension: Int,
		resolution: CGFloat = 72.0
	) throws -> Data {
		let doc = try Self.UsingTemplate(templateJSONData: templateJSONData, text: text)
		return try doc.pdfData(dimension: dimension, pdfResolution: resolution)
	}
}
