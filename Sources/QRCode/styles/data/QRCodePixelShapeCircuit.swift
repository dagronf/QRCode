//
//  QRCodePixelShapeCircuit.swift
//
//  Copyright © 2024 Darren Ford. All rights reserved.
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
	/// A generator for a pixel shape that displays connected circles
	@objc(QRCodePixelShapeCircuit) class Circuit: NSObject, QRCodePixelShapeGenerator {
		/// The generator name
		@objc public static let Name: String = "circuit"
		/// The generator title
		@objc public static var Title: String { "Circuit" }
		/// Create an instance of this path generator with the specified settings
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodePixelShapeGenerator { Circuit() }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePixelShapeGenerator { Circuit() }
	}
}

public extension QRCode.PixelShape.Circuit {
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
				let translate = CGAffineTransform(translationX: CGFloat(col) * dm + xoff, y: CGFloat(row) * dm + yoff)
				let ne = Neighbours(matrix: matrix, row: row, col: col)
				if matrix[row, col] == true {
					
					if ne.top, !ne.bottom, !ne.leading, !ne.trailing {
						path.addPath(Self.templateBottom, transform: scaleTransform.concatenating(translate))
					}
					else if !ne.top, ne.bottom, !ne.leading, !ne.trailing {
						path.addPath(Self.templateTop, transform: scaleTransform.concatenating(translate))
					}
					else if !ne.top, !ne.bottom, ne.leading, !ne.trailing {
						path.addPath(Self.templateLeft, transform: scaleTransform.concatenating(translate))
					}
					else if !ne.top, !ne.bottom, !ne.leading, ne.trailing {
						path.addPath(Self.templateRight, transform: scaleTransform.concatenating(translate))
					}

					else if ne.top, ne.bottom, !ne.leading, !ne.trailing {
						path.addPath(Self.templateTopBottom, transform: scaleTransform.concatenating(translate))
					}
					else if !ne.top, !ne.bottom, ne.leading, ne.trailing {
						path.addPath(Self.templateLeftRight, transform: scaleTransform.concatenating(translate))
					}

					else if ne.top, !ne.bottom, ne.leading, !ne.trailing {
						path.addPath(Self.templateBottomLeft, transform: scaleTransform.concatenating(translate))
					}
					else if ne.top, !ne.bottom, !ne.leading, ne.trailing {
						path.addPath(Self.templateBottomRight, transform: scaleTransform.concatenating(translate))
					}
					else if !ne.top, ne.bottom, ne.leading, !ne.trailing {
						path.addPath(Self.templateTopLeft, transform: scaleTransform.concatenating(translate))
					}
					else if !ne.top, ne.bottom, !ne.leading, ne.trailing {
						path.addPath(Self.templateTopRight, transform: scaleTransform.concatenating(translate))
					}

					else if ne.top, !ne.bottom, ne.leading, ne.trailing {
						path.addPath(Self.templateLeftBottomRight, transform: scaleTransform.concatenating(translate))
					}
					else if !ne.top, ne.bottom, ne.leading, ne.trailing {
						path.addPath(Self.templateTopLeftRight, transform: scaleTransform.concatenating(translate))
					}
					else if ne.top, ne.bottom, !ne.leading, ne.trailing {
						path.addPath(Self.templateTopRightBottom, transform: scaleTransform.concatenating(translate))
					}
					else if ne.top, ne.bottom, ne.leading, !ne.trailing {
						path.addPath(Self.templateTopLeftBottom, transform: scaleTransform.concatenating(translate))
					}

					else if ne.top, ne.bottom, ne.leading, ne.trailing {
						path.addPath(Self.templateTopLeftBottomRight, transform: scaleTransform.concatenating(translate))
					}

					else {
						path.addPath(Self.templateCentroid, transform: scaleTransform.concatenating(translate))
					}
				}
			}
		}
		path.closeSubpath()
		return path
	}
}

// MARK: - Settings

public extension QRCode.PixelShape.Circuit {
	/// Does the shape generator support setting values for a particular key?
	@objc func supportsSettingValue(forKey key: String) -> Bool { false }
	/// Returns a storable representation of the shape handler
	@objc func settings() -> [String: Any] { return [:] }
	/// Set a configuration value for a particular setting string
	@objc func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }
}

// MARK: - Pixel creation conveniences

public extension QRCodePixelShapeGenerator where Self == QRCode.PixelShape.Circuit {
	/// Create a organic pixel generator
	/// - Returns: A pixel generator
	@inlinable static func circuit() -> QRCodePixelShapeGenerator {
		QRCode.PixelShape.Circuit()
	}
}

// MARK: - Shapes

// Inner corner templates

private extension QRCode.PixelShape.Circuit {
	static let templateCentroid = CGPath(ellipseIn: CGRect(x: 1, y: 1, width: 8, height: 8), transform: nil)

	static let templateTop =
		CGPath.make {
			$0.move(to: CGPoint(x: 6.2, y: 10))
			$0.curve(to: CGPoint(x: 6.51, y: 9), controlPoint1: CGPoint(x: 6.2, y: 10), controlPoint2: CGPoint(x: 6.15, y: 9.5))
			$0.curve(to: CGPoint(x: 7.64, y: 8.01), controlPoint1: CGPoint(x: 6.85, y: 8.53), controlPoint2: CGPoint(x: 7.55, y: 8.07))
			$0.curve(to: CGPoint(x: 9, y: 5), controlPoint1: CGPoint(x: 8.48, y: 7.27), controlPoint2: CGPoint(x: 9, y: 6.19))
			$0.curve(to: CGPoint(x: 5, y: 1), controlPoint1: CGPoint(x: 9, y: 2.79), controlPoint2: CGPoint(x: 7.21, y: 1))
			$0.curve(to: CGPoint(x: 2.94, y: 1.57), controlPoint1: CGPoint(x: 4.25, y: 1), controlPoint2: CGPoint(x: 3.54, y: 1.21))
			$0.curve(to: CGPoint(x: 1, y: 5), controlPoint1: CGPoint(x: 1.78, y: 2.27), controlPoint2: CGPoint(x: 1, y: 3.54))
			$0.curve(to: CGPoint(x: 2.35, y: 8), controlPoint1: CGPoint(x: 1, y: 6.19), controlPoint2: CGPoint(x: 1.52, y: 7.27))
			$0.curve(to: CGPoint(x: 3.49, y: 9), controlPoint1: CGPoint(x: 2.41, y: 8.04), controlPoint2: CGPoint(x: 3.14, y: 8.52))
			$0.curve(to: CGPoint(x: 3.8, y: 10), controlPoint1: CGPoint(x: 3.85, y: 9.5), controlPoint2: CGPoint(x: 3.8, y: 10))
			$0.line(to: CGPoint(x: 6.2, y: 10))
			$0.line(to: CGPoint(x: 6.2, y: 10))
			$0.close()
		}

	static let templateBottom =
		CGPath.make {
			$0.move(to: CGPoint(x: 6.2, y: 0))
			$0.curve(to: CGPoint(x: 6.51, y: 1), controlPoint1: CGPoint(x: 6.2, y: 0), controlPoint2: CGPoint(x: 6.15, y: 0.5))
			$0.curve(to: CGPoint(x: 7.64, y: 1.99), controlPoint1: CGPoint(x: 6.85, y: 1.47), controlPoint2: CGPoint(x: 7.55, y: 1.93))
			$0.curve(to: CGPoint(x: 9, y: 5), controlPoint1: CGPoint(x: 8.48, y: 2.73), controlPoint2: CGPoint(x: 9, y: 3.81))
			$0.curve(to: CGPoint(x: 5, y: 9), controlPoint1: CGPoint(x: 9, y: 7.21), controlPoint2: CGPoint(x: 7.21, y: 9))
			$0.curve(to: CGPoint(x: 2.94, y: 8.43), controlPoint1: CGPoint(x: 4.25, y: 9), controlPoint2: CGPoint(x: 3.54, y: 8.79))
			$0.curve(to: CGPoint(x: 1, y: 5), controlPoint1: CGPoint(x: 1.78, y: 7.73), controlPoint2: CGPoint(x: 1, y: 6.46))
			$0.curve(to: CGPoint(x: 2.35, y: 2), controlPoint1: CGPoint(x: 1, y: 3.81), controlPoint2: CGPoint(x: 1.52, y: 2.73))
			$0.curve(to: CGPoint(x: 3.49, y: 1), controlPoint1: CGPoint(x: 2.41, y: 1.96), controlPoint2: CGPoint(x: 3.14, y: 1.48))
			$0.curve(to: CGPoint(x: 3.8, y: 0), controlPoint1: CGPoint(x: 3.85, y: 0.5), controlPoint2: CGPoint(x: 3.8, y: 0))
			$0.line(to: CGPoint(x: 6.2, y: 0))
			$0.line(to: CGPoint(x: 6.2, y: 0))
			$0.close()
		}

	static let templateLeft =
		CGPath.make {
			$0.move(to: CGPoint(x: 0, y: 3.8))
			$0.curve(to: CGPoint(x: 1, y: 3.49), controlPoint1: CGPoint(x: 0, y: 3.8), controlPoint2: CGPoint(x: 0.5, y: 3.85))
			$0.curve(to: CGPoint(x: 1.99, y: 2.36), controlPoint1: CGPoint(x: 1.47, y: 3.15), controlPoint2: CGPoint(x: 1.93, y: 2.45))
			$0.curve(to: CGPoint(x: 5, y: 1), controlPoint1: CGPoint(x: 2.73, y: 1.52), controlPoint2: CGPoint(x: 3.81, y: 1))
			$0.curve(to: CGPoint(x: 9, y: 5), controlPoint1: CGPoint(x: 7.21, y: 1), controlPoint2: CGPoint(x: 9, y: 2.79))
			$0.curve(to: CGPoint(x: 8.43, y: 7.06), controlPoint1: CGPoint(x: 9, y: 5.75), controlPoint2: CGPoint(x: 8.79, y: 6.46))
			$0.curve(to: CGPoint(x: 5, y: 9), controlPoint1: CGPoint(x: 7.73, y: 8.22), controlPoint2: CGPoint(x: 6.46, y: 9))
			$0.curve(to: CGPoint(x: 2, y: 7.65), controlPoint1: CGPoint(x: 3.81, y: 9), controlPoint2: CGPoint(x: 2.73, y: 8.48))
			$0.curve(to: CGPoint(x: 1, y: 6.51), controlPoint1: CGPoint(x: 1.96, y: 7.59), controlPoint2: CGPoint(x: 1.48, y: 6.86))
			$0.curve(to: CGPoint(x: 0, y: 6.2), controlPoint1: CGPoint(x: 0.5, y: 6.15), controlPoint2: CGPoint(x: 0, y: 6.2))
			$0.line(to: CGPoint(x: 0, y: 3.8))
			$0.line(to: CGPoint(x: 0, y: 3.8))
			$0.close()
		}

	static let templateRight =
		CGPath.make {
			$0.move(to: CGPoint(x: 10, y: 3.8))
			$0.curve(to: CGPoint(x: 9, y: 3.49), controlPoint1: CGPoint(x: 10, y: 3.8), controlPoint2: CGPoint(x: 9.5, y: 3.85))
			$0.curve(to: CGPoint(x: 8.01, y: 2.36), controlPoint1: CGPoint(x: 8.53, y: 3.15), controlPoint2: CGPoint(x: 8.07, y: 2.45))
			$0.curve(to: CGPoint(x: 5, y: 1), controlPoint1: CGPoint(x: 7.27, y: 1.52), controlPoint2: CGPoint(x: 6.19, y: 1))
			$0.curve(to: CGPoint(x: 1, y: 5), controlPoint1: CGPoint(x: 2.79, y: 1), controlPoint2: CGPoint(x: 1, y: 2.79))
			$0.curve(to: CGPoint(x: 1.57, y: 7.06), controlPoint1: CGPoint(x: 1, y: 5.75), controlPoint2: CGPoint(x: 1.21, y: 6.46))
			$0.curve(to: CGPoint(x: 5, y: 9), controlPoint1: CGPoint(x: 2.27, y: 8.22), controlPoint2: CGPoint(x: 3.54, y: 9))
			$0.curve(to: CGPoint(x: 8, y: 7.65), controlPoint1: CGPoint(x: 6.19, y: 9), controlPoint2: CGPoint(x: 7.27, y: 8.48))
			$0.curve(to: CGPoint(x: 9, y: 6.51), controlPoint1: CGPoint(x: 8.04, y: 7.59), controlPoint2: CGPoint(x: 8.52, y: 6.86))
			$0.curve(to: CGPoint(x: 10, y: 6.2), controlPoint1: CGPoint(x: 9.5, y: 6.15), controlPoint2: CGPoint(x: 10, y: 6.2))
			$0.line(to: CGPoint(x: 10, y: 3.8))
			$0.line(to: CGPoint(x: 10, y: 3.8))
			$0.close()
		}

	// -

	static let templateTopBottom =
		CGPath.make {
			$0.move(to: CGPoint(x: 7.65, y: 2))
			$0.curve(to: CGPoint(x: 6.51, y: 1), controlPoint1: CGPoint(x: 7.59, y: 1.96), controlPoint2: CGPoint(x: 6.86, y: 1.48))
			$0.curve(to: CGPoint(x: 6.2, y: 0), controlPoint1: CGPoint(x: 6.15, y: 0.5), controlPoint2: CGPoint(x: 6.2, y: 0))
			$0.line(to: CGPoint(x: 3.8, y: 0))
			$0.curve(to: CGPoint(x: 3.49, y: 1), controlPoint1: CGPoint(x: 3.8, y: 0), controlPoint2: CGPoint(x: 3.85, y: 0.5))
			$0.curve(to: CGPoint(x: 2.35, y: 2), controlPoint1: CGPoint(x: 3.14, y: 1.48), controlPoint2: CGPoint(x: 2.41, y: 1.96))
			$0.curve(to: CGPoint(x: 1, y: 5), controlPoint1: CGPoint(x: 1.52, y: 2.73), controlPoint2: CGPoint(x: 1, y: 3.81))
			$0.curve(to: CGPoint(x: 1.57, y: 7.06), controlPoint1: CGPoint(x: 1, y: 5.75), controlPoint2: CGPoint(x: 1.21, y: 6.46))
			$0.curve(to: CGPoint(x: 2.08, y: 7.73), controlPoint1: CGPoint(x: 1.71, y: 7.3), controlPoint2: CGPoint(x: 1.89, y: 7.53))
			$0.curve(to: CGPoint(x: 2.35, y: 8), controlPoint1: CGPoint(x: 2.17, y: 7.83), controlPoint2: CGPoint(x: 2.26, y: 7.92))
			$0.curve(to: CGPoint(x: 3.49, y: 9), controlPoint1: CGPoint(x: 2.41, y: 8.04), controlPoint2: CGPoint(x: 3.14, y: 8.52))
			$0.line(to: CGPoint(x: 3.54, y: 9.08))
			$0.curve(to: CGPoint(x: 3.8, y: 10), controlPoint1: CGPoint(x: 3.84, y: 9.55), controlPoint2: CGPoint(x: 3.8, y: 10))
			$0.line(to: CGPoint(x: 6.2, y: 10))
			$0.curve(to: CGPoint(x: 6.51, y: 9), controlPoint1: CGPoint(x: 6.2, y: 10), controlPoint2: CGPoint(x: 6.15, y: 9.5))
			$0.curve(to: CGPoint(x: 7.65, y: 8), controlPoint1: CGPoint(x: 6.86, y: 8.52), controlPoint2: CGPoint(x: 7.59, y: 8.04))
			$0.curve(to: CGPoint(x: 9, y: 5), controlPoint1: CGPoint(x: 8.48, y: 7.27), controlPoint2: CGPoint(x: 9, y: 6.19))
			$0.curve(to: CGPoint(x: 7.65, y: 2), controlPoint1: CGPoint(x: 9, y: 3.81), controlPoint2: CGPoint(x: 8.48, y: 2.73))
			$0.close()
		}

	static let templateLeftRight =
		CGPath.make {
			$0.move(to: CGPoint(x: 8, y: 7.65))
			$0.curve(to: CGPoint(x: 9, y: 6.51), controlPoint1: CGPoint(x: 8.04, y: 7.59), controlPoint2: CGPoint(x: 8.52, y: 6.86))
			$0.curve(to: CGPoint(x: 10, y: 6.2), controlPoint1: CGPoint(x: 9.5, y: 6.15), controlPoint2: CGPoint(x: 10, y: 6.2))
			$0.line(to: CGPoint(x: 10, y: 3.8))
			$0.curve(to: CGPoint(x: 9, y: 3.49), controlPoint1: CGPoint(x: 10, y: 3.8), controlPoint2: CGPoint(x: 9.5, y: 3.85))
			$0.curve(to: CGPoint(x: 8, y: 2.35), controlPoint1: CGPoint(x: 8.52, y: 3.14), controlPoint2: CGPoint(x: 8.04, y: 2.41))
			$0.curve(to: CGPoint(x: 5, y: 1), controlPoint1: CGPoint(x: 7.27, y: 1.52), controlPoint2: CGPoint(x: 6.19, y: 1))
			$0.curve(to: CGPoint(x: 2.94, y: 1.57), controlPoint1: CGPoint(x: 4.25, y: 1), controlPoint2: CGPoint(x: 3.54, y: 1.21))
			$0.curve(to: CGPoint(x: 2.27, y: 2.08), controlPoint1: CGPoint(x: 2.7, y: 1.71), controlPoint2: CGPoint(x: 2.47, y: 1.89))
			$0.curve(to: CGPoint(x: 2, y: 2.35), controlPoint1: CGPoint(x: 2.17, y: 2.17), controlPoint2: CGPoint(x: 2.08, y: 2.26))
			$0.curve(to: CGPoint(x: 1, y: 3.49), controlPoint1: CGPoint(x: 1.96, y: 2.41), controlPoint2: CGPoint(x: 1.48, y: 3.14))
			$0.line(to: CGPoint(x: 0.92, y: 3.54))
			$0.curve(to: CGPoint(x: 0, y: 3.8), controlPoint1: CGPoint(x: 0.45, y: 3.84), controlPoint2: CGPoint(x: 0, y: 3.8))
			$0.line(to: CGPoint(x: 0, y: 6.2))
			$0.curve(to: CGPoint(x: 1, y: 6.51), controlPoint1: CGPoint(x: 0, y: 6.2), controlPoint2: CGPoint(x: 0.5, y: 6.15))
			$0.curve(to: CGPoint(x: 2, y: 7.65), controlPoint1: CGPoint(x: 1.48, y: 6.86), controlPoint2: CGPoint(x: 1.96, y: 7.59))
			$0.curve(to: CGPoint(x: 5, y: 9), controlPoint1: CGPoint(x: 2.73, y: 8.48), controlPoint2: CGPoint(x: 3.81, y: 9))
			$0.curve(to: CGPoint(x: 8, y: 7.65), controlPoint1: CGPoint(x: 6.19, y: 9), controlPoint2: CGPoint(x: 7.27, y: 8.48))
			$0.close()
		}

	// -

	static let templateTopLeftRight =
		CGPath.make {
			$0.move(to: CGPoint(x: 6.2, y: 10))
			$0.curve(to: CGPoint(x: 6.51, y: 9), controlPoint1: CGPoint(x: 6.2, y: 10), controlPoint2: CGPoint(x: 6.15, y: 9.5))
			$0.curve(to: CGPoint(x: 7.64, y: 8.01), controlPoint1: CGPoint(x: 6.85, y: 8.53), controlPoint2: CGPoint(x: 7.55, y: 8.07))
			$0.curve(to: CGPoint(x: 8, y: 7.65), controlPoint1: CGPoint(x: 7.77, y: 7.89), controlPoint2: CGPoint(x: 7.89, y: 7.77))
			$0.curve(to: CGPoint(x: 9, y: 6.51), controlPoint1: CGPoint(x: 8.04, y: 7.59), controlPoint2: CGPoint(x: 8.52, y: 6.86))
			$0.curve(to: CGPoint(x: 10, y: 6.2), controlPoint1: CGPoint(x: 9.5, y: 6.15), controlPoint2: CGPoint(x: 10, y: 6.2))
			$0.line(to: CGPoint(x: 10, y: 3.8))
			$0.curve(to: CGPoint(x: 9, y: 3.49), controlPoint1: CGPoint(x: 10, y: 3.8), controlPoint2: CGPoint(x: 9.5, y: 3.85))
			$0.curve(to: CGPoint(x: 8, y: 2.35), controlPoint1: CGPoint(x: 8.52, y: 3.14), controlPoint2: CGPoint(x: 8.04, y: 2.41))
			$0.curve(to: CGPoint(x: 5, y: 1), controlPoint1: CGPoint(x: 7.27, y: 1.52), controlPoint2: CGPoint(x: 6.19, y: 1))
			$0.curve(to: CGPoint(x: 2.94, y: 1.57), controlPoint1: CGPoint(x: 4.25, y: 1), controlPoint2: CGPoint(x: 3.54, y: 1.21))
			$0.curve(to: CGPoint(x: 2.27, y: 2.08), controlPoint1: CGPoint(x: 2.7, y: 1.71), controlPoint2: CGPoint(x: 2.47, y: 1.89))
			$0.curve(to: CGPoint(x: 2, y: 2.35), controlPoint1: CGPoint(x: 2.17, y: 2.17), controlPoint2: CGPoint(x: 2.08, y: 2.26))
			$0.curve(to: CGPoint(x: 1, y: 3.49), controlPoint1: CGPoint(x: 1.96, y: 2.41), controlPoint2: CGPoint(x: 1.48, y: 3.14))
			$0.line(to: CGPoint(x: 0.92, y: 3.54))
			$0.curve(to: CGPoint(x: 0, y: 3.8), controlPoint1: CGPoint(x: 0.45, y: 3.84), controlPoint2: CGPoint(x: 0, y: 3.8))
			$0.line(to: CGPoint(x: 0, y: 6.2))
			$0.curve(to: CGPoint(x: 1, y: 6.51), controlPoint1: CGPoint(x: 0, y: 6.2), controlPoint2: CGPoint(x: 0.5, y: 6.15))
			$0.curve(to: CGPoint(x: 2, y: 7.65), controlPoint1: CGPoint(x: 1.48, y: 6.86), controlPoint2: CGPoint(x: 1.96, y: 7.59))
			$0.curve(to: CGPoint(x: 2.35, y: 8), controlPoint1: CGPoint(x: 2.11, y: 7.77), controlPoint2: CGPoint(x: 2.23, y: 7.89))
			$0.curve(to: CGPoint(x: 3.49, y: 9), controlPoint1: CGPoint(x: 2.41, y: 8.04), controlPoint2: CGPoint(x: 3.14, y: 8.52))
			$0.curve(to: CGPoint(x: 3.8, y: 10), controlPoint1: CGPoint(x: 3.85, y: 9.5), controlPoint2: CGPoint(x: 3.8, y: 10))
			$0.line(to: CGPoint(x: 6.2, y: 10))
			$0.close()
		}

	static let templateLeftBottomRight =
		CGPath.make {
			$0.move(to: CGPoint(x: 6.2, y: 0))
			$0.curve(to: CGPoint(x: 6.51, y: 1), controlPoint1: CGPoint(x: 6.2, y: 0), controlPoint2: CGPoint(x: 6.15, y: 0.5))
			$0.curve(to: CGPoint(x: 7.64, y: 1.99), controlPoint1: CGPoint(x: 6.85, y: 1.47), controlPoint2: CGPoint(x: 7.55, y: 1.93))
			$0.curve(to: CGPoint(x: 8, y: 2.35), controlPoint1: CGPoint(x: 7.77, y: 2.11), controlPoint2: CGPoint(x: 7.89, y: 2.23))
			$0.curve(to: CGPoint(x: 9, y: 3.49), controlPoint1: CGPoint(x: 8.04, y: 2.41), controlPoint2: CGPoint(x: 8.52, y: 3.14))
			$0.curve(to: CGPoint(x: 10, y: 3.8), controlPoint1: CGPoint(x: 9.5, y: 3.85), controlPoint2: CGPoint(x: 10, y: 3.8))
			$0.line(to: CGPoint(x: 10, y: 6.2))
			$0.curve(to: CGPoint(x: 9, y: 6.51), controlPoint1: CGPoint(x: 10, y: 6.2), controlPoint2: CGPoint(x: 9.5, y: 6.15))
			$0.curve(to: CGPoint(x: 8, y: 7.65), controlPoint1: CGPoint(x: 8.52, y: 6.86), controlPoint2: CGPoint(x: 8.04, y: 7.59))
			$0.curve(to: CGPoint(x: 5, y: 9), controlPoint1: CGPoint(x: 7.27, y: 8.48), controlPoint2: CGPoint(x: 6.19, y: 9))
			$0.curve(to: CGPoint(x: 2.94, y: 8.43), controlPoint1: CGPoint(x: 4.25, y: 9), controlPoint2: CGPoint(x: 3.54, y: 8.79))
			$0.curve(to: CGPoint(x: 2.27, y: 7.92), controlPoint1: CGPoint(x: 2.7, y: 8.29), controlPoint2: CGPoint(x: 2.47, y: 8.11))
			$0.curve(to: CGPoint(x: 2, y: 7.65), controlPoint1: CGPoint(x: 2.17, y: 7.83), controlPoint2: CGPoint(x: 2.08, y: 7.74))
			$0.curve(to: CGPoint(x: 1, y: 6.51), controlPoint1: CGPoint(x: 1.96, y: 7.59), controlPoint2: CGPoint(x: 1.48, y: 6.86))
			$0.line(to: CGPoint(x: 0.92, y: 6.46))
			$0.curve(to: CGPoint(x: 0, y: 6.2), controlPoint1: CGPoint(x: 0.45, y: 6.16), controlPoint2: CGPoint(x: 0, y: 6.2))
			$0.line(to: CGPoint(x: 0, y: 3.8))
			$0.curve(to: CGPoint(x: 1, y: 3.49), controlPoint1: CGPoint(x: 0, y: 3.8), controlPoint2: CGPoint(x: 0.5, y: 3.85))
			$0.curve(to: CGPoint(x: 2, y: 2.35), controlPoint1: CGPoint(x: 1.48, y: 3.14), controlPoint2: CGPoint(x: 1.96, y: 2.41))
			$0.curve(to: CGPoint(x: 2.35, y: 2), controlPoint1: CGPoint(x: 2.11, y: 2.23), controlPoint2: CGPoint(x: 2.23, y: 2.11))
			$0.curve(to: CGPoint(x: 3.49, y: 1), controlPoint1: CGPoint(x: 2.41, y: 1.96), controlPoint2: CGPoint(x: 3.14, y: 1.48))
			$0.curve(to: CGPoint(x: 3.8, y: 0), controlPoint1: CGPoint(x: 3.85, y: 0.5), controlPoint2: CGPoint(x: 3.8, y: 0))
			$0.line(to: CGPoint(x: 6.2, y: 0))
			$0.close()
		}

	static let templateTopRightBottom =
		CGPath.make {
			$0.move(to: CGPoint(x: 10, y: 6.2))
			$0.curve(to: CGPoint(x: 9, y: 6.51), controlPoint1: CGPoint(x: 10, y: 6.2), controlPoint2: CGPoint(x: 9.5, y: 6.15))
			$0.curve(to: CGPoint(x: 8.01, y: 7.64), controlPoint1: CGPoint(x: 8.53, y: 6.85), controlPoint2: CGPoint(x: 8.07, y: 7.55))
			$0.curve(to: CGPoint(x: 7.65, y: 8), controlPoint1: CGPoint(x: 7.89, y: 7.77), controlPoint2: CGPoint(x: 7.77, y: 7.89))
			$0.curve(to: CGPoint(x: 6.51, y: 9), controlPoint1: CGPoint(x: 7.59, y: 8.04), controlPoint2: CGPoint(x: 6.86, y: 8.52))
			$0.curve(to: CGPoint(x: 6.2, y: 10), controlPoint1: CGPoint(x: 6.15, y: 9.5), controlPoint2: CGPoint(x: 6.2, y: 10))
			$0.line(to: CGPoint(x: 3.8, y: 10))
			$0.curve(to: CGPoint(x: 3.49, y: 9), controlPoint1: CGPoint(x: 3.8, y: 10), controlPoint2: CGPoint(x: 3.85, y: 9.5))
			$0.curve(to: CGPoint(x: 2.35, y: 8), controlPoint1: CGPoint(x: 3.14, y: 8.52), controlPoint2: CGPoint(x: 2.41, y: 8.04))
			$0.curve(to: CGPoint(x: 1, y: 5), controlPoint1: CGPoint(x: 1.52, y: 7.27), controlPoint2: CGPoint(x: 1, y: 6.19))
			$0.curve(to: CGPoint(x: 1.57, y: 2.94), controlPoint1: CGPoint(x: 1, y: 4.25), controlPoint2: CGPoint(x: 1.21, y: 3.54))
			$0.curve(to: CGPoint(x: 2.08, y: 2.27), controlPoint1: CGPoint(x: 1.71, y: 2.7), controlPoint2: CGPoint(x: 1.89, y: 2.47))
			$0.curve(to: CGPoint(x: 2.35, y: 2), controlPoint1: CGPoint(x: 2.17, y: 2.17), controlPoint2: CGPoint(x: 2.26, y: 2.08))
			$0.curve(to: CGPoint(x: 3.49, y: 1), controlPoint1: CGPoint(x: 2.41, y: 1.96), controlPoint2: CGPoint(x: 3.14, y: 1.48))
			$0.line(to: CGPoint(x: 3.54, y: 0.92))
			$0.curve(to: CGPoint(x: 3.8, y: 0), controlPoint1: CGPoint(x: 3.84, y: 0.45), controlPoint2: CGPoint(x: 3.8, y: 0))
			$0.line(to: CGPoint(x: 6.2, y: 0))
			$0.curve(to: CGPoint(x: 6.51, y: 1), controlPoint1: CGPoint(x: 6.2, y: 0), controlPoint2: CGPoint(x: 6.15, y: 0.5))
			$0.curve(to: CGPoint(x: 7.65, y: 2), controlPoint1: CGPoint(x: 6.86, y: 1.48), controlPoint2: CGPoint(x: 7.59, y: 1.96))
			$0.curve(to: CGPoint(x: 8, y: 2.35), controlPoint1: CGPoint(x: 7.77, y: 2.11), controlPoint2: CGPoint(x: 7.89, y: 2.23))
			$0.curve(to: CGPoint(x: 9, y: 3.49), controlPoint1: CGPoint(x: 8.04, y: 2.41), controlPoint2: CGPoint(x: 8.52, y: 3.14))
			$0.curve(to: CGPoint(x: 10, y: 3.8), controlPoint1: CGPoint(x: 9.5, y: 3.85), controlPoint2: CGPoint(x: 10, y: 3.8))
			$0.line(to: CGPoint(x: 10, y: 6.2))
			$0.close()
		}

	static let templateTopLeftBottom =
		CGPath.make {
			$0.move(to: CGPoint(x: 0, y: 6.2))
			$0.curve(to: CGPoint(x: 1, y: 6.51), controlPoint1: CGPoint(x: 0, y: 6.2), controlPoint2: CGPoint(x: 0.5, y: 6.15))
			$0.curve(to: CGPoint(x: 1.99, y: 7.64), controlPoint1: CGPoint(x: 1.47, y: 6.85), controlPoint2: CGPoint(x: 1.93, y: 7.55))
			$0.curve(to: CGPoint(x: 2.35, y: 8), controlPoint1: CGPoint(x: 2.11, y: 7.77), controlPoint2: CGPoint(x: 2.23, y: 7.89))
			$0.curve(to: CGPoint(x: 3.49, y: 9), controlPoint1: CGPoint(x: 2.41, y: 8.04), controlPoint2: CGPoint(x: 3.14, y: 8.52))
			$0.curve(to: CGPoint(x: 3.8, y: 10), controlPoint1: CGPoint(x: 3.85, y: 9.5), controlPoint2: CGPoint(x: 3.8, y: 10))
			$0.line(to: CGPoint(x: 6.2, y: 10))
			$0.curve(to: CGPoint(x: 6.51, y: 9), controlPoint1: CGPoint(x: 6.2, y: 10), controlPoint2: CGPoint(x: 6.15, y: 9.5))
			$0.curve(to: CGPoint(x: 7.65, y: 8), controlPoint1: CGPoint(x: 6.86, y: 8.52), controlPoint2: CGPoint(x: 7.59, y: 8.04))
			$0.curve(to: CGPoint(x: 9, y: 5), controlPoint1: CGPoint(x: 8.48, y: 7.27), controlPoint2: CGPoint(x: 9, y: 6.19))
			$0.curve(to: CGPoint(x: 8.43, y: 2.94), controlPoint1: CGPoint(x: 9, y: 4.25), controlPoint2: CGPoint(x: 8.79, y: 3.54))
			$0.curve(to: CGPoint(x: 7.92, y: 2.27), controlPoint1: CGPoint(x: 8.29, y: 2.7), controlPoint2: CGPoint(x: 8.11, y: 2.47))
			$0.curve(to: CGPoint(x: 7.65, y: 2), controlPoint1: CGPoint(x: 7.83, y: 2.17), controlPoint2: CGPoint(x: 7.74, y: 2.08))
			$0.curve(to: CGPoint(x: 6.51, y: 1), controlPoint1: CGPoint(x: 7.59, y: 1.96), controlPoint2: CGPoint(x: 6.86, y: 1.48))
			$0.line(to: CGPoint(x: 6.46, y: 0.92))
			$0.curve(to: CGPoint(x: 6.2, y: 0), controlPoint1: CGPoint(x: 6.16, y: 0.45), controlPoint2: CGPoint(x: 6.2, y: 0))
			$0.line(to: CGPoint(x: 3.8, y: 0))
			$0.curve(to: CGPoint(x: 3.49, y: 1), controlPoint1: CGPoint(x: 3.8, y: 0), controlPoint2: CGPoint(x: 3.85, y: 0.5))
			$0.curve(to: CGPoint(x: 2.35, y: 2), controlPoint1: CGPoint(x: 3.14, y: 1.48), controlPoint2: CGPoint(x: 2.41, y: 1.96))
			$0.curve(to: CGPoint(x: 2, y: 2.35), controlPoint1: CGPoint(x: 2.23, y: 2.11), controlPoint2: CGPoint(x: 2.11, y: 2.23))
			$0.curve(to: CGPoint(x: 1, y: 3.49), controlPoint1: CGPoint(x: 1.96, y: 2.41), controlPoint2: CGPoint(x: 1.48, y: 3.14))
			$0.curve(to: CGPoint(x: 0, y: 3.8), controlPoint1: CGPoint(x: 0.5, y: 3.85), controlPoint2: CGPoint(x: 0, y: 3.8))
			$0.line(to: CGPoint(x: 0, y: 6.2))
			$0.close()
		}


	// -

	static let templateTopLeftBottomRight =
		CGPath.make {
			$0.move(to: CGPoint(x: 6.2, y: 10))
			$0.curve(to: CGPoint(x: 6.51, y: 9), controlPoint1: CGPoint(x: 6.2, y: 10), controlPoint2: CGPoint(x: 6.15, y: 9.5))
			$0.curve(to: CGPoint(x: 7.64, y: 8.01), controlPoint1: CGPoint(x: 6.85, y: 8.53), controlPoint2: CGPoint(x: 7.55, y: 8.07))
			$0.curve(to: CGPoint(x: 8, y: 7.65), controlPoint1: CGPoint(x: 7.77, y: 7.89), controlPoint2: CGPoint(x: 7.89, y: 7.77))
			$0.curve(to: CGPoint(x: 9, y: 6.51), controlPoint1: CGPoint(x: 8.04, y: 7.59), controlPoint2: CGPoint(x: 8.52, y: 6.86))
			$0.curve(to: CGPoint(x: 10, y: 6.2), controlPoint1: CGPoint(x: 9.5, y: 6.15), controlPoint2: CGPoint(x: 10, y: 6.2))
			$0.line(to: CGPoint(x: 10, y: 3.8))
			$0.curve(to: CGPoint(x: 9, y: 3.49), controlPoint1: CGPoint(x: 10, y: 3.8), controlPoint2: CGPoint(x: 9.5, y: 3.85))
			$0.curve(to: CGPoint(x: 8, y: 2.35), controlPoint1: CGPoint(x: 8.52, y: 3.14), controlPoint2: CGPoint(x: 8.04, y: 2.41))
			$0.curve(to: CGPoint(x: 7.65, y: 2), controlPoint1: CGPoint(x: 7.89, y: 2.23), controlPoint2: CGPoint(x: 7.77, y: 2.11))
			$0.curve(to: CGPoint(x: 6.51, y: 1), controlPoint1: CGPoint(x: 7.59, y: 1.96), controlPoint2: CGPoint(x: 6.86, y: 1.48))
			$0.curve(to: CGPoint(x: 6.2, y: 0), controlPoint1: CGPoint(x: 6.15, y: 0.5), controlPoint2: CGPoint(x: 6.2, y: 0))
			$0.line(to: CGPoint(x: 3.8, y: 0))
			$0.curve(to: CGPoint(x: 3.54, y: 0.92), controlPoint1: CGPoint(x: 3.8, y: 0), controlPoint2: CGPoint(x: 3.84, y: 0.45))
			$0.line(to: CGPoint(x: 3.49, y: 1))
			$0.curve(to: CGPoint(x: 2.35, y: 2), controlPoint1: CGPoint(x: 3.14, y: 1.48), controlPoint2: CGPoint(x: 2.41, y: 1.96))
			$0.curve(to: CGPoint(x: 2.27, y: 2.08), controlPoint1: CGPoint(x: 2.35, y: 2), controlPoint2: CGPoint(x: 2.27, y: 2.08))
			$0.curve(to: CGPoint(x: 2, y: 2.35), controlPoint1: CGPoint(x: 2.17, y: 2.17), controlPoint2: CGPoint(x: 2.08, y: 2.26))
			$0.curve(to: CGPoint(x: 1, y: 3.49), controlPoint1: CGPoint(x: 1.96, y: 2.41), controlPoint2: CGPoint(x: 1.48, y: 3.14))
			$0.curve(to: CGPoint(x: 0, y: 3.8), controlPoint1: CGPoint(x: 0.5, y: 3.85), controlPoint2: CGPoint(x: 0, y: 3.8))
			$0.line(to: CGPoint(x: 0, y: 6.2))
			$0.curve(to: CGPoint(x: 1, y: 6.51), controlPoint1: CGPoint(x: 0, y: 6.2), controlPoint2: CGPoint(x: 0.5, y: 6.15))
			$0.curve(to: CGPoint(x: 2, y: 7.65), controlPoint1: CGPoint(x: 1.48, y: 6.86), controlPoint2: CGPoint(x: 1.96, y: 7.59))
			$0.curve(to: CGPoint(x: 2.35, y: 8), controlPoint1: CGPoint(x: 2.11, y: 7.77), controlPoint2: CGPoint(x: 2.23, y: 7.89))
			$0.curve(to: CGPoint(x: 3.49, y: 9), controlPoint1: CGPoint(x: 2.41, y: 8.04), controlPoint2: CGPoint(x: 3.14, y: 8.52))
			$0.curve(to: CGPoint(x: 3.8, y: 10), controlPoint1: CGPoint(x: 3.85, y: 9.5), controlPoint2: CGPoint(x: 3.8, y: 10))
			$0.line(to: CGPoint(x: 6.2, y: 10))
			$0.close()
		}

	// -

	static let templateTopLeft =
		CGPath.make {
			$0.move(to: CGPoint(x: 6.2, y: 10))
			$0.curve(to: CGPoint(x: 6.51, y: 9), controlPoint1: CGPoint(x: 6.2, y: 10), controlPoint2: CGPoint(x: 6.15, y: 9.5))
			$0.curve(to: CGPoint(x: 7.64, y: 8.01), controlPoint1: CGPoint(x: 6.85, y: 8.53), controlPoint2: CGPoint(x: 7.55, y: 8.07))
			$0.curve(to: CGPoint(x: 9, y: 5), controlPoint1: CGPoint(x: 8.48, y: 7.27), controlPoint2: CGPoint(x: 9, y: 6.19))
			$0.curve(to: CGPoint(x: 5, y: 1), controlPoint1: CGPoint(x: 9, y: 2.79), controlPoint2: CGPoint(x: 7.21, y: 1))
			$0.curve(to: CGPoint(x: 2.94, y: 1.57), controlPoint1: CGPoint(x: 4.25, y: 1), controlPoint2: CGPoint(x: 3.54, y: 1.21))
			$0.curve(to: CGPoint(x: 2, y: 2.35), controlPoint1: CGPoint(x: 2.59, y: 1.78), controlPoint2: CGPoint(x: 2.27, y: 2.05))
			$0.curve(to: CGPoint(x: 1, y: 3.49), controlPoint1: CGPoint(x: 1.96, y: 2.41), controlPoint2: CGPoint(x: 1.48, y: 3.14))
			$0.curve(to: CGPoint(x: 0, y: 3.8), controlPoint1: CGPoint(x: 0.5, y: 3.85), controlPoint2: CGPoint(x: 0, y: 3.8))
			$0.line(to: CGPoint(x: 0, y: 6.2))
			$0.curve(to: CGPoint(x: 1, y: 6.51), controlPoint1: CGPoint(x: 0, y: 6.2), controlPoint2: CGPoint(x: 0.5, y: 6.15))
			$0.curve(to: CGPoint(x: 2, y: 7.65), controlPoint1: CGPoint(x: 1.48, y: 6.86), controlPoint2: CGPoint(x: 1.96, y: 7.59))
			$0.curve(to: CGPoint(x: 2.35, y: 8), controlPoint1: CGPoint(x: 2.11, y: 7.77), controlPoint2: CGPoint(x: 2.23, y: 7.89))
			$0.curve(to: CGPoint(x: 3.49, y: 9), controlPoint1: CGPoint(x: 2.41, y: 8.04), controlPoint2: CGPoint(x: 3.14, y: 8.52))
			$0.curve(to: CGPoint(x: 3.8, y: 10), controlPoint1: CGPoint(x: 3.85, y: 9.5), controlPoint2: CGPoint(x: 3.8, y: 10))
			$0.line(to: CGPoint(x: 6.2, y: 10))
			$0.line(to: CGPoint(x: 6.2, y: 10))
			$0.close()
		}

	static let templateTopRight =
		CGPath.make {
			$0.move(to: CGPoint(x: 10, y: 3.8))
			$0.curve(to: CGPoint(x: 9, y: 3.49), controlPoint1: CGPoint(x: 10, y: 3.8), controlPoint2: CGPoint(x: 9.5, y: 3.85))
			$0.curve(to: CGPoint(x: 8.01, y: 2.36), controlPoint1: CGPoint(x: 8.53, y: 3.15), controlPoint2: CGPoint(x: 8.07, y: 2.45))
			$0.curve(to: CGPoint(x: 5, y: 1), controlPoint1: CGPoint(x: 7.27, y: 1.52), controlPoint2: CGPoint(x: 6.19, y: 1))
			$0.curve(to: CGPoint(x: 1, y: 5), controlPoint1: CGPoint(x: 2.79, y: 1), controlPoint2: CGPoint(x: 1, y: 2.79))
			$0.curve(to: CGPoint(x: 1.57, y: 7.06), controlPoint1: CGPoint(x: 1, y: 5.75), controlPoint2: CGPoint(x: 1.21, y: 6.46))
			$0.curve(to: CGPoint(x: 2.35, y: 8), controlPoint1: CGPoint(x: 1.78, y: 7.41), controlPoint2: CGPoint(x: 2.05, y: 7.73))
			$0.curve(to: CGPoint(x: 3.49, y: 9), controlPoint1: CGPoint(x: 2.41, y: 8.04), controlPoint2: CGPoint(x: 3.14, y: 8.52))
			$0.curve(to: CGPoint(x: 3.8, y: 10), controlPoint1: CGPoint(x: 3.85, y: 9.5), controlPoint2: CGPoint(x: 3.8, y: 10))
			$0.line(to: CGPoint(x: 6.2, y: 10))
			$0.curve(to: CGPoint(x: 6.51, y: 9), controlPoint1: CGPoint(x: 6.2, y: 10), controlPoint2: CGPoint(x: 6.15, y: 9.5))
			$0.curve(to: CGPoint(x: 7.65, y: 8), controlPoint1: CGPoint(x: 6.86, y: 8.52), controlPoint2: CGPoint(x: 7.59, y: 8.04))
			$0.curve(to: CGPoint(x: 8, y: 7.65), controlPoint1: CGPoint(x: 7.77, y: 7.89), controlPoint2: CGPoint(x: 7.89, y: 7.77))
			$0.curve(to: CGPoint(x: 9, y: 6.51), controlPoint1: CGPoint(x: 8.04, y: 7.59), controlPoint2: CGPoint(x: 8.52, y: 6.86))
			$0.curve(to: CGPoint(x: 10, y: 6.2), controlPoint1: CGPoint(x: 9.5, y: 6.15), controlPoint2: CGPoint(x: 10, y: 6.2))
			$0.line(to: CGPoint(x: 10, y: 3.8))
			$0.line(to: CGPoint(x: 10, y: 3.8))
			$0.close()
		}

	static let templateBottomLeft =
		CGPath.make {
			$0.move(to: CGPoint(x: 6.2, y: 0))
			$0.curve(to: CGPoint(x: 6.51, y: 1), controlPoint1: CGPoint(x: 6.2, y: 0), controlPoint2: CGPoint(x: 6.15, y: 0.5))
			$0.curve(to: CGPoint(x: 7.64, y: 1.99), controlPoint1: CGPoint(x: 6.85, y: 1.47), controlPoint2: CGPoint(x: 7.55, y: 1.93))
			$0.curve(to: CGPoint(x: 9, y: 5), controlPoint1: CGPoint(x: 8.48, y: 2.73), controlPoint2: CGPoint(x: 9, y: 3.81))
			$0.curve(to: CGPoint(x: 5, y: 9), controlPoint1: CGPoint(x: 9, y: 7.21), controlPoint2: CGPoint(x: 7.21, y: 9))
			$0.curve(to: CGPoint(x: 2.94, y: 8.43), controlPoint1: CGPoint(x: 4.25, y: 9), controlPoint2: CGPoint(x: 3.54, y: 8.79))
			$0.curve(to: CGPoint(x: 2, y: 7.65), controlPoint1: CGPoint(x: 2.59, y: 8.22), controlPoint2: CGPoint(x: 2.27, y: 7.95))
			$0.curve(to: CGPoint(x: 1, y: 6.51), controlPoint1: CGPoint(x: 1.96, y: 7.59), controlPoint2: CGPoint(x: 1.48, y: 6.86))
			$0.curve(to: CGPoint(x: 0, y: 6.2), controlPoint1: CGPoint(x: 0.5, y: 6.15), controlPoint2: CGPoint(x: 0, y: 6.2))
			$0.line(to: CGPoint(x: 0, y: 3.8))
			$0.curve(to: CGPoint(x: 1, y: 3.49), controlPoint1: CGPoint(x: 0, y: 3.8), controlPoint2: CGPoint(x: 0.5, y: 3.85))
			$0.curve(to: CGPoint(x: 2, y: 2.35), controlPoint1: CGPoint(x: 1.48, y: 3.14), controlPoint2: CGPoint(x: 1.96, y: 2.41))
			$0.curve(to: CGPoint(x: 2.35, y: 2), controlPoint1: CGPoint(x: 2.11, y: 2.23), controlPoint2: CGPoint(x: 2.23, y: 2.11))
			$0.curve(to: CGPoint(x: 3.49, y: 1), controlPoint1: CGPoint(x: 2.41, y: 1.96), controlPoint2: CGPoint(x: 3.14, y: 1.48))
			$0.curve(to: CGPoint(x: 3.8, y: 0), controlPoint1: CGPoint(x: 3.85, y: 0.5), controlPoint2: CGPoint(x: 3.8, y: 0))
			$0.line(to: CGPoint(x: 6.2, y: 0))
			$0.line(to: CGPoint(x: 6.2, y: 0))
			$0.close()
		}

	static let templateBottomRight =
		CGPath.make {
			$0.move(to: CGPoint(x: 3.8, y: 0))
			$0.curve(to: CGPoint(x: 3.49, y: 1), controlPoint1: CGPoint(x: 3.8, y: 0), controlPoint2: CGPoint(x: 3.85, y: 0.5))
			$0.curve(to: CGPoint(x: 2.36, y: 1.99), controlPoint1: CGPoint(x: 3.15, y: 1.47), controlPoint2: CGPoint(x: 2.45, y: 1.93))
			$0.curve(to: CGPoint(x: 1, y: 5), controlPoint1: CGPoint(x: 1.52, y: 2.73), controlPoint2: CGPoint(x: 1, y: 3.81))
			$0.curve(to: CGPoint(x: 5, y: 9), controlPoint1: CGPoint(x: 1, y: 7.21), controlPoint2: CGPoint(x: 2.79, y: 9))
			$0.curve(to: CGPoint(x: 7.06, y: 8.43), controlPoint1: CGPoint(x: 5.75, y: 9), controlPoint2: CGPoint(x: 6.46, y: 8.79))
			$0.curve(to: CGPoint(x: 8, y: 7.65), controlPoint1: CGPoint(x: 7.41, y: 8.22), controlPoint2: CGPoint(x: 7.73, y: 7.95))
			$0.curve(to: CGPoint(x: 9, y: 6.51), controlPoint1: CGPoint(x: 8.04, y: 7.59), controlPoint2: CGPoint(x: 8.52, y: 6.86))
			$0.curve(to: CGPoint(x: 10, y: 6.2), controlPoint1: CGPoint(x: 9.5, y: 6.15), controlPoint2: CGPoint(x: 10, y: 6.2))
			$0.line(to: CGPoint(x: 10, y: 3.8))
			$0.curve(to: CGPoint(x: 9, y: 3.49), controlPoint1: CGPoint(x: 10, y: 3.8), controlPoint2: CGPoint(x: 9.5, y: 3.85))
			$0.curve(to: CGPoint(x: 8, y: 2.35), controlPoint1: CGPoint(x: 8.52, y: 3.14), controlPoint2: CGPoint(x: 8.04, y: 2.41))
			$0.curve(to: CGPoint(x: 7.65, y: 2), controlPoint1: CGPoint(x: 7.89, y: 2.23), controlPoint2: CGPoint(x: 7.77, y: 2.11))
			$0.curve(to: CGPoint(x: 6.51, y: 1), controlPoint1: CGPoint(x: 7.59, y: 1.96), controlPoint2: CGPoint(x: 6.86, y: 1.48))
			$0.curve(to: CGPoint(x: 6.2, y: 0), controlPoint1: CGPoint(x: 6.15, y: 0.5), controlPoint2: CGPoint(x: 6.2, y: 0))
			$0.line(to: CGPoint(x: 3.8, y: 0))
			$0.line(to: CGPoint(x: 3.8, y: 0))
			$0.close()
		}
}
