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
	/// A spiky circle pixel shape
	@objc(QRCodePixelShapeSpikyCircle) class SpikyCircle: NSObject, QRCodePixelShapeGenerator {
		/// The generator name
		@objc public static let Name: String = "spikyCircle"
		/// The generator title
		@objc public static var Title: String { "Spiky Circle" }

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
				pixelType: .spikyCircle,
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

			return SpikyCircle(
				insetGenerator: generator,
				insetFraction: insetFraction,
				rotationGenerator: rotationGenerator,
				rotationFraction: rotationFraction
			)
		}

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePixelShapeGenerator {
			return SpikyCircle(
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

internal extension QRCode.PixelShape.SpikyCircle {
	// A 10x10 'pixel' representation of a spiky circle
	static func spikyCircle10x10() -> CGPath { generatedPixelPath__ }
}

// MARK: - Settings

public extension QRCode.PixelShape.SpikyCircle {
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

public extension QRCodePixelShapeGenerator where Self == QRCode.PixelShape.SpikyCircle {
	/// Create a spiky circle pixel generator
	/// - Parameters:
	///   - insetGenerator: The inset generator
	///   - insetFraction: The inset between each pixel
	///   - rotationGenerator: The rotation generator
	///   - rotationFraction: The rotation fraction (-1.0 -> 1.0) to apply to the rotation of each pixel
	/// - Returns: A pixel generator
	@inlinable static func spikyCircle(
		insetGenerator: QRCodePixelInsetGenerator = QRCode.PixelInset.Fixed(),
		insetFraction: CGFloat = 0,
		rotationGenerator: QRCodePixelRotationGenerator = QRCode.PixelRotation.Fixed(),
		rotationFraction: CGFloat = 0
	) -> QRCodePixelShapeGenerator {
		QRCode.PixelShape.SpikyCircle(
			insetGenerator: insetGenerator,
			insetFraction: insetFraction,
			rotationGenerator: rotationGenerator,
			rotationFraction: rotationFraction
		)
	}
}


// MARK: - Paths

private let generatedPixelPath__: CGPath =
	CGPath.make { spikyCirclePath in
		spikyCirclePath.move(to: CGPoint(x: 9, y: 1.87))
		spikyCirclePath.curve(to: CGPoint(x: 7.27, y: 1.63), controlPoint1: CGPoint(x: 9, y: 1.87), controlPoint2: CGPoint(x: 7.67, y: 1.92))
		spikyCirclePath.curve(to: CGPoint(x: 6.47, y: 0.02), controlPoint1: CGPoint(x: 6.87, y: 1.34), controlPoint2: CGPoint(x: 6.47, y: 0.02))
		spikyCirclePath.curve(to: CGPoint(x: 4.94, y: 0.88), controlPoint1: CGPoint(x: 6.47, y: 0.02), controlPoint2: CGPoint(x: 5.42, y: 0.87))
		spikyCirclePath.curve(to: CGPoint(x: 3.38, y: 0.07), controlPoint1: CGPoint(x: 4.45, y: 0.89), controlPoint2: CGPoint(x: 3.38, y: 0.07))
		spikyCirclePath.curve(to: CGPoint(x: 2.63, y: 1.71), controlPoint1: CGPoint(x: 3.38, y: 0.07), controlPoint2: CGPoint(x: 3.02, y: 1.4))
		spikyCirclePath.curve(to: CGPoint(x: 0.91, y: 2), controlPoint1: CGPoint(x: 2.24, y: 2.01), controlPoint2: CGPoint(x: 0.91, y: 2))
		spikyCirclePath.curve(to: CGPoint(x: 1.22, y: 3.79), controlPoint1: CGPoint(x: 0.91, y: 2), controlPoint2: CGPoint(x: 1.37, y: 3.3))
		spikyCirclePath.curve(to: CGPoint(x: 0, y: 5.08), controlPoint1: CGPoint(x: 1.08, y: 4.28), controlPoint2: CGPoint(x: 0, y: 5.08))
		spikyCirclePath.curve(to: CGPoint(x: 1.26, y: 6.34), controlPoint1: CGPoint(x: 0, y: 5.08), controlPoint2: CGPoint(x: 1.11, y: 5.86))
		spikyCirclePath.curve(to: CGPoint(x: 1, y: 8.13), controlPoint1: CGPoint(x: 1.42, y: 6.82), controlPoint2: CGPoint(x: 1, y: 8.13))
		spikyCirclePath.curve(to: CGPoint(x: 2.73, y: 8.37), controlPoint1: CGPoint(x: 1, y: 8.13), controlPoint2: CGPoint(x: 2.33, y: 8.08))
		spikyCirclePath.curve(to: CGPoint(x: 3.53, y: 9.99), controlPoint1: CGPoint(x: 3.13, y: 8.66), controlPoint2: CGPoint(x: 3.53, y: 9.99))
		spikyCirclePath.curve(to: CGPoint(x: 5.06, y: 9.12), controlPoint1: CGPoint(x: 3.53, y: 9.99), controlPoint2: CGPoint(x: 4.58, y: 9.13))
		spikyCirclePath.curve(to: CGPoint(x: 6.62, y: 9.93), controlPoint1: CGPoint(x: 5.55, y: 9.11), controlPoint2: CGPoint(x: 6.62, y: 9.93))
		spikyCirclePath.curve(to: CGPoint(x: 7.37, y: 8.29), controlPoint1: CGPoint(x: 6.62, y: 9.93), controlPoint2: CGPoint(x: 6.98, y: 8.6))
		spikyCirclePath.curve(to: CGPoint(x: 9.09, y: 8), controlPoint1: CGPoint(x: 7.76, y: 7.99), controlPoint2: CGPoint(x: 9.09, y: 8))
		spikyCirclePath.curve(to: CGPoint(x: 8.78, y: 6.21), controlPoint1: CGPoint(x: 9.09, y: 8), controlPoint2: CGPoint(x: 8.63, y: 6.7))
		spikyCirclePath.curve(to: CGPoint(x: 10, y: 4.92), controlPoint1: CGPoint(x: 8.92, y: 5.72), controlPoint2: CGPoint(x: 10, y: 4.92))
		spikyCirclePath.curve(to: CGPoint(x: 8.74, y: 3.66), controlPoint1: CGPoint(x: 10, y: 4.92), controlPoint2: CGPoint(x: 8.89, y: 4.15))
		spikyCirclePath.curve(to: CGPoint(x: 9, y: 1.87), controlPoint1: CGPoint(x: 8.58, y: 3.18), controlPoint2: CGPoint(x: 9, y: 1.87))
		spikyCirclePath.close()
	}
