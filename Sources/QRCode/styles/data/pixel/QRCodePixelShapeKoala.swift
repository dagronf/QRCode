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
	/// A koala 'nose' pixel shape
	@objc(QRCodePixelShapeKoala) class Koala: NSObject, QRCodePixelShapeGenerator {
		/// The generator name
		@objc public static let Name: String = "koala"
		/// The generator title
		@objc public static var Title: String { "Koala" }

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
				pixelType: .koala,
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

			return Koala(
				insetGenerator: generator,
				insetFraction: insetFraction,
				rotationGenerator: rotationGenerator,
				rotationFraction: rotationFraction
			)
		}

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePixelShapeGenerator {
			return Koala(
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

internal extension QRCode.PixelShape.Koala {
	// A 10x10 'pixel' representation of a Koala pixel
	static func koala10x10() -> CGPath { generatedPixelPath__ }
}

private let generatedPixelPath__ = CGPath.make { koalaPath in
	koalaPath.move(to: CGPoint(x: 0.82, y: 9.18))
	koalaPath.curve(to: CGPoint(x: 9.62, y: 6.38), controlPoint1: CGPoint(x: 2.32, y: 10.68), controlPoint2: CGPoint(x: 8.92, y: 8.58))
	koalaPath.curve(to: CGPoint(x: 3.62, y: 0.38), controlPoint1: CGPoint(x: 10.32, y: 4.18), controlPoint2: CGPoint(x: 5.82, y: -0.32))
	koalaPath.curve(to: CGPoint(x: 0.82, y: 9.18), controlPoint1: CGPoint(x: 1.42, y: 1.08), controlPoint2: CGPoint(x: -0.68, y: 7.68))
	koalaPath.close()
}.flipped()

// MARK: - Settings

public extension QRCode.PixelShape.Koala {
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

public extension QRCodePixelShapeGenerator where Self == QRCode.PixelShape.Koala {
	/// Create a koala pixel generator
	/// - Parameters:
	///   - insetGenerator: The inset generator
	///   - insetFraction: The inset between each pixel
	///   - rotationGenerator: The rotation generator
	///   - rotationFraction: The rotation fraction (-1.0 -> 1.0) to apply to the rotation of each pixel
	/// - Returns: A pixel generator
	@inlinable static func koala(
		insetGenerator: QRCodePixelInsetGenerator = QRCode.PixelInset.Fixed(),
		insetFraction: CGFloat = 0,
		rotationGenerator: QRCodePixelRotationGenerator = QRCode.PixelRotation.Fixed(),
		rotationFraction: CGFloat = 0
	) -> QRCodePixelShapeGenerator {
		QRCode.PixelShape.Koala(
			insetGenerator: insetGenerator,
			insetFraction: insetFraction,
			rotationGenerator: rotationGenerator,
			rotationFraction: rotationFraction
		)
	}
}
