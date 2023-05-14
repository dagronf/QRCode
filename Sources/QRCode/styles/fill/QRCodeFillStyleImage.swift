//
//  QRCodeFillStyleImage.swift
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

public extension QRCode.FillStyle {
	/// A image, scaled proportionally to fill the qr code content
	@objc(QRCodeFillStyleImage) class Image: NSObject, QRCodeFillStyleGenerator {
		@objc public static var Name: String { "image" }

		/// The image to use for the fill
		@objc public var image: CGImage?

		/// Return the save settings for the fill style
		@objc public func settings() -> [String: Any] {
			return ["imagePNGbase64": getPngImageBase64() ?? ""]
		}

		/// Create the fill style from the specified settings
		@objc public static func Create(settings: [String: Any]) -> QRCodeFillStyleGenerator? {
			if let c = settings["imagePNGbase64"] as? String,
				let d = Data(base64Encoded: c),
				let i = DSFImage(data: d)
			{
				return QRCode.FillStyle.Image(i.cgImage())
			}
			return nil
		}

		/// Create with an image
		@objc public init(_ image: CGImage?) {
			self.image = image
			super.init()
		}

		/// Create an image file style using the platform image type
		@objc public convenience init(image: DSFImage?) {
			self.init(image?.cgImage())
		}

		/// Returns a new copy of the fill style
		public func copyStyle() -> QRCodeFillStyleGenerator {
			return Image(self.image?.copy())
		}

		/// fill the provided rect in the context with the current fill color
		public func fill(ctx: CGContext, rect: CGRect) {
			if let image = self.image {
				ctx.usingGState { context in
					// image drawing is flipped
					ctx.scaleBy(x: 1, y: -1)
					// translate into the rect
					ctx.translateBy(x: 0, y: -rect.height)
					ctx.translateBy(x: 0, y: -rect.origin.y * 2)
					// Draw the logo image into the mask bounds
					ctx.draw(image, in: rect)
				}
			}
		}

		/// fill the provided path in the context with the current fill color
		public func fill(ctx: CGContext, rect: CGRect, path: CGPath) {
			if let image = self.image {
				ctx.usingGState { context in
					// Clip to the mask path.
					ctx.addPath(path)
					ctx.clip()

					// image drawing is flipped
					ctx.scaleBy(x: 1, y: -1)
					ctx.translateBy(x: 0, y: -rect.height)
					ctx.translateBy(x: 0, y: -rect.origin.y * 2)

					// Draw the logo image into the mask bounds
					ctx.draw(image, in: rect)
				}
			}
		}

		// Return a PNG base64 representation for the image
		private func getPngImageBase64() -> String? {
			if let b64Data = try? self.image?.representation.png().base64EncodedData() {
				return String(data: b64Data, encoding: .ascii)
			}
			return nil
		}
	}
}

// MARK: - SVG Representation

public extension QRCode.FillStyle.Image {
	func svgRepresentation(styleIdentifier: String) -> QRCode.FillStyle.SVGDefinition? {
		guard
			let image = self.image,
			let jpegData = try? self.image?.representation.jpeg()
		else {
			return nil
		}

		let imageb64d = jpegData.base64EncodedData(options: [.lineLength64Characters, .endLineWithLineFeed])
		guard let strImage = String(data: imageb64d, encoding: .ascii) else {
			return nil
		}

		var def = "<pattern id=\"\(styleIdentifier)\" "
		def += " x=\"0\" y=\"0\" width=\"1\" height=\"1\" "
		def += " viewBox=\"0 0 \(image.width) \(image.height)\" "
		def += " preserveAspectRatio=\"xMidYMid slice\">\n"

		var imagedef = "<image width=\"\(image.width)\" height=\"\(image.height)\" "
		imagedef += " xlink:href=\"data:image/jpeg;base64,"
		imagedef += strImage
		imagedef += "\" x=\"0\" y=\"0\" />"

		def += imagedef + "</pattern>"

		return QRCode.FillStyle.SVGDefinition(
			styleAttribute: "fill=\"url(#\(styleIdentifier))\" fill-opacity=\"1\"",
			styleDefinition: def
		)
	}
}

// MARK: - SwiftUI conformances

#if canImport(SwiftUI)
import SwiftUI

@available(macOS 11, iOS 14, tvOS 14, watchOS 7.0, *)
public extension QRCode.FillStyle.Image {
	/// Returns a SwiftUI Image object for this solid color
	@inlinable func imageUI(label: Text) -> Image {
		if let image = self.image {
			return Image(image, scale: 1, label: label)
		}
		return Image("<none>", label: label)
	}
}
#endif
