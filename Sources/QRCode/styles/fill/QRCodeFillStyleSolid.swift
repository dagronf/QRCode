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
		public func fill(ctx: CGContext, rect: CGRect, path: CGPath) {
			ctx.setFillColor(color)
			ctx.addPath(path)
			ctx.fillPath()
		}
	}
}

// MARK: - SVG Representation

public extension QRCode.FillStyle.Solid {
	func svgRepresentation(styleIdentifier: String) throws -> QRCode.FillStyle.SVGDefinition {
		let fill = try self.color.hexRGBCode()
		return QRCode.FillStyle.SVGDefinition(
			styleAttribute: "fill=\"\(fill)\" fill-opacity=\"\(self.color.alpha)\"",
			styleDefinition: nil
		)
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


