//
//  QRCodePixelShapeVertical.swift
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
	@objc(QRCodePixelShapeVertical) class Vertical: NSObject, QRCodePixelShapeGenerator {
		/// The generators name
		@objc static public let Name: String = "vertical"
		/// The generator title
		@objc public static var Title: String { "Vertical bars" }

		/// Create an instance of this path generator with the specified settings
		@objc static public func Create(_ settings: [String: Any]?) -> QRCodePixelShapeGenerator {
			let insetFraction = DoubleValue(settings?[QRCode.SettingsKey.insetFraction, default: 0]) ?? 0
			let radius = DoubleValue(settings?[QRCode.SettingsKey.cornerRadiusFraction]) ?? 0
			return QRCode.PixelShape.Vertical(insetFraction: insetFraction, cornerRadiusFraction: radius)
		}

		// The fractional inset for the pixel
		var insetFraction: CGFloat
		// The fractional corner radius for the pixel
		var cornerRadiusFraction: CGFloat

		/// Create a generator with a specified inset fraction and corner radius fraction
		@objc public init(insetFraction: CGFloat = 0, cornerRadiusFraction: CGFloat = 0) {
			self.insetFraction = insetFraction.clamped(to: 0...1)
			self.cornerRadiusFraction = cornerRadiusFraction.clamped(to: 0...1)
			super.init()
		}

		/// Make a copy of the object
		@objc public func copyShape() -> QRCodePixelShapeGenerator {
			return Vertical(
				insetFraction: self.insetFraction,
				cornerRadiusFraction: self.cornerRadiusFraction
			)
		}

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

			let path = CGMutablePath()

			for col in 0 ..< matrix.dimension {
				var activeRect: CGRect?

				for row in 0 ..< matrix.dimension {
					if matrix[row, col] == false {
						if let r = activeRect {
							// We had an active rect. Close it.
							let ri = r.insetBy(
								dx: self.insetFraction * (r.width / 2.0),
								dy: self.insetFraction * (r.width / 2.0)
							)
							let cr = (ri.width / 2.0) * self.cornerRadiusFraction
							path.addPath(CGPath(roundedRect: ri, cornerWidth: cr, cornerHeight: cr, transform: nil))
						}
						activeRect = nil
					}
					else if activeRect != nil {
						// We are still going...
						activeRect?.size.height += dm
					}
					else {
						// Starting a new rect
						activeRect = CGRect(
							x: xoff + (CGFloat(col) * dm),
							y: yoff + (CGFloat(row) * dm),
							width: dm, height: dm
						)
					}
				}

				if let r = activeRect {
					// Close the rect
					let ri = r.insetBy(
						dx: self.insetFraction * (r.width / 2.0),
						dy: self.insetFraction * (r.width / 2.0)
					)
					let cr = (ri.width / 2.0) * self.cornerRadiusFraction
					path.addPath(CGPath(roundedRect: ri, cornerWidth: cr, cornerHeight: cr, transform: nil))
				}
			}
			return path
		}
	}
}

// MARK: - Settings

public extension QRCode.PixelShape.Vertical {
	/// Does the shape generator support setting values for a particular key?
	@objc func supportsSettingValue(forKey key: String) -> Bool {
		return key == QRCode.SettingsKey.insetFraction
			 || key == QRCode.SettingsKey.cornerRadiusFraction
	}

	/// Returns a storable representation of the shape handler
	@objc func settings() -> [String : Any] {
		return [
			QRCode.SettingsKey.insetFraction: self.insetFraction,
			QRCode.SettingsKey.cornerRadiusFraction: self.cornerRadiusFraction
		]
	}

	/// Set a configuration value for a particular setting string
	@objc func setSettingValue(_ value: Any?, forKey key: String) -> Bool {
		if key == QRCode.SettingsKey.insetFraction {
			guard let v = value else {
				self.insetFraction = 0
				return true
			}
			guard let v = DoubleValue(v) else { return false }
			self.insetFraction = v
			return true
		}
		else if key == QRCode.SettingsKey.cornerRadiusFraction {
			guard let v = value else {
				self.cornerRadiusFraction = 0
				return true
			}
			guard let v = DoubleValue(v) else { return false }
			self.cornerRadiusFraction = v
			return true
		}
		return false
	}
}
