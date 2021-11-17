//
//  QRCodeDataShapeHorizontal.swift
//
//  Created by Darren Ford on 17/11/21.
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

@objc public class QRCodeDataShapeHorizontal: NSObject, QRCodeDataShape {

	public func copyShape() -> QRCodeDataShape {
		return QRCodeDataShapeHorizontal(
			inset: self.inset,
			cornerRadiusFraction: self.cornerRadiusFraction)
	}

	let inset: CGFloat
	let cornerRadiusFraction: CGFloat
	@objc public init(inset: CGFloat = 0, cornerRadiusFraction: CGFloat = 0) {
		self.inset = inset
		self.cornerRadiusFraction = min(1, max(0, cornerRadiusFraction))
		super.init()
	}

	public func onPath(size: CGSize, data: QRCode) -> CGPath {

		let dx = size.width / CGFloat(data.pixelSize)
		let dy = size.height / CGFloat(data.pixelSize)
		let dm = min(dx, dy)

		let xoff = (size.width - (CGFloat(data.pixelSize) * dm)) / 2.0
		let yoff = (size.height - (CGFloat(data.pixelSize) * dm)) / 2.0

		let path = CGMutablePath()

		for row in 1 ..< data.pixelSize - 1 {

			var activeRect: CGRect?

			for col in 1 ..< data.pixelSize - 1 {

				if data.current[row, col] == false || data.isEyePixel(row, col) {
					if let r = activeRect {
						// Close the rect
						let ri = r.insetBy(dx: inset, dy: inset)
						let cr = (ri.height / 2.0) * cornerRadiusFraction
						path.addPath(CGPath(roundedRect: ri, cornerWidth: cr, cornerHeight: cr, transform: nil))
					}
					activeRect = nil
					continue
				}

				if var a = activeRect {
					a.size.width += dm
					activeRect = a
				}
				else {
					activeRect = CGRect(x: xoff + (CGFloat(col) * dm), y: yoff + (CGFloat(row) * dm), width: dm, height: dm)
				}
			}

			if let r = activeRect {
				// Close the rect
				let ri = r.insetBy(dx: inset, dy: inset)
				let cr = (ri.height / 2.0) * cornerRadiusFraction
				path.addPath(CGPath(roundedRect: ri, cornerWidth: cr, cornerHeight: cr, transform: nil))
			}
		}
		return path
	}

	public func offPath(size: CGSize, data: QRCode) -> CGPath {
		let dx = size.width / CGFloat(data.pixelSize)
		let dy = size.height / CGFloat(data.pixelSize)
		let dm = min(dx, dy)

		let xoff = (size.width - (CGFloat(data.pixelSize) * dm)) / 2.0
		let yoff = (size.height - (CGFloat(data.pixelSize) * dm)) / 2.0

		let path = CGMutablePath()

		for row in 1 ..< data.pixelSize - 1 {

			var activeRect: CGRect?

			for col in 1 ..< data.pixelSize - 1 {

				if data.current[row, col] == true || data.isEyePixel(row, col) {
					if let r = activeRect {
						// Close the rect
						let ri = r.insetBy(dx: inset, dy: inset)
						let cr = (ri.height / 2.0) * cornerRadiusFraction
						path.addPath(CGPath(roundedRect: ri, cornerWidth: cr, cornerHeight: cr, transform: nil))
					}
					activeRect = nil
					continue
				}

				if var a = activeRect {
					a.size.width += dm
					activeRect = a
				}
				else {
					activeRect = CGRect(x: xoff + (CGFloat(col) * dm), y: yoff + (CGFloat(row) * dm), width: dm, height: dm)
				}
			}

			if let r = activeRect {
				// Close the rect
				let ri = r.insetBy(dx: inset, dy: inset)
				let cr = (ri.height / 2.0) * cornerRadiusFraction
				path.addPath(CGPath(roundedRect: ri, cornerWidth: cr, cornerHeight: cr, transform: nil))
			}
		}
		return path

	}
}
