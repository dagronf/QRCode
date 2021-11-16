//
//  File.swift
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

/// Square style pixels
@objc public class QRCodePixelStyleSquare: NSObject, QRCodePixelStyle {
	let edgeInset: CGFloat
	@objc public init(edgeInset: CGFloat = 0) {
		self.edgeInset = edgeInset
	}

	public func path(rect: CGRect) -> CGPath {
		let r = rect.insetBy(dx: edgeInset, dy: edgeInset)
		return CGPath(rect: r, transform: nil)
	}
}

/// Circle-style pixels
@objc public class QRCodePixelStyleCircle: NSObject, QRCodePixelStyle {
	let edgeInset: CGFloat
	@objc public init(edgeInset: CGFloat = 0) {
		self.edgeInset = edgeInset
	}

	public func path(rect: CGRect) -> CGPath {
		let r = rect.insetBy(dx: edgeInset, dy: edgeInset)
		return CGPath(ellipseIn: r, transform: nil)
	}
}

/// Round rect style pixels
@objc public class QRCodePixelStyleRoundedSquare: NSObject, QRCodePixelStyle {
	let edgeInset: CGFloat
	let cornerRadius: CGFloat

	/// Draws the pixel as a rounded rect.
	/// - Parameter cornerRadius: The fractional size of the corner radius given the pixel size (0 == square, 1 == round)
	@objc public init(
		cornerRadius: CGFloat,
		edgeInset: CGFloat = 0)
	{
		self.cornerRadius = min(1, max(0, cornerRadius))
		self.edgeInset = edgeInset
	}

	public func path(rect: CGRect) -> CGPath {
		let r = rect.insetBy(dx: edgeInset, dy: edgeInset)
		let d = r.size.width
		let cr = d / 2.0 * cornerRadius
		return CGPath(roundedRect: r, cornerWidth: cr, cornerHeight: cr, transform: nil)
	}
}
