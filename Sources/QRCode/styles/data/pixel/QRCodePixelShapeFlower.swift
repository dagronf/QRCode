//
//  QRCodePixelShapeFlower.swift
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
	/// A flower pixel shape
	@objc(QRCodePixelShapeFlower) class Flower: NSObject, QRCodePixelShapeGenerator, Codable {
		/// The generator name
		@objc public static let Name: String = "flower"
		/// The generator title
		@objc public static var Title: String { "Flower" }

		//////// Codable

		enum CodingKeys: CodingKey {
			case insetFraction
			case useRandomInset
			case rotationFraction
			case useRandomRotation
		}

		convenience public required init(from decoder: Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			let insetFraction = try container.decodeIfPresent(CGFloat.self, forKey: .insetFraction) ?? 0.0
			let useRandomInset = try container.decodeIfPresent(Bool.self, forKey: .useRandomInset) ?? false

			let rotationFraction = try container.decodeIfPresent(CGFloat.self, forKey: .rotationFraction) ?? 0.0
			let useRandomRotation = try container.decodeIfPresent(Bool.self, forKey: .useRandomRotation) ?? false

			self.init(
				insetFraction: insetFraction,
				useRandomInset: useRandomInset,
				rotationFraction: rotationFraction,
				useRandomRotation: useRandomRotation
			)
		}

		public func encode(to encoder: Encoder) throws {
			var container = encoder.container(keyedBy: CodingKeys.self)
			if self.common.insetFraction > 0.0 {
				try container.encode(self.common.insetFraction, forKey: .insetFraction)
			}
			if self.common.useRandomInset {
				try container.encode(self.common.useRandomInset, forKey: .useRandomInset)
			}

			if self.common.rotationFraction > 0.0 {
				try container.encode(self.common.rotationFraction, forKey: .rotationFraction)
			}
			if self.common.useRandomRotation {
				try container.encode(self.common.useRandomRotation, forKey: .useRandomRotation)
			}
		}

		//////// Codable

		/// The fractional inset for the pixel
		@objc public var insetFraction: CGFloat { common.insetFraction }

		/// Create
		/// - Parameters:
		///   - insetFraction: The inset between each pixel
		///   - useRandomInset: If true, chooses a random inset value (between 0.0 -> `insetFraction`) for each pixel
		///   - rotationFraction: A rotation factor (0 -> 1) to apply to the rotation of each pixel
		///   - useRandomRotation: If true, randomly sets the rotation of each pixel within the range `0 ... rotationFraction`
		@objc public init(
			insetFraction: CGFloat = 0,
			useRandomInset: Bool = false,
			rotationFraction: CGFloat = 0,
			useRandomRotation: Bool = false
		) {
			self.common = CommonPixelGenerator(
				pixelType: .flower,
				insetFraction: insetFraction,
				useRandomInset: useRandomInset,
				rotationFraction: rotationFraction,
				useRandomRotation: useRandomRotation
			)
			super.init()
		}

		/// Create an instance of this path generator with the specified settings
		@objc public static func Create(_ settings: [String: Any]?) -> QRCodePixelShapeGenerator {
			let insetFraction = DoubleValue(settings?[QRCode.SettingsKey.insetFraction, default: 0]) ?? 0
			let useRandomInset = BoolValue(settings?[QRCode.SettingsKey.useRandomInset]) ?? false
			let rotationFraction = CGFloatValue(settings?[QRCode.SettingsKey.rotationFraction]) ?? 0.0
			let useRandomRotation = BoolValue(settings?[QRCode.SettingsKey.useRandomRotation]) ?? false
			return Flower(
				insetFraction: insetFraction,
				useRandomInset: useRandomInset,
				rotationFraction: rotationFraction,
				useRandomRotation: useRandomRotation
			)
		}

		/// Make a copy of the object
		@objc public func copyShape() -> QRCodePixelShapeGenerator {
			return Flower(
				insetFraction: self.common.insetFraction,
				useRandomInset: self.common.useRandomInset,
				rotationFraction: self.common.rotationFraction,
				useRandomRotation: self.common.useRandomRotation
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

		// A 10x10 'pixel' representation of a flower pixel
		internal static func flower10x10() -> CGPath {
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

		private let common: CommonPixelGenerator
	}
}

// MARK: - Settings

public extension QRCode.PixelShape.Flower {
	/// Returns true if the shape supports setting a value for the specified key, false otherwise
	@objc func supportsSettingValue(forKey key: String) -> Bool {
		return key == QRCode.SettingsKey.insetFraction
			|| key == QRCode.SettingsKey.useRandomInset
			|| key == QRCode.SettingsKey.rotationFraction
			|| key == QRCode.SettingsKey.useRandomRotation
	}

	/// Returns the current settings for the shape
	@objc func settings() -> [String : Any] {
		return [
			QRCode.SettingsKey.insetFraction: self.common.insetFraction,
			QRCode.SettingsKey.useRandomInset: self.common.useRandomInset,
			QRCode.SettingsKey.rotationFraction: self.common.rotationFraction,
			QRCode.SettingsKey.useRandomRotation: self.common.useRandomRotation,
		]
	}

	/// Set a configuration value for a particular setting string
	@objc func setSettingValue(_ value: Any?, forKey key: String) -> Bool {
		if key == QRCode.SettingsKey.insetFraction {
			return self.common.setInsetFractionValue(value)
		}
		else if key == QRCode.SettingsKey.useRandomInset {
			return self.common.setUsesRandomInset(value)
		}
		else if key == QRCode.SettingsKey.rotationFraction {
			return self.common.setRotationFraction(value)
		}
		else if key == QRCode.SettingsKey.useRandomRotation {
			return self.common.setUsesRandomRotation(value)
		}
		return false
	}
}
