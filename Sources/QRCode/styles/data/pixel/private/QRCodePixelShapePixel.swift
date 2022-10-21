//
//  QRCodePixelShapePixel.swift
//
//  Copyright © 2022 Darren Ford. All rights reserved.
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

internal extension QRCode.PixelShape {
	// A data shape generator where every pixel in the qr code becomes a discrete shape
	class CommonPixelGenerator {
		enum PixelType: String, CaseIterable {
			case square
			case circle
			case roundedRect
			case squircle
			case sharp
			static var availableTypes: [String] = Self.allCases.map { $0.rawValue }
		}

		var pixelType: PixelType

		// The fractional inset for the pixel
		var insetFraction: CGFloat
		// The fractional corner radius for the pixel
		var cornerRadiusFraction: CGFloat

		// Create
		// - Parameters:
		//   - pixelType: The type of pixel to use (eg. square, circle)
		//   - insetFraction: The inset within the each pixel to generate the pixel's path (0 -> 1)
		//   - cornerRadiusFraction: For types that support it, the roundedness of the corners (0 -> 1)
		init(pixelType: PixelType, insetFraction: CGFloat = 0, cornerRadiusFraction: CGFloat = 0) {
			self.pixelType = pixelType
			self.insetFraction = insetFraction.clamped(to: 0...1)
			self.cornerRadiusFraction = cornerRadiusFraction.clamped(to: 0...1)
		}

		private func path(size: CGSize, data: QRCode, isOn: Bool, isTemplate: Bool) -> CGPath {
			let dx = size.width / CGFloat(data.pixelSize)
			let dy = size.height / CGFloat(data.pixelSize)
			let dm = min(dx, dy)

			let xoff = (size.width - (CGFloat(data.pixelSize) * dm)) / 2.0
			let yoff = (size.height - (CGFloat(data.pixelSize) * dm)) / 2.0

			let path = CGMutablePath()

			for row in 0 ..< data.pixelSize {
				for col in 0 ..< data.pixelSize {
					if data.current[row, col] != isOn {
						continue
					}

					if !isTemplate && !isOn {
						if row == 0 || col == 0 || row == data.pixelSize - 1 || col == data.pixelSize - 1 {
							continue
						}
					}

					if data.isEyePixel(row, col), !isTemplate {
						// skip it
						continue
					}

					let r = CGRect(x: xoff + (CGFloat(col) * dm), y: yoff + (CGFloat(row) * dm), width: dm, height: dm)
					let insetValue = self.insetFraction * (r.height / 2.0)
					let ri = r.insetBy(dx: insetValue, dy: insetValue)

					if self.pixelType == .roundedRect {
						let cr = (ri.height / 2.0) * self.cornerRadiusFraction
						path.addPath(CGPath(roundedRect: ri, cornerWidth: cr, cornerHeight: cr, transform: nil))
					}
					else if self.pixelType == .circle {
						path.addPath(CGPath(ellipseIn: ri, transform: nil))
					}
					else if self.pixelType == .squircle {
						let transform = CGAffineTransform(scaleX: ri.width / 10, y: ri.width / 10)
							.concatenating(CGAffineTransform(
								translationX: xoff + (CGFloat(col) * dm) + insetValue,
								y: yoff + (CGFloat(row) * dm) + insetValue
							))

						let sq = Squircle.squircle10x10()
						path.addPath(sq, transform: transform)
					}
					else if self.pixelType == .sharp {
						let transform = CGAffineTransform(scaleX: ri.width / 10, y: ri.width / 10)
							.concatenating(CGAffineTransform(
								translationX: xoff + (CGFloat(col) * dm) + insetValue,
								y: yoff + (CGFloat(row) * dm) + insetValue
							))

						let sq = Sharp.sharp10x10()
						path.addPath(sq, transform: transform)
					}
					else {
						path.addPath(CGPath(rect: ri, transform: nil))
					}
				}
			}
			return path
		}

		public func onPath(size: CGSize, data: QRCode, isTemplate: Bool = false) -> CGPath {
			return self.path(size: size, data: data, isOn: true, isTemplate: isTemplate)
		}

		public func offPath(size: CGSize, data: QRCode, isTemplate: Bool = false) -> CGPath {
			return self.path(size: size, data: data, isOn: false, isTemplate: isTemplate)
		}
	}
}
