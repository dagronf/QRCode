//
//  CGImage+codable.swift
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

// Codable support for CGImage

#if canImport(CoreGraphics)

import CoreGraphics.CGImage
import Foundation

/// A codable wrapper for CGImage
struct CGImageCodable: Codable {
	enum ImageCodingError: Error {
		case InvalidData
		case UnableToConvertImageToPNG
	}
	let image: CGImage
	init(_ image: CGImage) { self.image = image }
}

extension CGImageCodable {
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let imageData = try container.decode(Data.self)
		guard let image = DSFImage(data: imageData)?.cgImage() else {
			throw ImageCodingError.InvalidData
		}
		self.image = image
	}
	func encode(to encoder: Encoder) throws {
		guard let pngData = self.image.pngRepresentation() else {
			throw ImageCodingError.UnableToConvertImageToPNG
		}
		var container = encoder.singleValueContainer()
		try container.encode(pngData)
	}
}

#endif
