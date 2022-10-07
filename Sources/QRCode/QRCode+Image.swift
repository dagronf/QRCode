//
//  QRCode+Image.swift
//
//  Created by Darren Ford on 12/12/21.
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

import CoreGraphics
import Foundation

// MARK: - Imaging

public extension QRCode {
	/// Returns a CGImage representation of the qr code using the specified style
	/// - Parameters:
	///   - dimension: The dimension of the image to generate
	///   - design: The design for the qr code
	/// - Returns: The image, or nil if an error occurred
	@objc func cgImage(
		dimension: CGFloat,
		design: QRCode.Design = QRCode.Design()
	) -> CGImage? {
		self.cgImage(CGSize(dimension: dimension), design: design)
	}

	/// Returns a CGImage representation of the qr code using the specified style
	/// - Parameters:
	///   - size: The pixel size of the image to generate
	///   - design: The design for the qr code
	/// - Returns: The image, or nil if an error occurred
	@objc func cgImage(
		_ size: CGSize,
		design: QRCode.Design = QRCode.Design()
	) -> CGImage? {
		let width = Int(size.width)
		let height = Int(size.height)
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		guard let context = CGContext(
			data: nil,
			width: width,
			height: height,
			bitsPerComponent: 8,
			bytesPerRow: 0,
			space: colorSpace,
			bitmapInfo: bitmapInfo.rawValue
		)
		else {
			return nil
		}

		context.scaleBy(x: 1, y: -1)
		context.translateBy(x: 0, y: -size.height)

		// Draw the qr with the required styles
		self.draw(ctx: context, rect: CGRect(origin: .zero, size: size), design: design)

		let im = context.makeImage()
		return im
	}

	/// Returns an pdf representation of the qr code using the specified style
	/// - Parameters:
	///   - size: The page size of the generated PDF
	///   - pdfResolution: The resolution of the pdf output
	///   - design: The design to use when generating the pdf output
	/// - Returns: A data object containing the PDF representation of the QR code
	@objc func pdfData(
		_ size: CGSize,
		pdfResolution: CGFloat = 72.0,
		design: QRCode.Design = QRCode.Design()
	) -> Data? {
		// Create a PDF context with a single page, and draw into that
		return UsingSinglePagePDFContext(size: size, pdfResolution: pdfResolution) { ctx, drawRect in

			// Need to flip the PDF context as it begins at the bottom right. We want top left.
			let af = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: drawRect.height)
			ctx.concatenate(af)

			// Draw the qr with the required styles
			self.draw(ctx: ctx, rect: drawRect, design: design)
		}
	}

	/// Return a PNG representation of the QR code
	/// - Parameters:
	///   - dimension: The dimensions of the image to create
	///   - design: The design for the QR Code
	/// - Returns: The PNG data
	@objc func pngData(
		dimension: CGFloat,
		design: QRCode.Design = QRCode.Design()
	) -> Data? {
#if os(macOS)
		guard let image = self.nsImage(CGSize(width: dimension, height: dimension), design: design) else {
			return nil
		}
		return image.pngRepresentation
#else
		guard let image = self.uiImage(CGSize(width: dimension, height: dimension), design: design) else {
			return nil
		}
		return image.pngData()
#endif
	}

	/// Draw the current qrcode into the context using the specified style
	@objc func draw(ctx: CGContext, rect: CGRect, design: QRCode.Design) {
		let style = design.style

		// Fill the background first
		let backgroundStyle = style.background ?? QRCode.FillStyle.clear
		ctx.usingGState { context in
			backgroundStyle.fill(ctx: context, rect: rect)
		}

		// Draw the background color behind the eyes
		if let eColor = design.style.eyeBackground {
			let eyeBackgroundPath = self.path(rect.size, components: .eyeBackground, shape: design.shape)
			ctx.usingGState { context in
				ctx.setFillColor(eColor)
				ctx.addPath(eyeBackgroundPath)
				ctx.fillPath()
			}
		}

		// Draw the outer eye
		let eyeOuterPath = self.path(rect.size, components: .eyeOuter, shape: design.shape)
		ctx.usingGState { context in
			style.actualEyeStyle.fill(ctx: context, rect: rect, path: eyeOuterPath)
		}

		// Draw the eye 'pupil'
		let eyePupilPath = self.path(rect.size, components: .eyePupil, shape: design.shape)
		ctx.usingGState { context in
			style.actualPupilStyle.fill(ctx: context, rect: rect, path: eyePupilPath)
		}

		// Now, the 'on' pixels background
		if let c = design.style.onPixelsBackground {
			onPixelBackgroundDesign.style.onPixels = QRCode.FillStyle.Solid(c)
			let qrPath2 = self.path(rect.size, components: .onPixels, shape: onPixelBackgroundDesign.shape)
			ctx.usingGState { context in
				onPixelBackgroundDesign.style.onPixels.fill(ctx: context, rect: rect, path: qrPath2)
			}
		}

		// Now, the 'on' pixels
		let qrPath = self.path(rect.size, components: .onPixels, shape: design.shape)
		ctx.usingGState { context in
			style.onPixels.fill(ctx: context, rect: rect, path: qrPath)
		}

		// The 'off' pixels ONLY IF the user specifies both a offPixels shape AND an offPixels style.
		if let s = style.offPixels, let _ = design.shape.offPixels {

			// Draw the 'off' pixels background IF the caller has set a color
			if let c = design.style.offPixelsBackground {
				offPixelBackgroundDesign.style.offPixels = QRCode.FillStyle.Solid(c)
				let qrPath2 = self.path(rect.size, components: .offPixels, shape: offPixelBackgroundDesign.shape)
				ctx.usingGState { context in
					offPixelBackgroundDesign.style.offPixels?.fill(ctx: context, rect: rect, path: qrPath2)
				}
			}

			let qrPath = self.path(rect.size, components: .offPixels, shape: design.shape)
			ctx.usingGState { context in
				s.fill(ctx: context, rect: rect, path: qrPath)
			}
		}
	}
}
