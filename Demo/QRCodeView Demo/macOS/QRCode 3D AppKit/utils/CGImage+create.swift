//
//  Copyright © 2025 Darren Ford. All rights reserved.
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

// Conveniences for making a CGImage and drawing into it

import CoreGraphics
import Foundation

/// Errors for making a CGImage
enum CGImageMakeError: Error {
	case InvalidContext
	case CannotMakeImage
}

extension CGImage {
	/// Make a CGImage and draw into it
	/// - Parameters:
	///   - width: The width of the resuling image
	///   - height: The height of the resuling image
	///   - flipped: Vertically flip the drawing
	///   - block: The block containing the drawing
	/// - Returns: A new CGImage
	static func makeImage(
		width: Int,
		height: Int,
		flipped: Bool = true,
		_ block: (CGContext) -> Void
	) throws -> CGImage {
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
		guard let ctx = CGContext(
			data: nil,
			width: width,
			height: height,
			bitsPerComponent: 8,
			bytesPerRow: width * 4,
			space: colorSpace,
			bitmapInfo: bitmapInfo.rawValue
		)
		else {
			throw CGImageMakeError.InvalidContext
		}

		if flipped {
			ctx.scaleBy(x: 1, y: -1)
			ctx.translateBy(x: 0, y: Double(-height))
		}
		block(ctx)

		guard let img = ctx.makeImage() else {
			throw CGImageMakeError.CannotMakeImage
		}

		return img
	}

	/// Make a CGImage and draw into it
	/// - Parameters:
	///   - dimension: The dimension of the time
	///   - flipped: Vertically flip the drawing
	///   - block: The block containing the drawing
	/// - Returns: A new CGImage
	static func makeImage(dimension: Int, flipped: Bool = true, _ block: (CGContext) -> Void) throws -> CGImage {
		try CGImage.makeImage(width: dimension, height: dimension, flipped: flipped, block)
	}
}
