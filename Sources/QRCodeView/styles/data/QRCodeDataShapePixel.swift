//
//  QRCodeDataShapePixel.swift
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

import CoreGraphics
import Foundation

public extension QRCode.DataShape {
	/// A data shape generator where every pixel in the qr code becomes a discrete shape
	@objc(QRCodeDataShapePixel) class Pixel: NSObject, QRCodeDataShapeHandler {
		@objc public enum PixelType: Int32 {
			case square = 0
			case circle = 1
			case roundedRect = 2
		}

		public func copyShape() -> QRCodeDataShapeHandler {
			return Pixel(
				pixelType: self.pixelType,
				inset: self.inset,
				cornerRadiusFraction: self.cornerRadiusFraction)
		}

		let inset: CGFloat
		let pixelType: PixelType
		let cornerRadiusFraction: CGFloat

		/// Create
		/// - Parameters:
		///   - pixelType: The type of pixel to use (eg. square, circle)
		///   - inset: The inset within the each pixel to generate the pixel's path
		///   - cornerRadiusFraction: For types that support it, the roundedness of the corners (0 -> 1)
		@objc public init(pixelType: PixelType, inset: CGFloat = 0, cornerRadiusFraction: CGFloat = 0) {
			self.pixelType = pixelType
			self.inset = inset
			self.cornerRadiusFraction = cornerRadiusFraction
			super.init()
		}

		private func path(size: CGSize, data: QRCode, isOn: Bool) -> CGPath {
			let dx = size.width / CGFloat(data.pixelSize)
			let dy = size.height / CGFloat(data.pixelSize)
			let dm = min(dx, dy)

			let xoff = (size.width - (CGFloat(data.pixelSize) * dm)) / 2.0
			let yoff = (size.height - (CGFloat(data.pixelSize) * dm)) / 2.0

			let path = CGMutablePath()

			for row in 1 ..< data.pixelSize - 1 {
				for col in 1 ..< data.pixelSize - 1 {
					if data.current[row, col] != isOn {
						continue
					}

					if data.isEyePixel(row, col) {
						// skip it
						continue
					}

					let r = CGRect(x: xoff + (CGFloat(col) * dm), y: yoff + (CGFloat(row) * dm), width: dm, height: dm)
					let ri = r.insetBy(dx: self.inset, dy: self.inset)

					if self.pixelType == .roundedRect {
						let cr = (ri.height / 2.0) * self.cornerRadiusFraction
						path.addPath(CGPath(roundedRect: ri, cornerWidth: cr, cornerHeight: cr, transform: nil))
					}
					else if self.pixelType == .circle {
						path.addPath(CGPath(ellipseIn: ri, transform: nil))
					}
					else {
						path.addPath(CGPath(rect: ri, transform: nil))
					}
				}
			}
			return path
		}

		public func onPath(size: CGSize, data: QRCode) -> CGPath {
			return self.path(size: size, data: data, isOn: true)
		}

		public func offPath(size: CGSize, data: QRCode) -> CGPath {
			return self.path(size: size, data: data, isOn: false)
		}
	}
}
