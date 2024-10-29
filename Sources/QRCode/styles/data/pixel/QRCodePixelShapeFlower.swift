//
//  QRCodePixelShapeFlower.swift
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

import CoreGraphics
import Foundation

public extension QRCode.PixelShape {
	/// A flower pixel shape
	@objc(QRCodePixelShapeFlower) class Flower: NSObject, QRCodePixelShapeGenerator { //}, Codable {
		/// The generator name
		@objc public static let Name: String = "flower"
		/// The generator title
		@objc public static var Title: String { "Flower" }

		/// This pupil generator can be used when generating eye and pupil shapes
		@objc public var canGenerateEyeAndPupilShapes: Bool { true }

		/// Create
		/// - Parameters:
		///   - insetGenerator: The inset function to apply to each pixel
		///   - insetFraction: The inset between each pixel
		///   - rotationGenerator: The rotation function to apply to each pixel
		///   - rotationFraction: The rotation fraction (-1.0 -> 1.0) to apply to the rotation of each pixel
		@objc public init(
			insetGenerator: QRCodePixelInsetGenerator = QRCode.PixelInset.Fixed(),
			insetFraction: CGFloat = 0,
			rotationGenerator: QRCodePixelRotationGenerator = QRCode.PixelRotation.Fixed(),
			rotationFraction: CGFloat = 0
		) {
			self.common = CommonPixelGenerator(
				pixelType: .flower,
				insetGenerator: insetGenerator,
				insetFraction: insetFraction,
				rotationGenerator: rotationGenerator,
				rotationFraction: rotationFraction
			)
			super.init()
		}

		/// Create an instance of this path generator with the specified settings
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodePixelShapeGenerator {
			let insetFraction = DoubleValue(settings?[QRCode.SettingsKey.insetFraction, default: 0]) ?? 0
			let rotationFraction = CGFloatValue(settings?[QRCode.SettingsKey.rotationFraction]) ?? 0.0

			let generator: QRCodePixelInsetGenerator
			if let s = settings?[QRCode.SettingsKey.insetGeneratorName] as? String {
				generator = QRCode.PixelInset.generator(named: s) ?? QRCode.PixelInset.Fixed()
			}
			else {
				// Backwards compatible
				let useRandomInset = BoolValue(settings?[QRCode.SettingsKey.useRandomInset]) ?? false
				generator = useRandomInset ? QRCode.PixelInset.Random() : QRCode.PixelInset.Fixed()
			}

			let rotationGenerator: QRCodePixelRotationGenerator
			if let s = settings?[QRCode.SettingsKey.rotationGeneratorName] as? String {
				rotationGenerator = QRCode.PixelRotation.generator(named: s) ?? QRCode.PixelRotation.Fixed()
			}
			else {
				// Backwards compatible
				let useRandomRotation = BoolValue(settings?[QRCode.SettingsKey.useRandomRotation]) ?? false
				rotationGenerator = useRandomRotation ? QRCode.PixelRotation.Random() : QRCode.PixelRotation.Fixed()
			}

			return Flower(
				insetGenerator: generator,
				insetFraction: insetFraction,
				rotationGenerator: rotationGenerator,
				rotationFraction: rotationFraction
			)
		}

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePixelShapeGenerator {
			return Flower(
				insetGenerator: self.common.insetGenerator.copyInsetGenerator(),
				insetFraction: self.common.insetFraction,
				rotationGenerator: self.common.rotationGenerator.copyRotationGenerator(),
				rotationFraction: self.common.rotationFraction
			)
		}

		/// Reset the generator back to defaults
		@objc public func reset() {
			self.common.insetGenerator = QRCode.PixelInset.Fixed()
			self.common.insetFraction = 0
			self.common.rotationGenerator = QRCode.PixelRotation.Fixed()
			self.common.rotationFraction = 0
		}

		/// Generate a CGPath from the matrix contents
		/// - Parameters:
		///   - matrix: The matrix to generate
		///   - size: The size of the resulting CGPath
		/// - Returns: A path
		public func generatePath(from matrix: BoolMatrix, size: CGSize) -> CGPath {
			common.generatePath(from: matrix, size: size)
		}

		private let common: CommonPixelGenerator
	}
}

// MARK: - Drawing

internal extension QRCode.PixelShape.Flower {
	// A 10x10 'pixel' representation of a flower pixel
	static func flower10x10() -> CGPath {
		let flowerPath = CGMutablePath()
		flowerPath.move(to: CGPoint(x: 10, y: 7.5))
		flowerPath.curve(to: CGPoint(x: 8.49, y: 5.21), controlPoint1: CGPoint(x: 10, y: 6.47), controlPoint2: CGPoint(x: 9.38, y: 5.59))
		flowerPath.curve(to: CGPoint(x: 8.5, y: 5), controlPoint1: CGPoint(x: 8.5, y: 5.14), controlPoint2: CGPoint(x: 8.5, y: 5.07))
		flowerPath.curve(to: CGPoint(x: 8.49, y: 4.79), controlPoint1: CGPoint(x: 8.5, y: 4.93), controlPoint2: CGPoint(x: 8.5, y: 4.86))
		flowerPath.curve(to: CGPoint(x: 10, y: 2.5), controlPoint1: CGPoint(x: 9.38, y: 4.41), controlPoint2: CGPoint(x: 10, y: 3.53))
		flowerPath.curve(to: CGPoint(x: 7.5, y: 0), controlPoint1: CGPoint(x: 10, y: 1.12), controlPoint2: CGPoint(x: 8.88, y: 0))
		flowerPath.curve(to: CGPoint(x: 5.36, y: 1.2), controlPoint1: CGPoint(x: 6.59, y: 0), controlPoint2: CGPoint(x: 5.8, y: 0.48))
		flowerPath.curve(to: CGPoint(x: 5.21, y: 1.51), controlPoint1: CGPoint(x: 5.3, y: 1.3), controlPoint2: CGPoint(x: 5.25, y: 1.4))
		flowerPath.curve(to: CGPoint(x: 5, y: 1.5), controlPoint1: CGPoint(x: 5.14, y: 1.5), controlPoint2: CGPoint(x: 5.07, y: 1.5))
		flowerPath.curve(to: CGPoint(x: 4.79, y: 1.51), controlPoint1: CGPoint(x: 4.93, y: 1.5), controlPoint2: CGPoint(x: 4.86, y: 1.5))
		flowerPath.curve(to: CGPoint(x: 2.5, y: 0), controlPoint1: CGPoint(x: 4.41, y: 0.62), controlPoint2: CGPoint(x: 3.53, y: 0))
		flowerPath.curve(to: CGPoint(x: 1.04, y: 0.47), controlPoint1: CGPoint(x: 1.96, y: 0), controlPoint2: CGPoint(x: 1.45, y: 0.17))
		flowerPath.line(to: CGPoint(x: 0.95, y: 0.54))
		flowerPath.curve(to: CGPoint(x: 0, y: 2.5), controlPoint1: CGPoint(x: 0.37, y: 0.99), controlPoint2: CGPoint(x: 0, y: 1.7))
		flowerPath.curve(to: CGPoint(x: 1.51, y: 4.79), controlPoint1: CGPoint(x: 0, y: 3.53), controlPoint2: CGPoint(x: 0.62, y: 4.41))
		flowerPath.curve(to: CGPoint(x: 1.5, y: 5), controlPoint1: CGPoint(x: 1.5, y: 4.86), controlPoint2: CGPoint(x: 1.5, y: 4.93))
		flowerPath.curve(to: CGPoint(x: 1.51, y: 5.21), controlPoint1: CGPoint(x: 1.5, y: 5.07), controlPoint2: CGPoint(x: 1.5, y: 5.14))
		flowerPath.curve(to: CGPoint(x: 0, y: 7.5), controlPoint1: CGPoint(x: 0.62, y: 5.59), controlPoint2: CGPoint(x: 0, y: 6.47))
		flowerPath.curve(to: CGPoint(x: 2.5, y: 10), controlPoint1: CGPoint(x: 0, y: 8.88), controlPoint2: CGPoint(x: 1.12, y: 10))
		flowerPath.curve(to: CGPoint(x: 4.79, y: 8.49), controlPoint1: CGPoint(x: 3.53, y: 10), controlPoint2: CGPoint(x: 4.41, y: 9.38))
		flowerPath.curve(to: CGPoint(x: 5, y: 8.5), controlPoint1: CGPoint(x: 4.86, y: 8.5), controlPoint2: CGPoint(x: 4.93, y: 8.5))
		flowerPath.curve(to: CGPoint(x: 5.21, y: 8.49), controlPoint1: CGPoint(x: 5.07, y: 8.5), controlPoint2: CGPoint(x: 5.14, y: 8.5))
		flowerPath.curve(to: CGPoint(x: 7.5, y: 10), controlPoint1: CGPoint(x: 5.59, y: 9.38), controlPoint2: CGPoint(x: 6.47, y: 10))
		flowerPath.curve(to: CGPoint(x: 10, y: 7.5), controlPoint1: CGPoint(x: 8.88, y: 10), controlPoint2: CGPoint(x: 10, y: 8.88))
		flowerPath.close()
		return flowerPath
	}
}

// MARK: - Settings

public extension QRCode.PixelShape.Flower {
	/// Returns true if the shape supports setting a value for the specified key, false otherwise
	@objc func supportsSettingValue(forKey key: String) -> Bool {
		return key == QRCode.SettingsKey.insetFraction
			|| key == QRCode.SettingsKey.insetGeneratorName
			|| key == QRCode.SettingsKey.rotationFraction
			|| key == QRCode.SettingsKey.rotationGeneratorName
	}

	/// Returns the current settings for the shape
	@objc func settings() -> [String : Any] {
		var result: [String: Any] = [
			QRCode.SettingsKey.insetGeneratorName: self.common.insetGenerator.name,
			QRCode.SettingsKey.insetFraction: self.common.insetFraction,
			QRCode.SettingsKey.rotationGeneratorName: self.common.rotationGenerator.name,
			QRCode.SettingsKey.rotationFraction: self.common.rotationFraction,
		]
		if self.common.insetGenerator is QRCode.PixelInset.Random {
			// Backwards compatibility
			result[QRCode.SettingsKey.useRandomInset] = true
		}
		if self.common.rotationGenerator is QRCode.PixelRotation.Random {
			// Backwards compatibility
			result[QRCode.SettingsKey.useRandomRotation] = true
		}
		return result
	}

	/// Set a configuration value for a particular setting string
	@objc func setSettingValue(_ value: Any?, forKey key: String) -> Bool {
		if key == QRCode.SettingsKey.insetFraction {
			return self.common.setInsetFractionValue(value)
		}
		else if key == QRCode.SettingsKey.insetGeneratorName {
			return self.common.setInsetGenerator(named: value)
		}
		else if key == QRCode.SettingsKey.rotationFraction {
			return self.common.setRotationFraction(value)
		}
		else if key == QRCode.SettingsKey.rotationGeneratorName {
			return self.common.setRotationGenerator(named: value)
		}
		else if key == QRCode.SettingsKey.useRandomRotation {
			// backwards compatibility
			let which = BoolValue(value) ?? false
			return self.common.setRotationGenerator(named: which ? QRCode.PixelRotation.Random() : QRCode.PixelRotation.Fixed())
		}
		else if key == QRCode.SettingsKey.useRandomInset {
			// backwards compatibility
			let which = BoolValue(value) ?? false
			return self.common.setInsetGenerator(which ? QRCode.PixelInset.Random() : QRCode.PixelInset.Fixed())
		}
		return false
	}
}

// MARK: - Pixel creation conveniences

public extension QRCodePixelShapeGenerator where Self == QRCode.PixelShape.Flower {
	/// Create a flower pixel generator
	/// - Parameters:
	///   - insetGenerator: The inset generator
	///   - insetFraction: The inset between each pixel
	///   - rotationGenerator: The rotation generator
	///   - rotationFraction: The rotation fraction (-1.0 -> 1.0) to apply to the rotation of each pixel
	/// - Returns: A pixel generator
	@inlinable static func flower(
		insetGenerator: QRCodePixelInsetGenerator = QRCode.PixelInset.Fixed(),
		insetFraction: CGFloat = 0,
		rotationGenerator: QRCodePixelRotationGenerator = QRCode.PixelRotation.Fixed(),
		rotationFraction: CGFloat = 0
	) -> QRCodePixelShapeGenerator {
		QRCode.PixelShape.Flower(
			insetGenerator: insetGenerator,
			insetFraction: insetFraction,
			rotationGenerator: rotationGenerator,
			rotationFraction: rotationFraction
		)
	}
}
