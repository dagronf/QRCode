//
//  QRCode+Platform
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

// Platform specific routines

import Foundation

#if os(macOS)
import AppKit
#else
import UIKit
#endif

#if canImport(SwiftUI)
import SwiftUI
#endif

// MARK: - Cross-platform framework view

#if os(macOS)
public typealias DSFView = NSView
@available(macOS 10.15, *)
typealias DSFViewRepresentable = NSViewRepresentable
extension NSView {
	@inlinable func setNeedsDisplay() { self.needsDisplay = true }
}
#elseif os(iOS) || os(tvOS)
public typealias DSFView = UIView
@available(iOS 13.0, tvOS 13.0, *)
typealias DSFViewRepresentable = UIViewRepresentable
#endif

// MARK: - Cross-platform framework image

#if os(macOS)
import AppKit
public typealias DSFImage = NSImage

extension NSImage {
	/// Create an NSImage from a CGImage
	@inlinable convenience init(cgImage: CGImage) {
		self.init(cgImage: cgImage, size: .zero)
	}
}

#else
public typealias DSFImage = UIImage
extension UIImage {
	func pngRepresentation() -> Data? { self.pngData() }
}
#endif

extension CGImage {
	/// Generate an platform-specific image
	func platformImage() -> DSFImage? {
		DSFImage(cgImage: self)
	}
}

// MARK :- Conveniences for platform-specific image types

#if os(macOS)
public extension QRCode {
	/// Returns an NSImage representation of the qr code using the specified style
	/// - Parameters:
	///   - size: The pixel size of the image to generate
	///   - dpi: The dpi for the resulting image
	///   - design: The design for the qr code
	/// - Returns: The image, or nil if an error occurred
	@objc func nsImage(
		_ size: CGSize,
		dpi: CGFloat = 72.0,
		design: QRCode.Design = QRCode.Design(),
		logoTemplate: QRCode.LogoTemplate? = nil
	) -> NSImage? {
		guard let qrImage = self.cgImage(size, design: design, logoTemplate: logoTemplate) else { return nil }
		let dpid = size * (72.0 / dpi)
		let image = NSImage(cgImage: qrImage, size: dpid)
		return image
	}
}
#endif

#if os(iOS) || os(tvOS) || os(watchOS)
public extension QRCode {
	/// Returns a UIImage representation of the qr code using the specified style
	/// - Parameters:
	///   - size: The pixel size of the image to generate
	///   - scale: The scale
	///   - design: The design for the qr code
	/// - Returns: The image, or nil if an error occurred
	@objc func uiImage(
		_ size: CGSize,
		dpi: CGFloat = 72.0,
		design: QRCode.Design = QRCode.Design(),
		logoTemplate: QRCode.LogoTemplate? = nil
	) -> UIImage? {
		guard let qrImage = self.cgImage(size, design: design, logoTemplate: logoTemplate) else { return nil }
		let im = UIImage(cgImage: qrImage, scale: (dpi / 72.0), orientation: .up)
		return im
	}
}
#endif

#if canImport(SwiftUI)
@available(macOS 11, iOS 13, tvOS 13, *)
public extension QRCode {
	/// Create a SwiftUI Image object for the QR code
	/// - Parameters:
	///   - size: The pixel size of the image to generate
	///   - dpi: The DPI of the resulting image
	///   - design: The design for the qr code
	///   - label: The label associated with the image. SwiftUI uses the label for accessibility.
	/// - Returns: An image, or nil if an error occurred
	func imageUI(
		_ size: CGSize,
		dpi: CGFloat = 72.0,
		design: QRCode.Design = QRCode.Design(),
		logoTemplate: QRCode.LogoTemplate? = nil,
		label: Text) -> SwiftUI.Image?
	{
		guard let qrImage = self.cgImage(size, design: design, logoTemplate: logoTemplate) else { return nil }
		return SwiftUI.Image(qrImage, scale: dpi / 72.0, label: label)
	}
}
#endif
