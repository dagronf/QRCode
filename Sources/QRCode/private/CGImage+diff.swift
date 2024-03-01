//
//  CGImage+diff.swift
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

#if canImport(CoreImage)

import Foundation
import CoreGraphics
import CoreImage

enum ImageDiffError: LocalizedError {
	case failedToCreateFilter
	case failedToCreateContext
	case cannotGenerateOutput
}

extension CGImage {
	/// Determine a fractional difference value between two images (pixel based)
	/// - Parameters:
	///   - image1: The first image to compare
	///   - image2: The second image to compare
	/// - Returns: A fractional value (0 -> 1) indicating the maximum difference value between the two images
	///
	/// This comparison routine is fairly basic, basically taking the pixel difference between the two images
	/// and then working out the maximum difference values for the r,g,b components.
	static func diff(_ image1: CGImage, _ image2: CGImage) throws -> CGFloat {
		guard
			let df = CIFilter(name: "CIDifferenceBlendMode"),
			let am = CIFilter(name: "CIAreaMaximum")
		else {
			throw ImageDiffError.failedToCreateFilter
		}
		
		let ciimage1 = CIImage(cgImage: image1)
		let ciimage2 = CIImage(cgImage: image2)
		
		df.setDefaults()
		df.setValue(ciimage1, forKey: kCIInputImageKey)
		df.setValue(ciimage2, forKey: kCIInputBackgroundImageKey)
		
		am.setDefaults()
		am.setValue(df.outputImage, forKey: kCIInputImageKey)
		
		let compareRect = CGRect(origin: .zero, size: image1.size)
		let extent = CIVector(cgRect: compareRect)
		am.setValue(extent, forKey: kCIInputExtentKey)
		
		// The filters have been setup, now set up the CGContext bitmap context the
		// output is drawn to. Setup the context with our supplied buffer.
		let alphaInfo = CGImageAlphaInfo.premultipliedLast
		let bitmapInfo = CGBitmapInfo(rawValue: alphaInfo.rawValue)
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		
		var buf: [UInt8] = Array<UInt8>(repeating: 255, count: 16)
		guard let context = CGContext(
			data: &buf,
			width: 1,
			height: 1,
			bitsPerComponent: 8,
			bytesPerRow: 16,
			space: colorSpace,
			bitmapInfo: bitmapInfo.rawValue
		) else {
			throw ImageDiffError.failedToCreateContext
		}
		
		let ciContextOpts = [
			CIContextOption.workingColorSpace: colorSpace,
			CIContextOption.useSoftwareRenderer: false
		] as [CIContextOption : Any]
		let ciContext = CIContext(cgContext: context, options: ciContextOpts)
		
		guard let valueImage = am.outputImage else { throw ImageDiffError.cannotGenerateOutput }
		ciContext.draw(valueImage, in: CGRect(x: 0, y: 0, width: 1, height: 1), from: valueImage.extent)
		
		// The first three bytes represent the R,G,B maximum components
		let maxVal = buf.prefix(3).max() ?? 255
		return CGFloat(maxVal) / 255.0
	}
}

#endif
