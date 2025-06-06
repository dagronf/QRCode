//
//  Copyright © 2025 Darren Ford. All rights reserved.
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
	@objc(QRCodePixelShapeCrosshatch) class Crosshatch: NSObject, QRCodePixelShapeGenerator {
		/// The generator name
		@objc public static let Name: String = "crosshatch"
		/// The generator title
		@objc public static var Title: String { "Crosshatch" }

		/// This pupil generator can be used when generating eye and pupil shapes
		@objc public var canGenerateEyeAndPupilShapes: Bool { true }

		/// Create an instance of this path generator with the specified settings
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodePixelShapeGenerator { Crosshatch() }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePixelShapeGenerator { Crosshatch() }

		/// Reset the generator back to defaults
		@objc public func reset() { }
	}
}

public extension QRCode.PixelShape.Crosshatch {
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

					if !ne.topLeading, !ne.bottomLeading, !ne.bottomTrailing, !ne.topTrailing {
						path.addPath(Self.templateNone, transform: scaleTransform.concatenating(translate))
					}

					// Single arm

					else if ne.topLeading, !ne.topTrailing, !ne.bottomLeading, !ne.bottomTrailing {
						path.addPath(Self.templateTL, transform: scaleTransform.concatenating(translate))
					}
					else if !ne.topLeading, ne.topTrailing, !ne.bottomLeading, !ne.bottomTrailing {
						path.addPath(Self.templateTR, transform: scaleTransform.concatenating(translate))
					}
					else if !ne.topLeading, !ne.topTrailing, ne.bottomLeading, !ne.bottomTrailing {
						path.addPath(Self.templateBL, transform: scaleTransform.concatenating(translate))
					}
					else if !ne.topLeading, !ne.topTrailing, !ne.bottomLeading, ne.bottomTrailing {
						path.addPath(Self.templateBR, transform: scaleTransform.concatenating(translate))
					}

					// Double arm

					else if ne.topLeading, ne.topTrailing, !ne.bottomLeading, !ne.bottomTrailing {
						path.addPath(Self.templateTLTR, transform: scaleTransform.concatenating(translate))
					}
					else if ne.topLeading, !ne.topTrailing, ne.bottomLeading, !ne.bottomTrailing {
						path.addPath(Self.templateTLBL, transform: scaleTransform.concatenating(translate))
					}
					else if !ne.topLeading, !ne.topTrailing, ne.bottomLeading, ne.bottomTrailing {
						path.addPath(Self.templateBLBR, transform: scaleTransform.concatenating(translate))
					}
					else if !ne.topLeading, ne.topTrailing, !ne.bottomLeading, ne.bottomTrailing {
						path.addPath(Self.templateTRBR, transform: scaleTransform.concatenating(translate))
					}
					else if !ne.topLeading, ne.topTrailing, ne.bottomLeading, !ne.bottomTrailing {
						path.addPath(Self.templateTRBL, transform: scaleTransform.concatenating(translate))
					}
					else if ne.topLeading, !ne.topTrailing, !ne.bottomLeading, ne.bottomTrailing {
						path.addPath(Self.templateTLBR, transform: scaleTransform.concatenating(translate))
					}

					// Three arm

					else if ne.topLeading, ne.topTrailing, ne.bottomLeading, !ne.bottomTrailing {
						path.addPath(Self.templateTLTRBL, transform: scaleTransform.concatenating(translate))
					}
					else if ne.topLeading, ne.topTrailing, !ne.bottomLeading, ne.bottomTrailing {
						path.addPath(Self.templateTLTRBR, transform: scaleTransform.concatenating(translate))
					}
					else if !ne.topLeading, ne.topTrailing, ne.bottomLeading, ne.bottomTrailing {
						path.addPath(Self.templateTRBLBR, transform: scaleTransform.concatenating(translate))
					}
					else if ne.topLeading, !ne.topTrailing, ne.bottomLeading, ne.bottomTrailing {
						path.addPath(Self.templateTLBLBR, transform: scaleTransform.concatenating(translate))
					}

					// All arms!

					else {
						// do nothing?
						path.addPath(Self.templateAll, transform: scaleTransform.concatenating(translate))
					}
				}
			}
		}
		path.closeSubpath()
		return path
	}
}

// MARK: - Settings

public extension QRCode.PixelShape.Crosshatch {
	/// Does the shape generator support setting values for a particular key?
	@objc func supportsSettingValue(forKey key: String) -> Bool { false }
	/// Returns a storable representation of the shape handler
	@objc func settings() -> [String: Any] { return [:] }
	/// Set a configuration value for a particular setting string
	@objc func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }
}

// MARK: - Pixel creation conveniences

public extension QRCodePixelShapeGenerator where Self == QRCode.PixelShape.Crosshatch {
	/// Create a organic pixel generator
	/// - Returns: A pixel generator
	@inlinable static func crosshatch() -> QRCodePixelShapeGenerator {
		QRCode.PixelShape.Crosshatch()
	}
}

// MARK: - Shapes

// Inner corner templates

private extension QRCode.PixelShape.Crosshatch {

	// Circle with no arms

	static let templateNone = CGPath(ellipseIn: CGRect(x: 1, y: 1, width: 8, height: 8), transform: nil)

	// Single arms

	static let templateTL =
		CGPath.make { linesTLPath in
			linesTLPath.move(to: CGPoint(x: 0.74, y: 10.74))
			linesTLPath.curve(to: CGPoint(x: 3.01, y: 8.47), controlPoint1: CGPoint(x: 0.74, y: 10.74), controlPoint2: CGPoint(x: 1.82, y: 9.66))
			linesTLPath.curve(to: CGPoint(x: 5, y: 9), controlPoint1: CGPoint(x: 3.6, y: 8.81), controlPoint2: CGPoint(x: 4.28, y: 9))
			linesTLPath.curve(to: CGPoint(x: 9, y: 5), controlPoint1: CGPoint(x: 7.21, y: 9), controlPoint2: CGPoint(x: 9, y: 7.21))
			linesTLPath.curve(to: CGPoint(x: 5, y: 1), controlPoint1: CGPoint(x: 9, y: 2.79), controlPoint2: CGPoint(x: 7.21, y: 1))
			linesTLPath.curve(to: CGPoint(x: 2.94, y: 1.57), controlPoint1: CGPoint(x: 4.25, y: 1), controlPoint2: CGPoint(x: 3.54, y: 1.21))
			linesTLPath.curve(to: CGPoint(x: 1, y: 5), controlPoint1: CGPoint(x: 1.78, y: 2.27), controlPoint2: CGPoint(x: 1, y: 3.54))
			linesTLPath.curve(to: CGPoint(x: 1.58, y: 7.08), controlPoint1: CGPoint(x: 1, y: 5.76), controlPoint2: CGPoint(x: 1.21, y: 6.47))
			linesTLPath.curve(to: CGPoint(x: 0.56, y: 8.1), controlPoint1: CGPoint(x: 1.22, y: 7.44), controlPoint2: CGPoint(x: 0.87, y: 7.79))
			linesTLPath.curve(to: CGPoint(x: -0.67, y: 9.33), controlPoint1: CGPoint(x: -0.15, y: 8.81), controlPoint2: CGPoint(x: -0.67, y: 9.33))
			linesTLPath.line(to: CGPoint(x: 0.74, y: 10.74))
			linesTLPath.close()
		}.flippedVertically(height: 10)

	static let templateTR =
		CGPath.make { linesTRPath in
			linesTRPath.move(to: CGPoint(x: 9.26, y: 10.74))
			linesTRPath.curve(to: CGPoint(x: 10.67, y: 9.33), controlPoint1: CGPoint(x: 9.26, y: 10.74), controlPoint2: CGPoint(x: 10.67, y: 9.33))
			linesTRPath.curve(to: CGPoint(x: 8.42, y: 7.08), controlPoint1: CGPoint(x: 10.67, y: 9.33), controlPoint2: CGPoint(x: 9.6, y: 8.26))
			linesTRPath.curve(to: CGPoint(x: 9, y: 5), controlPoint1: CGPoint(x: 8.79, y: 6.47), controlPoint2: CGPoint(x: 9, y: 5.76))
			linesTRPath.curve(to: CGPoint(x: 5, y: 1), controlPoint1: CGPoint(x: 9, y: 2.79), controlPoint2: CGPoint(x: 7.21, y: 1))
			linesTRPath.curve(to: CGPoint(x: 2.94, y: 1.57), controlPoint1: CGPoint(x: 4.25, y: 1), controlPoint2: CGPoint(x: 3.54, y: 1.21))
			linesTRPath.curve(to: CGPoint(x: 1, y: 5), controlPoint1: CGPoint(x: 1.78, y: 2.27), controlPoint2: CGPoint(x: 1, y: 3.54))
			linesTRPath.curve(to: CGPoint(x: 5, y: 9), controlPoint1: CGPoint(x: 1, y: 7.21), controlPoint2: CGPoint(x: 2.79, y: 9))
			linesTRPath.curve(to: CGPoint(x: 6.99, y: 8.47), controlPoint1: CGPoint(x: 5.72, y: 9), controlPoint2: CGPoint(x: 6.4, y: 8.81))
			linesTRPath.curve(to: CGPoint(x: 9.26, y: 10.74), controlPoint1: CGPoint(x: 8.18, y: 9.66), controlPoint2: CGPoint(x: 9.26, y: 10.74))
			linesTRPath.line(to: CGPoint(x: 9.26, y: 10.74))
			linesTRPath.close()
		}.flippedVertically(height: 10)

	static let templateBL =
		CGPath.make { linesBLPath in
			linesBLPath.move(to: CGPoint(x: 9, y: 5))
			linesBLPath.curve(to: CGPoint(x: 5, y: 1), controlPoint1: CGPoint(x: 9, y: 2.79), controlPoint2: CGPoint(x: 7.21, y: 1))
			linesBLPath.curve(to: CGPoint(x: 2.97, y: 1.55), controlPoint1: CGPoint(x: 4.26, y: 1), controlPoint2: CGPoint(x: 3.56, y: 1.2))
			linesBLPath.curve(to: CGPoint(x: 0.77, y: -0.65), controlPoint1: CGPoint(x: 1.83, y: 0.41), controlPoint2: CGPoint(x: 0.77, y: -0.65))
			linesBLPath.curve(to: CGPoint(x: 0.05, y: 0.07), controlPoint1: CGPoint(x: 0.77, y: -0.65), controlPoint2: CGPoint(x: 0.41, y: -0.29))
			linesBLPath.curve(to: CGPoint(x: -0.65, y: 0.77), controlPoint1: CGPoint(x: -0.3, y: 0.42), controlPoint2: CGPoint(x: -0.65, y: 0.77))
			linesBLPath.curve(to: CGPoint(x: 1.55, y: 2.97), controlPoint1: CGPoint(x: -0.65, y: 0.77), controlPoint2: CGPoint(x: 0.41, y: 1.83))
			linesBLPath.curve(to: CGPoint(x: 1, y: 5), controlPoint1: CGPoint(x: 1.2, y: 3.56), controlPoint2: CGPoint(x: 1, y: 4.26))
			linesBLPath.curve(to: CGPoint(x: 5, y: 9), controlPoint1: CGPoint(x: 1, y: 7.21), controlPoint2: CGPoint(x: 2.79, y: 9))
			linesBLPath.curve(to: CGPoint(x: 9, y: 5), controlPoint1: CGPoint(x: 7.21, y: 9), controlPoint2: CGPoint(x: 9, y: 7.21))
			linesBLPath.close()
		}.flippedVertically(height: 10)

	static let templateBR =
		CGPath.make { linesBRPath in
			linesBRPath.move(to: CGPoint(x: 9, y: 5))
			linesBRPath.curve(to: CGPoint(x: 8.47, y: 3.01), controlPoint1: CGPoint(x: 9, y: 4.28), controlPoint2: CGPoint(x: 8.81, y: 3.6))
			linesBRPath.curve(to: CGPoint(x: 10.74, y: 0.74), controlPoint1: CGPoint(x: 9.69, y: 1.79), controlPoint2: CGPoint(x: 10.74, y: 0.74))
			linesBRPath.line(to: CGPoint(x: 9.33, y: -0.67))
			linesBRPath.curve(to: CGPoint(x: 7.08, y: 1.58), controlPoint1: CGPoint(x: 9.33, y: -0.67), controlPoint2: CGPoint(x: 8.29, y: 0.37))
			linesBRPath.curve(to: CGPoint(x: 5, y: 1), controlPoint1: CGPoint(x: 6.47, y: 1.21), controlPoint2: CGPoint(x: 5.76, y: 1))
			linesBRPath.curve(to: CGPoint(x: 2.94, y: 1.57), controlPoint1: CGPoint(x: 4.25, y: 1), controlPoint2: CGPoint(x: 3.54, y: 1.21))
			linesBRPath.curve(to: CGPoint(x: 1, y: 5), controlPoint1: CGPoint(x: 1.78, y: 2.27), controlPoint2: CGPoint(x: 1, y: 3.54))
			linesBRPath.curve(to: CGPoint(x: 5, y: 9), controlPoint1: CGPoint(x: 1, y: 7.21), controlPoint2: CGPoint(x: 2.79, y: 9))
			linesBRPath.curve(to: CGPoint(x: 9, y: 5), controlPoint1: CGPoint(x: 7.21, y: 9), controlPoint2: CGPoint(x: 9, y: 7.21))
			linesBRPath.close()
		}.flippedVertically(height: 10)

	// Double arms

	static let templateTLTR =
		CGPath.make { linesTRTLPath in
			linesTRTLPath.move(to: CGPoint(x: 9.26, y: 10.74))
			linesTRTLPath.line(to: CGPoint(x: 10.67, y: 9.33))
			linesTRTLPath.curve(to: CGPoint(x: 8.42, y: 7.08), controlPoint1: CGPoint(x: 10.67, y: 9.33), controlPoint2: CGPoint(x: 9.6, y: 8.26))
			linesTRTLPath.curve(to: CGPoint(x: 9, y: 5), controlPoint1: CGPoint(x: 8.79, y: 6.47), controlPoint2: CGPoint(x: 9, y: 5.76))
			linesTRTLPath.curve(to: CGPoint(x: 5, y: 1), controlPoint1: CGPoint(x: 9, y: 2.79), controlPoint2: CGPoint(x: 7.21, y: 1))
			linesTRTLPath.curve(to: CGPoint(x: 2.94, y: 1.57), controlPoint1: CGPoint(x: 4.25, y: 1), controlPoint2: CGPoint(x: 3.54, y: 1.21))
			linesTRTLPath.curve(to: CGPoint(x: 1, y: 5), controlPoint1: CGPoint(x: 1.78, y: 2.27), controlPoint2: CGPoint(x: 1, y: 3.54))
			linesTRTLPath.curve(to: CGPoint(x: 1.58, y: 7.08), controlPoint1: CGPoint(x: 1, y: 5.76), controlPoint2: CGPoint(x: 1.21, y: 6.47))
			linesTRTLPath.curve(to: CGPoint(x: 0.56, y: 8.1), controlPoint1: CGPoint(x: 1.22, y: 7.44), controlPoint2: CGPoint(x: 0.87, y: 7.79))
			linesTRTLPath.curve(to: CGPoint(x: -0.67, y: 9.33), controlPoint1: CGPoint(x: -0.15, y: 8.81), controlPoint2: CGPoint(x: -0.67, y: 9.33))
			linesTRTLPath.line(to: CGPoint(x: 0.74, y: 10.74))
			linesTRTLPath.curve(to: CGPoint(x: 3.01, y: 8.47), controlPoint1: CGPoint(x: 0.74, y: 10.74), controlPoint2: CGPoint(x: 1.82, y: 9.66))
			linesTRTLPath.curve(to: CGPoint(x: 5, y: 9), controlPoint1: CGPoint(x: 3.6, y: 8.81), controlPoint2: CGPoint(x: 4.28, y: 9))
			linesTRTLPath.curve(to: CGPoint(x: 6.99, y: 8.47), controlPoint1: CGPoint(x: 5.72, y: 9), controlPoint2: CGPoint(x: 6.4, y: 8.81))
			linesTRTLPath.curve(to: CGPoint(x: 9.26, y: 10.74), controlPoint1: CGPoint(x: 8.18, y: 9.66), controlPoint2: CGPoint(x: 9.26, y: 10.74))
			linesTRTLPath.close()
		}.flippedVertically(height: 10)

	static let templateTLBL =
		CGPath.make { linesTLBLPath in
			linesTLBLPath.move(to: CGPoint(x: 0.74, y: 10.74))
			linesTLBLPath.curve(to: CGPoint(x: 3.01, y: 8.47), controlPoint1: CGPoint(x: 0.74, y: 10.74), controlPoint2: CGPoint(x: 1.82, y: 9.66))
			linesTLBLPath.curve(to: CGPoint(x: 5, y: 9), controlPoint1: CGPoint(x: 3.6, y: 8.81), controlPoint2: CGPoint(x: 4.28, y: 9))
			linesTLBLPath.curve(to: CGPoint(x: 9, y: 5), controlPoint1: CGPoint(x: 7.21, y: 9), controlPoint2: CGPoint(x: 9, y: 7.21))
			linesTLBLPath.curve(to: CGPoint(x: 5, y: 1), controlPoint1: CGPoint(x: 9, y: 2.79), controlPoint2: CGPoint(x: 7.21, y: 1))
			linesTLBLPath.curve(to: CGPoint(x: 2.97, y: 1.55), controlPoint1: CGPoint(x: 4.26, y: 1), controlPoint2: CGPoint(x: 3.56, y: 1.2))
			linesTLBLPath.curve(to: CGPoint(x: 0.77, y: -0.65), controlPoint1: CGPoint(x: 1.83, y: 0.41), controlPoint2: CGPoint(x: 0.77, y: -0.65))
			linesTLBLPath.curve(to: CGPoint(x: 0.05, y: 0.07), controlPoint1: CGPoint(x: 0.54, y: -0.42), controlPoint2: CGPoint(x: 0.3, y: -0.18))
			linesTLBLPath.line(to: CGPoint(x: 0.01, y: 0.11))
			linesTLBLPath.curve(to: CGPoint(x: -0.65, y: 0.77), controlPoint1: CGPoint(x: -0.33, y: 0.45), controlPoint2: CGPoint(x: -0.65, y: 0.77))
			linesTLBLPath.curve(to: CGPoint(x: 0.11, y: 1.52), controlPoint1: CGPoint(x: -0.65, y: 0.77), controlPoint2: CGPoint(x: -0.35, y: 1.07))
			linesTLBLPath.curve(to: CGPoint(x: 1.55, y: 2.97), controlPoint1: CGPoint(x: 0.5, y: 1.92), controlPoint2: CGPoint(x: 1.02, y: 2.43))
			linesTLBLPath.curve(to: CGPoint(x: 1, y: 5), controlPoint1: CGPoint(x: 1.2, y: 3.56), controlPoint2: CGPoint(x: 1, y: 4.26))
			linesTLBLPath.curve(to: CGPoint(x: 1.58, y: 7.08), controlPoint1: CGPoint(x: 1, y: 5.76), controlPoint2: CGPoint(x: 1.21, y: 6.47))
			linesTLBLPath.curve(to: CGPoint(x: 0.56, y: 8.09), controlPoint1: CGPoint(x: 1.22, y: 7.43), controlPoint2: CGPoint(x: 0.87, y: 7.78))
			linesTLBLPath.curve(to: CGPoint(x: -0.67, y: 9.33), controlPoint1: CGPoint(x: -0.15, y: 8.81), controlPoint2: CGPoint(x: -0.67, y: 9.33))
			linesTLBLPath.line(to: CGPoint(x: 0.74, y: 10.74))
			linesTLBLPath.close()
		}.flippedVertically(height: 10)

	static let templateBLBR =
		CGPath.make { linesBLBRPath in
			linesBLBRPath.move(to: CGPoint(x: 9, y: 5))
			linesBLBRPath.curve(to: CGPoint(x: 8.47, y: 3.01), controlPoint1: CGPoint(x: 9, y: 4.28), controlPoint2: CGPoint(x: 8.81, y: 3.6))
			linesBLBRPath.curve(to: CGPoint(x: 10.75, y: 0.76), controlPoint1: CGPoint(x: 9.56, y: 1.94), controlPoint2: CGPoint(x: 10.75, y: 0.76))
			linesBLBRPath.line(to: CGPoint(x: 9.35, y: -0.66))
			linesBLBRPath.curve(to: CGPoint(x: 7.07, y: 1.58), controlPoint1: CGPoint(x: 9.35, y: -0.66), controlPoint2: CGPoint(x: 8.16, y: 0.51))
			linesBLBRPath.curve(to: CGPoint(x: 5, y: 1), controlPoint1: CGPoint(x: 6.47, y: 1.21), controlPoint2: CGPoint(x: 5.76, y: 1))
			linesBLBRPath.curve(to: CGPoint(x: 2.97, y: 1.55), controlPoint1: CGPoint(x: 4.26, y: 1), controlPoint2: CGPoint(x: 3.56, y: 1.2))
			linesBLBRPath.curve(to: CGPoint(x: 0.77, y: -0.65), controlPoint1: CGPoint(x: 1.83, y: 0.41), controlPoint2: CGPoint(x: 0.77, y: -0.65))
			linesBLBRPath.curve(to: CGPoint(x: 0.07, y: 0.05), controlPoint1: CGPoint(x: 0.77, y: -0.65), controlPoint2: CGPoint(x: 0.42, y: -0.3))
			linesBLBRPath.curve(to: CGPoint(x: -0.65, y: 0.77), controlPoint1: CGPoint(x: -0.29, y: 0.41), controlPoint2: CGPoint(x: -0.65, y: 0.77))
			linesBLBRPath.curve(to: CGPoint(x: 1.55, y: 2.97), controlPoint1: CGPoint(x: -0.65, y: 0.77), controlPoint2: CGPoint(x: 0.41, y: 1.83))
			linesBLBRPath.curve(to: CGPoint(x: 1, y: 5), controlPoint1: CGPoint(x: 1.2, y: 3.56), controlPoint2: CGPoint(x: 1, y: 4.26))
			linesBLBRPath.curve(to: CGPoint(x: 5, y: 9), controlPoint1: CGPoint(x: 1, y: 7.21), controlPoint2: CGPoint(x: 2.79, y: 9))
			linesBLBRPath.curve(to: CGPoint(x: 9, y: 5), controlPoint1: CGPoint(x: 7.21, y: 9), controlPoint2: CGPoint(x: 9, y: 7.21))
			linesBLBRPath.close()
		}.flippedVertically(height: 10)

	static let templateTRBR =
		CGPath.make { linesTRBRPath in
			linesTRBRPath.move(to: CGPoint(x: 9.26, y: 10.74))
			linesTRBRPath.line(to: CGPoint(x: 10.67, y: 9.33))
			linesTRBRPath.curve(to: CGPoint(x: 8.42, y: 7.08), controlPoint1: CGPoint(x: 10.67, y: 9.33), controlPoint2: CGPoint(x: 9.6, y: 8.26))
			linesTRBRPath.curve(to: CGPoint(x: 9, y: 5), controlPoint1: CGPoint(x: 8.79, y: 6.47), controlPoint2: CGPoint(x: 9, y: 5.76))
			linesTRBRPath.curve(to: CGPoint(x: 8.47, y: 3.01), controlPoint1: CGPoint(x: 9, y: 4.28), controlPoint2: CGPoint(x: 8.81, y: 3.6))
			linesTRBRPath.curve(to: CGPoint(x: 10.74, y: 0.74), controlPoint1: CGPoint(x: 9.64, y: 1.84), controlPoint2: CGPoint(x: 10.74, y: 0.74))
			linesTRBRPath.line(to: CGPoint(x: 9.33, y: -0.67))
			linesTRBRPath.curve(to: CGPoint(x: 8.94, y: -0.28), controlPoint1: CGPoint(x: 9.33, y: -0.67), controlPoint2: CGPoint(x: 9.18, y: -0.52))
			linesTRBRPath.curve(to: CGPoint(x: 8.79, y: -0.14), controlPoint1: CGPoint(x: 8.89, y: -0.23), controlPoint2: CGPoint(x: 8.84, y: -0.19))
			linesTRBRPath.line(to: CGPoint(x: 8.72, y: -0.06))
			linesTRBRPath.line(to: CGPoint(x: 8.67, y: -0.02))
			linesTRBRPath.line(to: CGPoint(x: 8.63, y: 0.02))
			linesTRBRPath.curve(to: CGPoint(x: 7.96, y: 0.69), controlPoint1: CGPoint(x: 8.44, y: 0.22), controlPoint2: CGPoint(x: 8.21, y: 0.45))
			linesTRBRPath.line(to: CGPoint(x: 7.91, y: 0.75))
			linesTRBRPath.curve(to: CGPoint(x: 7.64, y: 1.02), controlPoint1: CGPoint(x: 7.82, y: 0.84), controlPoint2: CGPoint(x: 7.73, y: 0.93))
			linesTRBRPath.line(to: CGPoint(x: 7.58, y: 1.08))
			linesTRBRPath.line(to: CGPoint(x: 7.52, y: 1.13))
			linesTRBRPath.line(to: CGPoint(x: 7.47, y: 1.19))
			linesTRBRPath.line(to: CGPoint(x: 7.41, y: 1.25))
			linesTRBRPath.line(to: CGPoint(x: 7.35, y: 1.3))
			linesTRBRPath.line(to: CGPoint(x: 7.29, y: 1.36))
			linesTRBRPath.line(to: CGPoint(x: 7.08, y: 1.58))
			linesTRBRPath.curve(to: CGPoint(x: 5, y: 1), controlPoint1: CGPoint(x: 6.47, y: 1.21), controlPoint2: CGPoint(x: 5.76, y: 1))
			linesTRBRPath.curve(to: CGPoint(x: 2.94, y: 1.57), controlPoint1: CGPoint(x: 4.25, y: 1), controlPoint2: CGPoint(x: 3.54, y: 1.21))
			linesTRBRPath.curve(to: CGPoint(x: 1, y: 5), controlPoint1: CGPoint(x: 1.78, y: 2.27), controlPoint2: CGPoint(x: 1, y: 3.54))
			linesTRBRPath.curve(to: CGPoint(x: 5, y: 9), controlPoint1: CGPoint(x: 1, y: 7.21), controlPoint2: CGPoint(x: 2.79, y: 9))
			linesTRBRPath.curve(to: CGPoint(x: 6.99, y: 8.47), controlPoint1: CGPoint(x: 5.72, y: 9), controlPoint2: CGPoint(x: 6.4, y: 8.81))
			linesTRBRPath.curve(to: CGPoint(x: 9.26, y: 10.74), controlPoint1: CGPoint(x: 8.18, y: 9.66), controlPoint2: CGPoint(x: 9.26, y: 10.74))
			linesTRBRPath.close()
		}.flippedVertically(height: 10)

	static let templateTRBL =
		CGPath.make { linesTRBLPath in
			linesTRBLPath.move(to: CGPoint(x: 9.26, y: 10.74))
			linesTRBLPath.line(to: CGPoint(x: 10.67, y: 9.33))
			linesTRBLPath.curve(to: CGPoint(x: 8.42, y: 7.08), controlPoint1: CGPoint(x: 10.67, y: 9.33), controlPoint2: CGPoint(x: 9.6, y: 8.26))
			linesTRBLPath.curve(to: CGPoint(x: 9, y: 5), controlPoint1: CGPoint(x: 8.79, y: 6.47), controlPoint2: CGPoint(x: 9, y: 5.76))
			linesTRBLPath.curve(to: CGPoint(x: 5, y: 1), controlPoint1: CGPoint(x: 9, y: 2.79), controlPoint2: CGPoint(x: 7.21, y: 1))
			linesTRBLPath.curve(to: CGPoint(x: 2.96, y: 1.56), controlPoint1: CGPoint(x: 4.26, y: 1), controlPoint2: CGPoint(x: 3.56, y: 1.2))
			linesTRBLPath.curve(to: CGPoint(x: 0.77, y: -0.65), controlPoint1: CGPoint(x: 1.83, y: 0.41), controlPoint2: CGPoint(x: 0.77, y: -0.65))
			linesTRBLPath.curve(to: CGPoint(x: 0.06, y: 0.07), controlPoint1: CGPoint(x: 0.54, y: -0.42), controlPoint2: CGPoint(x: 0.3, y: -0.18))
			linesTRBLPath.curve(to: CGPoint(x: -0.65, y: 0.77), controlPoint1: CGPoint(x: -0.3, y: 0.42), controlPoint2: CGPoint(x: -0.65, y: 0.77))
			linesTRBLPath.curve(to: CGPoint(x: 1.55, y: 2.97), controlPoint1: CGPoint(x: -0.65, y: 0.77), controlPoint2: CGPoint(x: 0.41, y: 1.83))
			linesTRBLPath.curve(to: CGPoint(x: 1, y: 5), controlPoint1: CGPoint(x: 1.2, y: 3.56), controlPoint2: CGPoint(x: 1, y: 4.26))
			linesTRBLPath.curve(to: CGPoint(x: 5, y: 9), controlPoint1: CGPoint(x: 1, y: 7.21), controlPoint2: CGPoint(x: 2.79, y: 9))
			linesTRBLPath.curve(to: CGPoint(x: 6.99, y: 8.47), controlPoint1: CGPoint(x: 5.72, y: 9), controlPoint2: CGPoint(x: 6.4, y: 8.81))
			linesTRBLPath.curve(to: CGPoint(x: 9.26, y: 10.74), controlPoint1: CGPoint(x: 8.18, y: 9.66), controlPoint2: CGPoint(x: 9.26, y: 10.74))
			linesTRBLPath.close()
		}.flippedVertically(height: 10)

	static let templateTLBR =
		CGPath.make { linesTLBRPath in
			linesTLBRPath.move(to: CGPoint(x: 0.74, y: 10.74))
			linesTLBRPath.curve(to: CGPoint(x: 3.01, y: 8.47), controlPoint1: CGPoint(x: 0.74, y: 10.74), controlPoint2: CGPoint(x: 1.82, y: 9.66))
			linesTLBRPath.curve(to: CGPoint(x: 5, y: 9), controlPoint1: CGPoint(x: 3.6, y: 8.81), controlPoint2: CGPoint(x: 4.28, y: 9))
			linesTLBRPath.curve(to: CGPoint(x: 9, y: 5), controlPoint1: CGPoint(x: 7.21, y: 9), controlPoint2: CGPoint(x: 9, y: 7.21))
			linesTLBRPath.curve(to: CGPoint(x: 8.47, y: 3.01), controlPoint1: CGPoint(x: 9, y: 4.28), controlPoint2: CGPoint(x: 8.81, y: 3.6))
			linesTLBRPath.curve(to: CGPoint(x: 10.75, y: 0.76), controlPoint1: CGPoint(x: 9.56, y: 1.94), controlPoint2: CGPoint(x: 10.75, y: 0.76))
			linesTLBRPath.line(to: CGPoint(x: 9.35, y: -0.66))
			linesTLBRPath.curve(to: CGPoint(x: 7.07, y: 1.58), controlPoint1: CGPoint(x: 9.35, y: -0.66), controlPoint2: CGPoint(x: 8.16, y: 0.51))
			linesTLBRPath.curve(to: CGPoint(x: 5, y: 1), controlPoint1: CGPoint(x: 6.47, y: 1.21), controlPoint2: CGPoint(x: 5.76, y: 1))
			linesTLBRPath.curve(to: CGPoint(x: 2.94, y: 1.57), controlPoint1: CGPoint(x: 4.25, y: 1), controlPoint2: CGPoint(x: 3.54, y: 1.21))
			linesTLBRPath.curve(to: CGPoint(x: 1, y: 5), controlPoint1: CGPoint(x: 1.78, y: 2.27), controlPoint2: CGPoint(x: 1, y: 3.54))
			linesTLBRPath.curve(to: CGPoint(x: 1.58, y: 7.08), controlPoint1: CGPoint(x: 1, y: 5.76), controlPoint2: CGPoint(x: 1.21, y: 6.47))
			linesTLBRPath.curve(to: CGPoint(x: 0.56, y: 8.1), controlPoint1: CGPoint(x: 1.22, y: 7.44), controlPoint2: CGPoint(x: 0.87, y: 7.79))
			linesTLBRPath.curve(to: CGPoint(x: -0.67, y: 9.33), controlPoint1: CGPoint(x: -0.15, y: 8.81), controlPoint2: CGPoint(x: -0.67, y: 9.33))
			linesTLBRPath.line(to: CGPoint(x: 0.74, y: 10.74))
			linesTLBRPath.close()
		}.flippedVertically(height: 10)

	// Triple arms

	static let templateTLTRBL =
		CGPath.make { linesTLTRBLPath in
			linesTLTRBLPath.move(to: CGPoint(x: 9.26, y: 10.74))
			linesTLTRBLPath.line(to: CGPoint(x: 10.67, y: 9.33))
			linesTLTRBLPath.curve(to: CGPoint(x: 8.42, y: 7.08), controlPoint1: CGPoint(x: 10.67, y: 9.33), controlPoint2: CGPoint(x: 9.6, y: 8.26))
			linesTLTRBLPath.curve(to: CGPoint(x: 9, y: 5), controlPoint1: CGPoint(x: 8.79, y: 6.47), controlPoint2: CGPoint(x: 9, y: 5.76))
			linesTLTRBLPath.curve(to: CGPoint(x: 5, y: 1), controlPoint1: CGPoint(x: 9, y: 2.79), controlPoint2: CGPoint(x: 7.21, y: 1))
			linesTLTRBLPath.curve(to: CGPoint(x: 2.96, y: 1.56), controlPoint1: CGPoint(x: 4.26, y: 1), controlPoint2: CGPoint(x: 3.56, y: 1.2))
			linesTLTRBLPath.curve(to: CGPoint(x: 0.77, y: -0.65), controlPoint1: CGPoint(x: 1.83, y: 0.41), controlPoint2: CGPoint(x: 0.77, y: -0.65))
			linesTLTRBLPath.curve(to: CGPoint(x: 0.06, y: 0.07), controlPoint1: CGPoint(x: 0.54, y: -0.42), controlPoint2: CGPoint(x: 0.3, y: -0.18))
			linesTLTRBLPath.curve(to: CGPoint(x: -0.65, y: 0.77), controlPoint1: CGPoint(x: -0.3, y: 0.42), controlPoint2: CGPoint(x: -0.65, y: 0.77))
			linesTLTRBLPath.curve(to: CGPoint(x: 1.55, y: 2.97), controlPoint1: CGPoint(x: -0.65, y: 0.77), controlPoint2: CGPoint(x: 0.41, y: 1.83))
			linesTLTRBLPath.curve(to: CGPoint(x: 1, y: 5), controlPoint1: CGPoint(x: 1.2, y: 3.56), controlPoint2: CGPoint(x: 1, y: 4.26))
			linesTLTRBLPath.curve(to: CGPoint(x: 1.58, y: 7.08), controlPoint1: CGPoint(x: 1, y: 5.76), controlPoint2: CGPoint(x: 1.21, y: 6.47))
			linesTLTRBLPath.curve(to: CGPoint(x: 0.56, y: 8.09), controlPoint1: CGPoint(x: 1.22, y: 7.43), controlPoint2: CGPoint(x: 0.87, y: 7.78))
			linesTLTRBLPath.curve(to: CGPoint(x: -0.67, y: 9.33), controlPoint1: CGPoint(x: -0.15, y: 8.81), controlPoint2: CGPoint(x: -0.67, y: 9.33))
			linesTLTRBLPath.line(to: CGPoint(x: 0.74, y: 10.74))
			linesTLTRBLPath.curve(to: CGPoint(x: 3.01, y: 8.47), controlPoint1: CGPoint(x: 0.74, y: 10.74), controlPoint2: CGPoint(x: 1.82, y: 9.66))
			linesTLTRBLPath.curve(to: CGPoint(x: 5, y: 9), controlPoint1: CGPoint(x: 3.6, y: 8.81), controlPoint2: CGPoint(x: 4.28, y: 9))
			linesTLTRBLPath.curve(to: CGPoint(x: 6.99, y: 8.47), controlPoint1: CGPoint(x: 5.72, y: 9), controlPoint2: CGPoint(x: 6.4, y: 8.81))
			linesTLTRBLPath.curve(to: CGPoint(x: 9.26, y: 10.74), controlPoint1: CGPoint(x: 8.18, y: 9.66), controlPoint2: CGPoint(x: 9.26, y: 10.74))
			linesTLTRBLPath.close()
		}.flippedVertically(height: 10)

	static let templateTLTRBR =
		CGPath.make { linesTLTRBRPath in
			linesTLTRBRPath.move(to: CGPoint(x: 9.26, y: 10.74))
			linesTLTRBRPath.curve(to: CGPoint(x: 10.67, y: 9.33), controlPoint1: CGPoint(x: 9.26, y: 10.74), controlPoint2: CGPoint(x: 10.67, y: 9.33))
			linesTLTRBRPath.curve(to: CGPoint(x: 8.42, y: 7.08), controlPoint1: CGPoint(x: 10.67, y: 9.33), controlPoint2: CGPoint(x: 9.6, y: 8.26))
			linesTLTRBRPath.curve(to: CGPoint(x: 9, y: 5), controlPoint1: CGPoint(x: 8.79, y: 6.47), controlPoint2: CGPoint(x: 9, y: 5.76))
			linesTLTRBRPath.curve(to: CGPoint(x: 8.47, y: 3.01), controlPoint1: CGPoint(x: 9, y: 4.28), controlPoint2: CGPoint(x: 8.81, y: 3.6))
			linesTLTRBRPath.curve(to: CGPoint(x: 10.75, y: 0.76), controlPoint1: CGPoint(x: 9.56, y: 1.94), controlPoint2: CGPoint(x: 10.75, y: 0.76))
			linesTLTRBRPath.line(to: CGPoint(x: 9.35, y: -0.66))
			linesTLTRBRPath.curve(to: CGPoint(x: 7.07, y: 1.58), controlPoint1: CGPoint(x: 9.35, y: -0.66), controlPoint2: CGPoint(x: 8.16, y: 0.51))
			linesTLTRBRPath.curve(to: CGPoint(x: 5, y: 1), controlPoint1: CGPoint(x: 6.47, y: 1.21), controlPoint2: CGPoint(x: 5.76, y: 1))
			linesTLTRBRPath.curve(to: CGPoint(x: 2.94, y: 1.57), controlPoint1: CGPoint(x: 4.25, y: 1), controlPoint2: CGPoint(x: 3.54, y: 1.21))
			linesTLTRBRPath.curve(to: CGPoint(x: 1, y: 5), controlPoint1: CGPoint(x: 1.78, y: 2.27), controlPoint2: CGPoint(x: 1, y: 3.54))
			linesTLTRBRPath.curve(to: CGPoint(x: 1.58, y: 7.08), controlPoint1: CGPoint(x: 1, y: 5.76), controlPoint2: CGPoint(x: 1.21, y: 6.47))
			linesTLTRBRPath.curve(to: CGPoint(x: 0.56, y: 8.09), controlPoint1: CGPoint(x: 1.22, y: 7.43), controlPoint2: CGPoint(x: 0.87, y: 7.78))
			linesTLTRBRPath.curve(to: CGPoint(x: -0.67, y: 9.33), controlPoint1: CGPoint(x: -0.15, y: 8.81), controlPoint2: CGPoint(x: -0.67, y: 9.33))
			linesTLTRBRPath.line(to: CGPoint(x: 0.74, y: 10.74))
			linesTLTRBRPath.curve(to: CGPoint(x: 3.01, y: 8.47), controlPoint1: CGPoint(x: 0.74, y: 10.74), controlPoint2: CGPoint(x: 1.82, y: 9.66))
			linesTLTRBRPath.curve(to: CGPoint(x: 5, y: 9), controlPoint1: CGPoint(x: 3.6, y: 8.81), controlPoint2: CGPoint(x: 4.28, y: 9))
			linesTLTRBRPath.curve(to: CGPoint(x: 6.99, y: 8.47), controlPoint1: CGPoint(x: 5.72, y: 9), controlPoint2: CGPoint(x: 6.4, y: 8.81))
			linesTLTRBRPath.curve(to: CGPoint(x: 9.26, y: 10.74), controlPoint1: CGPoint(x: 8.18, y: 9.66), controlPoint2: CGPoint(x: 9.26, y: 10.74))
			linesTLTRBRPath.line(to: CGPoint(x: 9.26, y: 10.74))
			linesTLTRBRPath.close()
		}.flippedVertically(height: 10)

	static let templateTRBLBR =
		CGPath.make { linesTRBLBRPath in
			linesTRBLBRPath.move(to: CGPoint(x: 9.26, y: 10.74))
			linesTRBLBRPath.line(to: CGPoint(x: 10.67, y: 9.33))
			linesTRBLBRPath.curve(to: CGPoint(x: 8.42, y: 7.08), controlPoint1: CGPoint(x: 10.67, y: 9.33), controlPoint2: CGPoint(x: 9.6, y: 8.26))
			linesTRBLBRPath.curve(to: CGPoint(x: 9, y: 5), controlPoint1: CGPoint(x: 8.79, y: 6.47), controlPoint2: CGPoint(x: 9, y: 5.76))
			linesTRBLBRPath.curve(to: CGPoint(x: 8.47, y: 3.01), controlPoint1: CGPoint(x: 9, y: 4.28), controlPoint2: CGPoint(x: 8.81, y: 3.6))
			linesTRBLBRPath.curve(to: CGPoint(x: 10.75, y: 0.76), controlPoint1: CGPoint(x: 9.56, y: 1.94), controlPoint2: CGPoint(x: 10.75, y: 0.76))
			linesTRBLBRPath.line(to: CGPoint(x: 9.35, y: -0.66))
			linesTRBLBRPath.curve(to: CGPoint(x: 7.07, y: 1.58), controlPoint1: CGPoint(x: 9.35, y: -0.66), controlPoint2: CGPoint(x: 8.16, y: 0.51))
			linesTRBLBRPath.curve(to: CGPoint(x: 5, y: 1), controlPoint1: CGPoint(x: 6.47, y: 1.21), controlPoint2: CGPoint(x: 5.76, y: 1))
			linesTRBLBRPath.curve(to: CGPoint(x: 2.97, y: 1.55), controlPoint1: CGPoint(x: 4.26, y: 1), controlPoint2: CGPoint(x: 3.56, y: 1.2))
			linesTRBLBRPath.curve(to: CGPoint(x: 0.77, y: -0.65), controlPoint1: CGPoint(x: 1.83, y: 0.41), controlPoint2: CGPoint(x: 0.77, y: -0.65))
			linesTRBLBRPath.curve(to: CGPoint(x: 0.07, y: 0.05), controlPoint1: CGPoint(x: 0.77, y: -0.65), controlPoint2: CGPoint(x: 0.42, y: -0.3))
			linesTRBLBRPath.curve(to: CGPoint(x: -0.65, y: 0.77), controlPoint1: CGPoint(x: -0.29, y: 0.41), controlPoint2: CGPoint(x: -0.65, y: 0.77))
			linesTRBLBRPath.curve(to: CGPoint(x: 1.55, y: 2.97), controlPoint1: CGPoint(x: -0.65, y: 0.77), controlPoint2: CGPoint(x: 0.41, y: 1.83))
			linesTRBLBRPath.curve(to: CGPoint(x: 1, y: 5), controlPoint1: CGPoint(x: 1.2, y: 3.56), controlPoint2: CGPoint(x: 1, y: 4.26))
			linesTRBLBRPath.curve(to: CGPoint(x: 5, y: 9), controlPoint1: CGPoint(x: 1, y: 7.21), controlPoint2: CGPoint(x: 2.79, y: 9))
			linesTRBLBRPath.curve(to: CGPoint(x: 6.99, y: 8.47), controlPoint1: CGPoint(x: 5.72, y: 9), controlPoint2: CGPoint(x: 6.4, y: 8.81))
			linesTRBLBRPath.curve(to: CGPoint(x: 9.26, y: 10.74), controlPoint1: CGPoint(x: 8.18, y: 9.66), controlPoint2: CGPoint(x: 9.26, y: 10.74))
			linesTRBLBRPath.close()
		}.flippedVertically(height: 10)

	static let templateTLBLBR =
		CGPath.make { linesTLBLBRPath in
			linesTLBLBRPath.move(to: CGPoint(x: 0.74, y: 10.74))
			linesTLBLBRPath.curve(to: CGPoint(x: 3.01, y: 8.47), controlPoint1: CGPoint(x: 0.74, y: 10.74), controlPoint2: CGPoint(x: 1.82, y: 9.66))
			linesTLBLBRPath.curve(to: CGPoint(x: 5, y: 9), controlPoint1: CGPoint(x: 3.6, y: 8.81), controlPoint2: CGPoint(x: 4.28, y: 9))
			linesTLBLBRPath.curve(to: CGPoint(x: 9, y: 5), controlPoint1: CGPoint(x: 7.21, y: 9), controlPoint2: CGPoint(x: 9, y: 7.21))
			linesTLBLBRPath.curve(to: CGPoint(x: 8.47, y: 3.01), controlPoint1: CGPoint(x: 9, y: 4.28), controlPoint2: CGPoint(x: 8.81, y: 3.6))
			linesTLBLBRPath.curve(to: CGPoint(x: 10.75, y: 0.76), controlPoint1: CGPoint(x: 9.56, y: 1.94), controlPoint2: CGPoint(x: 10.75, y: 0.76))
			linesTLBLBRPath.line(to: CGPoint(x: 9.35, y: -0.66))
			linesTLBLBRPath.curve(to: CGPoint(x: 7.07, y: 1.58), controlPoint1: CGPoint(x: 9.35, y: -0.66), controlPoint2: CGPoint(x: 8.16, y: 0.51))
			linesTLBLBRPath.curve(to: CGPoint(x: 5, y: 1), controlPoint1: CGPoint(x: 6.47, y: 1.21), controlPoint2: CGPoint(x: 5.76, y: 1))
			linesTLBLBRPath.curve(to: CGPoint(x: 2.97, y: 1.55), controlPoint1: CGPoint(x: 4.26, y: 1), controlPoint2: CGPoint(x: 3.56, y: 1.2))
			linesTLBLBRPath.curve(to: CGPoint(x: 0.77, y: -0.65), controlPoint1: CGPoint(x: 1.83, y: 0.41), controlPoint2: CGPoint(x: 0.77, y: -0.65))
			linesTLBLBRPath.curve(to: CGPoint(x: 0.05, y: 0.07), controlPoint1: CGPoint(x: 0.54, y: -0.42), controlPoint2: CGPoint(x: 0.3, y: -0.18))
			linesTLBLBRPath.line(to: CGPoint(x: 0.01, y: 0.11))
			linesTLBLBRPath.curve(to: CGPoint(x: -0.65, y: 0.77), controlPoint1: CGPoint(x: -0.33, y: 0.45), controlPoint2: CGPoint(x: -0.65, y: 0.77))
			linesTLBLBRPath.curve(to: CGPoint(x: 0.11, y: 1.52), controlPoint1: CGPoint(x: -0.65, y: 0.77), controlPoint2: CGPoint(x: -0.35, y: 1.07))
			linesTLBLBRPath.curve(to: CGPoint(x: 1.55, y: 2.97), controlPoint1: CGPoint(x: 0.5, y: 1.92), controlPoint2: CGPoint(x: 1.02, y: 2.43))
			linesTLBLBRPath.curve(to: CGPoint(x: 1, y: 5), controlPoint1: CGPoint(x: 1.2, y: 3.56), controlPoint2: CGPoint(x: 1, y: 4.26))
			linesTLBLBRPath.curve(to: CGPoint(x: 1.58, y: 7.08), controlPoint1: CGPoint(x: 1, y: 5.76), controlPoint2: CGPoint(x: 1.21, y: 6.47))
			linesTLBLBRPath.curve(to: CGPoint(x: 0.56, y: 8.09), controlPoint1: CGPoint(x: 1.22, y: 7.43), controlPoint2: CGPoint(x: 0.87, y: 7.78))
			linesTLBLBRPath.curve(to: CGPoint(x: -0.67, y: 9.33), controlPoint1: CGPoint(x: -0.15, y: 8.81), controlPoint2: CGPoint(x: -0.67, y: 9.33))
			linesTLBLBRPath.line(to: CGPoint(x: 0.74, y: 10.74))
			linesTLBLBRPath.close()
		}.flippedVertically(height: 10)


	static let templateAll =
		CGPath.make { linesALLPath in
			linesALLPath.move(to: CGPoint(x: 9.26, y: 10.74))
			linesALLPath.line(to: CGPoint(x: 10.67, y: 9.33))
			linesALLPath.curve(to: CGPoint(x: 8.42, y: 7.08), controlPoint1: CGPoint(x: 10.67, y: 9.33), controlPoint2: CGPoint(x: 9.6, y: 8.26))
			linesALLPath.curve(to: CGPoint(x: 9, y: 5), controlPoint1: CGPoint(x: 8.79, y: 6.47), controlPoint2: CGPoint(x: 9, y: 5.76))
			linesALLPath.curve(to: CGPoint(x: 8.47, y: 3.01), controlPoint1: CGPoint(x: 9, y: 4.28), controlPoint2: CGPoint(x: 8.81, y: 3.6))
			linesALLPath.curve(to: CGPoint(x: 10.75, y: 0.76), controlPoint1: CGPoint(x: 9.56, y: 1.94), controlPoint2: CGPoint(x: 10.75, y: 0.76))
			linesALLPath.line(to: CGPoint(x: 9.35, y: -0.66))
			linesALLPath.curve(to: CGPoint(x: 7.07, y: 1.58), controlPoint1: CGPoint(x: 9.35, y: -0.66), controlPoint2: CGPoint(x: 8.16, y: 0.51))
			linesALLPath.curve(to: CGPoint(x: 5, y: 1), controlPoint1: CGPoint(x: 6.47, y: 1.21), controlPoint2: CGPoint(x: 5.76, y: 1))
			linesALLPath.curve(to: CGPoint(x: 2.96, y: 1.56), controlPoint1: CGPoint(x: 4.26, y: 1), controlPoint2: CGPoint(x: 3.56, y: 1.2))
			linesALLPath.curve(to: CGPoint(x: 0.77, y: -0.65), controlPoint1: CGPoint(x: 1.83, y: 0.41), controlPoint2: CGPoint(x: 0.77, y: -0.65))
			linesALLPath.curve(to: CGPoint(x: 0.06, y: 0.07), controlPoint1: CGPoint(x: 0.54, y: -0.42), controlPoint2: CGPoint(x: 0.3, y: -0.18))
			linesALLPath.curve(to: CGPoint(x: -0.65, y: 0.77), controlPoint1: CGPoint(x: -0.3, y: 0.42), controlPoint2: CGPoint(x: -0.65, y: 0.77))
			linesALLPath.curve(to: CGPoint(x: 1.55, y: 2.97), controlPoint1: CGPoint(x: -0.65, y: 0.77), controlPoint2: CGPoint(x: 0.41, y: 1.83))
			linesALLPath.curve(to: CGPoint(x: 1, y: 5), controlPoint1: CGPoint(x: 1.2, y: 3.56), controlPoint2: CGPoint(x: 1, y: 4.26))
			linesALLPath.curve(to: CGPoint(x: 1.58, y: 7.08), controlPoint1: CGPoint(x: 1, y: 5.76), controlPoint2: CGPoint(x: 1.21, y: 6.47))
			linesALLPath.curve(to: CGPoint(x: 0.56, y: 8.1), controlPoint1: CGPoint(x: 1.22, y: 7.44), controlPoint2: CGPoint(x: 0.87, y: 7.79))
			linesALLPath.curve(to: CGPoint(x: -0.67, y: 9.33), controlPoint1: CGPoint(x: -0.15, y: 8.81), controlPoint2: CGPoint(x: -0.67, y: 9.33))
			linesALLPath.line(to: CGPoint(x: 0.74, y: 10.74))
			linesALLPath.curve(to: CGPoint(x: 2.29, y: 9.2), controlPoint1: CGPoint(x: 0.74, y: 10.74), controlPoint2: CGPoint(x: 1.42, y: 10.07))
			linesALLPath.curve(to: CGPoint(x: 3.01, y: 8.47), controlPoint1: CGPoint(x: 2.52, y: 8.97), controlPoint2: CGPoint(x: 2.76, y: 8.72))
			linesALLPath.curve(to: CGPoint(x: 5, y: 9), controlPoint1: CGPoint(x: 3.6, y: 8.81), controlPoint2: CGPoint(x: 4.28, y: 9))
			linesALLPath.curve(to: CGPoint(x: 6.99, y: 8.47), controlPoint1: CGPoint(x: 5.72, y: 9), controlPoint2: CGPoint(x: 6.4, y: 8.81))
			linesALLPath.curve(to: CGPoint(x: 9.26, y: 10.74), controlPoint1: CGPoint(x: 8.18, y: 9.66), controlPoint2: CGPoint(x: 9.26, y: 10.74))
			linesALLPath.close()
		}.flippedVertically(height: 10)
}
