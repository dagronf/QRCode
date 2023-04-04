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
		@objc public static var Title: String { NSLocalizedString("eyestyle.shield", bundle: .localization, comment: "Shield eye generator title") }

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
		let bezier2Path = CGMutablePath()
		bezier2Path.move(to: NSPoint(x: 67.9, y: 80))
		bezier2Path.curve(to: NSPoint(x: 71, y: 71), controlPoint1: NSPoint(x: 67.9, y: 80), controlPoint2: NSPoint(x: 67.98, y: 74.03))
		bezier2Path.curve(to: NSPoint(x: 80, y: 67.9), controlPoint1: NSPoint(x: 74.03, y: 67.98), controlPoint2: NSPoint(x: 80, y: 67.9))
		bezier2Path.curve(to: NSPoint(x: 80, y: 60), controlPoint1: NSPoint(x: 80, y: 67.9), controlPoint2: NSPoint(x: 80, y: 62.89))
		bezier2Path.curve(to: NSPoint(x: 80, y: 58), controlPoint1: NSPoint(x: 80, y: 58.83), controlPoint2: NSPoint(x: 80, y: 58))
		bezier2Path.curve(to: NSPoint(x: 80, y: 45), controlPoint1: NSPoint(x: 80, y: 53.92), controlPoint2: NSPoint(x: 80, y: 45))
		bezier2Path.line(to: NSPoint(x: 70, y: 45))
		bezier2Path.curve(to: NSPoint(x: 70, y: 52.5), controlPoint1: NSPoint(x: 70, y: 45), controlPoint2: NSPoint(x: 70, y: 48.75))
		bezier2Path.curve(to: NSPoint(x: 70, y: 59.7), controlPoint1: NSPoint(x: 70, y: 55.63), controlPoint2: NSPoint(x: 70, y: 58.75))
		bezier2Path.curve(to: NSPoint(x: 63.5, y: 63.5), controlPoint1: NSPoint(x: 67.63, y: 60.52), controlPoint2: NSPoint(x: 65.28, y: 61.72))
		bezier2Path.curve(to: NSPoint(x: 59.7, y: 70), controlPoint1: NSPoint(x: 61.72, y: 65.28), controlPoint2: NSPoint(x: 60.52, y: 67.63))
		bezier2Path.line(to: NSPoint(x: 45, y: 70))
		bezier2Path.line(to: NSPoint(x: 45, y: 80))
		bezier2Path.line(to: NSPoint(x: 67.9, y: 80))
		bezier2Path.line(to: NSPoint(x: 67.9, y: 80))
		bezier2Path.close()
		return bezier2Path
	}

	func trOUT() -> CGPath {
		let bezier2Path = CGMutablePath()
		bezier2Path.move(to: NSPoint(x: 60, y: 80))
		bezier2Path.curve(to: NSPoint(x: 74.5, y: 74.5), controlPoint1: NSPoint(x: 63.43, y: 79.62), controlPoint2: NSPoint(x: 70.45, y: 78.55))
		bezier2Path.curve(to: NSPoint(x: 79.9, y: 60), controlPoint1: NSPoint(x: 78.55, y: 70.45), controlPoint2: NSPoint(x: 79.62, y: 63.43))
		bezier2Path.line(to: NSPoint(x: 80, y: 60))
		bezier2Path.curve(to: NSPoint(x: 80, y: 58), controlPoint1: NSPoint(x: 80, y: 60), controlPoint2: NSPoint(x: 80, y: 59.21))
		bezier2Path.curve(to: NSPoint(x: 80, y: 45), controlPoint1: NSPoint(x: 80, y: 53.92), controlPoint2: NSPoint(x: 80, y: 45))
		bezier2Path.line(to: NSPoint(x: 70, y: 45))
		bezier2Path.curve(to: NSPoint(x: 70, y: 52.5), controlPoint1: NSPoint(x: 70, y: 45), controlPoint2: NSPoint(x: 70, y: 48.75))
		bezier2Path.curve(to: NSPoint(x: 70, y: 59.39), controlPoint1: NSPoint(x: 70, y: 55.34), controlPoint2: NSPoint(x: 70, y: 58.18))
		bezier2Path.curve(to: NSPoint(x: 67, y: 67), controlPoint1: NSPoint(x: 69.79, y: 61.34), controlPoint2: NSPoint(x: 69.11, y: 64.89))
		bezier2Path.curve(to: NSPoint(x: 59.39, y: 70), controlPoint1: NSPoint(x: 64.89, y: 69.11), controlPoint2: NSPoint(x: 61.34, y: 69.79))
		bezier2Path.line(to: NSPoint(x: 45, y: 70))
		bezier2Path.line(to: NSPoint(x: 45, y: 80))
		bezier2Path.line(to: NSPoint(x: 60, y: 80))
		bezier2Path.line(to: NSPoint(x: 60, y: 80))
		bezier2Path.close()
		return bezier2Path
	}

	// MARK: - Top Left

	func tlIN() -> CGPath {
		let tlINPath = CGMutablePath()
		tlINPath.move(to: NSPoint(x: 45, y: 80))
		tlINPath.curve(to: NSPoint(x: 45, y: 70), controlPoint1: NSPoint(x: 45, y: 80), controlPoint2: NSPoint(x: 45, y: 70))
		tlINPath.line(to: NSPoint(x: 30.3, y: 70))
		tlINPath.curve(to: NSPoint(x: 26.5, y: 63.5), controlPoint1: NSPoint(x: 29.48, y: 67.63), controlPoint2: NSPoint(x: 28.28, y: 65.28))
		tlINPath.curve(to: NSPoint(x: 24.85, y: 62.11), controlPoint1: NSPoint(x: 25.99, y: 62.99), controlPoint2: NSPoint(x: 25.44, y: 62.53))
		tlINPath.curve(to: NSPoint(x: 20, y: 59.7), controlPoint1: NSPoint(x: 23.38, y: 61.07), controlPoint2: NSPoint(x: 21.69, y: 60.29))
		tlINPath.curve(to: NSPoint(x: 20, y: 49.99), controlPoint1: NSPoint(x: 20, y: 58.49), controlPoint2: NSPoint(x: 20, y: 53.76))
		tlINPath.curve(to: NSPoint(x: 20, y: 45), controlPoint1: NSPoint(x: 20, y: 47.24), controlPoint2: NSPoint(x: 20, y: 45))
		tlINPath.line(to: NSPoint(x: 10, y: 45))
		tlINPath.curve(to: NSPoint(x: 10, y: 58), controlPoint1: NSPoint(x: 10, y: 45), controlPoint2: NSPoint(x: 10, y: 53.92))
		tlINPath.curve(to: NSPoint(x: 10, y: 60), controlPoint1: NSPoint(x: 10, y: 58), controlPoint2: NSPoint(x: 10, y: 58.83))
		tlINPath.curve(to: NSPoint(x: 10, y: 67.9), controlPoint1: NSPoint(x: 10, y: 62.89), controlPoint2: NSPoint(x: 10, y: 67.9))
		tlINPath.curve(to: NSPoint(x: 19, y: 71), controlPoint1: NSPoint(x: 10, y: 67.9), controlPoint2: NSPoint(x: 15.98, y: 67.98))
		tlINPath.curve(to: NSPoint(x: 19.93, y: 72.15), controlPoint1: NSPoint(x: 19.35, y: 71.35), controlPoint2: NSPoint(x: 19.66, y: 71.74))
		tlINPath.curve(to: NSPoint(x: 22.1, y: 80), controlPoint1: NSPoint(x: 22.04, y: 75.32), controlPoint2: NSPoint(x: 22.1, y: 80))
		tlINPath.line(to: NSPoint(x: 45, y: 80))
		tlINPath.line(to: NSPoint(x: 45, y: 80))
		tlINPath.close()
		return tlINPath
	}

	func tlOUT() -> CGPath {
		let tlOUTPath = CGMutablePath()
		tlOUTPath.move(to: NSPoint(x: 45, y: 80))
		tlOUTPath.curve(to: NSPoint(x: 45, y: 70), controlPoint1: NSPoint(x: 45, y: 80), controlPoint2: NSPoint(x: 45, y: 70))
		tlOUTPath.line(to: NSPoint(x: 30.61, y: 70))
		tlOUTPath.curve(to: NSPoint(x: 27.8, y: 69.49), controlPoint1: NSPoint(x: 29.85, y: 69.92), controlPoint2: NSPoint(x: 28.86, y: 69.76))
		tlOUTPath.curve(to: NSPoint(x: 23, y: 67), controlPoint1: NSPoint(x: 26.12, y: 69.05), controlPoint2: NSPoint(x: 24.29, y: 68.29))
		tlOUTPath.curve(to: NSPoint(x: 20, y: 59.39), controlPoint1: NSPoint(x: 20.89, y: 64.89), controlPoint2: NSPoint(x: 20.21, y: 61.34))
		tlOUTPath.curve(to: NSPoint(x: 20, y: 49.99), controlPoint1: NSPoint(x: 20, y: 59.39), controlPoint2: NSPoint(x: 20, y: 54.14))
		tlOUTPath.curve(to: NSPoint(x: 20, y: 45.04), controlPoint1: NSPoint(x: 20, y: 47.28), controlPoint2: NSPoint(x: 20, y: 45.04))
		tlOUTPath.curve(to: NSPoint(x: 18.01, y: 45.03), controlPoint1: NSPoint(x: 20, y: 45.04), controlPoint2: NSPoint(x: 19.18, y: 45.04))
		tlOUTPath.curve(to: NSPoint(x: 10, y: 45), controlPoint1: NSPoint(x: 15.1, y: 45.02), controlPoint2: NSPoint(x: 10, y: 45))
		tlOUTPath.curve(to: NSPoint(x: 10, y: 58), controlPoint1: NSPoint(x: 10, y: 45), controlPoint2: NSPoint(x: 10, y: 53.92))
		tlOUTPath.curve(to: NSPoint(x: 10, y: 60), controlPoint1: NSPoint(x: 10, y: 59.21), controlPoint2: NSPoint(x: 10, y: 60))
		tlOUTPath.line(to: NSPoint(x: 10.1, y: 60))
		tlOUTPath.curve(to: NSPoint(x: 15.5, y: 74.5), controlPoint1: NSPoint(x: 10.38, y: 63.43), controlPoint2: NSPoint(x: 11.45, y: 70.45))
		tlOUTPath.curve(to: NSPoint(x: 30, y: 79.9), controlPoint1: NSPoint(x: 19.55, y: 78.55), controlPoint2: NSPoint(x: 26.57, y: 79.62))
		tlOUTPath.line(to: NSPoint(x: 45, y: 80))
		tlOUTPath.line(to: NSPoint(x: 45, y: 80))
		tlOUTPath.close()
		return tlOUTPath
	}

	// MARK: - Bottom Right

	func brIN() -> CGPath {
		let brINPath = CGMutablePath()
		brINPath.move(to: NSPoint(x: 80, y: 45))
		brINPath.curve(to: NSPoint(x: 80, y: 32), controlPoint1: NSPoint(x: 80, y: 45), controlPoint2: NSPoint(x: 80, y: 36.08))
		brINPath.curve(to: NSPoint(x: 80, y: 30), controlPoint1: NSPoint(x: 80, y: 30.79), controlPoint2: NSPoint(x: 80, y: 30))
		brINPath.curve(to: NSPoint(x: 80, y: 22.1), controlPoint1: NSPoint(x: 80, y: 27.11), controlPoint2: NSPoint(x: 80, y: 22.1))
		brINPath.curve(to: NSPoint(x: 71, y: 19), controlPoint1: NSPoint(x: 80, y: 22.1), controlPoint2: NSPoint(x: 74.03, y: 22.03))
		brINPath.curve(to: NSPoint(x: 67.9, y: 10), controlPoint1: NSPoint(x: 67.98, y: 15.98), controlPoint2: NSPoint(x: 67.9, y: 10))
		brINPath.line(to: NSPoint(x: 45, y: 10))
		brINPath.line(to: NSPoint(x: 45, y: 20))
		brINPath.line(to: NSPoint(x: 59.7, y: 20))
		brINPath.curve(to: NSPoint(x: 63.5, y: 26.5), controlPoint1: NSPoint(x: 60.52, y: 22.37), controlPoint2: NSPoint(x: 61.72, y: 24.72))
		brINPath.curve(to: NSPoint(x: 70, y: 30.3), controlPoint1: NSPoint(x: 65.28, y: 28.28), controlPoint2: NSPoint(x: 67.63, y: 29.48))
		brINPath.curve(to: NSPoint(x: 70, y: 39.38), controlPoint1: NSPoint(x: 70, y: 31.44), controlPoint2: NSPoint(x: 70, y: 35.73))
		brINPath.curve(to: NSPoint(x: 70, y: 45), controlPoint1: NSPoint(x: 70, y: 42.41), controlPoint2: NSPoint(x: 70, y: 45))
		brINPath.line(to: NSPoint(x: 80, y: 45))
		brINPath.line(to: NSPoint(x: 80, y: 45))
		brINPath.close()
		return brINPath
	}


	func brOUT() -> CGPath {
		let brOUTPath = CGMutablePath()
		brOUTPath.move(to: NSPoint(x: 80, y: 45))
		brOUTPath.curve(to: NSPoint(x: 80, y: 32), controlPoint1: NSPoint(x: 80, y: 45), controlPoint2: NSPoint(x: 80, y: 36.08))
		brOUTPath.curve(to: NSPoint(x: 80, y: 30), controlPoint1: NSPoint(x: 80, y: 30.79), controlPoint2: NSPoint(x: 80, y: 30))
		brOUTPath.line(to: NSPoint(x: 79.9, y: 30))
		brOUTPath.curve(to: NSPoint(x: 74.5, y: 15.5), controlPoint1: NSPoint(x: 79.62, y: 26.57), controlPoint2: NSPoint(x: 78.55, y: 19.55))
		brOUTPath.curve(to: NSPoint(x: 60, y: 10.1), controlPoint1: NSPoint(x: 70.45, y: 11.45), controlPoint2: NSPoint(x: 63.43, y: 10.38))
		brOUTPath.line(to: NSPoint(x: 45, y: 10))
		brOUTPath.line(to: NSPoint(x: 45, y: 20))
		brOUTPath.line(to: NSPoint(x: 59.39, y: 20))
		brOUTPath.curve(to: NSPoint(x: 67, y: 23), controlPoint1: NSPoint(x: 61.34, y: 20.21), controlPoint2: NSPoint(x: 64.89, y: 20.89))
		brOUTPath.curve(to: NSPoint(x: 70, y: 30.61), controlPoint1: NSPoint(x: 69.11, y: 25.11), controlPoint2: NSPoint(x: 69.79, y: 28.66))
		brOUTPath.curve(to: NSPoint(x: 70, y: 39.38), controlPoint1: NSPoint(x: 70, y: 32.09), controlPoint2: NSPoint(x: 70, y: 36))
		brOUTPath.curve(to: NSPoint(x: 70, y: 45), controlPoint1: NSPoint(x: 70, y: 42.41), controlPoint2: NSPoint(x: 70, y: 45))
		brOUTPath.line(to: NSPoint(x: 80, y: 45))
		brOUTPath.line(to: NSPoint(x: 80, y: 45))
		brOUTPath.close()
		return brOUTPath
	}

	// MARK: - Bottom Left

	func blIN() -> CGPath {
		let blINPath = CGMutablePath()
		blINPath.move(to: NSPoint(x: 20, y: 45))
		blINPath.curve(to: NSPoint(x: 20, y: 30.3), controlPoint1: NSPoint(x: 20, y: 45), controlPoint2: NSPoint(x: 20, y: 32.4))
		blINPath.curve(to: NSPoint(x: 26.5, y: 26.5), controlPoint1: NSPoint(x: 22.37, y: 29.48), controlPoint2: NSPoint(x: 24.72, y: 28.28))
		blINPath.curve(to: NSPoint(x: 30.3, y: 20), controlPoint1: NSPoint(x: 28.28, y: 24.72), controlPoint2: NSPoint(x: 29.48, y: 22.37))
		blINPath.line(to: NSPoint(x: 45, y: 20))
		blINPath.line(to: NSPoint(x: 45, y: 10))
		blINPath.line(to: NSPoint(x: 22.1, y: 10))
		blINPath.curve(to: NSPoint(x: 19, y: 19), controlPoint1: NSPoint(x: 22.1, y: 10), controlPoint2: NSPoint(x: 22.03, y: 15.98))
		blINPath.curve(to: NSPoint(x: 10, y: 22.1), controlPoint1: NSPoint(x: 15.98, y: 22.03), controlPoint2: NSPoint(x: 10, y: 22.1))
		blINPath.curve(to: NSPoint(x: 10, y: 30), controlPoint1: NSPoint(x: 10, y: 22.1), controlPoint2: NSPoint(x: 10, y: 27.11))
		blINPath.curve(to: NSPoint(x: 10, y: 32), controlPoint1: NSPoint(x: 10, y: 30), controlPoint2: NSPoint(x: 10, y: 30.79))
		blINPath.curve(to: NSPoint(x: 10, y: 45), controlPoint1: NSPoint(x: 10, y: 36.08), controlPoint2: NSPoint(x: 10, y: 45))
		blINPath.line(to: NSPoint(x: 20, y: 45))
		blINPath.line(to: NSPoint(x: 20, y: 45))
		blINPath.close()
		return blINPath
	}

	func blOUT() -> CGPath {
		let blOUTPath = CGMutablePath()
		blOUTPath.move(to: NSPoint(x: 20, y: 45))
		blOUTPath.curve(to: NSPoint(x: 20, y: 30.61), controlPoint1: NSPoint(x: 20, y: 45), controlPoint2: NSPoint(x: 20, y: 33.42))
		blOUTPath.curve(to: NSPoint(x: 23, y: 23), controlPoint1: NSPoint(x: 20.21, y: 28.66), controlPoint2: NSPoint(x: 20.89, y: 25.11))
		blOUTPath.curve(to: NSPoint(x: 30.61, y: 20), controlPoint1: NSPoint(x: 25.11, y: 20.89), controlPoint2: NSPoint(x: 28.66, y: 20.21))
		blOUTPath.line(to: NSPoint(x: 45, y: 20))
		blOUTPath.line(to: NSPoint(x: 45, y: 10))
		blOUTPath.line(to: NSPoint(x: 30, y: 10))
		blOUTPath.curve(to: NSPoint(x: 15.5, y: 15.5), controlPoint1: NSPoint(x: 26.57, y: 10.38), controlPoint2: NSPoint(x: 19.55, y: 11.45))
		blOUTPath.curve(to: NSPoint(x: 12.47, y: 20.05), controlPoint1: NSPoint(x: 14.21, y: 16.79), controlPoint2: NSPoint(x: 13.23, y: 18.38))
		blOUTPath.curve(to: NSPoint(x: 10.1, y: 30), controlPoint1: NSPoint(x: 10.85, y: 23.65), controlPoint2: NSPoint(x: 10.29, y: 27.66))
		blOUTPath.line(to: NSPoint(x: 10, y: 30))
		blOUTPath.curve(to: NSPoint(x: 10, y: 32), controlPoint1: NSPoint(x: 10, y: 30), controlPoint2: NSPoint(x: 10, y: 30.79))
		blOUTPath.curve(to: NSPoint(x: 10, y: 45), controlPoint1: NSPoint(x: 10, y: 36.08), controlPoint2: NSPoint(x: 10, y: 45))
		blOUTPath.line(to: NSPoint(x: 20, y: 45))
		blOUTPath.line(to: NSPoint(x: 20, y: 45))
		blOUTPath.close()
		return blOUTPath
	}
}
