//
//  QRCodePixelShapeCRT.swift
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
	/// A squircle pixel shape
	@objc(QRCodePixelShapeCRT) class CRT: NSObject, QRCodePixelShapeGenerator {
		/// The generator name
		@objc public static let Name: String = "crt"
		/// The generator title
		@objc public static var Title: String { "CRT" }

		/// The fractional inset for the pixel (0.0 -> 1.0)
		@objc public var insetFraction: CGFloat { self.common.insetFraction }
		/// If true, randomly sets the inset to create a "wobble"
		@objc public var useRandomInset: Bool { self.common.useRandomInset }
		/// The rotation for each pixel (0.0 -> 1.0)
		@objc public var rotationFraction: CGFloat { self.common.rotationFraction }
		/// If true, randomly chooses a rotation for each pixel
		@objc public var useRandomRotation: Bool { self.common.useRandomRotation }

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
				pixelType: .crt,
				insetFraction: insetFraction,
				useRandomInset: useRandomInset,
				rotationFraction: rotationFraction,
				useRandomRotation: useRandomRotation
			)
			super.init()
		}

		/// Create an instance of this path generator with the specified settings
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodePixelShapeGenerator {
			let insetFraction = DoubleValue(settings?[QRCode.SettingsKey.insetFraction, default: 0]) ?? 0
			let useRandomInset = BoolValue(settings?[QRCode.SettingsKey.useRandomInset]) ?? false
			let rotationFraction = CGFloatValue(settings?[QRCode.SettingsKey.rotationFraction]) ?? 0.0
			let useRandomRotation = BoolValue(settings?[QRCode.SettingsKey.useRandomRotation]) ?? false
			return CRT(
				insetFraction: insetFraction,
				useRandomInset: useRandomInset,
				rotationFraction: rotationFraction,
				useRandomRotation: useRandomRotation
			)
		}

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePixelShapeGenerator {
			return CRT(
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

		// A 10x10 'pixel' representation of a squircle
		internal static func crtPixel10x10() -> CGPath {
			let crt_pixelPath = CGMutablePath()
			crt_pixelPath.move(to: CGPoint(x: 0, y: 5))
			crt_pixelPath.curve(to: CGPoint(x: 0.6, y: 0.6), controlPoint1: CGPoint(x: 0, y: 2.5), controlPoint2: CGPoint(x: 0.6, y: 0.6))
			crt_pixelPath.curve(to: CGPoint(x: 5, y: 0), controlPoint1: CGPoint(x: 0.6, y: 0.6), controlPoint2: CGPoint(x: 2.5, y: 0))
			crt_pixelPath.curve(to: CGPoint(x: 9.4, y: 0.6), controlPoint1: CGPoint(x: 7.5, y: 0), controlPoint2: CGPoint(x: 9.4, y: 0.6))
			crt_pixelPath.curve(to: CGPoint(x: 10, y: 5), controlPoint1: CGPoint(x: 9.4, y: 0.6), controlPoint2: CGPoint(x: 10, y: 2.5))
			crt_pixelPath.curve(to: CGPoint(x: 9.4, y: 9.4), controlPoint1: CGPoint(x: 10, y: 7.5), controlPoint2: CGPoint(x: 9.4, y: 9.4))
			crt_pixelPath.curve(to: CGPoint(x: 5, y: 10), controlPoint1: CGPoint(x: 9.4, y: 9.4), controlPoint2: CGPoint(x: 7.5, y: 10))
			crt_pixelPath.curve(to: CGPoint(x: 0.6, y: 9.4), controlPoint1: CGPoint(x: 2.5, y: 10), controlPoint2: CGPoint(x: 0.6, y: 9.4))
			crt_pixelPath.curve(to: CGPoint(x: 0, y: 5), controlPoint1: CGPoint(x: 0.6, y: 9.4), controlPoint2: CGPoint(x: 0, y: 7.5))
			crt_pixelPath.close()
			return crt_pixelPath
		}

		private let common: CommonPixelGenerator
	}
}

// MARK: - Settings

public extension QRCode.PixelShape.CRT {
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
