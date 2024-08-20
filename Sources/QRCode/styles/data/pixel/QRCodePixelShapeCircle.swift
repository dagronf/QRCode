//
//  QRCodePixelShapeCircle.swift
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
	/// A circle pixel shape
	@objc(QRCodePixelShapeCircle) class Circle: NSObject, QRCodePixelShapeGenerator {
		/// The generator name
		@objc public static let Name: String = "circle"
		/// The generator title
		@objc public static var Title: String { "Circle" }

		/// Create a circle pixel shape
		/// - Parameters:
		///   - insetGenerator: The inset function to apply to each pixel
		///   - insetFraction: The inset between each pixel
		@objc public init(
			insetGenerator: QRCodePixelInsetGenerator = QRCode.PixelInset.Fixed(),
			insetFraction: CGFloat = 0
		) {
			self.common = CommonPixelGenerator(
				pixelType: .circle,
				insetGenerator: insetGenerator,
				insetFraction: insetFraction
			)
			super.init()
		}

		/// Create an instance of this path generator with the specified settings
		@objc public static func Create(_ settings: [String : Any]?) -> any QRCodePixelShapeGenerator {
			let insetFraction = DoubleValue(settings?[QRCode.SettingsKey.insetFraction, default: 0]) ?? 0

			let generator: QRCodePixelInsetGenerator
			if let s = settings?[QRCode.SettingsKey.insetGeneratorName] as? String {
				generator = QRCode.PixelInset.generator(named: s) ?? QRCode.PixelInset.Fixed()
			}
			else {
				// Backwards compatible
				let useRandomInset = BoolValue(settings?[QRCode.SettingsKey.useRandomInset]) ?? false
				generator = useRandomInset ? QRCode.PixelInset.Random() : QRCode.PixelInset.Fixed()
			}

			return Circle(insetGenerator: generator, insetFraction: insetFraction)
		}

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePixelShapeGenerator {
			return Circle(
				insetGenerator: self.common.insetGenerator.duplicate(),
				insetFraction: self.common.insetFraction
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

		/// The fractional inset for the pixel (0.0 -> 1.0)
		@objc public var insetFraction: CGFloat { common.insetFraction }

		// private

		private let common: CommonPixelGenerator
	}
}

// MARK: - Settings

public extension QRCode.PixelShape.Circle {
	/// Returns true if the shape supports setting a value for the specified key, false otherwise
	@objc func supportsSettingValue(forKey key: String) -> Bool {
		return key == QRCode.SettingsKey.insetFraction
			|| key == QRCode.SettingsKey.insetGeneratorName
	}

	/// Returns the current settings for the shape
	@objc func settings() -> [String : Any] {
		var result: [String : Any] = [:]

		// Write the inset fraction
		result[QRCode.SettingsKey.insetFraction] = self.common.insetFraction

		// Write the generator
		result[QRCode.SettingsKey.insetGeneratorName] = self.common.insetGenerator.name

		return result
	}

	/// Set a configuration value for a particular setting string
	@objc func setSettingValue(_ value: Any?, forKey key: String) -> Bool {
		if key == QRCode.SettingsKey.insetFraction {
			return self.common.setInsetFractionValue(value)
		}
		else if key == QRCode.SettingsKey.insetGeneratorName {
			return self.common.setInsetGenerator(value)
		}
		return false
	}
}

// MARK: - Pixel creation conveniences

public extension QRCodePixelShapeGenerator where Self == QRCode.PixelShape.Circle {
	/// Create a circle pixel generator
	/// - Parameters:
	///   - insetGenerator: The inset generator
	///   - insetFraction: The inset between each pixel
	/// - Returns: A pixel generator
	@inlinable static func circle(
		insetGenerator: QRCodePixelInsetGenerator = QRCode.PixelInset.Fixed(),
		insetFraction: CGFloat = 0
	) -> QRCodePixelShapeGenerator {
		QRCode.PixelShape.Circle(
			insetGenerator: insetGenerator,
			insetFraction: insetFraction
		)
	}
}
