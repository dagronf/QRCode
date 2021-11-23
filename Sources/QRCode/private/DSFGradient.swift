//
//  DSFGradient.swift
//
//  Created by Darren Ford on 16/11/21.
//  Copyright © 2021 Darren Ford. All rights reserved.
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

/// A color gradient represented as 'pins' of color along a 0.0 -> 1.0 range
@objc(DSFGradient) public class DSFGradient: NSObject, NSCopying {
	@objc(DSFGradientPin) public class Pin: NSObject, NSCopying {
		@objc public let position: CGFloat
		@objc public let color: CGColor

		/// Create a color pin
		@objc public init(_ color: CGColor, _ position: CGFloat) {
			self.color = color
			self.position = max(0, min(position, 1.0))
		}

		/// Make a copy of the pin
		@objc @inlinable public func copyPin() -> Pin {
			return Pin(self.color.copy()!, self.position)
		}

		/// NSCopying conformance for objc
		@objc public func copy(with zone: NSZone? = nil) -> Any {
			return self.copyPin()
		}
	}

	// The pinned colors along the gradient path
	@objc public let pins: [Pin]

	// The CoreGraphics gradient object
	@objc public let cgGradient: CGGradient

	/// Make a copy of the gradient
	@objc @inlinable public func copyGradient() -> DSFGradient {
		let pins = self.pins.map { $0.copyPin() }
		return DSFGradient(pins: pins)!
	}

	/// NSCopying conformance for objc
	@objc public func copy(with zone: NSZone? = nil) -> Any {
		return self.copyGradient()
	}

	/// Create a linear gradient
	/// - Parameters:
	///   - pins: The color pins to use when generating the gradient
	///   - colorspace: The colorspace to use. If not specified uses DeviceRGB
	@objc public init?(
		pins: [Pin],
		colorspace: CGColorSpace? = CGColorSpaceCreateDeviceRGB()
	) {
		// Sort by the position from 0 (start position) -> 1 (end position)
		self.pins = pins.sorted(by: { p1, p2 in p1.position < p2.position })

		let cgcolors: [CGColor] = self.pins.map { $0.color }
		let positions: [CGFloat] = self.pins.map { $0.position }
		guard let gr = CGGradient(
			colorsSpace: colorspace,
			colors: cgcolors as CFArray,
			locations: positions
		) else {
			return nil
		}
		self.cgGradient = gr
	}
}

public extension DSFGradient {

	// Format (all values fractional between 0.0 and 1.0):
	// red,green,blue,alpha,position|red,green,blue,alpha,position|red,green,blue,alpha,position:...
	//  0.0:1.0,0.0,0.0|0.5:0.0,1.0,0.0,1.0|1.0:0.0,0.0,1.0,1.0

	/// Create a string 'archive' of the object
	@objc func asRGBAGradientString() -> String? {
		var result = ""
		for pin in self.pins {
			if result.count > 0 { result += "|" }
			guard
				let pc = pin.color.converted(
					to: CGColorSpace(name: CGColorSpace.genericRGBLinear)!,
					intent: .defaultIntent,
					options: nil),
				let comps = pc.components,
				pc.numberOfComponents == 4
			else {
				return nil
			}
			result += "\(pin.position):\(comps[0]),\(comps[1]),\(comps[2]),\(comps[3])"
		}
		return result
	}

	/// Create a DSFGradient from a DSFGradient archive format
	/// - Parameter content: The archive 'string'
	/// - Returns: The DSFGradient, or nil if the content didn't contain a valid DSFGradient archive
	@objc static func FromRGBAGradientString(_ content: String) -> DSFGradient? {

		// Split out the pins
		let pinsS = content.split(separator: "|")

		// If the number of pins is < 2, then its an invalid gradient
		guard pinsS.count > 1 else { return nil }

		var pins: [Pin] = []

		for pinS in pinsS {

			// Pin format is "0.5:1,0,0,0.1"

			let grPin = pinS
				.split(separator: ":")                             // Split into position:color
				.map { $0.trimmingCharacters(in: .whitespaces) }   // Trim whitespace on each component
			guard grPin.count == 2 else { return nil }

			// First component is the fractional pin position
			guard var pos = CGFloat(grPin[0]) else { return nil }
			pos = pos.clamped(to: 0.0 ... 1.0)

			// Second component is the RGBA color component
			let compsS = grPin[1].split(separator: ",")
			let comps: [CGFloat] = compsS
				.map { $0.trimmingCharacters(in: .whitespaces) }    // Trim whitespaces
				.compactMap { CGFloat($0) }                         // Attempt to convert each component to a CGFloat
				.map { $0.clamped(to: 0 ... 1) }                    // Clamp the value to 0 -> 1
			guard comps.count == 4 else { return nil }

			let pin = Pin(CGColor(red: comps[0], green: comps[1], blue: comps[2], alpha: comps[3]), pos)
			pins.append(pin)
		}

		pins = pins.sorted(by: { p1, p2 in p1.position < p2.position })
		return DSFGradient(pins: pins)
	}
}
