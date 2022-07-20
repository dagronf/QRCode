//
//  QRCodePixelShapeRoundedPath.swift
//
//  Created by Darren Ford on 17/11/21.
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

public extension QRCode.PixelShape {
	@objc(QRCodePixelShapeRoundedPath) class RoundedPath: NSObject, QRCodePixelShapeGenerator {
		public static var Name = "roundedPath"
		public static func Create(_ settings: [String: Any]?) -> QRCodePixelShapeGenerator {
			return QRCode.PixelShape.RoundedPath()
		}

		public func settings() -> [String: Any] {
			return [:]
		}

		static let DefaultSize = CGSize(width: 10, height: 10)
		static let DefaultRect = CGRect(origin: .zero, size: DefaultSize)
		static let DefaultRadius = CGSize(width: 3, height: 3)

		public func copyShape() -> QRCodePixelShapeGenerator {
			RoundedPath()
		}

		static let templateCircle = CGPath(
			roundedRect: RoundedPath.DefaultRect,
			cornerWidth: DefaultRadius.width, cornerHeight: DefaultRadius.height,
			transform: nil
		)

		static let templateSquare = CGPath(rect: RoundedPath.DefaultRect, transform: nil)

		static let templateRoundTop = CGPath.RoundedRect(
			rect: RoundedPath.DefaultRect,
			topLeftRadius: RoundedPath.DefaultRadius,
			topRightRadius: RoundedPath.DefaultRadius
		)

		static let templateRoundRight = CGPath.RoundedRect(
			rect: RoundedPath.DefaultRect,
			topRightRadius: RoundedPath.DefaultRadius,
			bottomRightRadius: RoundedPath.DefaultRadius
		)

		static let templateRoundBottom = CGPath.RoundedRect(
			rect: RoundedPath.DefaultRect,
			bottomLeftRadius: RoundedPath.DefaultRadius,
			bottomRightRadius: RoundedPath.DefaultRadius
		)

		static let templateRoundLeft = CGPath.RoundedRect(
			rect: RoundedPath.DefaultRect,
			topLeftRadius: RoundedPath.DefaultRadius,
			bottomLeftRadius: RoundedPath.DefaultRadius
		)

		static let templateBottomRight = CGPath.RoundedRect(
			rect: RoundedPath.DefaultRect,
			bottomRightRadius: RoundedPath.DefaultRadius
		)

		static let templateTopRight = CGPath.RoundedRect(
			rect: RoundedPath.DefaultRect,
			topRightRadius: RoundedPath.DefaultRadius
		)

		static let templateTopLeft = CGPath.RoundedRect(
			rect: RoundedPath.DefaultRect,
			topLeftRadius: RoundedPath.DefaultRadius
		)

		static let templateBottomLeft = CGPath.RoundedRect(
			rect: RoundedPath.DefaultRect,
			bottomLeftRadius: RoundedPath.DefaultRadius
		)

		public func onPath(size: CGSize, data: QRCode, isTemplate: Bool = false) -> CGPath {
			return self.generatePath(size: size, data: data, isOn: true, isTemplate: isTemplate)
		}

		public func offPath(size: CGSize, data: QRCode, isTemplate: Bool = false) -> CGPath {
			return self.generatePath(size: size, data: data, isOn: false, isTemplate: isTemplate)
		}
	}
}

extension QRCode.PixelShape.RoundedPath {
	private func generatePath(size: CGSize, data: QRCode, isOn: Bool, isTemplate: Bool) -> CGPath {
		let dx = size.width / CGFloat(data.pixelSize)
		let dy = size.height / CGFloat(data.pixelSize)
		let dm = min(dx, dy)

		// The scale required to convert our template paths to output path size
		let w = QRCode.PixelShape.RoundedPath.DefaultSize.width
		let scaleTransform = CGAffineTransform(scaleX: dm / w, y: dm / w)

		let xoff = (size.width - (CGFloat(data.pixelSize) * dm)) / 2.0
		let yoff = (size.height - (CGFloat(data.pixelSize) * dm)) / 2.0

		let path = CGMutablePath()

		for row in 0 ..< data.pixelSize {
			for col in 0 ..< data.pixelSize {
				let isEye = data.isEyePixel(row, col) == true && isTemplate == false
				guard
					data.current[row, col] == isOn, isEye == false
				else {
					continue
				}

				let hasLeft = (col - 1) >= 0 ? data.current[row, col - 1] : false
				let hasRight = (col + 1) < data.pixelSize ? data.current[row, col + 1] : false
				let hasTop = (row - 1) >= 0 ? data.current[row - 1, col] : false
				let hasBottom = (row + 1) < data.pixelSize ? data.current[row + 1, col] : false

				let translate = CGAffineTransform(translationX: CGFloat(col) * dm + xoff, y: CGFloat(row) * dm + yoff)

				if !hasLeft, !hasRight, !hasTop, !hasBottom {
					path.addPath(
						QRCode.PixelShape.RoundedPath.templateCircle,
						transform: scaleTransform.concatenating(translate)
					)
				}
				else if hasLeft, !hasRight, !hasTop, !hasBottom {
					path.addPath(
						QRCode.PixelShape.RoundedPath.templateRoundRight,
						transform: scaleTransform.concatenating(translate)
					)
				}
				else if !hasLeft, hasRight, !hasTop, !hasBottom {
					path.addPath(
						QRCode.PixelShape.RoundedPath.templateRoundLeft,
						transform: scaleTransform.concatenating(translate)
					)
				}
				else if !hasLeft, !hasRight, hasTop, !hasBottom {
					path.addPath(
						QRCode.PixelShape.RoundedPath.templateRoundBottom,
						transform: scaleTransform.concatenating(translate)
					)
				}
				else if !hasLeft, !hasRight, !hasTop, hasBottom {
					path.addPath(
						QRCode.PixelShape.RoundedPath.templateRoundTop,
						transform: scaleTransform.concatenating(translate)
					)
				}

				else if hasLeft, hasTop, !hasRight, !hasBottom {
					path.addPath(
						QRCode.PixelShape.RoundedPath.templateBottomRight,
						transform: scaleTransform.concatenating(translate)
					)
				}
				else if !hasLeft, hasTop, hasRight, !hasBottom {
					path.addPath(
						QRCode.PixelShape.RoundedPath.templateBottomLeft,
						transform: scaleTransform.concatenating(translate)
					)
				}
				else if hasLeft, !hasTop, !hasRight, hasBottom {
					path.addPath(
						QRCode.PixelShape.RoundedPath.templateTopRight,
						transform: scaleTransform.concatenating(translate)
					)
				}
				else if !hasLeft, !hasTop, hasRight, hasBottom {
					path.addPath(
						QRCode.PixelShape.RoundedPath.templateTopLeft,
						transform: scaleTransform.concatenating(translate)
					)
				}

				else {
					path.addPath(
						QRCode.PixelShape.RoundedPath.templateSquare,
						transform: scaleTransform.concatenating(translate)
					)
				}
			}
		}
		return path
	}
}
