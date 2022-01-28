//
//  QRCodeDataShapePointy.swift
//
//  Created by Darren Ford on 28/1/2022.
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

import Foundation

public extension QRCode.DataShape {
	@objc(QRCodeDataShapePointy) class Pointy: NSObject, QRCodeDataShapeHandler {
		public static var Name: String = "pointy"
		public static func Create(_ settings: [String: Any]) -> QRCodeDataShapeHandler {
			Pointy()
		}

		public func settings() -> [String: Any] {
			return [:]
		}

		static let DefaultSize = CGSize(width: 10, height: 10)
		static let DefaultRect = CGRect(origin: .zero, size: DefaultSize)
		static let templateSquare: CGPath = {
			CGPath(rect: RoundedPath.DefaultRect, transform: nil)
		}()

		static let templatePointingDown: CGPath = {
			let p = CGMutablePath()
			p.move(to: .zero)
			p.line(to: CGPoint(x: DefaultRect.maxX, y: DefaultRect.minY))
			p.line(to: CGPoint(x: DefaultRect.maxX, y: DefaultRect.midY))
			p.line(to: CGPoint(x: DefaultRect.midX, y: DefaultRect.maxY))
			p.line(to: CGPoint(x: DefaultRect.minX, y: DefaultRect.midY))
			p.close()
			return p
		}()

		static let templatePointingUp: CGPath = {
			let p = CGMutablePath()
			// Note that top left is .zero
			p.move(to: CGPoint(x: DefaultRect.minX, y: DefaultRect.maxY))
			p.line(to: CGPoint(x: DefaultRect.maxX, y: DefaultRect.maxY))
			p.line(to: CGPoint(x: DefaultRect.maxX, y: DefaultRect.midY))
			p.line(to: CGPoint(x: DefaultRect.midX, y: DefaultRect.minY))
			p.line(to: CGPoint(x: DefaultRect.minX, y: DefaultRect.midY))
			p.close()
			return p
		}()

		static let templatePointingRight: CGPath = {
			let p = CGMutablePath()
			// Note that top left is .zero
			p.move(to: CGPoint(x: DefaultRect.minX, y: DefaultRect.minY))
			p.line(to: CGPoint(x: DefaultRect.minX, y: DefaultRect.maxY))
			p.line(to: CGPoint(x: DefaultRect.midX, y: DefaultRect.maxY))
			p.line(to: CGPoint(x: DefaultRect.maxX, y: DefaultRect.midY))
			p.line(to: CGPoint(x: DefaultRect.midX, y: DefaultRect.minY))
			p.close()
			return p
		}()

		static let templatePointingLeft: CGPath = {
			let p = CGMutablePath()
			// Note that top left is .zero
			p.move(to: CGPoint(x: DefaultRect.maxX, y: DefaultRect.minY))
			p.line(to: CGPoint(x: DefaultRect.midX, y: DefaultRect.minY))
			p.line(to: CGPoint(x: DefaultRect.minX, y: DefaultRect.midY))
			p.line(to: CGPoint(x: DefaultRect.midX, y: DefaultRect.maxY))
			p.line(to: CGPoint(x: DefaultRect.maxX, y: DefaultRect.maxY))
			p.close()
			return p
		}()

		public func copyShape() -> QRCodeDataShapeHandler {
			return Pointy()
		}

		public func onPath(size: CGSize, data: QRCode, isTemplate: Bool) -> CGPath {
			let dx = size.width / CGFloat(data.pixelSize)
			let dy = size.height / CGFloat(data.pixelSize)
			let dm = min(dx, dy)

			// The scale required to convert our template paths to output path size
			let w = QRCode.DataShape.RoundedPath.DefaultSize.width
			let scaleTransform = CGAffineTransform(scaleX: dm / w, y: dm / w)

			let xoff = (size.width - (CGFloat(data.pixelSize) * dm)) / 2.0
			let yoff = (size.height - (CGFloat(data.pixelSize) * dm)) / 2.0

			let path = CGMutablePath()

			for row in 1 ..< data.pixelSize - 1 {
				for col in 1 ..< data.pixelSize - 1 {
					let isEye = data.isEyePixel(row, col) && isTemplate == false

					if isEye || data.current[row, col] == false {
						continue
					}

					let hasLeft = data.current[row, col - 1]
					let hasRight = data.current[row, col + 1]
					let hasTop = data.current[row - 1, col]
					let hasBottom = data.current[row + 1, col]

					let translate = CGAffineTransform(translationX: CGFloat(col) * dm + xoff, y: CGFloat(row) * dm + yoff)

					if !hasLeft, !hasRight, !hasTop, !hasBottom {
						// isolated block
						path.addPath(Pointy.templateSquare,
										 transform: scaleTransform.concatenating(translate))
					}
					else if !hasLeft, !hasRight, !hasTop, hasBottom {
						// pointing up block
						path.addPath(
							Pointy.templatePointingUp,
							transform: scaleTransform.concatenating(translate)
						)
					}
					else if !hasLeft, !hasRight, !hasBottom, hasTop {
						// pointing down block
						path.addPath(
							Pointy.templatePointingDown,
							transform: scaleTransform.concatenating(translate)
						)
					}
					else if !hasTop, !hasRight, !hasBottom, hasLeft {
						// pointing right block
						path.addPath(
							Pointy.templatePointingRight,
							transform: scaleTransform.concatenating(translate)
						)
					}
					else if !hasTop, !hasLeft, !hasBottom, hasRight {
						// pointing left block
						path.addPath(
							Pointy.templatePointingLeft,
							transform: scaleTransform.concatenating(translate)
						)
					}
					else {
						path.addPath(
							Pointy.templateSquare,
							transform: scaleTransform.concatenating(translate)
						)
					}
				}
			}
			return path
		}

		public func offPath(size: CGSize, data: QRCode, isTemplate: Bool) -> CGPath {
			return CGMutablePath()
		}
	}
}
