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
	/// A simple radial gradient fill
	@objc(QRCodeFillStyleRadialGradient)
	class RadialGradient: NSObject, QRCodeFillStyleGenerator {

		@objc public static var Name: String { "radialgradient" }

		/// The gradient to use
		@objc public let gradient: DSFGradient

		/// The center point for the radial gradient
		@objc public var centerPoint: CGPoint

		/// The current settings for the radial gradient
		@objc public func settings() throws -> [String: Any] {
			[
				"centerX": centerPoint.x,
				"centerY": centerPoint.y,
				"gradient": try self.gradient.asRGBAGradientString()
			]
		}

		/// Create a radial gradient with the specified settings
		@objc public static func Create(settings: [String: Any]) throws -> (any QRCodeFillStyleGenerator) {
			guard
				let cX = DoubleValue(settings["centerX"]),
				let cY = DoubleValue(settings["centerY"]),
				let gs = settings["gradient"] as? String
			else {
				throw QRCodeError.cannotCreateGenerator
			}
			let grad = try DSFGradient.FromRGBAGradientString(gs)
			return QRCode.FillStyle.RadialGradient(grad, centerPoint: CGPoint(x: cX, y: cY))
		}

		/// Fill the specified path/rect with a gradient
		/// - Parameters:
		///   - gradient: The color gradient to use
		///   - centerPoint: The fractional position within the fill rect to start the radial fill (0.0 -> 1.0)
		@objc public init(
			_ gradient: DSFGradient,
			centerPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)
		) {
			self.gradient = gradient
			self.centerPoint = centerPoint
		}

		/// Fill the specified path/rect with a gradient
		/// - Parameters:
		///   - pins: An array of pins for the gradient
		///   - centerPoint: The fractional position within the fill rect to start the radial fill (0.0 -> 1.0)
		@objc public init(
			pins: [DSFGradient.Pin],
			centerPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)
		) throws {
			self.gradient = try DSFGradient(pins: pins)
			self.centerPoint = centerPoint
		}

		/// Fill the specified rect with the gradient
		public func fill(ctx: CGContext, rect: CGRect) {
			let grCentre = self.gradientCenterPt(rect)
			let grRadius = rect.width / 1.75
			ctx.drawRadialGradient(
				self.gradient.cgGradient,
				startCenter: self.gradientCenterPt(rect),
				startRadius: 0,
				endCenter: grCentre,
				endRadius: grRadius,
				options: [.drawsAfterEndLocation, .drawsBeforeStartLocation])
		}

		/// Fill the specified path with the gradient
		public func fill(ctx: CGContext, rect: CGRect, path: CGPath, expectedPixelSize: CGFloat, shadow: QRCode.Shadow? = nil) {
			ctx.usingGState { c in
				c.addPath(path)
				c.clip()

				let grCentre = self.gradientCenterPt(rect)
				let grRadius = rect.width / 1.75
				c.drawRadialGradient(
					self.gradient.cgGradient,
					startCenter: self.gradientCenterPt(rect), startRadius: 0,
					endCenter: grCentre, endRadius: grRadius,
					options: [.drawsAfterEndLocation, .drawsBeforeStartLocation]
				)
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

		public func copyStyle() throws -> any QRCodeFillStyleGenerator {
			return RadialGradient(
				try self.gradient.copyGradient(),
				centerPoint: self.centerPoint
			)
		}

		private func gradientCenterPt(_ rect: CGRect) -> CGPoint {
			return CGPoint(
				x: rect.minX + (self.centerPoint.x * rect.width),
				y: rect.minY + (self.centerPoint.y * rect.height)
			)
		}
	}
}

// MARK: - Fill creation conveniences

public extension QRCodeFillStyleGenerator where Self == QRCode.FillStyle.RadialGradient {
	/// Create a radial gradient fill
	/// - Parameters:
	///   - gradient: The color gradient to use
	///   - centerPoint: The fractional position within the fill rect to start the radial fill (0.0 -> 1.0)
	/// - Returns: A fill generator
	@inlinable static func radialGradient(
		_ gradient: DSFGradient,
		centerPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)
	) -> QRCodeFillStyleGenerator {
		QRCode.FillStyle.RadialGradient(gradient, centerPoint: centerPoint)
	}
}

// MARK: - SVG Representation

public extension QRCode.FillStyle.RadialGradient {

	func svgRepresentation(
		styleIdentifier: String,
		expectedPixelSize: CGFloat,
		shadow: QRCode.Shadow? = nil
	) throws -> QRCode.FillStyle.SVGDefinition {

		var svg = "<radialGradient "
		svg += "id=\"\(styleIdentifier)\" "

		let center = self.centerPoint
		svg += "cx=\"\(center.x)\" cy=\"\(center.y)\" r=\"0.5\">\n"

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
			svg += "   <stop offset=\"\(pin.position)\" stop-color=\"\(rgbColor)\" stop-opacity=\"\(pin.color.alpha)\" />\n"
		}
		svg += "</radialGradient>\n"

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
public extension QRCode.FillStyle.RadialGradient {
	/// Returns a SwiftUI RadialGradient for this fill style
	func radialGradient(startRadius: CGFloat, endRadius: CGFloat) -> RadialGradient {
		let stops: [Gradient.Stop] = self.gradient.pins
			.map { $0.gradientStop }
			.sorted { a, b in a.location < b.location }
		return RadialGradient(
			stops: stops,
			center: UnitPoint(x: self.centerPoint.x, y: self.centerPoint.y),
			startRadius: startRadius,
			endRadius: endRadius
		)
	}
}
#endif
