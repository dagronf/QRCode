//
//  QRCodePixelShapeSquare.swift
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
	/// A square pixel shape
	@objc(QRCodePixelShapeSquare) class Square: NSObject, QRCodePixelShapeGenerator {
		/// The generator name
		@objc public static let Name: String = "square"

		/// Create
		/// - Parameters:
		///   - insetFraction: The inset between each pixel
		///   - randomInsetSizing: If true, chooses a random inset value (between 0.0 -> `insetFraction`) for each pixel
		///   - rotationFraction: The rotation to apply to each pixel (0.0 -> 1.0)
		@objc public init(
			insetFraction: CGFloat = 0,
			randomInsetSizing: Bool = false,
			rotationFraction: CGFloat = 0
		) {
			self.common = CommonPixelGenerator(
				pixelType: .square,
				insetFraction: insetFraction,
				randomInsetSizing: randomInsetSizing,
				rotationFraction: rotationFraction
			)
			super.init()
		}

		/// Create an instance of this path generator with the specified settings
		@objc public static func Create(_ settings: [String: Any]?) -> QRCodePixelShapeGenerator {
			let insetFraction = DoubleValue(settings?[QRCode.SettingsKey.insetFraction, default: 0]) ?? 0
			let randomInsetSizing = BoolValue(settings?[QRCode.SettingsKey.randomInset]) ?? false
			let rotationFraction = CGFloatValue(settings?[QRCode.SettingsKey.rotationFraction]) ?? 0.0
			return Square(
				insetFraction: insetFraction,
				randomInsetSizing: randomInsetSizing,
				rotationFraction: rotationFraction
			)
		}

		/// Make a copy of this shape
		@objc public func copyShape() -> QRCodePixelShapeGenerator {
			return Square(
				insetFraction: self.common.insetFraction,
				randomInsetSizing: self.common.randomInsetSizing,
				rotationFraction: self.common.rotationFraction
			)
		}

		/// Generate a CGPath from the matrix contents
		/// - Parameters:
		///   - matrix: The matrix to generate
		///   - size: The size of the resulting CGPath
		/// - Returns: A path
		public func generatePath(from matrix: BoolMatrix, size: CGSize) -> CGPath {
			common.generatePath(from: matrix, size: size)
		}

		/// The fractional inset for the pixel
		@objc public var insetFraction: CGFloat { self.common.insetFraction }

		private let common: CommonPixelGenerator
	}
}

// MARK: - Settings

public extension QRCode.PixelShape.Square {
	/// Returns true if the shape supports setting a value for the specified key, false otherwise
	@objc func supportsSettingValue(forKey key: String) -> Bool {
		return key == QRCode.SettingsKey.insetFraction
			|| key == QRCode.SettingsKey.randomInset
			|| key == QRCode.SettingsKey.rotationFraction
	}

	/// Returns the current settings for the shape
	@objc func settings() -> [String: Any] {
		return [
			QRCode.SettingsKey.insetFraction: self.common.insetFraction,
			QRCode.SettingsKey.randomInset: self.common.randomInsetSizing,
			QRCode.SettingsKey.rotationFraction: self.common.rotationFraction,
		]
	}

	/// Set a configuration value for a particular setting string
	@objc func setSettingValue(_ value: Any?, forKey key: String) -> Bool {
		if key == QRCode.SettingsKey.insetFraction {
			guard let v = value else {
				self.common.insetFraction = 0
				return true
			}
			guard let v = DoubleValue(v) else { return false }
			self.common.insetFraction = v
			return true
		}
		else if key == QRCode.SettingsKey.randomInset {
			guard let v = value, let v = BoolValue(v) else {
				self.common.randomInsetSizing = false
				return true
			}
			self.common.randomInsetSizing = v
			return true
		}
		else if key == QRCode.SettingsKey.rotationFraction {
			guard let v = value, let v = CGFloatValue(v) else {
				self.common.rotationFraction = 0.0
				return true
			}
			self.common.rotationFraction = v
			return true
		}
		return false
	}
}
