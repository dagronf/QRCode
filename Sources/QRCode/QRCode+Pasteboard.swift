//
//  QRCode+Pasteboard.swift
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

import Foundation

#if os(macOS)
import AppKit.NSPasteboard
#elseif os(iOS)
import UIKit.UIPasteboard
#endif

// MARK: - QRCode Pasteboard support

public extension QRCode {
#if os(macOS)
	/// Add QRCode representations to the specified pasteboard
	/// - Parameters:
	///   - dimension: The dimensions of the image to create
	///   - dpi: The DPI for the image added to the pasteboard
	///   - design: The qr code design
	///   - logoTemplate: The logo template
	///   - pasteboard: The pasteboard to receive the representations
	@objc func addToPasteboard(
		dimension: Int,
		dpi: CGFloat = 72.0,
		design: QRCode.Design = QRCode.Design(),
		logoTemplate: QRCode.LogoTemplate? = nil,
		pasteboard: NSPasteboard = NSPasteboard.general
	) {
		self.addToPasteboard(
			CGSize(dimension: dimension),
			dpi: dpi,
			design: design,
			logoTemplate: logoTemplate,
			pasteboard: pasteboard
		)
	}

	/// Add QRCode representations to the specified pasteboard
	/// - Parameters:
	///   - size: The size of the QRCode to generate
	///   - dpi: The DPI for the image added to the pasteboard
	///   - design: The design for the QR code
	///   - logoTemplate: The logo to overlay on the qr code
	///   - pasteboard: The pasteboard to receive the representations
	@objc func addToPasteboard(
		_ size: CGSize,
		dpi: CGFloat = 72.0,
		design: QRCode.Design = QRCode.Design(),
		logoTemplate: QRCode.LogoTemplate? = nil,
		pasteboard: NSPasteboard = NSPasteboard.general
	) {
		pasteboard.clearContents()

		do {
			let pdfData = try self.pdfData(size, pdfResolution: dpi, design: design, logoTemplate: logoTemplate)
			pasteboard.setData(pdfData, forType: .pdf)
		}
		catch {
		}

		do {
			let tiffData = try self.tiffData(size, dpi: dpi, design: design, logoTemplate: logoTemplate)
			pasteboard.setData(tiffData, forType: .tiff)
		}
		catch {
		}

		do {
			let pngData = try self.pngData(size, dpi: dpi, design: design, logoTemplate: logoTemplate)
			pasteboard.setData(pngData, forType: .png)
		}
		catch {
		}

		do {
			let svgData = try self.svgData(
				dimension: Int(size.width.rounded(.towardZero)),
				design: design,
				logoTemplate: logoTemplate
			)
			pasteboard.setData(svgData, forType: NSPasteboard.PasteboardType(rawValue: "public.svg-image"))
		}
		catch {
		}
	}

#elseif os(iOS)
	/// Add QRCode representations to the specified pasteboard
	/// - Parameters:
	///   - dimension: The dimensions of the image to create
	///   - pasteboard: The pasteboard to receive the representations
	///   - scale: The scale (eg. scale=2 -> retina -> 144dpi)
	@objc func addToPasteboard(
		dimension: Int,
		dpi: CGFloat = 72.0,
		design: QRCode.Design = QRCode.Design(),
		logoTemplate: QRCode.LogoTemplate? = nil,
		pasteboard: UIPasteboard = UIPasteboard.general
	) {
		self.addToPasteboard(
			CGSize(dimension: dimension),
			dpi: dpi,
			design: design,
			logoTemplate: logoTemplate,
			pasteboard: pasteboard
		)
	}

	/// Add QRCode representations to the specified pasteboard
	/// - Parameters:
	///   - size: The size of the QRCode to generate
	///   - scale: The scale (eg. scale=2 -> retina -> 144dpi)
	///   - pasteboard: The pasteboard to receive the representations
	@objc func addToPasteboard(
		_ size: CGSize,
		dpi: CGFloat = 72.0,
		design: QRCode.Design = QRCode.Design(),
		logoTemplate: QRCode.LogoTemplate? = nil,
		pasteboard: UIPasteboard = UIPasteboard.general
	) {
		pasteboard.items = []
		do {
			let pdfData = try self.pdfData(size, pdfResolution: dpi, design: design, logoTemplate: logoTemplate)
			pasteboard.setData(pdfData, forPasteboardType: String("com.adobe.pdf"))
		}
		catch {
		}

		do {
			let pngData = try self.pngData(size, dpi: dpi, design: design, logoTemplate: logoTemplate)
			pasteboard.setData(pngData, forPasteboardType: String("public.png"))
		}
		catch {
		}
	}
#endif
}

// MARK: - QRCode.Document pasteboard support

public extension QRCode.Document {
#if os(macOS)
	/// Add QRCode representations to the specified pasteboard
	/// - Parameters:
	///   - pasteboard: The pasteboard to receive the representations
	///   - dimension: The dimensions of the image to create
	///   - dpi: The DPI for the resulting image
	@objc func addToPasteboard(
		dimension: Int,
		dpi: CGFloat = 72.0,
		pasteboard: NSPasteboard = NSPasteboard.general
	) {
		self.qrcode.addToPasteboard(
			CGSize(dimension: dimension),
			dpi: dpi,
			design: self.design,
			logoTemplate: self.logoTemplate,
			pasteboard: pasteboard
		)
	}

	/// Add QRCode representations to the specified pasteboard
	/// - Parameters:
	///   - size: The size of the QRCode to generate
	///   - dpi: The DPI for the image added to the pasteboard
	///   - pasteboard: The pasteboard to receive the representations
	@objc func addToPasteboard(
		_ size: CGSize,
		dpi: CGFloat = 72.0,
		pasteboard: NSPasteboard = NSPasteboard.general
	) {
		self.qrcode.addToPasteboard(
			size,
			dpi: dpi,
			design: self.design,
			logoTemplate: self.logoTemplate,
			pasteboard: pasteboard
		)
	}

#elseif os(iOS)
	/// Add QRCode representations to the specified pasteboard
	/// - Parameters:
	///   - pasteboard: The pasteboard to receive the representations
	///   - size: The size of the QRCode to generate
	///   - scale: The scale (eg. scale=2 -> retina -> 144dpi)
	@objc func addToPasteboard(
		_ size: CGSize,
		dpi: CGFloat = 72.0,
		pasteboard: UIPasteboard = UIPasteboard.general
	) {
		self.qrcode.addToPasteboard(
			size,
			dpi: dpi,
			design: self.design,
			logoTemplate: self.logoTemplate,
			pasteboard: pasteboard
		)
	}
#endif
}
