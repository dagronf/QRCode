//
//  Copyright © 2025 Darren Ford. All rights reserved.
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

public extension QRCode.FillStyle {

	/// A simple single-color solid fill style
	@objc(QRCodeFillStyleSolid) class Solid: NSObject, QRCodeFillStyleGenerator {

		@objc public static var Name: String { "solid" }

		/// The fill color
		@objc public let color: CGColor

		/// The color settings as a dictionary
		@objc public func settings() throws -> [String: Any] {
			[ "color": try color.archiveSRGBA() ]
		}

		/// Create a Solid fill style using the provided settings dictionary
		/// - Parameter settings: The settings dictionary
		/// - Returns: A solid fill style object
		@objc public static func Create(settings: [String: Any]) throws -> (any QRCodeFillStyleGenerator) {
			guard let c = settings["color"] as? String else {
				throw QRCodeError.cannotCreateGenerator
			}
			let g = try CGColor.UnarchiveSRGBA(c)
			return QRCode.FillStyle.Solid(g)
		}

		/// Create with a color
		@objc public init(_ color: CGColor) {
			self.color = color
		}

		/// Create a color from srgb float values
		@objc public convenience init(srgbRed: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) {
			self.init(CGColor.sRGBA(srgbRed, green, blue, alpha))
		}

		/// Create a color from rgb float values
		@objc public convenience init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, alpha: CGFloat = 1.0) {
			self.init(CGColor.RGBA(red, green, blue, alpha))
		}

		/// Create a color from gray values
		@objc public convenience init(gray: CGFloat, alpha: CGFloat = 1.0) {
			self.init(CGColor.gray(gray, alpha))
		}

		/// Create a solid color from a hex string
		///
		/// Supported formats:
		/// * [#]fff (rgb, alpha = 1)
		/// * [#]ffff (rgba)
		/// * [#]ffffff (rgb, alpha = 1)
		/// * [#]ffffffff (rgba)
		@objc public convenience init(hexString: String) throws {
			self.init(try CGColor.fromHexString(hexString))
		}

		/// Returns a new copy of the fill style
		public func copyStyle() throws -> any QRCodeFillStyleGenerator {
			return Solid(self.color.copy()!)
		}

		/// fill the provided rect in the context with the current fill color
		public func fill(ctx: CGContext, rect: CGRect) {
			ctx.setFillColor(color)
			ctx.fill(rect)
		}

		/// fill the provided path in the context with the current fill color
		public func fill(ctx: CGContext, rect: CGRect, path: CGPath, expectedPixelSize: CGFloat, shadow: QRCode.Shadow? = nil) {
			// Apply shadow if needed
			if let shadow = shadow, shadow.type == .dropShadow {
				let dx = expectedPixelSize * shadow.offset.width
				let dy = expectedPixelSize * shadow.offset.height
				let sz = CGSize(width: dx, height: dy)
				ctx.setShadow(offset: sz, blur: shadow.blur, color: shadow.color)
			}

			ctx.setFillColor(color)
			ctx.addPath(path)
			ctx.fillPath()

			if let shadow = shadow, shadow.type == .innerShadow {
				let dx = expectedPixelSize * shadow.offset.width
				let dy = expectedPixelSize * shadow.offset.height
				let sz = CGSize(width: dx, height: dy)
				ctx.drawInnerShadow(in: path, shadowColor: shadow.color, offset: sz, blurRadius: shadow.blur)
			}
		}
	}
}

// MARK: - Fill creation conveniences

public extension QRCodeFillStyleGenerator where Self == QRCode.FillStyle.Solid {
	/// Create a solid color
	/// - Returns: A fill generator
	/// - Parameter color: The color
	@inlinable static func solid(_ color: CGColor) -> QRCodeFillStyleGenerator {
		QRCode.FillStyle.Solid(color)
	}
	/// Create a solid color
	/// - Returns: A fill generator
	@inlinable static func solid(srgbRed: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> QRCodeFillStyleGenerator {
		QRCode.FillStyle.Solid(srgbRed: srgbRed, green: green, blue: blue, alpha: alpha)
	}
	/// Create a solid color
	/// - Returns: A fill generator
	@inlinable static func solid(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, alpha: CGFloat = 1.0) -> QRCodeFillStyleGenerator {
		QRCode.FillStyle.Solid(srgbRed: red, green: green, blue: blue, alpha: alpha)
	}
	/// Create a solid color
	/// - Returns: A fill generator
	@inlinable static func solid(gray: CGFloat, alpha: CGFloat = 1.0) -> QRCodeFillStyleGenerator {
		QRCode.FillStyle.Solid(gray: gray, alpha: alpha)
	}
	/// Create a solid color from a hex string
	///
	/// Supported formats:
	/// * [#]fff (rgb, alpha = 1)
	/// * [#]ffff (rgba)
	/// * [#]ffffff (rgb, alpha = 1)
	/// * [#]ffffffff (rgba)
	@inlinable static func solid(hexString: String) throws -> QRCodeFillStyleGenerator {
		try QRCode.FillStyle.Solid(hexString: hexString)
	}
}

// MARK: - SVG Representation

public extension QRCode.FillStyle.Solid {
	func svgRepresentation(
		styleIdentifier: String,
		expectedPixelSize: CGFloat,
		shadow: QRCode.Shadow? = nil
	) throws -> QRCode.FillStyle.SVGDefinition {
		let fill = try self.color.hexRGBCode()

		var sa = "fill=\"\(fill)\" fill-opacity=\"\(self.color.alpha)\" "

		var svg: String? = nil
		if let shadow = shadow {
			if shadow.type == .dropShadow {
				svg = try shadow.buildSVGDropShadowFilterDef(expectedPixelSize: expectedPixelSize, named: styleIdentifier + "-shadow")
			}
			else if shadow.type == .innerShadow {
				svg = try shadow.buildSVGInnerShadowFilterDef(expectedPixelSize: expectedPixelSize, named: styleIdentifier + "-shadow")
			}
			else {
				fatalError()
			}
			sa += "style=\"filter:url(#\(styleIdentifier)-shadow)\""
		}
		return QRCode.FillStyle.SVGDefinition(styleAttribute: sa, styleDefinition: svg)
	}
}

// MARK: - SwiftUI conformances

#if canImport(SwiftUI)
import SwiftUI

@available(macOS 11, iOS 14, tvOS 14, watchOS 7.0, *)
public extension QRCode.FillStyle.Solid {
	/// Returns a SwiftUI Color object for this solid color
	@inlinable func colorUI() -> Color {
		Color(self.color)
	}
}
#endif


