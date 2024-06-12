//
//  QRCode+Document+Export.swift
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

#if canImport(SwiftUI)
import SwiftUI
#endif

// MARK: - Draw

public extension QRCode.Document {
	/// Draw the current qrcode document into the specified context and rect
	/// - Parameters:
	///   - ctx: The drawing context to draw into
	///   - rect: The bounds within the context to draw into
	@objc func draw(ctx: CGContext, rect: CGRect) {
		self.qrcode.draw(
			ctx: ctx,
			rect: rect,
			design: self.design,
			logoTemplate: self.logoTemplate
		)
	}
}

// MARK: - Path

public extension QRCode.Document {
	/// Generate a path containing the QR Code components for the current QRCode shape
	/// - Parameters:
	///   - size: The size of the generated path
	///   - components: The components of the QR code to include in the path
	/// - Returns: A path containing the components
	@objc func path(_ size: CGSize, components: QRCode.Components = .all) -> CGPath {
		/// The size of each pixel in the output
		let additionalQuietSpacePixels = CGFloat(design.additionalQuietZonePixels)
		let dm: CGFloat = CGFloat(size.width) / (CGFloat(self.cellDimension) + (2.0 * additionalQuietSpacePixels))
		let additionalQuietSpace = dm * additionalQuietSpacePixels

		// Factor in the additional quiet space in the result
		guard (2 * additionalQuietSpace) < size.width else {
			Swift.print("additionalQuietSpace too large")
			return CGMutablePath()
		}

		var components = components
		if self.design.shape.negatedOnPixelsOnly {
			components.insert(.negative)
		}

		return self.qrcode.path(
			CGSize(
				width: size.width - (2 * additionalQuietSpace),
				height: size.height - (2 * additionalQuietSpace)
			),
			components: components,
			shape: self.design.shape,
			logoTemplate: self.logoTemplate,
			additionalQuietSpace: additionalQuietSpace
		)
	}

	/// Generate a path containing the QR Code components for the current QRCode shape
	/// - Parameters:
	///   - dimension: The dimension of the generated path
	///   - components: The components of the QR code to include in the path
	/// - Returns: A path containing the components
	@objc func path(dimension: Int, components: QRCode.Components = .all) -> CGPath {
		self.path(CGSize(dimension: dimension), components: components)
	}
}

// MARK: - Bitmap representations

public extension QRCode.Document {
	/// Returns a PNG representation of the QRCode
	/// - Parameters:
	///   - dimension: The size of the QR code
	/// - Returns: The PNG data
	@objc func pngData(dimension: Int, dpi: CGFloat = 72.0) throws -> Data {
		try self.qrcode.pngData(
			dimension: dimension,
			dpi: dpi,
			design: self.design,
			logoTemplate: self.logoTemplate
		)
	}

	/// Returns a JPEG representation of the QRCode
	/// - Parameter
	///   - dimension: The size of the QR code
	///   - dpi: The DPI of the resulting image
	///   - compression: The compression level to use when generating the JPEG (0.0 -> 1.0)
	/// - Returns: The PNG data
	@objc func jpegData(dimension: Int, dpi: CGFloat = 72.0, compression: Double = 0.9) throws -> Data {
		try self.qrcode.jpegData(
			dimension: dimension,
			dpi: dpi,
			design: self.design,
			logoTemplate: self.logoTemplate,
			compression: compression.clamped(to: 0.0 ... 1.0)
		)
	}

	/// Return a TIFF representation of the QR code
	/// - Parameters:
	///   - dimension: The dimensions of the image to create
	///   - dpi: The DPI of the resulting image
	/// - Returns: The TIFF data
	@objc func tiffData(dimension: Int, dpi: CGFloat = 72.0) throws -> Data {
		try self.qrcode.tiffData(
			dimension: dimension,
			dpi: dpi,
			design: self.design,
			logoTemplate: self.logoTemplate
		)
	}
}

public extension QRCode.Document {
	/// The supported exportable image types
	enum ExportType {
		/// PNG export
		case png(dpi: CGFloat = 72.0)
		/// JPEG export. Default compression value is 0.75
		case jpg(dpi: CGFloat = 72.0, compression: CGFloat = 0.75)
		/// TIFF export
		case tiff(dpi: CGFloat = 72.0)
		/// PDF export
		case pdf(pdfResolution: CGFloat = 72.0)
		/// Binary representation of an SVG file
		case svg

		/// Returns the extension for the export type
		var fileExtension: String {
			switch self {
			case .png: return "png"
			case .jpg: return "jpg"
			case .tiff: return "tiff"
			case .pdf: return "pdf"
			case .svg: return "svg"
			}
		}
	}

	/// Returns the QRCode document as an image
	/// - Parameters:
	///   - type: The type of image
	///   - dimension: The size of the resulting image
	/// - Returns: Data representation of the image
	@inlinable func imageData(_ type: ExportType, dimension: Int) throws -> Data {
		switch type {
		case let .png(dpi):
			return try self.pngData(dimension: dimension, dpi: dpi)
		case let .jpg(dpi, compression):
			return try self.jpegData(dimension: dimension, dpi: dpi, compression: compression)
		case let .pdf(resolution):
			return try self.pdfData(dimension: dimension, pdfResolution: resolution)
		case .svg:
			return try self.svgData(dimension: dimension)
		case let .tiff(dpi):
			return try self.tiffData(dimension: dimension, dpi: dpi)
		}
	}
}

// MARK: - Vector representations

// MARK: PDF

public extension QRCode.Document {
	/// Returns a pdf representation of the qr code document
	/// - Parameters:
	///   - dimension: The dimension of the generated PDF
	///   - pdfResolution: The resolution of the pdf output
	/// - Returns: A data object containing the PDF representation of the QR code
	@objc func pdfData(dimension: Int, pdfResolution: CGFloat = 72.0) throws -> Data {
		try self.pdfData(CGSize(dimension: dimension), pdfResolution: pdfResolution)
	}

	/// Returns a pdf representation of the qr code document
	/// - Parameters:
	///   - width: The page width of the generated PDF
	///   - height: The page height of the generated PDF
	///   - pdfResolution: The resolution of the pdf output
	/// - Returns: A data object containing the PDF representation of the QR code
	@objc func pdfData(width: CGFloat, height: CGFloat, pdfResolution: CGFloat = 72.0) throws -> Data {
		try self.pdfData(CGSize(width: width, height: height), pdfResolution: pdfResolution)
	}

	/// Returns a pdf representation of the qr code document
	/// - Parameters:
	///   - size: The page size of the generated PDF
	///   - pdfResolution: The resolution of the pdf output
	/// - Returns: A data object containing the PDF representation of the QR code
	@objc func pdfData(_ size: CGSize, pdfResolution: CGFloat = 72.0) throws -> Data {
		try self.qrcode.pdfData(
			size,
			pdfResolution: pdfResolution,
			design: self.design,
			logoTemplate: self.logoTemplate
		)
	}
}

// MARK: SVG

public extension QRCode.Document {
	/// Returns an SVG utf8 string representation of the QR code
	/// - Parameters:
	///   - dimension: The dimension of the output svg
	/// - Returns: An SVG representation of the QR code
	///
	/// The string always uses Unix newlines (\n), regardless of the platform.
	@objc func svg(dimension: Int) throws -> String {
		try self.qrcode.svg(dimension: dimension, design: self.design, logoTemplate: self.logoTemplate)
	}

	/// Returns an SVG data representation of the QR Code.
	/// - Parameters:
	///   - dimension: The dimension of the output svg
	/// - Returns: A UTF8 encoded SVG representation of the QR code
	///
	/// The string always uses Unix newlines (\n), regardless of the platform.
	@objc func svgData(dimension: Int) throws -> Data {
		try self.qrcode.svgData(dimension: dimension, design: design, logoTemplate: logoTemplate)
	}
}

// MARK: - Image

public extension QRCode.Document {
	/// Returns a CGImage representation of the qr code
	/// - Parameters:
	///   - dimension: The dimension of the image to create
	/// - Returns: The image, or nil if an error occurred
	@objc func cgImage(dimension: Int) throws -> CGImage {
		try self.qrcode.cgImage(
			CGSize(dimension: dimension),
			design: self.design,
			logoTemplate: self.logoTemplate
		)
	}

	/// Returns a CGImage representation of the qr code
	/// - Parameters:
	///   - width: The pixel width of the image to generate
	///   - height: The pixel height of the image to generate
	/// - Returns: The image, or nil if an error occurred
	@objc func cgImage(width: CGFloat, height: CGFloat) throws -> CGImage {
		try self.cgImage(CGSize(width: width, height: height))
	}

	/// Returns a CGImage representation of the qr code
	/// - Parameters:
	///   - size: The pixel size of the image to generate
	/// - Returns: The image, or nil if an error occurred
	@objc func cgImage(_ size: CGSize) throws -> CGImage {
		try self.qrcode.cgImage(
			size,
			design: self.design,
			logoTemplate: self.logoTemplate
		)
	}
}

#if os(macOS)
public extension QRCode.Document {
	/// Returns a platform specific representation of the qr code document
	/// - Parameters:
	///   - dimension: The pixel dimension of the image to generate
	///   - dpi: The DPI of the resulting image
	/// - Returns: The image, or nil if an error occurred
	@objc func platformImage(dimension: Int, dpi: CGFloat = 72.0) throws -> DSFImage {
		try self.qrcode.nsImage(
			CGSize(dimension: dimension),
			dpi: dpi,
			design: self.design,
			logoTemplate: self.logoTemplate
		)
	}

	/// Returns an NSImage representation of the qr code document
	/// - Parameters:
	///   - dimension: The pixel dimension of the image to generate
	///   - dpi: The DPI of the resulting image
	/// - Returns: The image, or nil if an error occurred
	@objc func nsImage(dimension: Int, dpi: CGFloat = 72.0) throws -> NSImage {
		try self.qrcode.nsImage(
			CGSize(dimension: dimension),
			dpi: dpi,
			design: self.design,
			logoTemplate: self.logoTemplate
		)
	}

	/// Returns an NSImage representation of the qr code document
	/// - Parameters:
	///   - size: The pixel size of the image to generate
	///   - dpi: The DPI of the resulting image
	/// - Returns: The image, or nil if an error occurred
	@objc func nsImage(_ size: CGSize, dpi: CGFloat = 72.0) throws -> NSImage {
		try self.qrcode.nsImage(
			size,
			dpi: dpi,
			design: self.design,
			logoTemplate: self.logoTemplate
		)
	}
}
#endif

#if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
public extension QRCode.Document {
	/// Returns a platform specific representation of the qr code document
	/// - Parameters:
	///   - dimension: The pixel dimension of the image to generate
	///   - dpi: The DPI of the resulting image
	/// - Returns: The image, or nil if an error occurred
	@objc func platformImage(dimension: Int, dpi: CGFloat = 72.0) throws -> DSFImage {
		try self.qrcode.uiImage(
			CGSize(dimension: dimension),
			dpi: dpi,
			design: self.design,
			logoTemplate: self.logoTemplate
		)
	}

	/// Returns a UIImage representation of the qr code document
	/// - Parameters:
	///   - dimension: The pixel dimension of the image to generate
	///   - dpi: The DPI of the resulting image
	/// - Returns: The image, or nil if an error occurred
	@objc func uiImage(dimension: Int, dpi: CGFloat) throws -> UIImage {
		try self.uiImage(CGSize(dimension: dimension), dpi: dpi)
	}

	/// Returns a UIImage representation of the qr code document
	/// - Parameters:
	///   - dimension: The size of the image to generate
	///   - scale: The scale factor for the image, with a value like 1.0, 2.0, or 3.0.
	/// - Returns: The image, or nil if an error occurred
	@objc func uiImage(dimension: Int, scale: CGFloat = 1) throws -> UIImage {
		try self.uiImage(CGSize(dimension: dimension), dpi: scale * 72.0)
	}

	/// Returns a UIImage representation of the qr code document
	/// - Parameters:
	///   - size: The pixel size of the image to generate
	///   - dpi: The DPI of the resulting image
	/// - Returns: The image, or nil if an error occurred
	@objc func uiImage(_ size: CGSize, dpi: CGFloat = 72.0) throws -> UIImage {
		let scale = dpi / 72.0
		let qrImage = try self.qrcode.cgImage(
			size * scale,
			design: self.design,
			logoTemplate: self.logoTemplate
		)
		return UIImage(cgImage: qrImage, scale: scale, orientation: .up)
	}
}
#endif

// MARK: - SwiftUI

#if canImport(SwiftUI)
public extension QRCode.Document {
	/// Create a SwiftUI Image object for the QR code
	/// - Parameters:
	///   - size: The pixel size of the image to generate
	///   - dpi: The DPI of the resulting image
	///   - label: The label associated with the image. SwiftUI uses the label for accessibility.
	/// - Returns: An image, or nil if an error occurred
	@available(macOS 11, iOS 13, tvOS 13, *)
	func imageUI(_ size: CGSize, dpi: CGFloat = 72.0, label: Text) throws -> SwiftUI.Image {
		try self.qrcode.imageUI(
			size,
			dpi: dpi,
			design: self.design,
			logoTemplate: self.logoTemplate,
			label: label
		)
	}
}
#endif

// MARK: - ASCII representation

public extension QRCode.Document {
	/// A simple ASCII representation of the core QRCode data.
	///
	/// Example output (data is "testing")
	/// ```
	///  ██████████████    ██  ████  ██████████████
	///  ██          ██  ████  ██    ██          ██
	///  ██  ██████  ██  ████    ██  ██  ██████  ██
	///  ██  ██████  ██    ██  ██    ██  ██████  ██
	///  ██  ██████  ██  ██      ██  ██  ██████  ██
	///  ██          ██  ██    ████  ██          ██
	///  ██████████████  ██  ██  ██  ██████████████
	///                  ██████████
	///  ████  ██    ████  ████      ██████  ████
	///  ██  ████████      ██        ████      ████
	///  ████████    ████    ██  ████      ████  ██
	///  ████  ████    ██  ██  ██        ████  ████
	///  ████  ████  ██      ██  ██  ████████  ████
	///                  ████  ██      ██  ██  ████
	///  ██████████████  ████      ██  ████    ██
	///  ██          ██      ████████  ████      ██
	///  ██  ██████  ██        ██    ████████    ██
	///  ██  ██████  ██  ██  ████      ██████  ████
	///  ██  ██████  ██      ██  ██    ████  ██  ██
	///  ██          ██  ██  ██    ████  ██
	///  ██████████████  ██  ██████        ██  ██
	///
	/// ```
	@objc var asciiRepresentation: String {
		self.qrcode.asciiRepresentation()
	}

	/// A simple smaller ASCII representation of the core QRCode data
	///
	/// Example output (data is "testing")
	/// ```
	///  ▄▄▄▄▄▄▄  ▄ ▄▄ ▄▄▄▄▄▄▄
	///  █ ▄▄▄ █ ██ ▀▄ █ ▄▄▄ █
	///  █ ███ █ ▄▀ ▀▄ █ ███ █
	///  █▄▄▄▄▄█ █ ▄▀█ █▄▄▄▄▄█
	///  ▄▄ ▄  ▄▄▀██▀▀ ▄▄▄ ▄▄
	///  █▄██▀▀▄▄ ▀▄ ▄▄▀▀ ▄▄▀█
	///  ██ ██ ▄▀ ▀▄▀▄ ▄▄██ ██
	///  ▄▄▄▄▄▄▄ ██ ▀ ▄ █▄▀ █▀
	///  █ ▄▄▄ █   ▀█▀▀▄██▄  █
	///  █ ███ █ ▀ █▀▄  ██▀▄▀█
	///  █▄▄▄▄▄█ █ █▄▄▀▀ ▀▄ ▄
	///
	/// ```
	@objc var smallAsciiRepresentation: String {
		self.qrcode.smallAsciiRepresentation()
	}
}
