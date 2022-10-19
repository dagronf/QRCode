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
		/// The generator name
		@objc public static let Name = "roundedPath"

		/// Create an instance of this path generator with the specified settings
		@objc public static func Create(_ settings: [String: Any]?) -> QRCodePixelShapeGenerator {
			let radius = DoubleValue(settings?[QRCode.SettingsKey.cornerRadiusFraction]) ?? self.DefaultCornerRadiusValue
			let hasInnerCorners = BoolValue(settings?[QRCode.SettingsKey.hasInnerCorners]) ?? false
			return RoundedPath(cornerRadiusFraction: radius, hasInnerCorners: hasInnerCorners)
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

		/// Do we draw the inner corners when drawing path?
		@objc public var hasInnerCorners: Bool = false

		/// Create
		@objc public init(
			cornerRadiusFraction: CGFloat = 0.3,
			hasInnerCorners: Bool = false
		) {
			self._cornerRadius = cornerRadiusFraction.clamped(to: 0 ... 1)
			self.hasInnerCorners = hasInnerCorners
			super.init()
			self.cornerRadiusChanged()
		}

		/// Make a copy of the shape
		@objc public func copyShape() -> QRCodePixelShapeGenerator {
			RoundedPath(
				cornerRadiusFraction: self.cornerRadiusFraction,
				hasInnerCorners: self.hasInnerCorners
			)
		}

		/// The path representing the 'on' pixels
		public func onPath(size: CGSize, data: QRCode, isTemplate: Bool = false) -> CGPath {
			return self.generatePath(size: size, data: data, isOn: true, isTemplate: isTemplate)
		}

		/// The path representing the 'off' pixels
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

		// Mask out the QR patterns (if we're not a template image)
		let currentData = isTemplate ? data.current : data.current.maskingQREyes(inverted: !isOn)

		for row in 1 ..< data.pixelSize - 1 {
			for col in 1 ..< data.pixelSize - 1 {

				let hasLeft = (col - 1) >= 0 ? currentData[row, col - 1] : false
				let hasRight = (col + 1) < data.pixelSize ? currentData[row, col + 1] : false
				let hasTop = (row - 1) >= 0 ? currentData[row - 1, col] : false
				let hasBottom = (row + 1) < data.pixelSize ? currentData[row + 1, col] : false

				let translate = CGAffineTransform(translationX: CGFloat(col) * dm + xoff, y: CGFloat(row) * dm + yoff)

				guard currentData[row, col] == true else {
					guard hasInnerCorners == true else {
						continue
					}

					let hasTopLeft = ((col - 1) >= 0 && (row - 1) >= 0) ? currentData[row - 1, col - 1] : false
					let hasTopRight = ((col + 1) >= 0 && (row - 1) >= 0) ? currentData[row - 1, col + 1] : false
					let hasBottomLeft = ((col - 1) >= 0 && (row + 1) >= 0) ? currentData[row + 1, col - 1] : false
					let hasBottomRight = ((col + 1) >= 0 && (row + 1) >= 0) ? currentData[row + 1, col + 1] : false

					if hasLeft, hasTop, hasTopLeft {
						path.addPath(
							self.templateRoundTopLeft(),
							transform: scaleTransform.concatenating(translate)
						)
					}
					if hasRight, hasTop, hasTopRight {
						path.addPath(
							self.templateRoundTopRight(),
							transform: scaleTransform.concatenating(translate)
						)
					}
					if hasLeft, hasBottom, hasBottomLeft {
						path.addPath(
							self.templateRoundBottomLeft(),
							transform: scaleTransform.concatenating(translate)
						)
					}
					if hasRight, hasBottom, hasBottomRight {
						path.addPath(
							self.templateRoundBottomRight(),
							transform: scaleTransform.concatenating(translate)
						)
					}
					continue
				}

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

// MARK: - Template corner shapes

private extension QRCode.PixelShape.RoundedPath {
	private func templateRoundTopLeft() -> CGPath {
		let tlPath = CGMutablePath()
		tlPath.move(to: CGPoint(x: 1.31, y: 0.14))
		tlPath.curve(to: CGPoint(x: 0.58, y: 0.58), controlPoint1: CGPoint(x: 1, y: 0.24), controlPoint2: CGPoint(x: 0.77, y: 0.39))
		tlPath.curve(to: CGPoint(x: 0.15, y: 1.26), controlPoint1: CGPoint(x: 0.39, y: 0.77), controlPoint2: CGPoint(x: 0.24, y: 1))
		tlPath.curve(to: CGPoint(x: 0, y: 3.06), controlPoint1: CGPoint(x: -0, y: 1.74), controlPoint2: CGPoint(x: 0, y: 2.18))
		tlPath.curve(to: CGPoint(x: 0, y: 0), controlPoint1: CGPoint(x: 0, y: 1.35), controlPoint2: CGPoint(x: 0, y: 0))
		tlPath.line(to: CGPoint(x: 3.06, y: 0))
		tlPath.curve(to: CGPoint(x: 1.26, y: 0.15), controlPoint1: CGPoint(x: 2.18, y: 0), controlPoint2: CGPoint(x: 1.74, y: 0))
		tlPath.line(to: CGPoint(x: 1.31, y: 0.14))
		tlPath.close()
		return tlPath
	}

	private func templateRoundTopRight() -> CGPath {
		let trPath = CGMutablePath()
		trPath.move(to: CGPoint(x: 8.69, y: 0.14))
		trPath.curve(to: CGPoint(x: 9.42, y: 0.58), controlPoint1: CGPoint(x: 9, y: 0.24), controlPoint2: CGPoint(x: 9.23, y: 0.39))
		trPath.curve(to: CGPoint(x: 9.85, y: 1.26), controlPoint1: CGPoint(x: 9.61, y: 0.77), controlPoint2: CGPoint(x: 9.76, y: 1))
		trPath.curve(to: CGPoint(x: 10, y: 3.06), controlPoint1: CGPoint(x: 10, y: 1.74), controlPoint2: CGPoint(x: 10, y: 2.18))
		trPath.curve(to: CGPoint(x: 10, y: 0), controlPoint1: CGPoint(x: 10, y: 1.35), controlPoint2: CGPoint(x: 10, y: 0))
		trPath.line(to: CGPoint(x: 6.94, y: 0))
		trPath.curve(to: CGPoint(x: 8.74, y: 0.15), controlPoint1: CGPoint(x: 7.82, y: 0), controlPoint2: CGPoint(x: 8.26, y: 0))
		trPath.line(to: CGPoint(x: 8.69, y: 0.14))
		trPath.close()
		return trPath
	}

	private func templateRoundBottomLeft() -> CGPath {
		let blPath = CGMutablePath()
		blPath.move(to: CGPoint(x: 1.31, y: 9.86))
		blPath.curve(to: CGPoint(x: 0.58, y: 9.42), controlPoint1: CGPoint(x: 1, y: 9.76), controlPoint2: CGPoint(x: 0.77, y: 9.61))
		blPath.curve(to: CGPoint(x: 0.15, y: 8.74), controlPoint1: CGPoint(x: 0.39, y: 9.23), controlPoint2: CGPoint(x: 0.24, y: 9))
		blPath.curve(to: CGPoint(x: 0, y: 6.94), controlPoint1: CGPoint(x: -0, y: 8.26), controlPoint2: CGPoint(x: 0, y: 7.82))
		blPath.curve(to: CGPoint(x: 0, y: 10), controlPoint1: CGPoint(x: 0, y: 8.65), controlPoint2: CGPoint(x: 0, y: 10))
		blPath.line(to: CGPoint(x: 3.06, y: 10))
		blPath.curve(to: CGPoint(x: 1.26, y: 9.85), controlPoint1: CGPoint(x: 2.18, y: 10), controlPoint2: CGPoint(x: 1.74, y: 10))
		blPath.line(to: CGPoint(x: 1.31, y: 9.86))
		blPath.close()
		return blPath
	}

	private func templateRoundBottomRight() -> CGPath {
		let brPath = CGMutablePath()
		brPath.move(to: CGPoint(x: 8.69, y: 9.86))
		brPath.curve(to: CGPoint(x: 9.42, y: 9.42), controlPoint1: CGPoint(x: 9, y: 9.76), controlPoint2: CGPoint(x: 9.23, y: 9.61))
		brPath.curve(to: CGPoint(x: 9.85, y: 8.74), controlPoint1: CGPoint(x: 9.61, y: 9.23), controlPoint2: CGPoint(x: 9.76, y: 9))
		brPath.curve(to: CGPoint(x: 10, y: 6.94), controlPoint1: CGPoint(x: 10, y: 8.26), controlPoint2: CGPoint(x: 10, y: 7.82))
		brPath.curve(to: CGPoint(x: 10, y: 10), controlPoint1: CGPoint(x: 10, y: 8.65), controlPoint2: CGPoint(x: 10, y: 10))
		brPath.line(to: CGPoint(x: 6.94, y: 10))
		brPath.curve(to: CGPoint(x: 8.74, y: 9.85), controlPoint1: CGPoint(x: 7.82, y: 10), controlPoint2: CGPoint(x: 8.26, y: 10))
		brPath.line(to: CGPoint(x: 8.69, y: 9.86))
		brPath.close()
		return brPath
	}

}

// MARK: - Settings

public extension QRCode.PixelShape.RoundedPath {
	/// Does the shape generator support setting values for a particular key?
	@objc func supportsSettingValue(forKey key: String) -> Bool {
		return key == QRCode.SettingsKey.cornerRadiusFraction
			 || key == QRCode.SettingsKey.hasInnerCorners
	}

	/// Returns a storable representation of the shape handler
	@objc func settings() -> [String: Any] {
		return [
			QRCode.SettingsKey.cornerRadiusFraction: self._cornerRadius,
			QRCode.SettingsKey.hasInnerCorners: self.hasInnerCorners
		]
	}

	/// Set a configuration value for a particular setting string
	@objc func setSettingValue(_ value: Any?, forKey key: String) -> Bool {
		if key == QRCode.SettingsKey.cornerRadiusFraction {
			guard let v = value else {
				self.cornerRadiusFraction = 0
				return true
			}
			guard let v = DoubleValue(v) else { return false }
			self.cornerRadiusFraction = v
			return true
		}
		if key == QRCode.SettingsKey.hasInnerCorners {
			guard let v = value else {
				self.hasInnerCorners = false
				return true
			}
			guard let v = BoolValue(v) else { return false }
			self.hasInnerCorners = v
			return true
		}
		return false
	}
}
