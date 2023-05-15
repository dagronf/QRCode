//
//  QRCode+Image.swift
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

import CoreGraphics
import Foundation

import SwiftImageReadWrite

// MARK: - CGImage

public extension QRCode {
	/// Returns a CGImage representation of the qr code using the specified style
	/// - Parameters:
	///   - dimension: The dimension of the image to generate
	///   - design: The design for the qr code
	/// - Returns: The image, or nil if an error occurred
	@objc func cgImage(
		dimension: Int,
		design: QRCode.Design = QRCode.Design(),
		logoTemplate: QRCode.LogoTemplate? = nil
	) -> CGImage? {
		self.cgImage(CGSize(dimension: dimension), design: design, logoTemplate: logoTemplate)
	}

	/// Returns a CGImage representation of the qr code using the specified style
	/// - Parameters:
	///   - size: The pixel size of the image to generate
	///   - design: The design for the qr code
	/// - Returns: The image, or nil if an error occurred
	@objc func cgImage(
		_ size: CGSize,
		design: QRCode.Design = QRCode.Design(),
		logoTemplate: QRCode.LogoTemplate? = nil
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
		self.draw(ctx: context, rect: CGRect(origin: .zero, size: size), design: design, logoTemplate: logoTemplate)

		let im = context.makeImage()
		return im
	}
}

// MARK: - PDF

public extension QRCode {
	/// Returns an pdf representation of the qr code using the specified style
	/// - Parameters:
	///   - size: The page size of the generated PDF
	///   - pdfResolution: The resolution of the pdf output
	///   - design: The design to use when generating the pdf output
	/// - Returns: A data object containing the PDF representation of the QR code
	@objc func pdfData(
		dimension: Int,
		pdfResolution: CGFloat = 72.0,
		design: QRCode.Design = QRCode.Design(),
		logoTemplate: QRCode.LogoTemplate? = nil
	) -> Data? {
		self.pdfData(
			CGSize(dimension: dimension),
			pdfResolution: pdfResolution,
			design: design,
			logoTemplate: logoTemplate
		)
	}

	/// Returns an pdf representation of the qr code using the specified style
	/// - Parameters:
	///   - size: The page size of the generated PDF
	///   - pdfResolution: The resolution of the pdf output
	///   - design: The design to use when generating the pdf output
	///   - logoTemplate: The logo template to apply to the qr code
	/// - Returns: A data object containing the PDF representation of the QR code
	@objc func pdfData(
		_ size: CGSize,
		pdfResolution: CGFloat = 72.0,
		design: QRCode.Design = QRCode.Design(),
		logoTemplate: QRCode.LogoTemplate? = nil
	) -> Data? {
		// Create a PDF context with a single page, and draw into that
		return UsingSinglePagePDFContext(size: size, pdfResolution: pdfResolution) { ctx, drawRect in

			// Need to flip the PDF context as it begins at the bottom right. We want top left.
			let af = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: drawRect.height)
			ctx.concatenate(af)

			// Draw the qr with the required styles
			self.draw(ctx: ctx, rect: drawRect, design: design, logoTemplate: logoTemplate)
		}
	}
}

// MARK: - PNG

public extension QRCode {
	/// Return a PNG representation of the QR code
	/// - Parameters:
	///   - dimension: The dimensions of the image to create
	///   - dpi: The dpi for the resulting images
	///   - design: The design for the QR Code
	///   - logoTemplate: The logo template to apply to the qr code
	/// - Returns: The PNG data
	@objc func pngData(
		dimension: Int,
		dpi: CGFloat = 72,
		design: QRCode.Design = QRCode.Design(),
		logoTemplate: QRCode.LogoTemplate? = nil
	) -> Data? {
		return self.pngData(
			CGSize(dimension: dimension),
			dpi: dpi,
			design: design,
			logoTemplate: logoTemplate
		)
	}

	/// Return a PNG representation of the QR code
	/// - Parameters:
	///   - size: The size of the resulting image
	///   - dpi: The dpi for the resulting images
	///   - design: The design for the QR Code
	///   - logoTemplate: The logo template to apply to the qr code
	/// - Returns: The PNG data
	@objc func pngData(
		_ size: CGSize,
		dpi: CGFloat = 72,
		design: QRCode.Design = QRCode.Design(),
		logoTemplate: QRCode.LogoTemplate? = nil
	) -> Data? {
		if let image = self.cgImage(size, design: design, logoTemplate: logoTemplate) {
			return try? image.representation.png(dpi: dpi)
		}
		return nil
	}
}

// MARK: - TIFF

public extension QRCode {
	/// Return a TIFF representation of the QR code
	/// - Parameters:
	///   - dimension: The dimensions of the image to create
	///   - dpi: The dpi for the resulting images
	///   - design: The design for the QR Code
	///   - logoTemplate: The logo template to apply to the qr code
	///   - compression: The compression level when generating the image (0.0 ... 1.0)
	/// - Returns: The TIFF data
	@objc func tiffData(
		dimension: Int,
		dpi: CGFloat = 72,
		design: QRCode.Design = QRCode.Design(),
		logoTemplate: QRCode.LogoTemplate? = nil,
		compression: Double = .infinity
	) -> Data? {
		return self.tiffData(
			CGSize(dimension: dimension),
			dpi: dpi,
			design: design,
			logoTemplate: logoTemplate
		)
	}

	/// Return a TIFF representation of the QR code
	/// - Parameters:
	///   - size: The size of the resulting image
	///   - dpi: The dpi for the resultant image
	///   - design: The design for the QR Code
	///   - logoTemplate: The logo template to apply to the qr code
	///   - compression: The compression level when generating the image (0.0 ... 1.0)
	/// - Returns: The TIFF data
	@objc func tiffData(
		_ size: CGSize,
		dpi: CGFloat = 72,
		design: QRCode.Design = QRCode.Design(),
		logoTemplate: QRCode.LogoTemplate? = nil,
		compression: Double = .infinity
	) -> Data? {
		let compression: CGFloat? = (compression == .infinity) ? nil : compression
		if let image = self.cgImage(size, design: design, logoTemplate: logoTemplate) {
			return try? image.representation.tiff(dpi: dpi, compression: compression)
		}
		return nil
	}
}

// MARK: - JPEG

public extension QRCode {
	/// Return a JPEG representation of the QR code
	/// - Parameters:
	///   - dimension: The dimensions of the image to create
	///   - dpi: The dpi for the resulting images
	///   - design: The design for the QR Code
	///   - logoTemplate: The logo template to apply to the qr code
	///   - compression: The compression level when generating the JPEG file (0.0 ... 1.0)
	/// - Returns: The JPEG data
	@objc func jpegData(
		dimension: Int,
		dpi: CGFloat = 72,
		design: QRCode.Design = QRCode.Design(),
		logoTemplate: QRCode.LogoTemplate? = nil,
		compression: Double = .infinity
	) -> Data? {
		return self.jpegData(
			CGSize(dimension: dimension),
			dpi: dpi,
			design: design,
			logoTemplate: logoTemplate,
			compression: compression
		)
	}

	/// Return a JPEG representation of the QR code
	/// - Parameters:
	///   - size: The dimensions of the image to create
	///   - dpi: The dpi for the resulting images
	///   - design: The design for the QR Code
	///   - logoTemplate: The logo template to apply to the qr code
	///   - compression: The compression level when generating the JPEG file (0.0 ... 1.0)
	/// - Returns: The JPEG data
	@objc func jpegData(
		_ size: CGSize,
		dpi: CGFloat = 72,
		design: QRCode.Design = QRCode.Design(),
		logoTemplate: QRCode.LogoTemplate? = nil,
		compression: Double = .infinity
	) -> Data? {
		let compression: CGFloat? = (compression == .infinity) ? nil : compression
		if let image = self.cgImage(size, design: design, logoTemplate: logoTemplate) {
			return try? image.representation.jpeg(dpi: dpi, compression: compression)
		}
		return nil
	}
}
