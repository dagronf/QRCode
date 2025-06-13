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

public extension QRCode.EyeShape {
	@objc(QRCodeEyeShapeHolePunch) class HolePunch: NSObject, QRCodeEyeShapeGenerator {
		@objc public static let Name = "holePunch"
		@objc public static var Title: String { "Hole Punch" }
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodeEyeShapeGenerator { HolePunch() }

		@objc public func settings() -> [String: Any] { return [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		/// Make a copy of this shape generator
		@objc public func copyShape() -> any QRCodeEyeShapeGenerator { HolePunch() }

		/// Reset the eye shape generator back to defaults
		@objc public func reset() { }

		/// Returns the path representing the eye-outer shape
		public func eyePath() -> CGPath { eyeFrameOuter__ }
		/// Returns the path representing the background shape for the entire eye
		public func eyeBackgroundPath() -> CGPath { eyeFrameBackground__ }

		private static let _defaultPupil = QRCode.PupilShape.Circle()
		/// Returns the generator for the default pixel shape 
		public func defaultPupil() -> any QRCodePupilShapeGenerator { Self._defaultPupil }
	}
}

public extension QRCodeEyeShapeGenerator where Self == QRCode.EyeShape.HolePunch {
	/// Create a dot drag eye shape generator
	/// - Returns: An eye shape generator
	@inlinable static func holePunch() -> QRCodeEyeShapeGenerator { QRCode.EyeShape.HolePunch() }
}

// MARK: - Path generation

private let eyeFrameBackground__ = CGPath.make { eyebackgroundPath in
	eyebackgroundPath.move(to: CGPoint(x: 0, y: 0))
	eyebackgroundPath.line(to: CGPoint(x: 90, y: 0))
	eyebackgroundPath.line(to: CGPoint(x: 90, y: 90))
	eyebackgroundPath.line(to: CGPoint(x: 0, y: 90))
	eyebackgroundPath.line(to: CGPoint(x: 0, y: 0))
	eyebackgroundPath.close()
}

private let eyeFrameOuter__ = CGPath.make { eyeouterPath in
	eyeouterPath.move(to: CGPoint(x: 45, y: 70))
	eyeouterPath.curve(to: CGPoint(x: 20, y: 45), controlPoint1: CGPoint(x: 31.19, y: 70), controlPoint2: CGPoint(x: 20, y: 58.81))
	eyeouterPath.curve(to: CGPoint(x: 34.91, y: 22.12), controlPoint1: CGPoint(x: 20, y: 34.78), controlPoint2: CGPoint(x: 26.13, y: 26))
	eyeouterPath.curve(to: CGPoint(x: 45, y: 20), controlPoint1: CGPoint(x: 37.99, y: 20.76), controlPoint2: CGPoint(x: 41.41, y: 20))
	eyeouterPath.curve(to: CGPoint(x: 70, y: 45), controlPoint1: CGPoint(x: 58.81, y: 20), controlPoint2: CGPoint(x: 70, y: 31.19))
	eyeouterPath.curve(to: CGPoint(x: 45, y: 70), controlPoint1: CGPoint(x: 70, y: 58.81), controlPoint2: CGPoint(x: 58.81, y: 70))
	eyeouterPath.close()
	eyeouterPath.move(to: CGPoint(x: 80, y: 80))
	eyeouterPath.curve(to: CGPoint(x: 80, y: 10), controlPoint1: CGPoint(x: 80, y: 80), controlPoint2: CGPoint(x: 80, y: 10))
	eyeouterPath.line(to: CGPoint(x: 10, y: 10))
	eyeouterPath.line(to: CGPoint(x: 10, y: 80))
	eyeouterPath.line(to: CGPoint(x: 80, y: 80))
	eyeouterPath.line(to: CGPoint(x: 80, y: 80))
	eyeouterPath.close()
}
