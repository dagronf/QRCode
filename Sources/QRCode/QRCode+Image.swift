//
//  QRCode+Image.swift
//
//  Created by Darren Ford on 12/12/21.
//  Copyright © 2021 Darren Ford. All rights reserved.
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
		) else {
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

	/// Draw the current qrcode into the context using the specified style
	@objc func draw(ctx: CGContext, rect: CGRect, design: QRCode.Design) {

		let style = design.style

		// Fill the background first
		let backgroundStyle = style.background ?? QRCode.FillStyle.clear
		ctx.usingGState { context in
			backgroundStyle.fill(ctx: context, rect: rect)
		}

		// Draw the outer eye
		let eyeOuterPath = self.path(rect.size, components: .eyeOuter, shape: design.shape)
		ctx.usingGState { context in
			let outerStyle = style.eye ?? style.data
			outerStyle.fill(ctx: context, rect: rect, path: eyeOuterPath)
		}

		// Draw the eye 'pupil'
		let eyePupilPath = self.path(rect.size, components: .eyePupil, shape: design.shape)
		ctx.usingGState { context in
			let pupilStyle = style.pupil ?? style.eye ?? style.data
			pupilStyle.fill(ctx: context, rect: rect, path: eyePupilPath)
		}

		// Now, the 'on' pixels
		let qrPath = self.path(rect.size, components: .onPixels, shape: design.shape)
		ctx.usingGState { context in
			style.data.fill(ctx: context, rect: rect, path: qrPath)
		}

		// The 'off' pixels ONLY IF the user specifies both a data inverted shape AND a data inverted style.
		if let s = style.dataInverted, let _ = design.shape.dataInverted {
			let qrPath = self.path(rect.size, components: .offPixels, shape: design.shape)
			ctx.usingGState { context in
				s.fill(ctx: context, rect: rect, path: qrPath)
			}
		}
	}
}
