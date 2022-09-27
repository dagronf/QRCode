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
			let radius = DoubleValue(settings?["cornerRadiusFraction"]) ?? self.DefaultCornerRadiusValue
			return RoundedPath(cornerRadiusFraction: radius)
		}

		public func settings() -> [String: Any] {
			return ["cornerRadiusFraction": self._cornerRadius]
		}

		// The template pixel generator size is 10x10
		static let DefaultSize = CGSize(width: 10, height: 10)
		static let DefaultRect = CGRect(origin: .zero, size: DefaultSize)

		// The default radius for the curved edges is 3
		private static let DefaultCornerRadiusValue: CGFloat = 0.3

		private var actualRadiusSize = CGSize(width: 3, height: 3)
		private var actualRadius: CGFloat = 3

		private func cornerRadiusChanged() {
			self.actualRadius = self._cornerRadius * 5
			self.actualRadiusSize = CGSize(width: self.actualRadius, height: self.actualRadius)
		}

		// The radius as relates to the 10x10 pixel size
		private var _cornerRadius: CGFloat = DefaultCornerRadiusValue {
			didSet {
				self.cornerRadiusChanged()
			}
		}

		/// The corner radius fraction (0 ... 1)
		@objc public var cornerRadiusFraction: CGFloat {
			get { self._cornerRadius }
			set { self._cornerRadius = newValue.clamped(to: 0 ... 1) }
		}

		@objc public init(cornerRadiusFraction: CGFloat = 0.3) {
			self._cornerRadius = cornerRadiusFraction.clamped(to: 0 ... 1)
			super.init()
			self.cornerRadiusChanged()
		}

		@objc public func copyShape() -> QRCodePixelShapeGenerator {
			RoundedPath(cornerRadiusFraction: self.cornerRadiusFraction)
		}

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
						self.templateCircle(),
						transform: scaleTransform.concatenating(translate)
					)
				}
				else if hasLeft, !hasRight, !hasTop, !hasBottom {
					path.addPath(
						self.templateRoundRight(),
						transform: scaleTransform.concatenating(translate)
					)
				}
				else if !hasLeft, hasRight, !hasTop, !hasBottom {
					path.addPath(
						self.templateRoundLeft(),
						transform: scaleTransform.concatenating(translate)
					)
				}
				else if !hasLeft, !hasRight, hasTop, !hasBottom {
					path.addPath(
						self.templateRoundBottom(),
						transform: scaleTransform.concatenating(translate)
					)
				}
				else if !hasLeft, !hasRight, !hasTop, hasBottom {
					path.addPath(
						self.templateRoundTop(),
						transform: scaleTransform.concatenating(translate)
					)
				}

				else if hasLeft, hasTop, !hasRight, !hasBottom {
					path.addPath(
						self.templateBottomRight(),
						transform: scaleTransform.concatenating(translate)
					)
				}
				else if !hasLeft, hasTop, hasRight, !hasBottom {
					path.addPath(
						self.templateBottomLeft(),
						transform: scaleTransform.concatenating(translate)
					)
				}
				else if hasLeft, !hasTop, !hasRight, hasBottom {
					path.addPath(
						self.templateTopRight(),
						transform: scaleTransform.concatenating(translate)
					)
				}
				else if !hasLeft, !hasTop, hasRight, hasBottom {
					path.addPath(
						self.templateTopLeft(),
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

// MARK: - Template shapes

private extension QRCode.PixelShape.RoundedPath {
	private static let templateSquare = CGPath(rect: QRCode.PixelShape.RoundedPath.DefaultRect, transform: nil)

	private func templateCircle() -> CGPath {
		CGPath(
			roundedRect: QRCode.PixelShape.RoundedPath.DefaultRect,
			cornerWidth: actualRadius, cornerHeight: actualRadius,
			transform: nil
		)
	}

	private func templateRoundTop() -> CGPath {
		CGPath.RoundedRect(
			rect: QRCode.PixelShape.RoundedPath.DefaultRect,
			topLeftRadius: actualRadiusSize,
			topRightRadius: actualRadiusSize
		)
	}

	private func templateRoundRight() -> CGPath {
		CGPath.RoundedRect(
			rect: QRCode.PixelShape.RoundedPath.DefaultRect,
			topRightRadius: actualRadiusSize,
			bottomRightRadius: actualRadiusSize
		)
	}

	private func templateRoundBottom() -> CGPath {
		CGPath.RoundedRect(
			rect: QRCode.PixelShape.RoundedPath.DefaultRect,
			bottomLeftRadius: actualRadiusSize,
			bottomRightRadius: actualRadiusSize
		)
	}

	private func templateRoundLeft() -> CGPath {
		CGPath.RoundedRect(
			rect: QRCode.PixelShape.RoundedPath.DefaultRect,
			topLeftRadius: actualRadiusSize,
			bottomLeftRadius: actualRadiusSize
		)
	}

	private func templateBottomRight() -> CGPath {
		CGPath.RoundedRect(
			rect: QRCode.PixelShape.RoundedPath.DefaultRect,
			bottomRightRadius: actualRadiusSize
		)
	}

	private func templateTopRight() -> CGPath {
		CGPath.RoundedRect(
			rect: QRCode.PixelShape.RoundedPath.DefaultRect,
			topRightRadius: actualRadiusSize
		)
	}

	private func templateTopLeft() -> CGPath {
		CGPath.RoundedRect(
			rect: QRCode.PixelShape.RoundedPath.DefaultRect,
			topLeftRadius: actualRadiusSize
		)
	}

	private func templateBottomLeft() -> CGPath {
		CGPath.RoundedRect(
			rect: QRCode.PixelShape.RoundedPath.DefaultRect,
			bottomLeftRadius: actualRadiusSize
		)
	}
}
