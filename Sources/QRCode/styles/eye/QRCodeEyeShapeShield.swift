//
//  QRCodeEyeShapeShield.swift
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

public extension QRCode.EyeShape {
	/// A 'shield' style eye design with configurable corner styles
	@objc(QRCodeEyeShapeShield) class Shield: NSObject, QRCodeEyeShapeGenerator {
		@objc public static let Name = "shield"
		@objc public static var Title: String { "Shield" }

		/// The corners to push in
		public var corners: QRCode.Corners = .all

		/// Create a Shield eye shape compatible with objective-c
		@objc public init(topLeft: Bool, topRight: Bool, bottomLeft: Bool, bottomRight: Bool) {
			self.corners = .none
			if topLeft { self.corners.insert(.tl) }
			if topRight { self.corners.insert(.tr) }
			if bottomLeft { self.corners.insert(.bl) }
			if bottomRight { self.corners.insert(.br) }
			super.init()
		}

		/// Create a Shield eye shape with the specified corner radius
		public init(corners: QRCode.Corners = .all) {
			self.corners = corners
			super.init()
		}

		/// Create a shield eye shape using the provided settings
		@objc public static func Create(_ settings: [String: Any]?) -> QRCodeEyeShapeGenerator {
			if let value = IntValue(settings?[QRCode.SettingsKey.corners]) {
				return Shield(corners: QRCode.Corners(rawValue: value))
			}
			return Shield()
		}

		@objc public func settings() -> [String: Any] { [QRCode.SettingsKey.corners: self.corners.rawValue] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { key == QRCode.SettingsKey.corners }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool {
			if key == QRCode.SettingsKey.corners,
				let value = IntValue(value)
			{
				self.corners = QRCode.Corners(rawValue: value)
				return true
			}
			return false
		}

		/// Make a copy of the object
		@objc public func copyShape() -> QRCodeEyeShapeGenerator {
			Self.Create(self.settings())
		}

		public func eyePath() -> CGPath {
			let eyePath = CGMutablePath()
			corners.contains(QRCode.Corners.tl) ? eyePath.addPath(tlIN()) : eyePath.addPath(tlOUT())
			corners.contains(QRCode.Corners.tr) ? eyePath.addPath(trIN()) : eyePath.addPath(trOUT())
			corners.contains(QRCode.Corners.bl) ? eyePath.addPath(blIN()) : eyePath.addPath(blOUT())
			corners.contains(QRCode.Corners.br) ? eyePath.addPath(brIN()) : eyePath.addPath(brOUT())
			return eyePath
		}

		@objc public func eyeBackgroundPath() -> CGPath {
			let roundedRectEye2Path = CGMutablePath()
			roundedRectEye2Path.move(to: CGPoint(x: 90, y: 77.14))
			roundedRectEye2Path.line(to: CGPoint(x: 90, y: 12.86))
			roundedRectEye2Path.curve(to: CGPoint(x: 77.14, y: 0), controlPoint1: CGPoint(x: 90, y: 5.76), controlPoint2: CGPoint(x: 84.24, y: -0))
			roundedRectEye2Path.line(to: CGPoint(x: 12.86, y: 0))
			roundedRectEye2Path.curve(to: CGPoint(x: 0, y: 12.86), controlPoint1: CGPoint(x: 5.76, y: 0), controlPoint2: CGPoint(x: 0, y: 5.76))
			roundedRectEye2Path.line(to: CGPoint(x: 0, y: 77.14))
			roundedRectEye2Path.curve(to: CGPoint(x: 12.86, y: 90), controlPoint1: CGPoint(x: 0, y: 84.24), controlPoint2: CGPoint(x: 5.76, y: 90))
			roundedRectEye2Path.line(to: CGPoint(x: 77.14, y: 90))
			roundedRectEye2Path.curve(to: CGPoint(x: 90, y: 77.14), controlPoint1: CGPoint(x: 84.24, y: 90), controlPoint2: CGPoint(x: 90, y: 84.24))
			roundedRectEye2Path.close()
			return roundedRectEye2Path
		}

		/// Returns the default pixel shape for this eye (inherits corners)
		public func defaultPupil() -> QRCodePupilShapeGenerator {
			QRCode.PupilShape.Shield(corners: self.corners)
		}
	}
}

// MARK: - Custom Paths

// This paths were created in PaintCode (see `Art/paths.pcvd`)

extension QRCode.EyeShape.Shield {

	// MARK: - Top Right

	func trIN() -> CGPath {
		let trINPath = CGMutablePath()
		trINPath.move(to: CGPoint(x: 67.1, y: 78.06))
		trINPath.curve(to: CGPoint(x: 70.97, y: 71.61), controlPoint1: CGPoint(x: 69.1, y: 76.06), controlPoint2: CGPoint(x: 68.22, y: 74.36))
		trINPath.curve(to: CGPoint(x: 77.43, y: 67.74), controlPoint1: CGPoint(x: 73.72, y: 68.86), controlPoint2: CGPoint(x: 74.84, y: 70.32))
		trINPath.curve(to: CGPoint(x: 80, y: 60.1), controlPoint1: CGPoint(x: 79.8, y: 65.37), controlPoint2: CGPoint(x: 79.98, y: 60.83))
		trINPath.curve(to: CGPoint(x: 80, y: 45), controlPoint1: CGPoint(x: 80, y: 60.1), controlPoint2: CGPoint(x: 80, y: 45))
		trINPath.line(to: CGPoint(x: 70, y: 45))
		trINPath.curve(to: CGPoint(x: 70, y: 52.59), controlPoint1: CGPoint(x: 70, y: 45), controlPoint2: CGPoint(x: 70, y: 48.8))
		trINPath.curve(to: CGPoint(x: 70, y: 60), controlPoint1: CGPoint(x: 70, y: 55.99), controlPoint2: CGPoint(x: 70, y: 59.38))
		trINPath.curve(to: CGPoint(x: 64, y: 64), controlPoint1: CGPoint(x: 70, y: 60), controlPoint2: CGPoint(x: 66.5, y: 61.5))
		trINPath.curve(to: CGPoint(x: 60, y: 70), controlPoint1: CGPoint(x: 61.51, y: 66.49), controlPoint2: CGPoint(x: 60.01, y: 69.98))
		trINPath.curve(to: CGPoint(x: 52.58, y: 70), controlPoint1: CGPoint(x: 60, y: 70), controlPoint2: CGPoint(x: 56.31, y: 70))
		trINPath.curve(to: CGPoint(x: 45, y: 70), controlPoint1: CGPoint(x: 48.81, y: 70), controlPoint2: CGPoint(x: 45, y: 70))
		trINPath.line(to: CGPoint(x: 45, y: 80))
		trINPath.line(to: CGPoint(x: 60, y: 80))
		trINPath.curve(to: CGPoint(x: 67.1, y: 78.06), controlPoint1: CGPoint(x: 60, y: 80), controlPoint2: CGPoint(x: 65.1, y: 80.06))
		trINPath.close()
		return trINPath
	}

	func trOUT() -> CGPath {
		let bezier2Path = CGMutablePath()
		bezier2Path.move(to: CGPoint(x: 60, y: 80))
		bezier2Path.curve(to: CGPoint(x: 74.5, y: 74.5), controlPoint1: CGPoint(x: 63.43, y: 79.62), controlPoint2: CGPoint(x: 70.45, y: 78.55))
		bezier2Path.curve(to: CGPoint(x: 79.9, y: 60), controlPoint1: CGPoint(x: 78.55, y: 70.45), controlPoint2: CGPoint(x: 79.62, y: 63.43))
		bezier2Path.line(to: CGPoint(x: 80, y: 60))
		bezier2Path.curve(to: CGPoint(x: 80, y: 58), controlPoint1: CGPoint(x: 80, y: 60), controlPoint2: CGPoint(x: 80, y: 59.21))
		bezier2Path.curve(to: CGPoint(x: 80, y: 45), controlPoint1: CGPoint(x: 80, y: 53.92), controlPoint2: CGPoint(x: 80, y: 45))
		bezier2Path.line(to: CGPoint(x: 70, y: 45))
		bezier2Path.curve(to: CGPoint(x: 70, y: 52.5), controlPoint1: CGPoint(x: 70, y: 45), controlPoint2: CGPoint(x: 70, y: 48.75))
		bezier2Path.curve(to: CGPoint(x: 70, y: 59.39), controlPoint1: CGPoint(x: 70, y: 55.34), controlPoint2: CGPoint(x: 70, y: 58.18))
		bezier2Path.curve(to: CGPoint(x: 67, y: 67), controlPoint1: CGPoint(x: 69.79, y: 61.34), controlPoint2: CGPoint(x: 69.11, y: 64.89))
		bezier2Path.curve(to: CGPoint(x: 59.39, y: 70), controlPoint1: CGPoint(x: 64.89, y: 69.11), controlPoint2: CGPoint(x: 61.34, y: 69.79))
		bezier2Path.line(to: CGPoint(x: 45, y: 70))
		bezier2Path.line(to: CGPoint(x: 45, y: 80))
		bezier2Path.line(to: CGPoint(x: 60, y: 80))
		bezier2Path.line(to: CGPoint(x: 60, y: 80))
		bezier2Path.close()
		return bezier2Path
	}

	// MARK: - Top Left

	func tlIN() -> CGPath {
		let tlINPath = CGMutablePath()
		tlINPath.move(to: CGPoint(x: 22.9, y: 78.06))
		tlINPath.curve(to: CGPoint(x: 19.03, y: 71.61), controlPoint1: CGPoint(x: 20.9, y: 76.06), controlPoint2: CGPoint(x: 21.78, y: 74.36))
		tlINPath.curve(to: CGPoint(x: 12.57, y: 67.74), controlPoint1: CGPoint(x: 16.28, y: 68.86), controlPoint2: CGPoint(x: 15.16, y: 70.32))
		tlINPath.curve(to: CGPoint(x: 10, y: 60.1), controlPoint1: CGPoint(x: 10.2, y: 65.37), controlPoint2: CGPoint(x: 10.02, y: 60.83))
		tlINPath.curve(to: CGPoint(x: 10, y: 45), controlPoint1: CGPoint(x: 10, y: 60.1), controlPoint2: CGPoint(x: 10, y: 45))
		tlINPath.line(to: CGPoint(x: 20, y: 45))
		tlINPath.curve(to: CGPoint(x: 20, y: 52.59), controlPoint1: CGPoint(x: 20, y: 45), controlPoint2: CGPoint(x: 20, y: 48.8))
		tlINPath.curve(to: CGPoint(x: 20, y: 60), controlPoint1: CGPoint(x: 20, y: 55.99), controlPoint2: CGPoint(x: 20, y: 59.38))
		tlINPath.curve(to: CGPoint(x: 26, y: 64), controlPoint1: CGPoint(x: 20, y: 60), controlPoint2: CGPoint(x: 23.5, y: 61.5))
		tlINPath.curve(to: CGPoint(x: 30, y: 70), controlPoint1: CGPoint(x: 28.49, y: 66.49), controlPoint2: CGPoint(x: 29.99, y: 69.98))
		tlINPath.curve(to: CGPoint(x: 37.42, y: 70), controlPoint1: CGPoint(x: 30, y: 70), controlPoint2: CGPoint(x: 33.69, y: 70))
		tlINPath.curve(to: CGPoint(x: 45, y: 70), controlPoint1: CGPoint(x: 41.19, y: 70), controlPoint2: CGPoint(x: 45, y: 70))
		tlINPath.line(to: CGPoint(x: 45, y: 80))
		tlINPath.line(to: CGPoint(x: 30, y: 80))
		tlINPath.curve(to: CGPoint(x: 22.9, y: 78.06), controlPoint1: CGPoint(x: 30, y: 80), controlPoint2: CGPoint(x: 24.9, y: 80.06))
		tlINPath.close()
		return tlINPath
	}

	func tlOUT() -> CGPath {
		let tlOUTPath = CGMutablePath()
		tlOUTPath.move(to: CGPoint(x: 45, y: 80))
		tlOUTPath.curve(to: CGPoint(x: 45, y: 70), controlPoint1: CGPoint(x: 45, y: 80), controlPoint2: CGPoint(x: 45, y: 70))
		tlOUTPath.line(to: CGPoint(x: 30.61, y: 70))
		tlOUTPath.curve(to: CGPoint(x: 27.8, y: 69.49), controlPoint1: CGPoint(x: 29.85, y: 69.92), controlPoint2: CGPoint(x: 28.86, y: 69.76))
		tlOUTPath.curve(to: CGPoint(x: 23, y: 67), controlPoint1: CGPoint(x: 26.12, y: 69.05), controlPoint2: CGPoint(x: 24.29, y: 68.29))
		tlOUTPath.curve(to: CGPoint(x: 20, y: 59.39), controlPoint1: CGPoint(x: 20.89, y: 64.89), controlPoint2: CGPoint(x: 20.21, y: 61.34))
		tlOUTPath.curve(to: CGPoint(x: 20, y: 49.99), controlPoint1: CGPoint(x: 20, y: 59.39), controlPoint2: CGPoint(x: 20, y: 54.14))
		tlOUTPath.curve(to: CGPoint(x: 20, y: 45.04), controlPoint1: CGPoint(x: 20, y: 47.28), controlPoint2: CGPoint(x: 20, y: 45.04))
		tlOUTPath.curve(to: CGPoint(x: 18.01, y: 45.03), controlPoint1: CGPoint(x: 20, y: 45.04), controlPoint2: CGPoint(x: 19.18, y: 45.04))
		tlOUTPath.curve(to: CGPoint(x: 10, y: 45), controlPoint1: CGPoint(x: 15.1, y: 45.02), controlPoint2: CGPoint(x: 10, y: 45))
		tlOUTPath.curve(to: CGPoint(x: 10, y: 58), controlPoint1: CGPoint(x: 10, y: 45), controlPoint2: CGPoint(x: 10, y: 53.92))
		tlOUTPath.curve(to: CGPoint(x: 10, y: 60), controlPoint1: CGPoint(x: 10, y: 59.21), controlPoint2: CGPoint(x: 10, y: 60))
		tlOUTPath.line(to: CGPoint(x: 10.1, y: 60))
		tlOUTPath.curve(to: CGPoint(x: 15.5, y: 74.5), controlPoint1: CGPoint(x: 10.38, y: 63.43), controlPoint2: CGPoint(x: 11.45, y: 70.45))
		tlOUTPath.curve(to: CGPoint(x: 30, y: 79.9), controlPoint1: CGPoint(x: 19.55, y: 78.55), controlPoint2: CGPoint(x: 26.57, y: 79.62))
		tlOUTPath.line(to: CGPoint(x: 45, y: 80))
		tlOUTPath.line(to: CGPoint(x: 45, y: 80))
		tlOUTPath.close()
		return tlOUTPath
	}

	// MARK: - Bottom Right

	func brIN() -> CGPath {
		let brINPath = CGMutablePath()
		brINPath.move(to: CGPoint(x: 67.1, y: 11.94))
		brINPath.curve(to: CGPoint(x: 70.97, y: 18.39), controlPoint1: CGPoint(x: 69.1, y: 13.94), controlPoint2: CGPoint(x: 68.22, y: 15.64))
		brINPath.curve(to: CGPoint(x: 77.43, y: 22.26), controlPoint1: CGPoint(x: 73.72, y: 21.14), controlPoint2: CGPoint(x: 74.84, y: 19.68))
		brINPath.curve(to: CGPoint(x: 80, y: 29.9), controlPoint1: CGPoint(x: 79.8, y: 24.63), controlPoint2: CGPoint(x: 79.98, y: 29.17))
		brINPath.curve(to: CGPoint(x: 80, y: 45), controlPoint1: CGPoint(x: 80, y: 29.9), controlPoint2: CGPoint(x: 80, y: 45))
		brINPath.line(to: CGPoint(x: 70, y: 45))
		brINPath.curve(to: CGPoint(x: 70, y: 37.41), controlPoint1: CGPoint(x: 70, y: 45), controlPoint2: CGPoint(x: 70, y: 41.2))
		brINPath.curve(to: CGPoint(x: 70, y: 30), controlPoint1: CGPoint(x: 70, y: 34.01), controlPoint2: CGPoint(x: 70, y: 30.62))
		brINPath.curve(to: CGPoint(x: 64, y: 26), controlPoint1: CGPoint(x: 70, y: 30), controlPoint2: CGPoint(x: 66.5, y: 28.5))
		brINPath.curve(to: CGPoint(x: 60, y: 20), controlPoint1: CGPoint(x: 61.51, y: 23.51), controlPoint2: CGPoint(x: 60.01, y: 20.02))
		brINPath.curve(to: CGPoint(x: 52.58, y: 20), controlPoint1: CGPoint(x: 60, y: 20), controlPoint2: CGPoint(x: 56.31, y: 20))
		brINPath.curve(to: CGPoint(x: 45, y: 20), controlPoint1: CGPoint(x: 48.81, y: 20), controlPoint2: CGPoint(x: 45, y: 20))
		brINPath.line(to: CGPoint(x: 45, y: 10))
		brINPath.line(to: CGPoint(x: 60, y: 10))
		brINPath.curve(to: CGPoint(x: 67.1, y: 11.94), controlPoint1: CGPoint(x: 60, y: 10), controlPoint2: CGPoint(x: 65.1, y: 9.94))
		brINPath.close()
		return brINPath
	}


	func brOUT() -> CGPath {
		let brOUTPath = CGMutablePath()
		brOUTPath.move(to: CGPoint(x: 80, y: 45))
		brOUTPath.curve(to: CGPoint(x: 80, y: 32), controlPoint1: CGPoint(x: 80, y: 45), controlPoint2: CGPoint(x: 80, y: 36.08))
		brOUTPath.curve(to: CGPoint(x: 80, y: 30), controlPoint1: CGPoint(x: 80, y: 30.79), controlPoint2: CGPoint(x: 80, y: 30))
		brOUTPath.line(to: CGPoint(x: 79.9, y: 30))
		brOUTPath.curve(to: CGPoint(x: 74.5, y: 15.5), controlPoint1: CGPoint(x: 79.62, y: 26.57), controlPoint2: CGPoint(x: 78.55, y: 19.55))
		brOUTPath.curve(to: CGPoint(x: 60, y: 10.1), controlPoint1: CGPoint(x: 70.45, y: 11.45), controlPoint2: CGPoint(x: 63.43, y: 10.38))
		brOUTPath.line(to: CGPoint(x: 45, y: 10))
		brOUTPath.line(to: CGPoint(x: 45, y: 20))
		brOUTPath.line(to: CGPoint(x: 59.39, y: 20))
		brOUTPath.curve(to: CGPoint(x: 67, y: 23), controlPoint1: CGPoint(x: 61.34, y: 20.21), controlPoint2: CGPoint(x: 64.89, y: 20.89))
		brOUTPath.curve(to: CGPoint(x: 70, y: 30.61), controlPoint1: CGPoint(x: 69.11, y: 25.11), controlPoint2: CGPoint(x: 69.79, y: 28.66))
		brOUTPath.curve(to: CGPoint(x: 70, y: 39.38), controlPoint1: CGPoint(x: 70, y: 32.09), controlPoint2: CGPoint(x: 70, y: 36))
		brOUTPath.curve(to: CGPoint(x: 70, y: 45), controlPoint1: CGPoint(x: 70, y: 42.41), controlPoint2: CGPoint(x: 70, y: 45))
		brOUTPath.line(to: CGPoint(x: 80, y: 45))
		brOUTPath.line(to: CGPoint(x: 80, y: 45))
		brOUTPath.close()
		return brOUTPath
	}

	// MARK: - Bottom Left

	func blIN() -> CGPath {
		let blINPath = CGMutablePath()
		blINPath.move(to: CGPoint(x: 22.9, y: 11.94))
		blINPath.curve(to: CGPoint(x: 19.03, y: 18.39), controlPoint1: CGPoint(x: 20.9, y: 13.94), controlPoint2: CGPoint(x: 21.78, y: 15.64))
		blINPath.curve(to: CGPoint(x: 12.57, y: 22.26), controlPoint1: CGPoint(x: 16.28, y: 21.14), controlPoint2: CGPoint(x: 15.16, y: 19.68))
		blINPath.curve(to: CGPoint(x: 10, y: 29.9), controlPoint1: CGPoint(x: 10.2, y: 24.63), controlPoint2: CGPoint(x: 10.02, y: 29.17))
		blINPath.curve(to: CGPoint(x: 10, y: 45), controlPoint1: CGPoint(x: 10, y: 29.9), controlPoint2: CGPoint(x: 10, y: 45))
		blINPath.line(to: CGPoint(x: 20, y: 45))
		blINPath.curve(to: CGPoint(x: 20, y: 37.41), controlPoint1: CGPoint(x: 20, y: 45), controlPoint2: CGPoint(x: 20, y: 41.2))
		blINPath.curve(to: CGPoint(x: 20, y: 30), controlPoint1: CGPoint(x: 20, y: 34.01), controlPoint2: CGPoint(x: 20, y: 30.62))
		blINPath.curve(to: CGPoint(x: 26, y: 26), controlPoint1: CGPoint(x: 20, y: 30), controlPoint2: CGPoint(x: 23.5, y: 28.5))
		blINPath.curve(to: CGPoint(x: 30, y: 20), controlPoint1: CGPoint(x: 28.49, y: 23.51), controlPoint2: CGPoint(x: 29.99, y: 20.02))
		blINPath.curve(to: CGPoint(x: 37.42, y: 20), controlPoint1: CGPoint(x: 30, y: 20), controlPoint2: CGPoint(x: 33.69, y: 20))
		blINPath.curve(to: CGPoint(x: 45, y: 20), controlPoint1: CGPoint(x: 41.19, y: 20), controlPoint2: CGPoint(x: 45, y: 20))
		blINPath.line(to: CGPoint(x: 45, y: 10))
		blINPath.line(to: CGPoint(x: 30, y: 10))
		blINPath.curve(to: CGPoint(x: 22.9, y: 11.94), controlPoint1: CGPoint(x: 30, y: 10), controlPoint2: CGPoint(x: 24.9, y: 9.94))
		blINPath.close()
		return blINPath
	}

	func blOUT() -> CGPath {
		let blOUTPath = CGMutablePath()
		blOUTPath.move(to: CGPoint(x: 20, y: 45))
		blOUTPath.curve(to: CGPoint(x: 20, y: 30.61), controlPoint1: CGPoint(x: 20, y: 45), controlPoint2: CGPoint(x: 20, y: 33.42))
		blOUTPath.curve(to: CGPoint(x: 23, y: 23), controlPoint1: CGPoint(x: 20.21, y: 28.66), controlPoint2: CGPoint(x: 20.89, y: 25.11))
		blOUTPath.curve(to: CGPoint(x: 30.61, y: 20), controlPoint1: CGPoint(x: 25.11, y: 20.89), controlPoint2: CGPoint(x: 28.66, y: 20.21))
		blOUTPath.line(to: CGPoint(x: 45, y: 20))
		blOUTPath.line(to: CGPoint(x: 45, y: 10))
		blOUTPath.line(to: CGPoint(x: 30, y: 10))
		blOUTPath.curve(to: CGPoint(x: 15.5, y: 15.5), controlPoint1: CGPoint(x: 26.57, y: 10.38), controlPoint2: CGPoint(x: 19.55, y: 11.45))
		blOUTPath.curve(to: CGPoint(x: 12.47, y: 20.05), controlPoint1: CGPoint(x: 14.21, y: 16.79), controlPoint2: CGPoint(x: 13.23, y: 18.38))
		blOUTPath.curve(to: CGPoint(x: 10.1, y: 30), controlPoint1: CGPoint(x: 10.85, y: 23.65), controlPoint2: CGPoint(x: 10.29, y: 27.66))
		blOUTPath.line(to: CGPoint(x: 10, y: 30))
		blOUTPath.curve(to: CGPoint(x: 10, y: 32), controlPoint1: CGPoint(x: 10, y: 30), controlPoint2: CGPoint(x: 10, y: 30.79))
		blOUTPath.curve(to: CGPoint(x: 10, y: 45), controlPoint1: CGPoint(x: 10, y: 36.08), controlPoint2: CGPoint(x: 10, y: 45))
		blOUTPath.line(to: CGPoint(x: 20, y: 45))
		blOUTPath.line(to: CGPoint(x: 20, y: 45))
		blOUTPath.close()
		return blOUTPath
	}
}
