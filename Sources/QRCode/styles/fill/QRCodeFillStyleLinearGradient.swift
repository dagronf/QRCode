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
	/// A simple linear gradient fill style
	@objc(QRCodeFillStyleLinearGradient)
	class LinearGradient: NSObject, QRCodeFillStyleGenerator {

		@objc public static var Name: String { "lineargradient" }

		/// The gradient
		@objc public let gradient: DSFGradient
		/// linear starting point (0 -> 1)
		@objc public let startPoint: CGPoint
		/// linear ending point (0 -> 1)
		@objc public let endPoint: CGPoint

		/// The current settings for the linear gradient
		@objc public func settings() throws -> [String: Any] {
			[
				"startX": startPoint.x,
				"startY": startPoint.y,
				"endX": endPoint.x,
				"endY": endPoint.y,
				"gradient": try self.gradient.asRGBAGradientString()
			]
		}

		/// Create a linear gradient with the specified settings
		@objc public static func Create(settings: [String: Any]) throws -> (any QRCodeFillStyleGenerator) {
			guard
				let sX = DoubleValue(settings["startX"]),
				let sY = DoubleValue(settings["startY"]),
				let eX = DoubleValue(settings["endX"]),
				let eY = DoubleValue(settings["endY"]),
				let gs = settings["gradient"] as? String
			else {
				throw QRCodeError.cannotCreateGenerator
			}
			let grad = try DSFGradient.FromRGBAGradientString(gs)
			return QRCode.FillStyle.LinearGradient(
				grad,
				startPoint: CGPoint(x: sX, y: sY),
				endPoint: CGPoint(x: eX, y: eY)
			)
		}

		/// Fill the specified path/rect with a gradient
		/// - Parameters:
		///   - gradient: The color gradient to use
		///   - startPoint: The fractional position within the fill rect to start the gradient (0.0 -> 1.0)
		///   - endPoint: The fractional position within the fill rect to end the gradient (0.0 -> 1.0)
		@objc public init(
			_ gradient: DSFGradient,
			startPoint: CGPoint = CGPoint(x: 0, y: 0),
			endPoint: CGPoint = CGPoint(x: 1, y: 1)
		) {
			self.gradient = gradient
			self.startPoint = startPoint
			self.endPoint = endPoint
		}

		/// Fill the specified path/rect with a gradient
		/// - Parameters:
		///   - pins: An array of pins for the gradient
		///   - startPoint: The fractional position within the fill rect to start the gradient (0.0 -> 1.0)
		///   - endPoint: The fractional position within the fill rect to end the gradient (0.0 -> 1.0)
		@objc public init(
			pins: [DSFGradient.Pin],
			startPoint: CGPoint = CGPoint(x: 0, y: 0),
			endPoint: CGPoint = CGPoint(x: 1, y: 1)
		) throws {
			self.gradient = try DSFGradient(pins: pins)
			self.startPoint = startPoint
			self.endPoint = endPoint
		}

		/// Fill the specified rect with the gradient
		public func fill(ctx: CGContext, rect: CGRect) {
			ctx.drawLinearGradient(
				self.gradient.cgGradient,
				start: self.gradientStartPt(for: rect),
				end: self.gradientEndPt(for: rect),
				options: [.drawsAfterEndLocation, .drawsBeforeStartLocation])
		}

		/// Fill the specified path with the gradient
		public func fill(ctx: CGContext, rect: CGRect, path: CGPath, expectedPixelSize: CGFloat, shadow: QRCode.Shadow? = nil) {
			ctx.usingGState { c in
				c.addPath(path)
				c.clip()
				c.drawLinearGradient(
					self.gradient.cgGradient,
					start: self.gradientStartPt(for: rect),
					end: self.gradientEndPt(for: rect),
					options: [.drawsAfterEndLocation, .drawsBeforeStartLocation])
			}

			// Draw the shadow

			if let s = shadow {
				if s.type == .dropShadow {
					ctx.usingGState { c in
						c.addRect(rect)
						c.addPath(path)
						c.clip(using: .evenOdd)

						c.addPath(path)

						let dx = expectedPixelSize * s.offset.width
						let dy = expectedPixelSize * s.offset.height
						c.setShadow(offset: CGSize(width: dx, height: dy), blur: s.blur, color: s.color)

						c.setBlendMode(.normal)
						c.setFillColor(.commonWhite)
						c.fillPath()
					}
				}
				else if s.type == .innerShadow {
					ctx.usingGState { c in
						let dx = expectedPixelSize * s.offset.width
						let dy = expectedPixelSize * s.offset.height
						let sz = CGSize(width: dx, height: dy)
						c.drawInnerShadow(in: path, shadowColor: s.color, offset: sz, blurRadius: s.blur)
					}
				}
				else {
					fatalError()
				}
			}
		}

		/// Create a copy of the style
		public func copyStyle() throws -> any QRCodeFillStyleGenerator {
			return LinearGradient(
				try self.gradient.copyGradient(),
				startPoint: self.startPoint,
				endPoint: self.endPoint)
		}

		private func gradientStartPt(for rect: CGRect) -> CGPoint {
			let sz = rect.width
			return CGPoint(x: rect.minX + (self.startPoint.x * sz), y: rect.minY + (self.startPoint.y * sz))
		}

		private func gradientEndPt(for rect: CGRect) -> CGPoint {
			let sz = rect.width
			return CGPoint(x: rect.minX + (self.endPoint.x * sz), y: rect.minY + (self.endPoint.y * sz))
		}
	}
}

// MARK: - Fill creation conveniences

public extension QRCodeFillStyleGenerator where Self == QRCode.FillStyle.LinearGradient {
	/// Create a linear gradient fill
	/// - Parameters:
	///   - gradient: The color gradient to use
	///   - startPoint: The fractional position within the fill rect to start the gradient (0.0 -> 1.0)
	///   - endPoint: The fractional position within the fill rect to end the gradient (0.0 -> 1.0)
	/// - Returns: A fill generator
	@inlinable static func linearGradient(
		_ gradient: DSFGradient,
		startPoint: CGPoint = CGPoint(x: 0, y: 0),
		endPoint: CGPoint = CGPoint(x: 1, y: 1)
	) -> QRCodeFillStyleGenerator {
		QRCode.FillStyle.LinearGradient(gradient, startPoint: startPoint, endPoint: endPoint)
	}
}

// MARK: - SVG Representation

public extension QRCode.FillStyle.LinearGradient {
	func svgRepresentation(
		styleIdentifier: String,
		expectedPixelSize: CGFloat,
		shadow: QRCode.Shadow? = nil
	) throws -> QRCode.FillStyle.SVGDefinition {

		/*
		 <linearGradient id="Gradient" x1="0%" x2="0%" y1="0%" y2="100%">
			<stop offset="0%" stop-color="red" stop-opacity="50%"/>
			<stop offset="100%" stop-color="green"/>
		 </linearGradient>
		 */

		var svg = "<linearGradient "
		svg += "id=\"\(styleIdentifier)\" "
		svg += "x1=\"\(self.startPoint.x)\" "
		svg += "y1=\"\(self.startPoint.y)\" "
		svg += "x2=\"\(self.endPoint.x)\" "
		svg += "y2=\"\(self.endPoint.y)\">\n"

		var sa = ""
		if let shadow = shadow {
			if shadow.type == .dropShadow {
				svg += try shadow.buildSVGDropShadowFilterDef(expectedPixelSize: expectedPixelSize, named: styleIdentifier + "-shadow")
			}
			else if shadow.type == .innerShadow {
				svg += try shadow.buildSVGInnerShadowFilterDef(expectedPixelSize: expectedPixelSize, named: styleIdentifier + "-shadow")
			}
			else {
				fatalError()
			}
			sa += "style=\"filter:url(#\(styleIdentifier)-shadow)\""
		}

		let sorted = self.gradient.pins.sorted(by: { p1, p2 in p1.position < p2.position })

		for pin in sorted {
			let rgbColor = try pin.color.hexRGBCode()
			svg += "<stop offset=\"\(pin.position)\" stop-color=\"\(rgbColor)\" stop-opacity=\"\(pin.color.alpha)\" />\n"
		}
		svg += "</linearGradient>\n"

		return QRCode.FillStyle.SVGDefinition(
			styleAttribute: "fill=\"url(#\(styleIdentifier))\" \(sa)",
			styleDefinition: svg
		)
	}
}

// MARK: - SwiftUI conformances

#if canImport(SwiftUI)
import SwiftUI

@available(macOS 11, iOS 14, tvOS 14, watchOS 7.0, *)
public extension QRCode.FillStyle.LinearGradient {
	/// Returns a SwiftUI LinearGradient for this fill style
	func linearGradient() -> LinearGradient {
		let stops: [Gradient.Stop] = self.gradient.pins
			.map { $0.gradientStop }
			.sorted { a, b in a.location < b.location }
		return LinearGradient(
			stops: stops,
			startPoint: UnitPoint(x: self.startPoint.x, y: self.startPoint.y),
			endPoint: UnitPoint(x: self.endPoint.x, y: self.endPoint.y)
		)
	}
}
#endif
