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
	/// A strounded triangle pixel shape
	@objc(QRCodePixelShapeRoundedTriangle) class RoundedTriangle: NSObject, QRCodePixelShapeGenerator {
		/// The generator name
		@objc public static let Name: String = "roundedTriangle"
		/// The generator title
		@objc public static var Title: String { "RoundedTriangle" }

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
				pixelType: .roundedTriangle,
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

			return RoundedTriangle(
				insetGenerator: generator,
				insetFraction: insetFraction,
				rotationGenerator: rotationGenerator,
				rotationFraction: rotationFraction
			)
		}

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePixelShapeGenerator {
			RoundedTriangle(
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

internal extension QRCode.PixelShape.RoundedTriangle {
	// A 10x10 'pixel' representation of a rounded triangle pixel
	static func roundedTriangle10x10() -> CGPath { pixelPath__ }
}

private let pixelPath__ = CGPath.make { trPixelPath in
	trPixelPath.move(to: NSPoint(x: 1.69, y: 0.5))
	trPixelPath.curve(to: NSPoint(x: 1.06, y: 0.67), controlPoint1: NSPoint(x: 1.45, y: 0.5), controlPoint2: NSPoint(x: 1.23, y: 0.56))
	trPixelPath.curve(to: NSPoint(x: 0.64, y: 1.14), controlPoint1: NSPoint(x: 0.88, y: 0.79), controlPoint2: NSPoint(x: 0.74, y: 0.95))
	trPixelPath.curve(to: NSPoint(x: 0.5, y: 1.81), controlPoint1: NSPoint(x: 0.55, y: 1.34), controlPoint2: NSPoint(x: 0.5, y: 1.56))
	trPixelPath.curve(to: NSPoint(x: 0.67, y: 2.48), controlPoint1: NSPoint(x: 0.5, y: 2.04), controlPoint2: NSPoint(x: 0.56, y: 2.27))
	trPixelPath.line(to: NSPoint(x: 3.98, y: 8.84))
	trPixelPath.curve(to: NSPoint(x: 4.42, y: 9.33), controlPoint1: NSPoint(x: 4.09, y: 9.06), controlPoint2: NSPoint(x: 4.24, y: 9.22))
	trPixelPath.curve(to: NSPoint(x: 5, y: 9.5), controlPoint1: NSPoint(x: 4.61, y: 9.44), controlPoint2: NSPoint(x: 4.8, y: 9.5))
	trPixelPath.curve(to: NSPoint(x: 5.57, y: 9.33), controlPoint1: NSPoint(x: 5.2, y: 9.5), controlPoint2: NSPoint(x: 5.39, y: 9.44))
	trPixelPath.curve(to: NSPoint(x: 6.02, y: 8.84), controlPoint1: NSPoint(x: 5.76, y: 9.22), controlPoint2: NSPoint(x: 5.91, y: 9.06))
	trPixelPath.line(to: NSPoint(x: 9.33, y: 2.48))
	trPixelPath.curve(to: NSPoint(x: 9.46, y: 2.15), controlPoint1: NSPoint(x: 9.39, y: 2.37), controlPoint2: NSPoint(x: 9.43, y: 2.26))
	trPixelPath.curve(to: NSPoint(x: 9.5, y: 1.81), controlPoint1: NSPoint(x: 9.49, y: 2.03), controlPoint2: NSPoint(x: 9.5, y: 1.92))
	trPixelPath.curve(to: NSPoint(x: 9.36, y: 1.14), controlPoint1: NSPoint(x: 9.5, y: 1.56), controlPoint2: NSPoint(x: 9.45, y: 1.34))
	trPixelPath.curve(to: NSPoint(x: 8.94, y: 0.67), controlPoint1: NSPoint(x: 9.26, y: 0.95), controlPoint2: NSPoint(x: 9.12, y: 0.79))
	trPixelPath.curve(to: NSPoint(x: 8.31, y: 0.5), controlPoint1: NSPoint(x: 8.77, y: 0.56), controlPoint2: NSPoint(x: 8.55, y: 0.5))
	trPixelPath.line(to: NSPoint(x: 1.69, y: 0.5))
	trPixelPath.close()
}.flippedVertically(height: 10)

// MARK: - Settings

public extension QRCode.PixelShape.RoundedTriangle {
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

public extension QRCodePixelShapeGenerator where Self == QRCode.PixelShape.RoundedTriangle {
	/// Create a rounded triangle pixel generator
	/// - Parameters:
	///   - insetGenerator: The inset generator
	///   - insetFraction: The inset between each pixel
	///   - rotationGenerator: The rotation generator
	///   - rotationFraction: The rotation fraction (-1.0 -> 1.0) to apply to the rotation of each pixel
	/// - Returns: A pixel generator
	@inlinable static func roundedTriangle(
		insetGenerator: QRCodePixelInsetGenerator = QRCode.PixelInset.Fixed(),
		insetFraction: CGFloat = 0,
		rotationGenerator: QRCodePixelRotationGenerator = QRCode.PixelRotation.Fixed(),
		rotationFraction: CGFloat = 0
	) -> QRCodePixelShapeGenerator {
		QRCode.PixelShape.RoundedTriangle(
			insetGenerator: insetGenerator,
			insetFraction: insetFraction,
			rotationGenerator: rotationGenerator,
			rotationFraction: rotationFraction
		)
	}
}
