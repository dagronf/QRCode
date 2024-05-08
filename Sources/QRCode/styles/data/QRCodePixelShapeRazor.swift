//
//  QRCodePixelShapeRazor.swift
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
	@objc(QRCodePixelShapeRazor) class Razor: NSObject, QRCodePixelShapeGenerator {
		/// The generator name
		@objc public static let Name: String = "razor"
		/// The generator title
		@objc public static var Title: String { "Razor" }
		/// Create an instance of this path generator with the specified settings
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodePixelShapeGenerator { Razor() }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePixelShapeGenerator { Razor() }
	}
}

public extension QRCode.PixelShape.Razor {
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
				//guard matrix[row, col] == true else { continue }

				let translate = CGAffineTransform(translationX: CGFloat(col) * dm + xoff, y: CGFloat(row) * dm + yoff)

				let ne = Neighbours(matrix: matrix, row: row, col: col)

				if matrix[row, col] == false {
					// Attach inner corners if needed
					if ne.leading, ne.top, ne.topLeading {
						path.addPath(
							Self.templateRoundTopLeft,
							transform: scaleTransform.concatenating(translate)
						)
					}
					if ne.trailing, ne.top, ne.topTrailing {
						path.addPath(
							Self.templateRoundTopRight,
							transform: scaleTransform.concatenating(translate)
						)
					}
					if ne.leading, ne.bottom, ne.bottomLeading {
						path.addPath(
							Self.templateRoundBottomLeft,
							transform: scaleTransform.concatenating(translate)
						)
					}
					if ne.trailing, ne.bottom, ne.bottomTrailing {
						path.addPath(
							Self.templateRoundBottomRight,
							transform: scaleTransform.concatenating(translate)
						)
					}
					continue
				}

				if !ne.bottom, !ne.trailing, !ne.top, !ne.leading {
					path.addPath(
						Self.templateIsolated,
						transform: scaleTransform.concatenating(translate)
					)
				}
				else if ne.bottom, ne.trailing, !ne.top, !ne.leading {
					path.addPath(
						Self.templatePointingUpperLeft,
						transform: scaleTransform.concatenating(translate)
					)
				}
				else if ne.bottom, ne.leading, !ne.trailing, !ne.top {
					path.addPath(
						Self.templatePointingUpperRight,
						transform: scaleTransform.concatenating(translate)
					)
				}
				else if ne.top, ne.trailing, !ne.leading, !ne.bottom {
					path.addPath(
						Self.templatePointingLowerLeft,
						transform: scaleTransform.concatenating(translate)
					)
				}
				else if ne.top, ne.leading, !ne.bottom, !ne.trailing {
					path.addPath(
						Self.templatePointingLowerRight,
						transform: scaleTransform.concatenating(translate)
					)
				}

				else if ne.bottom, !ne.trailing, !ne.top, !ne.leading {
					path.addPath(
						Self.templatePointingUp,
						transform: scaleTransform.concatenating(translate)
					)
				}
				else if ne.top, !ne.trailing, !ne.bottom, !ne.leading  {
					path.addPath(
						Self.templatePointingDown,
						transform: scaleTransform.concatenating(translate)
					)
				}
				else if ne.leading, !ne.trailing, !ne.bottom, !ne.top {
					path.addPath(
						Self.templatePointingRight,
						transform: scaleTransform.concatenating(translate)
					)
				}
				else if ne.trailing, !ne.leading, !ne.bottom, !ne.top {
					path.addPath(
						Self.templatePointingLeft,
						transform: scaleTransform.concatenating(translate)
					)
				}
				else {
					path.addPath(
						Self.templateSquare,
						transform: scaleTransform.concatenating(translate)
					)
				}
			}
		}
		return path
	}
}

// MARK: - Settings

public extension QRCode.PixelShape.Razor {
	/// Does the shape generator support setting values for a particular key?
	@objc func supportsSettingValue(forKey key: String) -> Bool { false }
	/// Returns a storable representation of the shape handler
	@objc func settings() -> [String: Any] { return [:] }
	/// Set a configuration value for a particular setting string
	@objc func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }
}

// MARK: - Shapes

private extension QRCode.PixelShape.Razor {
	/// A square
	static let templateSquare =
		CGPath(rect: CGRect(origin: .zero, size: .init(width: 10, height: 10)), transform: nil)

	/// A pixel that's isolated
	static let templateIsolated =
		CGPath(roundedRect: CGRect(x: 0, y: 0, width: 10, height: 10), cornerWidth: 3, cornerHeight: 3, transform: nil)

	static let templatePointingDown =
		CGPath.make {
			$0.move(to: CGPoint(x: 0, y: 0))
			$0.line(to: CGPoint(x: 10, y: 0))
			$0.line(to: CGPoint(x: 10, y: 10))
			$0.curve(to: CGPoint(x: 2, y: 8), controlPoint1: CGPoint(x: 10, y: 10), controlPoint2: CGPoint(x: 4.5, y: 9.5))
			$0.curve(to: CGPoint(x: 0, y: 4), controlPoint1: CGPoint(x: -0.5, y: 6.5), controlPoint2: CGPoint(x: 0, y: 4))
			$0.line(to: CGPoint(x: 0, y: 0))
			$0.close()
		}

	static let templatePointingUp =
		CGPath.make {
			$0.move(to: CGPoint(x: 0, y: 0))
			$0.curve(to: CGPoint(x: 8, y: 2), controlPoint1: CGPoint(x: 0, y: 0), controlPoint2: CGPoint(x: 5.5, y: 0.5))
			$0.curve(to: CGPoint(x: 10, y: 6), controlPoint1: CGPoint(x: 10.5, y: 3.5), controlPoint2: CGPoint(x: 10, y: 6))
			$0.line(to: CGPoint(x: 10, y: 10))
			$0.line(to: CGPoint(x: 0, y: 10))
			$0.line(to: CGPoint(x: 0, y: 0))
			$0.close()
		}

	static let templatePointingRight =
		CGPath.make {
			$0.move(to: CGPoint(x: 0, y: 0))
			$0.line(to: CGPoint(x: 10, y: 0))
			$0.curve(to: CGPoint(x: 8, y: 8), controlPoint1: CGPoint(x: 10, y: 0), controlPoint2: CGPoint(x: 9.5, y: 5.5))
			$0.curve(to: CGPoint(x: 4, y: 10), controlPoint1: CGPoint(x: 6.5, y: 10.5), controlPoint2: CGPoint(x: 4, y: 10))
			$0.line(to: CGPoint(x: 0, y: 10))
			$0.line(to: CGPoint(x: 0, y: 0))
			$0.close()
		}

	static let templatePointingLeft =
		CGPath.make {
			$0.move(to: CGPoint(x: 2, y: 2))
			$0.curve(to: CGPoint(x: 6, y: 0), controlPoint1: CGPoint(x: 3.5, y: -0.5), controlPoint2: CGPoint(x: 6, y: 0))
			$0.line(to: CGPoint(x: 10, y: 0))
			$0.line(to: CGPoint(x: 10, y: 10))
			$0.line(to: CGPoint(x: 0, y: 10))
			$0.curve(to: CGPoint(x: 2, y: 2), controlPoint1: CGPoint(x: 0, y: 10), controlPoint2: CGPoint(x: 0.5, y: 4.5))
			$0.close()
		}
}

private extension QRCode.PixelShape.Razor {
	static let templatePointingUpperLeft =
		CGPath.make {
			$0.move(to: CGPoint(x: 10, y: 10))
			$0.curve(to: CGPoint(x: 10, y: 3), controlPoint1: CGPoint(x: 10, y: 10), controlPoint2: CGPoint(x: 10, y: 3))
			$0.curve(to: CGPoint(x: 10, y: 0), controlPoint1: CGPoint(x: 10, y: 1.32), controlPoint2: CGPoint(x: 10, y: 0))
			$0.line(to: CGPoint(x: 3, y: 0))
			$0.curve(to: CGPoint(x: 1.22, y: 0.58), controlPoint1: CGPoint(x: 2.34, y: 0), controlPoint2: CGPoint(x: 1.72, y: 0.22))
			$0.curve(to: CGPoint(x: 0, y: 3), controlPoint1: CGPoint(x: 0.48, y: 1.13), controlPoint2: CGPoint(x: 0, y: 2.01))
			$0.line(to: CGPoint(x: 0, y: 10))
			$0.line(to: CGPoint(x: 10, y: 10))
			$0.line(to: CGPoint(x: 10, y: 10))
			$0.close()
		}

	static let templatePointingUpperRight =
		CGPath.make {
			$0.move(to: CGPoint(x: 0, y: 10))
			$0.curve(to: CGPoint(x: 0, y: 3), controlPoint1: CGPoint(x: 0, y: 10), controlPoint2: CGPoint(x: 0, y: 3))
			$0.curve(to: CGPoint(x: 0, y: 0), controlPoint1: CGPoint(x: 0, y: 1.32), controlPoint2: CGPoint(x: 0, y: 0))
			$0.line(to: CGPoint(x: 7, y: 0))
			$0.curve(to: CGPoint(x: 8.78, y: 0.58), controlPoint1: CGPoint(x: 7.66, y: 0), controlPoint2: CGPoint(x: 8.28, y: 0.22))
			$0.curve(to: CGPoint(x: 10, y: 3), controlPoint1: CGPoint(x: 9.52, y: 1.13), controlPoint2: CGPoint(x: 10, y: 2.01))
			$0.line(to: CGPoint(x: 10, y: 10))
			$0.line(to: CGPoint(x: 0, y: 10))
			$0.line(to: CGPoint(x: 0, y: 10))
			$0.close()
		}

	static let templatePointingLowerLeft =
		CGPath.make {
			$0.move(to: CGPoint(x: 10, y: 0))
			$0.curve(to: CGPoint(x: 10, y: 7), controlPoint1: CGPoint(x: 10, y: 0), controlPoint2: CGPoint(x: 10, y: 7))
			$0.curve(to: CGPoint(x: 10, y: 10), controlPoint1: CGPoint(x: 10, y: 8.68), controlPoint2: CGPoint(x: 10, y: 10))
			$0.line(to: CGPoint(x: 3, y: 10))
			$0.curve(to: CGPoint(x: 1.22, y: 9.42), controlPoint1: CGPoint(x: 2.34, y: 10), controlPoint2: CGPoint(x: 1.72, y: 9.78))
			$0.curve(to: CGPoint(x: 0, y: 7), controlPoint1: CGPoint(x: 0.48, y: 8.87), controlPoint2: CGPoint(x: 0, y: 7.99))
			$0.line(to: CGPoint(x: 0, y: 0))
			$0.line(to: CGPoint(x: 10, y: 0))
			$0.line(to: CGPoint(x: 10, y: 0))
			$0.close()
		}

	static let templatePointingLowerRight =
		CGPath.make {
			$0.move(to: CGPoint(x: 0, y: 0))
			$0.curve(to: CGPoint(x: 0, y: 7), controlPoint1: CGPoint(x: 0, y: 0), controlPoint2: CGPoint(x: 0, y: 7))
			$0.curve(to: CGPoint(x: 0, y: 10), controlPoint1: CGPoint(x: 0, y: 8.68), controlPoint2: CGPoint(x: 0, y: 10))
			$0.line(to: CGPoint(x: 7, y: 10))
			$0.curve(to: CGPoint(x: 8.78, y: 9.42), controlPoint1: CGPoint(x: 7.66, y: 10), controlPoint2: CGPoint(x: 8.28, y: 9.78))
			$0.curve(to: CGPoint(x: 10, y: 7), controlPoint1: CGPoint(x: 9.52, y: 8.87), controlPoint2: CGPoint(x: 10, y: 7.99))
			$0.line(to: CGPoint(x: 10, y: 0))
			$0.line(to: CGPoint(x: 0, y: 0))
			$0.line(to: CGPoint(x: 0, y: 0))
			$0.close()
		}
}

// Inner corner templates

private extension QRCode.PixelShape.Razor {
	static let templateRoundTopLeft =
		CGPath.make {
			let fr = 1.25
			$0.move(to: CGPoint(x: fr, y: 0))
			$0.line(to: CGPoint(x: 0, y: 0))
			$0.curve(to: CGPoint(x: 0, y: fr), controlPoint1: CGPoint(x: 0, y: 0), controlPoint2: CGPoint(x: 0, y: fr / 2))
			$0.curve(to: CGPoint(x: fr, y: 0), controlPoint1: CGPoint(x: 0, y: fr / 2), controlPoint2: CGPoint(x: fr / 2, y: 0))
			$0.close()
		}

	static let templateRoundTopRight =
		CGPath.make {
			$0.addPath(
				QRCode.PixelShape.Razor.templateRoundTopLeft,
				transform:
					CGAffineTransform(scaleX: -1, y: 1)
					.concatenating(
						CGAffineTransform(translationX: 10, y: 0)
					)
			)
		}

	static let templateRoundBottomLeft =
		CGPath.make {
			$0.addPath(
				QRCode.PixelShape.Razor.templateRoundTopLeft,
				transform:
					CGAffineTransform(scaleX: 1, y: -1)
					.concatenating(.init(translationX: 0, y: 10))
			)
		}

	static let templateRoundBottomRight =
		CGPath.make {
			$0.addPath(
				QRCode.PixelShape.Razor.templateRoundTopLeft,
				transform:
					CGAffineTransform(scaleX: -1, y: -1)
					.concatenating(.init(translationX: 10, y: 10))
			)
	}
}
