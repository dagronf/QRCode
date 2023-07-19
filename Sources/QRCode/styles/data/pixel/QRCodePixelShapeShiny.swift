//
//  QRCodePixelShapeShiny.swift
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
	/// A star pixel shape
	@objc(QRCodePixelShapeShiny) class Shiny: NSObject, QRCodePixelShapeGenerator {
		/// The generator name
		@objc public static let Name: String = "shiny"
		/// The generator title
		@objc public static var Title: String { "Shiny" }

		/// Create an instance of this path generator with the specified settings
		@objc public static func Create(_ settings: [String: Any]?) -> QRCodePixelShapeGenerator {
			return Shiny()
		}

		/// Make a copy of the object
		@objc public func copyShape() -> QRCodePixelShapeGenerator {
			return Shiny()
		}

		@objc public override init() {
			self.common = CommonPixelGenerator(pixelType: .shiny)
			super.init()
		}

		/// Generate a CGPath from the matrix contents
		/// - Parameters:
		///   - matrix: The matrix to generate
		///   - size: The size of the resulting CGPath
		/// - Returns: A path
		public func generatePath(from matrix: BoolMatrix, size: CGSize) -> CGPath {
			common.generatePath(from: matrix, size: size)
		}

		// A 10x10 'pixel' representation of a star pixel
		static func pathShiny(row: Int, col: Int) -> CGPath {
			if row.isOdd && col.isOdd || col.isEven && row.isEven {
				let oddpathPath = CGMutablePath()
				oddpathPath.move(to: CGPoint(x: 1.47, y: 5.88))
				oddpathPath.curve(to: CGPoint(x: 1.47, y: 4.12), controlPoint1: CGPoint(x: 0.98, y: 5.4), controlPoint2: CGPoint(x: 0.98, y: 4.6))
				oddpathPath.line(to: CGPoint(x: 4.12, y: 1.47))
				oddpathPath.curve(to: CGPoint(x: 5.88, y: 1.47), controlPoint1: CGPoint(x: 4.6, y: 0.98), controlPoint2: CGPoint(x: 5.4, y: 0.98))
				oddpathPath.line(to: CGPoint(x: 8.53, y: 4.12))
				oddpathPath.curve(to: CGPoint(x: 8.53, y: 5.88), controlPoint1: CGPoint(x: 9.02, y: 4.6), controlPoint2: CGPoint(x: 9.02, y: 5.4))
				oddpathPath.line(to: CGPoint(x: 5.88, y: 8.53))
				oddpathPath.curve(to: CGPoint(x: 4.12, y: 8.53), controlPoint1: CGPoint(x: 5.4, y: 9.02), controlPoint2: CGPoint(x: 4.6, y: 9.02))
				oddpathPath.line(to: CGPoint(x: 1.47, y: 5.88))
				oddpathPath.close()
				return oddpathPath
			}
			else {
				let evenpathPath = CGMutablePath()
				evenpathPath.move(to: CGPoint(x: 3, y: 5))
				evenpathPath.curve(to: CGPoint(x: 0, y: 0), controlPoint1: CGPoint(x: 3, y: 3.33), controlPoint2: CGPoint(x: 0, y: 0))
				evenpathPath.curve(to: CGPoint(x: 5, y: 3), controlPoint1: CGPoint(x: 0, y: 0), controlPoint2: CGPoint(x: 3.33, y: 3))
				evenpathPath.curve(to: CGPoint(x: 10, y: 0), controlPoint1: CGPoint(x: 6.67, y: 3), controlPoint2: CGPoint(x: 10, y: 0))
				evenpathPath.curve(to: CGPoint(x: 7, y: 5), controlPoint1: CGPoint(x: 10, y: 0), controlPoint2: CGPoint(x: 7, y: 3.33))
				evenpathPath.curve(to: CGPoint(x: 10, y: 10), controlPoint1: CGPoint(x: 7, y: 6.67), controlPoint2: CGPoint(x: 10, y: 10))
				evenpathPath.curve(to: CGPoint(x: 5, y: 7), controlPoint1: CGPoint(x: 10, y: 10), controlPoint2: CGPoint(x: 6.67, y: 7))
				evenpathPath.curve(to: CGPoint(x: 0, y: 10), controlPoint1: CGPoint(x: 3.33, y: 7), controlPoint2: CGPoint(x: 0, y: 10))
				evenpathPath.curve(to: CGPoint(x: 3, y: 5), controlPoint1: CGPoint(x: 0, y: 10), controlPoint2: CGPoint(x: 3, y: 6.67))
				evenpathPath.close()
				return evenpathPath
			}
		}

		private let common: CommonPixelGenerator
	}
}

// MARK: - Settings

public extension QRCode.PixelShape.Shiny {
	/// Returns true if the shape supports setting a value for the specified key, false otherwise
	@objc func supportsSettingValue(forKey key: String) -> Bool { false }

	/// Returns the current settings for the shape
	@objc func settings() -> [String : Any] { [:] }

	/// Set a configuration value for a particular setting string
	@objc func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }
}
