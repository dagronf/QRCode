//
//  QRCodePixelShapeRoundedEndIndent.swift
//
//  Copyright © 2023 Darren Ford. All rights reserved.
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
	@objc(QRCodePixelShapeRoundedEndIndent) class RoundedEndIndent: NSObject, QRCodePixelShapeGenerator {
		/// The generator name
		@objc public static let Name = "roundedEndIndent"
		/// The generator title
		@objc public static var Title: String { "Rounded end indent" }

		/// Create an instance of this path generator with the specified settings
		@objc public static func Create(_ settings: [String: Any]?) -> QRCodePixelShapeGenerator {
			let radius = DoubleValue(settings?[QRCode.SettingsKey.cornerRadiusFraction]) ?? self.DefaultCornerRadiusValue
			let hasInnerCorners = BoolValue(settings?[QRCode.SettingsKey.hasInnerCorners]) ?? true
			return RoundedEndIndent(cornerRadiusFraction: radius, hasInnerCorners: hasInnerCorners)
		}

		// The template pixel generator size is 10x10
		static let DefaultSize = CGSize(width: 10, height: 10)
		static let DefaultRect = CGRect(origin: .zero, size: DefaultSize)

		// The default radius for the curved edges is 3
		private static let DefaultCornerRadiusValue: CGFloat = 0.3

		private let innerRadius: Double = 5.0 / 3.0

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
		@objc public var hasInnerCorners: Bool = true

		/// Create
		@objc public init(
			cornerRadiusFraction: CGFloat = 0.3,
			hasInnerCorners: Bool = true
		) {
			self._cornerRadius = cornerRadiusFraction.clamped(to: 0 ... 1)
			self.hasInnerCorners = hasInnerCorners
			super.init()
			self.cornerRadiusChanged()
		}

		/// Make a copy of the shape
		@objc public func copyShape() -> QRCodePixelShapeGenerator {
			RoundedEndIndent(
				cornerRadiusFraction: self.cornerRadiusFraction,
				hasInnerCorners: self.hasInnerCorners
			)
		}
	}
}

extension QRCode.PixelShape.RoundedEndIndent {
	/// Generate a CGPath from the matrix contents
	/// - Parameters:
	///   - matrix: The matrix to generate
	///   - size: The size of the resulting CGPath
	/// - Returns: A path
	@objc public func generatePath(from matrix: BoolMatrix, size: CGSize) -> CGPath {
		let dx = size.width / CGFloat(matrix.dimension)
		let dy = size.height / CGFloat(matrix.dimension)
		let dm = min(dx, dy)

		let xoff = (size.width - (CGFloat(matrix.dimension) * dm)) / 2.0
		let yoff = (size.height - (CGFloat(matrix.dimension) * dm)) / 2.0

		// The scale required to convert our template paths to output path size
		let w = QRCode.PixelShape.RoundedEndIndent.DefaultSize.width
		let scaleTransform = CGAffineTransform(scaleX: dm / w, y: dm / w)

		let path = CGMutablePath()

		for row in 0 ..< matrix.dimension {
			for col in 0 ..< matrix.dimension {

				let hasLeft: Bool = {
					if col == 0 { return false }
					return (col - 1) >= 0 ? matrix[row, col - 1] : false
				}()
				let hasRight: Bool = {
					if col == (matrix.dimension - 1) { return false }
					return (col + 1) < matrix.dimension ? matrix[row, col + 1] : false
				}()
				let hasTop: Bool = {
					if row == 0 { return false }
					return (row - 1) >= 0 ? matrix[row - 1, col] : false
				}()
				let hasBottom: Bool = {
					if row == (matrix.dimension - 1) { return false }
					return (row + 1) < matrix.dimension ? matrix[row + 1, col] : false
				}()

				let translate = CGAffineTransform(translationX: CGFloat(col) * dm + xoff, y: CGFloat(row) * dm + yoff)

				guard matrix[row, col] == true else {
					guard hasInnerCorners == true else {
						continue
					}

					let hasTopLeft: Bool = {
						if col == 0 || row == 0 { return false }
						return ((col - 1) >= 0 && (row - 1) >= 0) ? matrix[row - 1, col - 1] : false
					}()
					let hasTopRight: Bool = {
						if col == (matrix.dimension - 1) || row == 0 { return false }
						return ((col + 1) >= 0 && (row - 1) >= 0) ? matrix[row - 1, col + 1] : false
					}()
					let hasBottomLeft: Bool = {
						if col == 0 || row == (matrix.dimension - 1) { return false }
						return ((col - 1) >= 0 && (row + 1) >= 0) ? matrix[row + 1, col - 1] : false
					}()
					let hasBottomRight: Bool = {
						if col == (matrix.dimension - 1) || row == (matrix.dimension - 1) { return false }
						return ((col + 1) >= 0 && (row + 1) >= 0) ? matrix[row + 1, col + 1] : false
					}()

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
						QRCode.PixelShape.RoundedEndIndent.templateSquare,
						transform: scaleTransform.concatenating(translate)
					)
				}
			}
		}
		return path
	}
}

// MARK: - Template shapes

private extension QRCode.PixelShape.RoundedEndIndent {
	private static let templateSquare = CGPath(rect: QRCode.PixelShape.RoundedEndIndent.DefaultRect, transform: nil)

	private func templateCircle() -> CGPath {
		CGPath(
			roundedRect: QRCode.PixelShape.RoundedEndIndent.DefaultRect,
			cornerWidth: actualRadius, cornerHeight: actualRadius,
			transform: nil
		)
	}

	private func templateRoundTop() -> CGPath {
		let rectanglePath = CGMutablePath()
		rectanglePath.move(to: CGPoint(x: 0, y: 10))
		rectanglePath.line(to: CGPoint(x: 10, y: 10))
		rectanglePath.line(to: CGPoint(x: 10, y: 0))
		rectanglePath.curve(to: CGPoint(x: 5, y: 2), controlPoint1: CGPoint(x: 10, y: 0), controlPoint2: CGPoint(x: 9, y: 2))
		rectanglePath.curve(to: CGPoint(x: 0, y: 0), controlPoint1: CGPoint(x: 1, y: 2), controlPoint2: CGPoint(x: 0, y: 0))
		rectanglePath.line(to: CGPoint(x: 0, y: 10))
		rectanglePath.close()
		return rectanglePath
	}

	private func templateRoundRight() -> CGPath {
		//// Rectangle Drawing
		let rectanglePath = CGMutablePath()
		rectanglePath.move(to: CGPoint(x: 0, y: 0))
		rectanglePath.line(to: CGPoint(x: 10, y: 0))
		rectanglePath.curve(to: CGPoint(x: 8, y: 5), controlPoint1: CGPoint(x: 10, y: 0), controlPoint2: CGPoint(x: 8, y: 1))
		rectanglePath.curve(to: CGPoint(x: 10, y: 10), controlPoint1: CGPoint(x: 8, y: 9), controlPoint2: CGPoint(x: 10, y: 10))
		rectanglePath.line(to: CGPoint(x: 0, y: 10))
		rectanglePath.line(to: CGPoint(x: 0, y: 0))
		rectanglePath.close()
		return rectanglePath
	}

	private func templateRoundBottom() -> CGPath {
		let rectanglePath = CGMutablePath()
		rectanglePath.move(to: CGPoint(x: 0, y: 0))
		rectanglePath.line(to: CGPoint(x: 10, y: 0))
		rectanglePath.line(to: CGPoint(x: 10, y: 10))
		rectanglePath.curve(to: CGPoint(x: 5, y: 8), controlPoint1: CGPoint(x: 10, y: 10), controlPoint2: CGPoint(x: 9, y: 8))
		rectanglePath.curve(to: CGPoint(x: 0, y: 10), controlPoint1: CGPoint(x: 1, y: 8), controlPoint2: CGPoint(x: 0, y: 10))
		rectanglePath.line(to: CGPoint(x: 0, y: 0))
		rectanglePath.close()
		return rectanglePath
	}

	private func templateRoundLeft() -> CGPath {
		let rectanglePath = CGMutablePath()
		rectanglePath.move(to: CGPoint(x: 10, y: 0))
		rectanglePath.line(to: CGPoint(x: 0, y: 0))
		rectanglePath.curve(to: CGPoint(x: 2, y: 5), controlPoint1: CGPoint(x: 0, y: 0), controlPoint2: CGPoint(x: 2, y: 1))
		rectanglePath.curve(to: CGPoint(x: 0, y: 10), controlPoint1: CGPoint(x: 2, y: 9), controlPoint2: CGPoint(x: 0, y: 10))
		rectanglePath.line(to: CGPoint(x: 10, y: 10))
		rectanglePath.line(to: CGPoint(x: 10, y: 0))
		rectanglePath.close()
		return rectanglePath
	}

	private func templateBottomRight() -> CGPath {
		CGPath.RoundedRect(
			rect: QRCode.PixelShape.RoundedEndIndent.DefaultRect,
			bottomRightRadius: actualRadiusSize
		)
	}

	private func templateTopRight() -> CGPath {
		CGPath.RoundedRect(
			rect: QRCode.PixelShape.RoundedEndIndent.DefaultRect,
			topRightRadius: actualRadiusSize
		)
	}

	private func templateTopLeft() -> CGPath {
		CGPath.RoundedRect(
			rect: QRCode.PixelShape.RoundedEndIndent.DefaultRect,
			topLeftRadius: actualRadiusSize
		)
	}

	private func templateBottomLeft() -> CGPath {
		CGPath.RoundedRect(
			rect: QRCode.PixelShape.RoundedEndIndent.DefaultRect,
			bottomLeftRadius: actualRadiusSize
		)
	}
}

// MARK: - Template corner shapes

private extension QRCode.PixelShape.RoundedEndIndent {
	private func templateRoundTopLeft() -> CGPath {
		let tlPath = CGMutablePath()
		let fr = innerRadius * cornerRadiusFraction
		tlPath.move(to: CGPoint(x: fr, y: 0))
		tlPath.line(to: CGPoint(x: 0, y: 0))
		tlPath.curve(to: CGPoint(x: 0, y: fr), controlPoint1: CGPoint(x: 0, y: 0), controlPoint2: CGPoint(x: 0, y: fr / 2))
		tlPath.curve(to: CGPoint(x: fr, y: 0), controlPoint1: CGPoint(x: 0, y: fr / 2), controlPoint2: CGPoint(x: fr / 2, y: 0))
		tlPath.close()
		return tlPath
	}

	private func templateRoundTopRight() -> CGPath {
		let trPath = CGMutablePath()
		trPath.addPath(
			templateRoundTopLeft(),
			transform:
				CGAffineTransform(scaleX: -1, y: 1)
					.concatenating(
						CGAffineTransform(translationX: 10, y: 0)))
		return trPath
	}

	private func templateRoundBottomLeft() -> CGPath {
		let blPath = CGMutablePath()
		blPath.addPath(
			templateRoundTopLeft(),
			transform:
				CGAffineTransform(scaleX: 1, y: -1)
					.concatenating(.init(translationX: 0, y: 10)))
		return blPath
	}

	private func templateRoundBottomRight() -> CGPath {
		let brPath = CGMutablePath()
		brPath.addPath(
			templateRoundTopLeft(),
			transform:
				CGAffineTransform(scaleX: -1, y: -1)
					.concatenating(.init(translationX: 10, y: 10)))
		return brPath
	}

}

// MARK: - Settings

public extension QRCode.PixelShape.RoundedEndIndent {
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
