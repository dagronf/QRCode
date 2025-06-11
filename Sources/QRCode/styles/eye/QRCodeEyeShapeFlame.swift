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
	/// A 'flame' style eye design
	@objc(QRCodeEyeShapeFlame) class Flame: NSObject, QRCodeEyeShapeGenerator {
		@objc public static let Name = "flame"
		@objc public static var Title: String { "Flame" }
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodeEyeShapeGenerator {
			return QRCode.EyeShape.Flame()
		}

		@objc public func settings() -> [String: Any] { return [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodeEyeShapeGenerator { Flame() }

		/// Reset the eye shape generator back to defaults
		@objc public func reset() { }

		private static let _defaultPupil = QRCode.PupilShape.Flame()
		public func defaultPupil() -> any QRCodePupilShapeGenerator { Self._defaultPupil }
	}
}

public extension QRCodeEyeShapeGenerator where Self == QRCode.EyeShape.Flame {
	/// Create a flame eye shape generator
	/// - Returns: An eye shape generator
	@inlinable static func flame() -> QRCodeEyeShapeGenerator { QRCode.EyeShape.Flame() }
}

public extension QRCode.EyeShape.Flame {
	func eyePath() -> CGPath { eyePath__ }
	func eyeBackgroundPath() -> CGPath { eyeBackgroundPath__ }
}

// MARK: - Designs

private let eyePath__ = CGPath.make { flameeyePath in
	flameeyePath.move(to: CGPoint(x: 21, y: 70))
	flameeyePath.line(to: CGPoint(x: 23.72, y: 27.78))
	flameeyePath.curve(to: CGPoint(x: 31.34, y: 20), controlPoint1: CGPoint(x: 24, y: 20), controlPoint2: CGPoint(x: 25, y: 20))
	flameeyePath.line(to: CGPoint(x: 70, y: 20))
	flameeyePath.line(to: CGPoint(x: 70, y: 59))
	flameeyePath.curve(to: CGPoint(x: 65, y: 67), controlPoint1: CGPoint(x: 70, y: 65.56), controlPoint2: CGPoint(x: 70.05, y: 66.75))
	flameeyePath.line(to: CGPoint(x: 21, y: 70))
	flameeyePath.close()
	flameeyePath.move(to: CGPoint(x: 10, y: 80))
	flameeyePath.curve(to: CGPoint(x: 69.11, y: 76.11), controlPoint1: CGPoint(x: 10, y: 80), controlPoint2: CGPoint(x: 69.11, y: 76.11))
	flameeyePath.curve(to: CGPoint(x: 80, y: 65.22), controlPoint1: CGPoint(x: 75.12, y: 76.11), controlPoint2: CGPoint(x: 80, y: 71.24))
	flameeyePath.line(to: CGPoint(x: 80, y: 10))
	flameeyePath.line(to: CGPoint(x: 24.78, y: 10))
	flameeyePath.curve(to: CGPoint(x: 13.89, y: 20.89), controlPoint1: CGPoint(x: 18.76, y: 10), controlPoint2: CGPoint(x: 13.89, y: 14.88))
	flameeyePath.line(to: CGPoint(x: 10, y: 80))
	flameeyePath.line(to: CGPoint(x: 10, y: 80))
	flameeyePath.close()
}.flippedVertically(height: 90)

private let eyeBackgroundPath__ = CGPath.make { flameeyebackgroundPath in
	flameeyebackgroundPath.move(to: CGPoint(x: 5, y: 14))
	flameeyebackgroundPath.curve(to: CGPoint(x: 19, y: 0), controlPoint1: CGPoint(x: 5, y: 6.27), controlPoint2: CGPoint(x: 11.27, y: 0))
	flameeyebackgroundPath.line(to: CGPoint(x: 90, y: 0))
	flameeyebackgroundPath.line(to: CGPoint(x: 90, y: 71))
	flameeyebackgroundPath.curve(to: CGPoint(x: 76, y: 85), controlPoint1: CGPoint(x: 90, y: 78.73), controlPoint2: CGPoint(x: 83.73, y: 85))
	flameeyebackgroundPath.line(to: CGPoint(x: 0, y: 90))
	flameeyebackgroundPath.line(to: CGPoint(x: 5, y: 14))
	flameeyebackgroundPath.close()
}.flippedVertically(height: 90)
