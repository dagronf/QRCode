//
//  QRCodePixelShapeSquircle.swift
//
//  Copyright © 2022 Darren Ford. All rights reserved.
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

		/// Create
		/// - Parameters:
		///   - inset: The inset between each pixel
		@objc public init(inset: CGFloat = 0) {
			self.common = CommonPixelGenerator(pixelType: .squircle, inset: inset)
			super.init()
		}

		/// Create an instance of this path generator with the specified settings
		@objc public static func Create(_ settings: [String: Any]?) -> QRCodePixelShapeGenerator {
			let inset = DoubleValue(settings?[QRCode.SettingsKey.inset, default: 0]) ?? 0
			return Squircle(inset: inset)
		}

		/// Make a copy of the object
		@objc public func copyShape() -> QRCodePixelShapeGenerator {
			return Squircle(inset: self.common.inset)
		}
		
		public func onPath(size: CGSize, data: QRCode, isTemplate: Bool) -> CGPath {
			self.common.onPath(size: size, data: data, isTemplate: isTemplate)
		}
		
		public func offPath(size: CGSize, data: QRCode, isTemplate: Bool) -> CGPath {
			self.common.offPath(size: size, data: data, isTemplate: isTemplate)
		}
		
		@objc public var inset: CGFloat { self.common.inset }
		
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
		return key == QRCode.SettingsKey.inset
	}
	
	/// Returns the current settings for the shape
	@objc func settings() -> [String: Any] {
		return [QRCode.SettingsKey.inset: self.common.inset]
	}
	
	/// Set a configuration value for a particular setting string
	@objc func setSettingValue(_ value: Any?, forKey key: String) -> Bool {
		if key == QRCode.SettingsKey.inset {
			guard let v = value else {
				self.common.inset = 0
				return true
			}
			guard let v = DoubleValue(v) else { return false }
			self.common.inset = v
			return true
		}
		return false
	}
}
