//
//  NSImage+extensions.swift
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

#if os(macOS)

import AppKit
import Foundation

extension NSImage {
	/// Returns a png representation of the current image.
	func pngRepresentation() -> Data? {
		guard
			let tiff = self.tiffRepresentation,
			let tiffData = NSBitmapImageRep(data: tiff)
		else {
			return nil
		}
		return tiffData.representation(using: .png, properties: [:])
	}

	/// Returns a jpeg representation of the current image.
	func jpegRepresentation(compression: Double = 0.9) -> Data? {
		guard
			(0.0 ... 1.0).contains(compression),
			let tiff = self.tiffRepresentation,
			let tiffData = NSBitmapImageRep(data: tiff)
		else {
			return nil
		}
		return tiffData.representation(using: .jpeg, properties: [.compressionFactor: compression])
	}

	func cgImage() -> CGImage? {
		self.cgImage(forProposedRect: nil, context: nil, hints: nil)
	}
}

#else

import UIKit.UIImage

extension UIImage {
	func cgImage() -> CGImage? { self.cgImage }
}

#endif
