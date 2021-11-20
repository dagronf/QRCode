//
//  QRGradient.swift
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

/// A gradient
@objc(QRGradient) public class QRGradient: NSObject {
	@objc(QRGradientPin) public class Pin: NSObject {
		let color: CGColor
		let position: CGFloat
		@objc public init(_ color: CGColor, _ position: CGFloat) {
			self.color = color
			self.position = max(0, min(position, 1.0))
		}

		public func copyPin() -> Pin {
			let p = Pin(self.color.copy()!, self.position)
			return p
		}
	}

	// The pinned colors along the gradient path
	private let pins: [Pin]

	// The CoreGraphics gradient object
	public let cgGradient: CGGradient

	public func copyGradient() -> QRGradient {
		let pins = self.pins.map { $0.copyPin() }
		return QRGradient(pins: pins)!
	}

	/// Create a linear gradient
	/// - Parameters:
	///   - pins: The color pins to use when generating the gradient
	///   - colorspace: The colorspace to use. If not specified uses DeviceRGB
	@objc public init?(
		pins: [Pin],
		colorspace: CGColorSpace? = CGColorSpaceCreateDeviceRGB()
	) {
		self.pins = pins

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
