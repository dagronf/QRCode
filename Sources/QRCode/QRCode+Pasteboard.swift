//
//  QRCode+Pasteboard.swift
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
	///   - pasteboard: The pasteboard to receive the representations
	///   - size: The size of the QRCode to generate
	///   - scale: The scale (eg. scale=2 -> retina -> 144dpi)
	@objc func addToPasteboard(
		pasteboard: NSPasteboard = NSPasteboard.general,
		_ size: CGSize,
		scale: CGFloat = 2,
		design: QRCode.Design = QRCode.Design()
	) {
		pasteboard.clearContents()
		if let pdfData = self.pdfData(size, pdfResolution: 72.0 * scale, design: design) {
			pasteboard.setData(pdfData, forType: .pdf)
		}

		guard let image = self.nsImage(size, scale: scale) else {
			return
		}

		if let tiffData = image.tiffRepresentation {
			pasteboard.setData(tiffData, forType: .tiff)
		}

		if let pngData = image.pngRepresentation {
			pasteboard.setData(pngData, forType: .png)
		}
	}

#elseif os(iOS)
	/// Add QRCode representations to the specified pasteboard
	/// - Parameters:
	///   - pasteboard: The pasteboard to receive the representations
	///   - size: The size of the QRCode to generate
	///   - scale: The scale (eg. scale=2 -> retina -> 144dpi)
	@objc func addToPasteboard(
		pasteboard: UIPasteboard = UIPasteboard.general,
		_ size: CGSize,
		scale: CGFloat = 2,
		design: QRCode.Design = QRCode.Design()
	) {
		pasteboard.items = []
		if let pdfData = self.pdfData(size, pdfResolution: 72.0 * scale, design: design) {
			pasteboard.setData(pdfData, forPasteboardType: String("com.adobe.pdf"))
		}

		guard let image = self.uiImage(size, scale: scale, design: design) else {
			return
		}

		if let pngData = image.pngData() {
			pasteboard.setData(pngData, forPasteboardType: String("public.png"))
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
	///   - size: The size of the QRCode to generate
	///   - scale: The scale (eg. scale=2 -> retina -> 144dpi)
	@objc func addToPasteboard(
		pasteboard: NSPasteboard = NSPasteboard.general,
		_ size: CGSize,
		scale: CGFloat = 2
	) {
		self.qrcode.addToPasteboard(pasteboard: pasteboard, size, scale: scale, design: self.design)
	}

#elseif os(iOS)
	/// Add QRCode representations to the specified pasteboard
	/// - Parameters:
	///   - pasteboard: The pasteboard to receive the representations
	///   - size: The size of the QRCode to generate
	///   - scale: The scale (eg. scale=2 -> retina -> 144dpi)
	@objc func addToPasteboard(
		pasteboard: UIPasteboard = UIPasteboard.general,
		_ size: CGSize,
		scale: CGFloat = 2
	) {
		self.qrcode.addToPasteboard(pasteboard: pasteboard, size, scale: scale, design: self.design)
	}
#endif
}
