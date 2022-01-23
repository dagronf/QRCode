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

		static public let name: String = "pixel"
		static public func Create(_ settings: [String: Any]) -> QRCodeDataShapeHandler {
			let type = settings["pixelType", default: 0] as? Int32 ?? 0
			let pixelType = QRCode.DataShape.Pixel.PixelType(rawValue: type) ?? .square
			let inset = settings["inset", default: 0] as? Double ?? 0
			let radius = settings["cornerRadiusFraction", default: 0] as? Double ?? 0
			return QRCode.DataShape.Pixel(
				pixelType: pixelType,
				inset: inset,
				cornerRadiusFraction: radius.clamped(to: 0 ... 1))
		}

		public func settings() -> [String : Any] {
			return [
				"type": self.pixelType.rawValue,
				"inset": self.inset,
				"cornerRadiusFraction": self.cornerRadiusFraction
			]
		}

		@objc public enum PixelType: Int32 {
			case square = 0
			case circle = 1
			case roundedRect = 2
			case squircle = 3
		}

		public func copyShape() -> QRCodeDataShapeHandler {
			return Pixel(
				pixelType: self.pixelType,
				inset: self.inset,
				cornerRadiusFraction: self.cornerRadiusFraction
			)
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
					else if self.pixelType == .squircle {
						let i = (self.inset / 2)
						let transform = CGAffineTransform(scaleX: (ri.width / 10), y: (ri.width / 10))
							.concatenating(CGAffineTransform(
								translationX: xoff + (CGFloat(col) * dm) + i,
								y: yoff + (CGFloat(row) * dm) + i))

						let sq = Squircle.squircle10x10()
						path.addPath(sq, transform: transform)
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

// MARK: - Convenience types

public extension QRCode.DataShape {
	/// A square pixel shape
	@objc(QRCodeDataShapeSquare) class Square: Pixel {
		/// Create
		/// - Parameters:
		///   - inset: The inset within the each square to generate the path
		@objc public init(inset: CGFloat = 0) {
			super.init(pixelType: .square, inset: inset)
		}

		override public func copyShape() -> QRCodeDataShapeHandler {
			return Square(inset: self.inset)
		}
	}

	/// A circle pixel shape
	@objc(QRCodeDataShapeCircle) class Circle: Pixel {
		/// Create
		/// - Parameters:
		///   - inset: The inset within the each circle to generate the path
		@objc public init(inset: CGFloat = 0) {
			super.init(pixelType: .circle, inset: inset)
		}

		override public func copyShape() -> QRCodeDataShapeHandler {
			return Circle(inset: self.inset)
		}
	}

	/// A rounded rect pixel shape
	@objc(QRCodeDataShapeRoundedRect) class RoundedRect: Pixel {
		/// Create
		/// - Parameters:
		///   - inset: The inset within the each round rect to generate the path
		///   - cornerRadiusFraction: For types that support it, the roundedness of the corners (0 -> 1)
		@objc public init(inset: CGFloat = 0, cornerRadiusFraction: CGFloat = 0) {
			super.init(pixelType: .roundedRect, inset: inset, cornerRadiusFraction: cornerRadiusFraction)
		}

		override public func copyShape() -> QRCodeDataShapeHandler {
			return RoundedRect(inset: self.inset, cornerRadiusFraction: self.cornerRadiusFraction)
		}
	}

	/// A squircle pixel shape
	@objc(QRCodeDataShapeSquircle) class Squircle: Pixel {
		/// Create
		/// - Parameters:
		///   - inset: The inset within the each circle to generate the path
		@objc public init(inset: CGFloat = 0) {
			super.init(pixelType: .squircle, inset: inset)
		}

		override public func copyShape() -> QRCodeDataShapeHandler {
			return Squircle(inset: self.inset)
		}

		// A 10x10 'pixel' representation of a squircle
		fileprivate static func squircle10x10() -> CGPath {
			let s10 = CGMutablePath()
			s10.move(to: CGPoint(x: 5, y: 0))
			s10.curve(to: CGPoint(x: 9.2, y: 0.8), controlPoint1: CGPoint(x: 7.19, y: 0), controlPoint2: CGPoint(x: 8.41, y: 0))
			s10.curve(to: CGPoint(x: 10, y: 5), controlPoint1: CGPoint(x: 10, y: 1.59), controlPoint2: CGPoint(x: 10, y: 2.81))
			s10.curve(to: CGPoint(x: 9.2, y: 9.2), controlPoint1: CGPoint(x: 10, y: 7.19), controlPoint2: CGPoint(x: 10, y: 8.41))
			s10.curve(to: CGPoint(x: 5, y: 10), controlPoint1: CGPoint(x: 8.41, y: 10), controlPoint2: CGPoint(x: 7.19, y: 10))
			s10.curve(to: CGPoint(x: 0.8, y: 9.2), controlPoint1: CGPoint(x: 2.81, y: 10), controlPoint2: CGPoint(x: 1.59, y: 10))
			s10.curve(to: CGPoint(x: 0, y: 5), controlPoint1: CGPoint(x: 0, y: 8.41), controlPoint2: CGPoint(x: 0, y: 7.19))
			s10.curve(to: CGPoint(x: 0.8, y: 0.8), controlPoint1: CGPoint(x: 0, y: 2.81), controlPoint2: CGPoint(x: 0, y: 1.59))
			s10.curve(to: CGPoint(x: 5, y: 0), controlPoint1: CGPoint(x: 1.59, y: 0), controlPoint2: CGPoint(x: 2.81, y: 0))
			s10.close()
			return s10
		}
	}
}
