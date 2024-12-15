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

// MARK: - 2x2 Grid

public extension QRCode.PixelShape {
	@objc(QRCodePixelShapeGrid2x2) class Grid2x2: NSObject, QRCodePixelShapeGenerator {
		/// The generator name
		@objc public static let Name: String = "grid2x2"
		/// The generator title
		@objc public static var Title: String { "2x2 Square Grid" }
		/// This pupil generator can be used when generating eye and pupil shapes
		@objc public var canGenerateEyeAndPupilShapes: Bool { true }
		/// Create an instance of this path generator with the specified settings
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodePixelShapeGenerator {
			QRCode.PixelShape.Grid2x2()
		}
		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePixelShapeGenerator { Grid2x2() }
		/// Does the shape generator support setting values for a particular key?
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		/// Returns a storable representation of the shape handler
		@objc public func settings() -> [String: Any] { [:] }
		/// Reset
		@objc public func reset() { }
		/// Set a configuration value for a particular setting string
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }
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
			let w = _templateSize.width
			let scaleTransform = CGAffineTransform(scaleX: dm / w, y: dm / w)

			let path = CGMutablePath()

			for row in 0 ..< matrix.dimension {
				for col in 0 ..< matrix.dimension {
					guard matrix[row, col] == true else { continue }
					let translate = CGAffineTransform(translationX: CGFloat(col) * dm + xoff, y: CGFloat(row) * dm + yoff)
					path.addPath(_2x2template, transform: scaleTransform.concatenating(translate))
				}
			}
			return path
		}
	}
}

private let _2x2template: CGPath = {
	CGPath.make { bezierPath in
		bezierPath.move(to: NSPoint(x: 0.5, y: 0))
		bezierPath.line(to: NSPoint(x: 5, y: 0))
		bezierPath.line(to: NSPoint(x: 5, y: 4.5))
		bezierPath.line(to: NSPoint(x: 0.5, y: 4.5))
		bezierPath.line(to: NSPoint(x: 0.5, y: 0))
		bezierPath.close()
		bezierPath.move(to: NSPoint(x: 5.5, y: 0))
		bezierPath.line(to: NSPoint(x: 10, y: 0))
		bezierPath.line(to: NSPoint(x: 10, y: 4.5))
		bezierPath.line(to: NSPoint(x: 5.5, y: 4.5))
		bezierPath.line(to: NSPoint(x: 5.5, y: 0))
		bezierPath.close()
		bezierPath.move(to: NSPoint(x: 0.5, y: 5))
		bezierPath.line(to: NSPoint(x: 5, y: 5))
		bezierPath.line(to: NSPoint(x: 5, y: 9.5))
		bezierPath.line(to: NSPoint(x: 0.5, y: 9.5))
		bezierPath.line(to: NSPoint(x: 0.5, y: 5))
		bezierPath.close()
		bezierPath.move(to: NSPoint(x: 5.5, y: 5))
		bezierPath.line(to: NSPoint(x: 10, y: 5))
		bezierPath.line(to: NSPoint(x: 10, y: 9.5))
		bezierPath.line(to: NSPoint(x: 5.5, y: 9.5))
		bezierPath.line(to: NSPoint(x: 5.5, y: 5))
		bezierPath.close()
	}
}()

// MARK: - 3x3

public extension QRCode.PixelShape {
	@objc(QRCodePixelShapeGrid3x3) class Grid3x3: NSObject, QRCodePixelShapeGenerator {
		/// The generator name
		@objc public static let Name: String = "grid3x3"
		/// The generator title
		@objc public static var Title: String { "3x3 Square Grid" }
		/// This pupil generator can be used when generating eye and pupil shapes
		@objc public var canGenerateEyeAndPupilShapes: Bool { true }
		/// Create an instance of this path generator with the specified settings
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodePixelShapeGenerator {
			QRCode.PixelShape.Grid3x3()
		}
		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePixelShapeGenerator { Grid3x3() }
		/// Does the shape generator support setting values for a particular key?
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		/// Returns a storable representation of the shape handler
		@objc public func settings() -> [String: Any] { [:] }
		/// Set a configuration value for a particular setting string
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }
		/// Reset
		@objc public func reset() { }
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
			let w = _templateSize.width
			let scaleTransform = CGAffineTransform(scaleX: dm / w, y: dm / w)

			let path = CGMutablePath()

			for row in 0 ..< matrix.dimension {
				for col in 0 ..< matrix.dimension {
					guard matrix[row, col] == true else { continue }
					let translate = CGAffineTransform(translationX: CGFloat(col) * dm + xoff, y: CGFloat(row) * dm + yoff)
					path.addPath(_3x3template, transform: scaleTransform.concatenating(translate))
				}
			}
			return path
		}
	}
}

private let _3x3template: CGPath = {
	CGPath.make { bezierPath in
		bezierPath.move(to: NSPoint(x: 0.33, y: 0))
		bezierPath.line(to: NSPoint(x: 3.33, y: 0))
		bezierPath.line(to: NSPoint(x: 3.33, y: 3))
		bezierPath.line(to: NSPoint(x: 0.33, y: 3))
		bezierPath.line(to: NSPoint(x: 0.33, y: 0))
		bezierPath.close()
		bezierPath.move(to: NSPoint(x: 0.33, y: 3.33))
		bezierPath.line(to: NSPoint(x: 3.33, y: 3.33))
		bezierPath.line(to: NSPoint(x: 3.33, y: 6.33))
		bezierPath.line(to: NSPoint(x: 0.33, y: 6.33))
		bezierPath.line(to: NSPoint(x: 0.33, y: 3.33))
		bezierPath.close()
		bezierPath.move(to: NSPoint(x: 0.33, y: 6.66))
		bezierPath.line(to: NSPoint(x: 3.33, y: 6.66))
		bezierPath.line(to: NSPoint(x: 3.33, y: 9.66))
		bezierPath.line(to: NSPoint(x: 0.33, y: 9.66))
		bezierPath.line(to: NSPoint(x: 0.33, y: 6.66))
		bezierPath.close()
		bezierPath.move(to: NSPoint(x: 3.66, y: 0))
		bezierPath.line(to: NSPoint(x: 6.66, y: 0))
		bezierPath.line(to: NSPoint(x: 6.66, y: 3))
		bezierPath.line(to: NSPoint(x: 3.66, y: 3))
		bezierPath.line(to: NSPoint(x: 3.66, y: 0))
		bezierPath.close()
		bezierPath.move(to: NSPoint(x: 3.66, y: 3.33))
		bezierPath.line(to: NSPoint(x: 6.66, y: 3.33))
		bezierPath.line(to: NSPoint(x: 6.66, y: 6.33))
		bezierPath.line(to: NSPoint(x: 3.66, y: 6.33))
		bezierPath.line(to: NSPoint(x: 3.66, y: 3.33))
		bezierPath.close()
		bezierPath.move(to: NSPoint(x: 3.66, y: 6.66))
		bezierPath.line(to: NSPoint(x: 6.66, y: 6.66))
		bezierPath.line(to: NSPoint(x: 6.66, y: 9.66))
		bezierPath.line(to: NSPoint(x: 3.66, y: 9.66))
		bezierPath.line(to: NSPoint(x: 3.66, y: 6.66))
		bezierPath.close()
		bezierPath.move(to: NSPoint(x: 6.99, y: 0))
		bezierPath.line(to: NSPoint(x: 9.99, y: 0))
		bezierPath.line(to: NSPoint(x: 9.99, y: 3))
		bezierPath.line(to: NSPoint(x: 6.99, y: 3))
		bezierPath.line(to: NSPoint(x: 6.99, y: 0))
		bezierPath.close()
		bezierPath.move(to: NSPoint(x: 6.99, y: 3.33))
		bezierPath.line(to: NSPoint(x: 9.99, y: 3.33))
		bezierPath.line(to: NSPoint(x: 9.99, y: 6.33))
		bezierPath.line(to: NSPoint(x: 6.99, y: 6.33))
		bezierPath.line(to: NSPoint(x: 6.99, y: 3.33))
		bezierPath.close()
		bezierPath.move(to: NSPoint(x: 6.99, y: 6.66))
		bezierPath.line(to: NSPoint(x: 9.99, y: 6.66))
		bezierPath.line(to: NSPoint(x: 9.99, y: 9.66))
		bezierPath.line(to: NSPoint(x: 6.99, y: 9.66))
		bezierPath.line(to: NSPoint(x: 6.99, y: 6.66))
		bezierPath.close()
	}
}()

// MARK: - 4x4

public extension QRCode.PixelShape {
	@objc(QRCodePixelShapeGrid4x4) class Grid4x4: NSObject, QRCodePixelShapeGenerator {
		/// The generator name
		@objc public static let Name: String = "grid4x4"
		/// The generator title
		@objc public static var Title: String { "4x4 Square Grid" }
		/// This pupil generator can be used when generating eye and pupil shapes
		@objc public var canGenerateEyeAndPupilShapes: Bool { true }
		/// Create an instance of this path generator with the specified settings
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodePixelShapeGenerator {
			QRCode.PixelShape.Grid4x4()
		}
		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePixelShapeGenerator { Grid4x4() }
		/// Does the shape generator support setting values for a particular key?
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		/// Returns a storable representation of the shape handler
		@objc public func settings() -> [String: Any] { [:] }
		/// Set a configuration value for a particular setting string
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }
		/// Reset
		@objc public func reset() { }
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
			let w = _templateSize.width
			let scaleTransform = CGAffineTransform(scaleX: dm / w, y: dm / w)

			let path = CGMutablePath()

			for row in 0 ..< matrix.dimension {
				for col in 0 ..< matrix.dimension {
					guard matrix[row, col] == true else { continue }
					let translate = CGAffineTransform(translationX: CGFloat(col) * dm + xoff, y: CGFloat(row) * dm + yoff)
					path.addPath(_4x4template, transform: scaleTransform.concatenating(translate))
				}
			}
			return path
		}
	}
}

private let _4x4template: CGPath = {
	CGPath.make { bezierPath in
		bezierPath.move(to: NSPoint(x: 5.25, y: 0.25))
		bezierPath.line(to: NSPoint(x: 7.5, y: 0.25))
		bezierPath.line(to: NSPoint(x: 7.5, y: 2.5))
		bezierPath.line(to: NSPoint(x: 5.25, y: 2.5))
		bezierPath.line(to: NSPoint(x: 5.25, y: 0.25))
		bezierPath.close()
		bezierPath.move(to: NSPoint(x: 7.75, y: 0.25))
		bezierPath.line(to: NSPoint(x: 10, y: 0.25))
		bezierPath.line(to: NSPoint(x: 10, y: 2.5))
		bezierPath.line(to: NSPoint(x: 7.75, y: 2.5))
		bezierPath.line(to: NSPoint(x: 7.75, y: 0.25))
		bezierPath.close()
		bezierPath.move(to: NSPoint(x: 5.25, y: 2.75))
		bezierPath.line(to: NSPoint(x: 7.5, y: 2.75))
		bezierPath.line(to: NSPoint(x: 7.5, y: 5))
		bezierPath.line(to: NSPoint(x: 5.25, y: 5))
		bezierPath.line(to: NSPoint(x: 5.25, y: 2.75))
		bezierPath.close()
		bezierPath.move(to: NSPoint(x: 7.75, y: 2.75))
		bezierPath.line(to: NSPoint(x: 10, y: 2.75))
		bezierPath.line(to: NSPoint(x: 10, y: 5))
		bezierPath.line(to: NSPoint(x: 7.75, y: 5))
		bezierPath.line(to: NSPoint(x: 7.75, y: 2.75))
		bezierPath.close()
		bezierPath.move(to: NSPoint(x: 0.25, y: 0.25))
		bezierPath.line(to: NSPoint(x: 2.5, y: 0.25))
		bezierPath.line(to: NSPoint(x: 2.5, y: 2.5))
		bezierPath.line(to: NSPoint(x: 0.25, y: 2.5))
		bezierPath.line(to: NSPoint(x: 0.25, y: 0.25))
		bezierPath.close()
		bezierPath.move(to: NSPoint(x: 2.75, y: 0.25))
		bezierPath.line(to: NSPoint(x: 5, y: 0.25))
		bezierPath.line(to: NSPoint(x: 5, y: 2.5))
		bezierPath.line(to: NSPoint(x: 2.75, y: 2.5))
		bezierPath.line(to: NSPoint(x: 2.75, y: 0.25))
		bezierPath.close()
		bezierPath.move(to: NSPoint(x: 0.25, y: 2.75))
		bezierPath.line(to: NSPoint(x: 2.5, y: 2.75))
		bezierPath.line(to: NSPoint(x: 2.5, y: 5))
		bezierPath.line(to: NSPoint(x: 0.25, y: 5))
		bezierPath.line(to: NSPoint(x: 0.25, y: 2.75))
		bezierPath.close()
		bezierPath.move(to: NSPoint(x: 2.75, y: 2.75))
		bezierPath.line(to: NSPoint(x: 5, y: 2.75))
		bezierPath.line(to: NSPoint(x: 5, y: 5))
		bezierPath.line(to: NSPoint(x: 2.75, y: 5))
		bezierPath.line(to: NSPoint(x: 2.75, y: 2.75))
		bezierPath.close()
		bezierPath.move(to: NSPoint(x: 5.25, y: 5.25))
		bezierPath.line(to: NSPoint(x: 7.5, y: 5.25))
		bezierPath.line(to: NSPoint(x: 7.5, y: 7.5))
		bezierPath.line(to: NSPoint(x: 5.25, y: 7.5))
		bezierPath.line(to: NSPoint(x: 5.25, y: 5.25))
		bezierPath.close()
		bezierPath.move(to: NSPoint(x: 7.75, y: 5.25))
		bezierPath.line(to: NSPoint(x: 10, y: 5.25))
		bezierPath.line(to: NSPoint(x: 10, y: 7.5))
		bezierPath.line(to: NSPoint(x: 7.75, y: 7.5))
		bezierPath.line(to: NSPoint(x: 7.75, y: 5.25))
		bezierPath.close()
		bezierPath.move(to: NSPoint(x: 5.25, y: 7.75))
		bezierPath.line(to: NSPoint(x: 7.5, y: 7.75))
		bezierPath.line(to: NSPoint(x: 7.5, y: 10))
		bezierPath.line(to: NSPoint(x: 5.25, y: 10))
		bezierPath.line(to: NSPoint(x: 5.25, y: 7.75))
		bezierPath.close()
		bezierPath.move(to: NSPoint(x: 7.75, y: 7.75))
		bezierPath.line(to: NSPoint(x: 10, y: 7.75))
		bezierPath.line(to: NSPoint(x: 10, y: 10))
		bezierPath.line(to: NSPoint(x: 7.75, y: 10))
		bezierPath.line(to: NSPoint(x: 7.75, y: 7.75))
		bezierPath.close()
		bezierPath.move(to: NSPoint(x: 0.25, y: 5.25))
		bezierPath.line(to: NSPoint(x: 2.5, y: 5.25))
		bezierPath.line(to: NSPoint(x: 2.5, y: 7.5))
		bezierPath.line(to: NSPoint(x: 0.25, y: 7.5))
		bezierPath.line(to: NSPoint(x: 0.25, y: 5.25))
		bezierPath.close()
		bezierPath.move(to: NSPoint(x: 2.75, y: 5.25))
		bezierPath.line(to: NSPoint(x: 5, y: 5.25))
		bezierPath.line(to: NSPoint(x: 5, y: 7.5))
		bezierPath.line(to: NSPoint(x: 2.75, y: 7.5))
		bezierPath.line(to: NSPoint(x: 2.75, y: 5.25))
		bezierPath.close()
		bezierPath.move(to: NSPoint(x: 0.25, y: 7.75))
		bezierPath.line(to: NSPoint(x: 2.5, y: 7.75))
		bezierPath.line(to: NSPoint(x: 2.5, y: 10))
		bezierPath.line(to: NSPoint(x: 0.25, y: 10))
		bezierPath.line(to: NSPoint(x: 0.25, y: 7.75))
		bezierPath.close()
		bezierPath.move(to: NSPoint(x: 2.75, y: 7.75))
		bezierPath.line(to: NSPoint(x: 5, y: 7.75))
		bezierPath.line(to: NSPoint(x: 5, y: 10))
		bezierPath.line(to: NSPoint(x: 2.75, y: 10))
		bezierPath.line(to: NSPoint(x: 2.75, y: 7.75))
		bezierPath.closeSubpath()
	}
}()

//public extension QRCode.PixelShape {
//	@objc(QRCodePixelShapeFourSquare) class FourSquare: NSObject, QRCodePixelShapeGenerator {
//
//		@objc(QRCodePixelShapeFourSquareType)
//		public enum FourSquareType: Int {
//			case two = 0
//			case three = 1
//			case four = 2
//		}
//
//		/// The generator name
//		@objc public static let Name: String = "fourSquare"
//		/// The generator title
//		@objc public static var Title: String { "FourSquare" }
//
//		/// This pupil generator can be used when generating eye and pupil shapes
//		@objc public var canGenerateEyeAndPupilShapes: Bool { true }
//
//		/// Create an instance of this path generator with the specified settings
//		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodePixelShapeGenerator {
//			QRCode.PixelShape.FourSquare()
//		}
//
//		/// Reset the generator back to defaults
//		@objc public func reset() {
//			self.type = .two
//		}
//
//		/// Make a copy of the object
//		@objc public func copyShape() -> any QRCodePixelShapeGenerator { FourSquare() }
//
//		/// The number of squares on one side of the pixel
//		@objc public var type: FourSquareType = .two
//	}
//}
//
//
//
//public extension QRCode.PixelShape.FourSquare {
//	/// Generate a CGPath from the matrix contents
//	/// - Parameters:
//	///   - matrix: The matrix to generate
//	///   - size: The size of the resulting CGPath
//	/// - Returns: A path
//	@objc func generatePath(from matrix: BoolMatrix, size: CGSize) -> CGPath {
//		let dx = size.width / CGFloat(matrix.dimension)
//		let dy = size.height / CGFloat(matrix.dimension)
//		let dm = min(dx, dy)
//
//		let xoff = (size.width - (CGFloat(matrix.dimension) * dm)) / 2.0
//		let yoff = (size.height - (CGFloat(matrix.dimension) * dm)) / 2.0
//
//		// The scale required to convert our template paths to output path size
//		let w = _templateSize.width
//		let scaleTransform = CGAffineTransform(scaleX: dm / w, y: dm / w)
//
//		let path = CGMutablePath()
//
//		for row in 0 ..< matrix.dimension {
//			for col in 0 ..< matrix.dimension {
//				guard matrix[row, col] == true else { continue }
//
//				let translate = CGAffineTransform(translationX: CGFloat(col) * dm + xoff, y: CGFloat(row) * dm + yoff)
//
//				let pth: CGPath = {
//					switch self.type {
//					case .two: return _2x2template
//					case .three: return _3x3template
//					case .four: return _4x4template
//					}
//				}()
//
//				path.addPath(pth, transform: scaleTransform.concatenating(translate))
//			}
//		}
//		return path
//	}
//}
//
//// MARK: - Settings
//
//public extension QRCode.PixelShape.FourSquare {
//	/// Does the shape generator support setting values for a particular key?
//	@objc func supportsSettingValue(forKey key: String) -> Bool {
//		key == QRCode.SettingsKey.dimension
//	}
//
//	/// Returns a storable representation of the shape handler
//	@objc func settings() -> [String: Any] {
//		[QRCode.SettingsKey.dimension: self.type.rawValue]
//	}
//
//	/// Set a configuration value for a particular setting string
//	@objc func setSettingValue(_ value: Any?, forKey key: String) -> Bool {
//		if key == QRCode.SettingsKey.dimension,
//			let value = IntValue(value),
//			let type = QRCode.PixelShape.FourSquare.FourSquareType(rawValue: value)
//		{
//			self.type = type
//			return true
//		}
//		return false
//	}
//}
//
//// MARK: - Pixel creation conveniences
//
//public extension QRCodePixelShapeGenerator where Self == QRCode.PixelShape.FourSquare {
//	/// Create a four square pixel generator
//	/// - Returns: A pixel generator
//	@inlinable static func fourSquare() -> QRCodePixelShapeGenerator {
//		QRCode.PixelShape.FourSquare()
//	}
//}
//
//
////////////


// The template pixel generator size is 10x10
private let _templateSize = CGSize(width: 10, height: 10)





