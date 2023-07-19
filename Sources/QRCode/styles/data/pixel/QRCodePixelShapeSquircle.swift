//
//  QRCodePixelShapeSquircle.swift
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
	/// A squircle pixel shape
	@objc(QRCodePixelShapeSquircle) class Squircle: NSObject, QRCodePixelShapeGenerator {
		/// The generator name
		@objc public static let Name: String = "squircle"
		/// The generator title
		@objc public static var Title: String { "Squircle" }

		/// Create
		/// - Parameters:
		///   - insetFraction: The inset between each pixel
		///   - useRandomInset: If true, randomly sets the inset of each pixel within the range `0 ... insetFraction`
		///   - rotationFraction: A rotation factor (0 -> 1) to apply to the rotation of each pixel
		///   - useRandomRotation: If true, randomly sets the rotation of each pixel within the range `0 ... rotationFraction`
		@objc public init(
			insetFraction: CGFloat = 0,
			useRandomInset: Bool = false,
			rotationFraction: CGFloat = 0,
			useRandomRotation: Bool = false
		) {
			self.common = CommonPixelGenerator(
				pixelType: .squircle,
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
			return Squircle(
				insetFraction: insetFraction,
				useRandomInset: useRandomInset,
				rotationFraction: rotationFraction,
				useRandomRotation: useRandomRotation
			)
		}

		/// Make a copy of the object
		@objc public func copyShape() -> QRCodePixelShapeGenerator {
			return Squircle(
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

		/// The fractional inset for the pixel
		@objc public var insetFraction: CGFloat { self.common.insetFraction }
		
		// A 10x10 'pixel' representation of a squircle
		internal static func squircle10x10() -> CGPath {
			let s10 = CGMutablePath()
			s10.move(to: CGPoint(x: 5, y: 0))
			s10.curve(to: CGPoint(x: 9.2, y: 0.8), controlPoint1: CGPoint(x: 7.19, y: 0), controlPoint2: CGPoint(x: 8.41, y: 0))
			s10.curve(to: CGPoint(x: 10, y: 5), controlPoint1: CGPoint(x: 10, y: 1.59), controlPoint2: CGPoint(x: 10, y: 2.81))
			s10.curve(to: CGPoint(x: 9.2, y: 9.2), controlPoint1: CGPoint(x: 10, y: 7.19), controlPoint2: CGPoint(x: 10, y: 8.41))
			s10.curve(to: CGPoint(x: 5, y: 10), controlPoint1: CGPoint(x: 8.41, y: 10), controlPoint2: CGPoint(x: 7.19, y: 10))
			s10.curve(to: CGPoint(x: 0.8, y: 9.2), controlPoint1: CGPoint(x: 2.81, y: 10), controlPoint2: CGPoint(x: 1.59, y: 10))
			s10.curve(to: CGPoint(x: 0, y: 5), controlPoint1: CGPoint(x: 0, y: 8.41), controlPoint2: CGPoint(x: 0, y: 7.19))
			s10.curve(to: CGPoint(x: 0.8, y: 0.8), controlPoint1: CGPoint(x: 0, y: 2.81), controlPoint2: CGPoint(x: 0, y: 1.59))
			s10.curve(to: CGPoint(x: 5, y: 0), controlPoint1: CGPoint(x: 1.59, y: 0), controlPoint2: CGPoint(x: 2.81, y: 0))
			s10.close()
			return s10
		}

		private let common: CommonPixelGenerator
	}
}

// MARK: - Settings

public extension QRCode.PixelShape.Squircle {
	/// Returns true if the shape supports setting a value for the specified key, false otherwise
	@objc func supportsSettingValue(forKey key: String) -> Bool {
		return key == QRCode.SettingsKey.insetFraction
			|| key == QRCode.SettingsKey.useRandomInset
			|| key == QRCode.SettingsKey.rotationFraction
			|| key == QRCode.SettingsKey.useRandomRotation
	}
	
	/// Returns the current settings for the shape
	@objc func settings() -> [String: Any] {
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
