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

import Foundation
import CoreGraphics

/// A gradient
@objc public class QRGradient: NSObject, NSCopying {

	@objc(QRGradientPin) public class Pin: NSObject, NSCopying {
		let color: CGColor
		let position: CGFloat
		public init(_ color: CGColor, _ position: CGFloat) {
			self.color = color
			self.position = max(0, min(position, 1.0))
		}
		public func copy(with zone: NSZone? = nil) -> Any {
			return Pin(self.color.copy()!, self.position)
		}
	}

	// The pinned colors along the gradient path
	private let pins: [Pin]

	// For linear
	public var start: CGPoint
	public var end: CGPoint

	// For radial gradients, the center point
	public var center: CGPoint = CGPoint(x: 0.5, y: 0.5)

	public let cgGradient: CGGradient

	public func copy(with zone: NSZone? = nil) -> Any {
		return QRGradient(pins: self.pins, start: start, end: end)!
	}


	/// Create a linear gradient
	/// - Parameters:
	///   - gradient: The color pins to use when generating the gradient
	///   - colorspace: The colorspace to use. If not specified uses DeviceRGB
	///   - start: The fractional position within the drawing rectangle to START the gradient at (0,0 == top left, 1,1 == bottom right)
	///   - end: The fractional position within the drawing rectangle to END the gradient at (0,0 == top left, 1,1 == bottom right)
	public init?(
		pins: [Pin],
		colorspace: CGColorSpace? = CGColorSpaceCreateDeviceRGB(),
		start: CGPoint = CGPoint(x: 0, y: 0),
		end: CGPoint = CGPoint(x: 1.0, y: 1.0))
	{
		self.pins = pins
		self.start = start
		self.end = end

		let cgcolors: [CGColor] = self.pins.map { $0.color }
		let positions: [CGFloat] = self.pins.map { $0.position }
		guard let gr = CGGradient(colorsSpace: colorspace,
										  colors: cgcolors as CFArray,
										  locations: positions) else {
			return nil
		}
		self.cgGradient = gr
	}

	public func gradientStartPt(forSize: CGFloat) -> CGPoint {
		return CGPoint(x: self.start.x * forSize, y: self.start.y * forSize)
	}

	public func gradientEndPt(forSize: CGFloat) -> CGPoint {
		return CGPoint(x: self.end.x * forSize, y: self.end.y * forSize)
	}

	public func gradientCenterPt(forSize: CGFloat) -> CGPoint {
		return CGPoint(x: self.center.x * forSize, y: self.center.y * forSize)
	}
}
