//
//  QRCodePixelShapePointy.swift
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

import Foundation
import CoreGraphics

public extension QRCode.PixelShape {
	@objc(QRCodePixelShapePointy) class Pointy: NSObject, QRCodePixelShapeGenerator {
		/// The generator name
		@objc public static let Name: String = "pointy"
		/// The generator title
		@objc public static var Title: String { "Pointy" }

		/// Create an instance of this path generator with the specified settings
		@objc public static func Create(_ settings: [String: Any]?) -> QRCodePixelShapeGenerator {
			QRCode.PixelShape.Pointy()
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

		/// Make a copy of the object
		@objc public func copyShape() -> QRCodePixelShapeGenerator {
			return Pointy()
		}
	}
}

public extension QRCode.PixelShape.Pointy {
	/// Generate a CGPath from the matrix contents
	/// - Parameters:
	///   - matrix: The matrix to generate
	///   - size: The size of the resulting CGPath
	/// - Returns: A path
	@objc func generatePath(from matrix: BoolMatrix, size: CGSize) -> CGPath {
		let dx = size.width / CGFloat(matrix.dimension)
		let dy = size.height / CGFloat(matrix.dimension)
		let dm = min(dx, dy)

		let xoff = (size.width - (CGFloat(matrix.dimension) * dm)) / 2.0
		let yoff = (size.height - (CGFloat(matrix.dimension) * dm)) / 2.0

		// The scale required to convert our template paths to output path size
		let w = QRCode.PixelShape.RoundedPath.DefaultSize.width
		let scaleTransform = CGAffineTransform(scaleX: dm / w, y: dm / w)

		let path = CGMutablePath()

		for row in 0 ..< matrix.dimension {
			for col in 0 ..< matrix.dimension {
				guard matrix[row, col] == true else { continue }

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

				if !hasLeft, !hasRight, !hasTop, !hasBottom {
					// isolated block
					path.addPath(
						QRCode.PixelShape.Pointy.templateSquare,
						transform: scaleTransform.concatenating(translate)
					)
				}
				else if !hasLeft, !hasRight, !hasTop, hasBottom {
					// pointing up block
					path.addPath(
						QRCode.PixelShape.Pointy.templatePointingUp,
						transform: scaleTransform.concatenating(translate)
					)
				}
				else if !hasLeft, !hasRight, !hasBottom, hasTop {
					// pointing down block
					path.addPath(
						QRCode.PixelShape.Pointy.templatePointingDown,
						transform: scaleTransform.concatenating(translate)
					)
				}
				else if !hasTop, !hasRight, !hasBottom, hasLeft {
					// pointing right block
					path.addPath(
						QRCode.PixelShape.Pointy.templatePointingRight,
						transform: scaleTransform.concatenating(translate)
					)
				}
				else if !hasTop, !hasLeft, !hasBottom, hasRight {
					// pointing left block
					path.addPath(
						QRCode.PixelShape.Pointy.templatePointingLeft,
						transform: scaleTransform.concatenating(translate)
					)
				}
				else {
					path.addPath(
						QRCode.PixelShape.Pointy.templateSquare,
						transform: scaleTransform.concatenating(translate)
					)
				}
			}
		}
		return path
	}
}

// MARK: - Settings

public extension QRCode.PixelShape.Pointy {
	/// Does the shape generator support setting values for a particular key?
	@objc func supportsSettingValue(forKey key: String) -> Bool { false }

	/// Returns a storable representation of the shape handler
	@objc func settings() -> [String: Any] {
		return [:]
	}

	/// Set a configuration value for a particular setting string
	@objc func setSettingValue(_ value: Any?, forKey key: String) -> Bool {
		return false
	}
}
