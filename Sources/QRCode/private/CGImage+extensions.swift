//
//  CGImage+extensions.swift
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

import CoreGraphics
import ImageIO

extension CGImage {
	/// Create a png representation of the CGImage
	/// - Parameters:
	///   - scale: (optional) the scale for the resulting image (default 1)
	///   - compression: (optional) the compression level to use (0 ... 1)
	func pngRepresentation(scale: Int = 1, compression: CGFloat? = nil) -> Data? {
		self.pngRepresentation(dpi: 72.0 * CGFloat(scale), compression: compression)
	}

	/// Create a png representation of the CGImage
	/// - Parameters:
	///   - scale: (optional) the dpi for the resulting image (default 72.0)
	///   - compression: (optional) the compression level to use (0 ... 1)
	func pngRepresentation(dpi: CGFloat, compression: CGFloat? = nil) -> Data? {
		var opts: [CFString: Any] = [:]
		if dpi != 1 {
			opts[kCGImagePropertyPixelWidth] = self.width
			opts[kCGImagePropertyPixelHeight] = self.height
			opts[kCGImagePropertyDPIWidth] = dpi
			opts[kCGImagePropertyDPIHeight] = dpi
		}
		if let compression = compression {
			opts[kCGImageDestinationLossyCompressionQuality] = compression
		}

		guard
			let mutableData = CFDataCreateMutable(nil, 0),
			let destination = CGImageDestinationCreateWithData(mutableData, "public.png" as CFString, 1, nil)
		else {
			return nil
		}

		CGImageDestinationAddImage(destination, self, opts as CFDictionary)
		CGImageDestinationFinalize(destination)

		return mutableData as Data
	}
}

extension CGImage {
	/// Create a jpg representation of the CGImage
	/// - Parameters:
	///   - scale: (optional) the scale for the resulting image (default 1)
	///   - compression: (optional) the compression level to use (0 ... 1)
	func jpgRepresentation(scale: Int = 1, compression: CGFloat? = nil) -> Data? {
		self.jpgRepresentation(dpi: 72.0 * CGFloat(scale), compression: compression)
	}

	/// Create a JPG representation for the CGImage
	/// - Parameters:
	///   - dpi: (optional) the dpi for the resulting image (default 72)
	///   - compression: (optional) the compression level to use (0 ... 1)
	/// - Returns: JPEG data for the image
	func jpgRepresentation(dpi: CGFloat, compression: CGFloat? = nil) -> Data? {
		var opts: [CFString: Any] = [:]
		if dpi != 1 {
			opts[kCGImagePropertyPixelWidth] = self.width
			opts[kCGImagePropertyPixelHeight] = self.height
			opts[kCGImagePropertyDPIWidth] = dpi
			opts[kCGImagePropertyDPIHeight] = dpi
		}
		if let compression = compression {
			opts[kCGImageDestinationLossyCompressionQuality] = compression
		}
		guard
			let mutableData = CFDataCreateMutable(nil, 0),
			let destination = CGImageDestinationCreateWithData(mutableData, "public.jpeg" as CFString, 1, nil)
		else {
			return nil
		}

		CGImageDestinationAddImage(destination, self, opts as CFDictionary)
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

extension CGImage {
	static func imageByScalingImageToFill(_ image: CGImage, targetSize: CGSize) -> CGImage? {
		let origSize = CGSize(width: image.width, height: image.height)

		var destWidth: CGFloat = 0
		var destHeight: CGFloat = 0
		let widthRatio = targetSize.width / origSize.width
		let heightRatio = targetSize.height / origSize.height

		// Keep aspect ratio
		if heightRatio > widthRatio {
			destHeight = targetSize.height
			destWidth = origSize.width * targetSize.height / origSize.height
		}
		else {
			destWidth = targetSize.width
			destHeight = origSize.height * targetSize.width / origSize.width
		}

		return Self.Create(size: targetSize) { ctx, targetSize in
			ctx.draw(
				image,
				in: CGRect(
					x: (targetSize.width - destWidth) / 2,
					y: (targetSize.height - destHeight) / 2,
					width: destWidth,
					height: destHeight
				)
			)
		}
	}

	/// Create a CGImage with an sRGB colorspace
	/// - Parameters:
	///   - size: The size of the resulting image
	///   - backgroundColor: The color to fill the created image, or nil for no fill
	///   - drawBlock: A block used to draw content into the new image, or nil for no drawing
	/// - Returns: The created CGImage
	static func Create(
		size: CGSize,
		backgroundColor: CGColor? = nil,
		_ drawBlock: ((CGContext, CGSize) -> Void)? = nil
	) -> CGImage? {
		// Make the context. For the moment, always work in RGBA (CGColorSpace.sRGB)
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		guard
			let space = CGColorSpace(name: CGColorSpace.sRGB),
			let ctx = CGContext(
				data: nil,
				width: Int(size.width),
				height: Int(size.height),
				bitsPerComponent: 8,
				bytesPerRow: 0,
				space: space,
				bitmapInfo: bitmapInfo.rawValue
			)
		else {
			return nil
		}

		// Drawing defaults
		ctx.setShouldAntialias(true)
		ctx.setAllowsAntialiasing(true)
		ctx.interpolationQuality = .high

		// If a background color is set, fill it here
		if let backgroundColor = backgroundColor {
			ctx.saveGState()
			ctx.setFillColor(backgroundColor)
			ctx.fill([CGRect(origin: .zero, size: size)])
			ctx.restoreGState()
		}

		// Perform the draw block
		if let block = drawBlock {
			ctx.saveGState()
			block(ctx, size)
			ctx.restoreGState()
		}

		guard let result = ctx.makeImage() else {
			return nil
		}
		return result
	}
}

extension CGImage {
	/// Create a CGImage and draw onto it
	static func Create(size: CGSize, _ drawBlock: (CGContext) -> Void) -> CGImage? {
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		guard
			let space = CGColorSpace(name: CGColorSpace.sRGB),
			let ctx = CGContext(
				data: nil,
				width: Int(size.width),
				height: Int(size.height),
				bitsPerComponent: 8,
				bytesPerRow: Int(size.width) * 4,
				space: space,
				bitmapInfo: bitmapInfo.rawValue
			)
		else {
			return nil
		}

		drawBlock(ctx)

		return ctx.makeImage()
	}
}

extension CGColor {
	/// Create a CGImage containing a color
	func swatch(size: CGSize = .init(width: 100, height: 100)) -> CGImage? {
		return CGImage.Create(size: size) { ctx in
			ctx.saveGState()
			ctx.setFillColor(self)
			ctx.fill([CGRect(origin: .zero, size: size)])
			ctx.restoreGState()
		}
	}
}
