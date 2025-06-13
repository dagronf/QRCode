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

import CoreGraphics
import Foundation

public extension QRCode.PixelShape {
	/// A gear pixel shape
	@objc(QRCodePixelShapeGear) class Gear: NSObject, QRCodePixelShapeGenerator {
		/// The generator name
		@objc public static let Name: String = "gear"
		/// The generator title
		@objc public static var Title: String { "Gear" }

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
				pixelType: .gear,
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

			return Gear(
				insetGenerator: generator,
				insetFraction: insetFraction,
				rotationGenerator: rotationGenerator,
				rotationFraction: rotationFraction
			)
		}

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePixelShapeGenerator {
			return Gear(
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

internal extension QRCode.PixelShape.Gear {
	// A 10x10 'pixel' representation of a gear circle
	static func gear10x10() -> CGPath { generatedPixelPath__ }
}

// MARK: - Settings

public extension QRCode.PixelShape.Gear {
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

public extension QRCodePixelShapeGenerator where Self == QRCode.PixelShape.Gear {
	/// Create a gear pixel generator
	/// - Parameters:
	///   - insetGenerator: The inset generator
	///   - insetFraction: The inset between each pixel
	///   - rotationGenerator: The rotation generator
	///   - rotationFraction: The rotation fraction (-1.0 -> 1.0) to apply to the rotation of each pixel
	/// - Returns: A pixel generator
	@inlinable static func gear(
		insetGenerator: QRCodePixelInsetGenerator = QRCode.PixelInset.Fixed(),
		insetFraction: CGFloat = 0,
		rotationGenerator: QRCodePixelRotationGenerator = QRCode.PixelRotation.Fixed(),
		rotationFraction: CGFloat = 0
	) -> QRCodePixelShapeGenerator {
		QRCode.PixelShape.Gear(
			insetGenerator: insetGenerator,
			insetFraction: insetFraction,
			rotationGenerator: rotationGenerator,
			rotationFraction: rotationFraction
		)
	}
}

// MARK: - Paths

private let generatedPixelPath__ = CGPath.make { gearpixel2Path in
		gearpixel2Path.move(to: CGPoint(x: 10, y: 5.51))
		gearpixel2Path.curve(to: CGPoint(x: 9.72, y: 5.84), controlPoint1: CGPoint(x: 10, y: 5.67), controlPoint2: CGPoint(x: 9.88, y: 5.81))
		gearpixel2Path.line(to: CGPoint(x: 8.87, y: 5.99))
		gearpixel2Path.curve(to: CGPoint(x: 8.82, y: 6), controlPoint1: CGPoint(x: 8.85, y: 5.99), controlPoint2: CGPoint(x: 8.84, y: 6))
		gearpixel2Path.curve(to: CGPoint(x: 8.41, y: 7), controlPoint1: CGPoint(x: 8.73, y: 6.35), controlPoint2: CGPoint(x: 8.59, y: 6.69))
		gearpixel2Path.curve(to: CGPoint(x: 8.44, y: 7.04), controlPoint1: CGPoint(x: 8.42, y: 7.01), controlPoint2: CGPoint(x: 8.43, y: 7.02))
		gearpixel2Path.line(to: CGPoint(x: 8.93, y: 7.74))
		gearpixel2Path.curve(to: CGPoint(x: 8.9, y: 8.17), controlPoint1: CGPoint(x: 9.02, y: 7.88), controlPoint2: CGPoint(x: 9.01, y: 8.06))
		gearpixel2Path.line(to: CGPoint(x: 8.17, y: 8.9))
		gearpixel2Path.curve(to: CGPoint(x: 7.74, y: 8.94), controlPoint1: CGPoint(x: 8.06, y: 9.01), controlPoint2: CGPoint(x: 7.88, y: 9.02))
		gearpixel2Path.line(to: CGPoint(x: 7.03, y: 8.44))
		gearpixel2Path.curve(to: CGPoint(x: 7, y: 8.41), controlPoint1: CGPoint(x: 7.02, y: 8.43), controlPoint2: CGPoint(x: 7.01, y: 8.42))
		gearpixel2Path.curve(to: CGPoint(x: 5.99, y: 8.82), controlPoint1: CGPoint(x: 6.69, y: 8.59), controlPoint2: CGPoint(x: 6.35, y: 8.73))
		gearpixel2Path.curve(to: CGPoint(x: 5.99, y: 8.87), controlPoint1: CGPoint(x: 5.99, y: 8.84), controlPoint2: CGPoint(x: 5.99, y: 8.85))
		gearpixel2Path.line(to: CGPoint(x: 5.84, y: 9.72))
		gearpixel2Path.curve(to: CGPoint(x: 5.51, y: 10), controlPoint1: CGPoint(x: 5.81, y: 9.88), controlPoint2: CGPoint(x: 5.67, y: 9.99))
		gearpixel2Path.line(to: CGPoint(x: 4.49, y: 10))
		gearpixel2Path.curve(to: CGPoint(x: 4.16, y: 9.72), controlPoint1: CGPoint(x: 4.32, y: 9.99), controlPoint2: CGPoint(x: 4.19, y: 9.88))
		gearpixel2Path.line(to: CGPoint(x: 4.01, y: 8.87))
		gearpixel2Path.curve(to: CGPoint(x: 4, y: 8.83), controlPoint1: CGPoint(x: 4.01, y: 8.86), controlPoint2: CGPoint(x: 4, y: 8.84))
		gearpixel2Path.curve(to: CGPoint(x: 3, y: 8.41), controlPoint1: CGPoint(x: 3.65, y: 8.73), controlPoint2: CGPoint(x: 3.31, y: 8.59))
		gearpixel2Path.curve(to: CGPoint(x: 2.96, y: 8.44), controlPoint1: CGPoint(x: 2.99, y: 8.42), controlPoint2: CGPoint(x: 2.98, y: 8.43))
		gearpixel2Path.line(to: CGPoint(x: 2.26, y: 8.93))
		gearpixel2Path.curve(to: CGPoint(x: 1.83, y: 8.9), controlPoint1: CGPoint(x: 2.12, y: 9.02), controlPoint2: CGPoint(x: 1.94, y: 9.01))
		gearpixel2Path.line(to: CGPoint(x: 1.1, y: 8.17))
		gearpixel2Path.curve(to: CGPoint(x: 1.06, y: 7.74), controlPoint1: CGPoint(x: 0.99, y: 8.05), controlPoint2: CGPoint(x: 0.98, y: 7.88))
		gearpixel2Path.line(to: CGPoint(x: 1.56, y: 7.03))
		gearpixel2Path.curve(to: CGPoint(x: 1.59, y: 7), controlPoint1: CGPoint(x: 1.57, y: 7.02), controlPoint2: CGPoint(x: 1.58, y: 7.01))
		gearpixel2Path.curve(to: CGPoint(x: 1.18, y: 5.99), controlPoint1: CGPoint(x: 1.41, y: 6.69), controlPoint2: CGPoint(x: 1.27, y: 6.35))
		gearpixel2Path.curve(to: CGPoint(x: 1.13, y: 5.99), controlPoint1: CGPoint(x: 1.16, y: 5.99), controlPoint2: CGPoint(x: 1.15, y: 5.99))
		gearpixel2Path.line(to: CGPoint(x: 0.28, y: 5.84))
		gearpixel2Path.curve(to: CGPoint(x: 0, y: 5.51), controlPoint1: CGPoint(x: 0.12, y: 5.81), controlPoint2: CGPoint(x: 0.01, y: 5.67))
		gearpixel2Path.line(to: CGPoint(x: 0, y: 4.49))
		gearpixel2Path.curve(to: CGPoint(x: 0.28, y: 4.16), controlPoint1: CGPoint(x: 0.01, y: 4.33), controlPoint2: CGPoint(x: 0.12, y: 4.19))
		gearpixel2Path.line(to: CGPoint(x: 1.13, y: 4.01))
		gearpixel2Path.curve(to: CGPoint(x: 1.18, y: 4.01), controlPoint1: CGPoint(x: 1.15, y: 4.01), controlPoint2: CGPoint(x: 1.16, y: 4.01))
		gearpixel2Path.curve(to: CGPoint(x: 1.59, y: 3), controlPoint1: CGPoint(x: 1.27, y: 3.65), controlPoint2: CGPoint(x: 1.41, y: 3.31))
		gearpixel2Path.curve(to: CGPoint(x: 1.56, y: 2.96), controlPoint1: CGPoint(x: 1.58, y: 2.99), controlPoint2: CGPoint(x: 1.57, y: 2.98))
		gearpixel2Path.line(to: CGPoint(x: 1.06, y: 2.26))
		gearpixel2Path.curve(to: CGPoint(x: 1.1, y: 1.83), controlPoint1: CGPoint(x: 0.98, y: 2.12), controlPoint2: CGPoint(x: 0.99, y: 1.95))
		gearpixel2Path.line(to: CGPoint(x: 1.83, y: 1.1))
		gearpixel2Path.curve(to: CGPoint(x: 2.26, y: 1.07), controlPoint1: CGPoint(x: 1.94, y: 0.99), controlPoint2: CGPoint(x: 2.12, y: 0.98))
		gearpixel2Path.line(to: CGPoint(x: 2.97, y: 1.56))
		gearpixel2Path.curve(to: CGPoint(x: 3, y: 1.59), controlPoint1: CGPoint(x: 2.98, y: 1.57), controlPoint2: CGPoint(x: 2.99, y: 1.58))
		gearpixel2Path.curve(to: CGPoint(x: 4.01, y: 1.18), controlPoint1: CGPoint(x: 3.31, y: 1.41), controlPoint2: CGPoint(x: 3.65, y: 1.27))
		gearpixel2Path.curve(to: CGPoint(x: 4.01, y: 1.13), controlPoint1: CGPoint(x: 4.01, y: 1.16), controlPoint2: CGPoint(x: 4.01, y: 1.15))
		gearpixel2Path.line(to: CGPoint(x: 4.16, y: 0.28))
		gearpixel2Path.curve(to: CGPoint(x: 4.49, y: 0), controlPoint1: CGPoint(x: 4.19, y: 0.12), controlPoint2: CGPoint(x: 4.33, y: 0))
		gearpixel2Path.line(to: CGPoint(x: 5.51, y: 0))
		gearpixel2Path.curve(to: CGPoint(x: 5.84, y: 0.28), controlPoint1: CGPoint(x: 5.67, y: 0.01), controlPoint2: CGPoint(x: 5.81, y: 0.12))
		gearpixel2Path.line(to: CGPoint(x: 5.99, y: 1.13))
		gearpixel2Path.curve(to: CGPoint(x: 5.99, y: 1.18), controlPoint1: CGPoint(x: 5.99, y: 1.15), controlPoint2: CGPoint(x: 5.99, y: 1.16))
		gearpixel2Path.curve(to: CGPoint(x: 7, y: 1.59), controlPoint1: CGPoint(x: 6.35, y: 1.27), controlPoint2: CGPoint(x: 6.69, y: 1.41))
		gearpixel2Path.curve(to: CGPoint(x: 7.04, y: 1.56), controlPoint1: CGPoint(x: 7.01, y: 1.58), controlPoint2: CGPoint(x: 7.02, y: 1.57))
		gearpixel2Path.line(to: CGPoint(x: 7.74, y: 1.07))
		gearpixel2Path.curve(to: CGPoint(x: 8.17, y: 1.1), controlPoint1: CGPoint(x: 7.88, y: 0.98), controlPoint2: CGPoint(x: 8.06, y: 0.99))
		gearpixel2Path.line(to: CGPoint(x: 8.9, y: 1.83))
		gearpixel2Path.curve(to: CGPoint(x: 8.94, y: 2.26), controlPoint1: CGPoint(x: 9.01, y: 1.94), controlPoint2: CGPoint(x: 9.02, y: 2.12))
		gearpixel2Path.line(to: CGPoint(x: 8.44, y: 2.96))
		gearpixel2Path.curve(to: CGPoint(x: 8.41, y: 3), controlPoint1: CGPoint(x: 8.43, y: 2.98), controlPoint2: CGPoint(x: 8.42, y: 2.99))
		gearpixel2Path.curve(to: CGPoint(x: 8.82, y: 4.01), controlPoint1: CGPoint(x: 8.59, y: 3.31), controlPoint2: CGPoint(x: 8.73, y: 3.65))
		gearpixel2Path.curve(to: CGPoint(x: 8.87, y: 4.01), controlPoint1: CGPoint(x: 8.84, y: 4.01), controlPoint2: CGPoint(x: 8.85, y: 4.01))
		gearpixel2Path.line(to: CGPoint(x: 9.72, y: 4.16))
		gearpixel2Path.curve(to: CGPoint(x: 10, y: 4.49), controlPoint1: CGPoint(x: 9.88, y: 4.19), controlPoint2: CGPoint(x: 10, y: 4.33))
		gearpixel2Path.line(to: CGPoint(x: 10, y: 5.51))
		gearpixel2Path.close()
	}
