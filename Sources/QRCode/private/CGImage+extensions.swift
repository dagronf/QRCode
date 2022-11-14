//
//  CGImage+extensions.swift
//
//  Copyright © 2022 Darren Ford. All rights reserved.
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

import CoreGraphics
import ImageIO

extension CGImage {
	/// Create a png representation of the CGImage
	func pngRepresentation() -> Data? {
		guard
			let mutableData = CFDataCreateMutable(nil, 0),
			let destination = CGImageDestinationCreateWithData(mutableData, "public.png" as CFString, 1, nil)
		else {
			return nil
		}

		CGImageDestinationAddImage(destination, self, nil)
		CGImageDestinationFinalize(destination)

		return mutableData as Data
	}

	/// Create a CGImage from a png data representation
	static func fromPNGData(_ data: Data) -> CGImage? {
		guard let provider = CGDataProvider(data: data as CFData) else { return nil }
		return CGImage(pngDataProviderSource: provider, decode: nil, shouldInterpolate: false, intent: .defaultIntent)
	}

	/// Create a CGImage from a PNG file
	static func fromPNGFile(_ fileURL: URL) -> CGImage? {
		guard let provider = CGDataProvider(url: fileURL as CFURL) else { return nil }
		return CGImage(pngDataProviderSource: provider, decode: nil, shouldInterpolate: false, intent: .defaultIntent)
	}
}
