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
	/// A 'pinch' style eye design
	@objc(QRCodeEyeShapeArc) class Arc: NSObject, QRCodeEyeShapeGenerator {
		@objc public static let Name = "arc"
		@objc public static var Title: String { "Arc" }
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodeEyeShapeGenerator {
			return QRCode.EyeShape.Arc()
		}

		@objc public func settings() -> [String: Any] { return [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodeEyeShapeGenerator {
			return Self.Create(self.settings())
		}

		/// Reset the eye shape generator back to defaults
		@objc public func reset() { }

		private static let _defaultPupil = QRCode.PupilShape.Arc()
		public func defaultPupil() -> any QRCodePupilShapeGenerator { Self._defaultPupil }
	}
}

public extension QRCodeEyeShapeGenerator where Self == QRCode.EyeShape.Arc {
	/// Create an arc eye shape generator
	/// - Returns: An eye shape generator
	@inlinable static func arc() -> QRCodeEyeShapeGenerator { QRCode.EyeShape.Arc() }
}

public extension QRCode.EyeShape.Arc {
	func eyePath() -> CGPath { eyePath__ }
	func eyeBackgroundPath() -> CGPath { eyeBackgroudPath__ }
}

// MARK: - Paths

private let eyePath__: CGPath =
	CGPath.make { arcouterPath in
		arcouterPath.move(to: CGPoint(x: 51.07, y: 79.96))
		arcouterPath.curve(to: CGPoint(x: 10, y: 37), controlPoint1: CGPoint(x: 28.22, y: 78.95), controlPoint2: CGPoint(x: 10, y: 60.1))
		arcouterPath.curve(to: CGPoint(x: 10, y: 36), controlPoint1: CGPoint(x: 10, y: 36.77), controlPoint2: CGPoint(x: 10, y: 36.11))
		arcouterPath.line(to: CGPoint(x: 10, y: 20))
		arcouterPath.curve(to: CGPoint(x: 19.52, y: 10.01), controlPoint1: CGPoint(x: 10, y: 14.64), controlPoint2: CGPoint(x: 14.22, y: 10.26))
		arcouterPath.curve(to: CGPoint(x: 19.72, y: 10), controlPoint1: CGPoint(x: 19.61, y: 10.01), controlPoint2: CGPoint(x: 19.68, y: 10.01))
		arcouterPath.curve(to: CGPoint(x: 20, y: 10), controlPoint1: CGPoint(x: 19.75, y: 10), controlPoint2: CGPoint(x: 20, y: 10))
		arcouterPath.line(to: CGPoint(x: 70, y: 10))
		arcouterPath.line(to: CGPoint(x: 70.26, y: 10))
		arcouterPath.line(to: CGPoint(x: 70.51, y: 10.01))
		arcouterPath.line(to: CGPoint(x: 70.74, y: 10.03))
		arcouterPath.curve(to: CGPoint(x: 71.02, y: 10.05), controlPoint1: CGPoint(x: 70.77, y: 10.03), controlPoint2: CGPoint(x: 71.02, y: 10.05))
		arcouterPath.line(to: CGPoint(x: 71.27, y: 10.08))
		arcouterPath.line(to: CGPoint(x: 71.52, y: 10.12))
		arcouterPath.line(to: CGPoint(x: 71.77, y: 10.16))
		arcouterPath.line(to: CGPoint(x: 71.99, y: 10.2))
		arcouterPath.curve(to: CGPoint(x: 72.26, y: 10.26), controlPoint1: CGPoint(x: 72.02, y: 10.2), controlPoint2: CGPoint(x: 72.26, y: 10.26))
		arcouterPath.line(to: CGPoint(x: 72.5, y: 10.31))
		arcouterPath.line(to: CGPoint(x: 72.74, y: 10.38))
		arcouterPath.line(to: CGPoint(x: 72.97, y: 10.45))
		arcouterPath.line(to: CGPoint(x: 73.21, y: 10.53))
		arcouterPath.line(to: CGPoint(x: 73.44, y: 10.61))
		arcouterPath.line(to: CGPoint(x: 73.67, y: 10.69))
		arcouterPath.line(to: CGPoint(x: 73.85, y: 10.77))
		arcouterPath.curve(to: CGPoint(x: 74.12, y: 10.88), controlPoint1: CGPoint(x: 73.89, y: 10.79), controlPoint2: CGPoint(x: 74.12, y: 10.88))
		arcouterPath.line(to: CGPoint(x: 74.34, y: 10.99))
		arcouterPath.line(to: CGPoint(x: 74.55, y: 11.09))
		arcouterPath.line(to: CGPoint(x: 74.77, y: 11.21))
		arcouterPath.line(to: CGPoint(x: 74.94, y: 11.31))
		arcouterPath.curve(to: CGPoint(x: 75.19, y: 11.45), controlPoint1: CGPoint(x: 74.98, y: 11.32), controlPoint2: CGPoint(x: 75.19, y: 11.45))
		arcouterPath.line(to: CGPoint(x: 75.39, y: 11.58))
		arcouterPath.line(to: CGPoint(x: 75.59, y: 11.71))
		arcouterPath.line(to: CGPoint(x: 75.79, y: 11.84))
		arcouterPath.line(to: CGPoint(x: 75.98, y: 11.99))
		arcouterPath.line(to: CGPoint(x: 76.15, y: 12.12))
		arcouterPath.curve(to: CGPoint(x: 76.36, y: 12.28), controlPoint1: CGPoint(x: 76.17, y: 12.13), controlPoint2: CGPoint(x: 76.36, y: 12.28))
		arcouterPath.line(to: CGPoint(x: 76.54, y: 12.44))
		arcouterPath.line(to: CGPoint(x: 76.71, y: 12.59))
		arcouterPath.line(to: CGPoint(x: 76.84, y: 12.71))
		arcouterPath.curve(to: CGPoint(x: 77.07, y: 12.93), controlPoint1: CGPoint(x: 76.9, y: 12.76), controlPoint2: CGPoint(x: 77.07, y: 12.93))
		arcouterPath.line(to: CGPoint(x: 77.24, y: 13.1))
		arcouterPath.line(to: CGPoint(x: 77.4, y: 13.28))
		arcouterPath.line(to: CGPoint(x: 77.53, y: 13.42))
		arcouterPath.curve(to: CGPoint(x: 77.72, y: 13.64), controlPoint1: CGPoint(x: 77.6, y: 13.5), controlPoint2: CGPoint(x: 77.72, y: 13.64))
		arcouterPath.line(to: CGPoint(x: 77.81, y: 13.76))
		arcouterPath.curve(to: CGPoint(x: 78, y: 14), controlPoint1: CGPoint(x: 77.87, y: 13.83), controlPoint2: CGPoint(x: 78, y: 14))
		arcouterPath.line(to: CGPoint(x: 78.16, y: 14.21))
		arcouterPath.line(to: CGPoint(x: 78.23, y: 14.31))
		arcouterPath.line(to: CGPoint(x: 78.29, y: 14.41))
		arcouterPath.curve(to: CGPoint(x: 78.42, y: 14.61), controlPoint1: CGPoint(x: 78.34, y: 14.49), controlPoint2: CGPoint(x: 78.42, y: 14.61))
		arcouterPath.line(to: CGPoint(x: 78.49, y: 14.72))
		arcouterPath.line(to: CGPoint(x: 78.55, y: 14.81))
		arcouterPath.line(to: CGPoint(x: 78.63, y: 14.95))
		arcouterPath.curve(to: CGPoint(x: 78.77, y: 15.18), controlPoint1: CGPoint(x: 78.68, y: 15.02), controlPoint2: CGPoint(x: 78.77, y: 15.18))
		arcouterPath.curve(to: CGPoint(x: 78.91, y: 15.45), controlPoint1: CGPoint(x: 78.83, y: 15.3), controlPoint2: CGPoint(x: 78.91, y: 15.45))
		arcouterPath.curve(to: CGPoint(x: 79.01, y: 15.66), controlPoint1: CGPoint(x: 78.93, y: 15.5), controlPoint2: CGPoint(x: 79.01, y: 15.66))
		arcouterPath.curve(to: CGPoint(x: 79.11, y: 15.88), controlPoint1: CGPoint(x: 79.05, y: 15.74), controlPoint2: CGPoint(x: 79.11, y: 15.88))
		arcouterPath.line(to: CGPoint(x: 79.2, y: 16.07))
		arcouterPath.line(to: CGPoint(x: 79.26, y: 16.22))
		arcouterPath.line(to: CGPoint(x: 79.31, y: 16.33))
		arcouterPath.curve(to: CGPoint(x: 79.39, y: 16.56), controlPoint1: CGPoint(x: 79.34, y: 16.41), controlPoint2: CGPoint(x: 79.39, y: 16.56))
		arcouterPath.line(to: CGPoint(x: 79.43, y: 16.67))
		arcouterPath.line(to: CGPoint(x: 79.47, y: 16.79))
		arcouterPath.line(to: CGPoint(x: 79.51, y: 16.9))
		arcouterPath.line(to: CGPoint(x: 79.55, y: 17.03))
		arcouterPath.line(to: CGPoint(x: 79.59, y: 17.15))
		arcouterPath.line(to: CGPoint(x: 79.62, y: 17.26))
		arcouterPath.line(to: CGPoint(x: 79.67, y: 17.45))
		arcouterPath.curve(to: CGPoint(x: 79.74, y: 17.74), controlPoint1: CGPoint(x: 79.69, y: 17.5), controlPoint2: CGPoint(x: 79.74, y: 17.74))
		arcouterPath.line(to: CGPoint(x: 79.77, y: 17.86))
		arcouterPath.line(to: CGPoint(x: 79.8, y: 17.98))
		arcouterPath.line(to: CGPoint(x: 79.82, y: 18.11))
		arcouterPath.line(to: CGPoint(x: 79.84, y: 18.23))
		arcouterPath.line(to: CGPoint(x: 79.87, y: 18.37))
		arcouterPath.line(to: CGPoint(x: 79.88, y: 18.48))
		arcouterPath.curve(to: CGPoint(x: 79.92, y: 18.73), controlPoint1: CGPoint(x: 79.9, y: 18.56), controlPoint2: CGPoint(x: 79.92, y: 18.73))
		arcouterPath.line(to: CGPoint(x: 79.94, y: 18.92))
		arcouterPath.curve(to: CGPoint(x: 79.96, y: 19.11), controlPoint1: CGPoint(x: 79.95, y: 18.98), controlPoint2: CGPoint(x: 79.96, y: 19.11))
		arcouterPath.line(to: CGPoint(x: 79.97, y: 19.23))
		arcouterPath.line(to: CGPoint(x: 79.98, y: 19.38))
		arcouterPath.line(to: CGPoint(x: 79.99, y: 19.49))
		arcouterPath.line(to: CGPoint(x: 80, y: 19.74))
		arcouterPath.curve(to: CGPoint(x: 80, y: 19.98), controlPoint1: CGPoint(x: 80, y: 19.74), controlPoint2: CGPoint(x: 80, y: 19.91))
		arcouterPath.curve(to: CGPoint(x: 80, y: 70), controlPoint1: CGPoint(x: 80, y: 20), controlPoint2: CGPoint(x: 80, y: 70))
		arcouterPath.line(to: CGPoint(x: 80, y: 70.25))
		arcouterPath.curve(to: CGPoint(x: 79.99, y: 70.48), controlPoint1: CGPoint(x: 79.99, y: 70.33), controlPoint2: CGPoint(x: 79.99, y: 70.48))
		arcouterPath.curve(to: CGPoint(x: 70, y: 80), controlPoint1: CGPoint(x: 79.74, y: 75.78), controlPoint2: CGPoint(x: 75.36, y: 80))
		arcouterPath.curve(to: CGPoint(x: 51.07, y: 79.96), controlPoint1: CGPoint(x: 70, y: 80), controlPoint2: CGPoint(x: 51.38, y: 79.99))
		arcouterPath.close()
		arcouterPath.move(to: CGPoint(x: 52, y: 70))
		arcouterPath.line(to: CGPoint(x: 65, y: 70))
		arcouterPath.curve(to: CGPoint(x: 70, y: 65), controlPoint1: CGPoint(x: 67.76, y: 70), controlPoint2: CGPoint(x: 70, y: 67.76))
		arcouterPath.curve(to: CGPoint(x: 70, y: 64.46), controlPoint1: CGPoint(x: 70, y: 65), controlPoint2: CGPoint(x: 70, y: 64.8))
		arcouterPath.curve(to: CGPoint(x: 70, y: 52), controlPoint1: CGPoint(x: 70, y: 62), controlPoint2: CGPoint(x: 70, y: 52))
		arcouterPath.curve(to: CGPoint(x: 70, y: 25), controlPoint1: CGPoint(x: 70, y: 40.32), controlPoint2: CGPoint(x: 70, y: 25))
		arcouterPath.curve(to: CGPoint(x: 65, y: 20), controlPoint1: CGPoint(x: 70, y: 22.24), controlPoint2: CGPoint(x: 67.76, y: 20))
		arcouterPath.curve(to: CGPoint(x: 52.55, y: 20), controlPoint1: CGPoint(x: 65, y: 20), controlPoint2: CGPoint(x: 59.47, y: 20))
		arcouterPath.curve(to: CGPoint(x: 33.71, y: 20), controlPoint1: CGPoint(x: 46.4, y: 20), controlPoint2: CGPoint(x: 39.15, y: 20))
		arcouterPath.curve(to: CGPoint(x: 25.54, y: 20), controlPoint1: CGPoint(x: 28.92, y: 20), controlPoint2: CGPoint(x: 25.54, y: 20))
		arcouterPath.line(to: CGPoint(x: 25, y: 20))
		arcouterPath.curve(to: CGPoint(x: 20, y: 25), controlPoint1: CGPoint(x: 22.24, y: 20), controlPoint2: CGPoint(x: 20, y: 22.24))
		arcouterPath.line(to: CGPoint(x: 20, y: 38))
		arcouterPath.curve(to: CGPoint(x: 52, y: 70), controlPoint1: CGPoint(x: 20, y: 55.67), controlPoint2: CGPoint(x: 34.33, y: 70))
		arcouterPath.close()
	}
	.flippedVertically(height: 90)

private let eyeBackgroudPath__: CGPath =
	CGPath.make { arcbackgroundPath in
		arcbackgroundPath.move(to: CGPoint(x: 0.01, y: 40.6))
		arcbackgroundPath.curve(to: CGPoint(x: 0, y: 40), controlPoint1: CGPoint(x: 0, y: 40.4), controlPoint2: CGPoint(x: 0, y: 40.2))
		arcbackgroundPath.curve(to: CGPoint(x: 0, y: 39.5), controlPoint1: CGPoint(x: 0, y: 40), controlPoint2: CGPoint(x: 0, y: 39.82))
		arcbackgroundPath.curve(to: CGPoint(x: 0, y: 15), controlPoint1: CGPoint(x: 0, y: 35.97), controlPoint2: CGPoint(x: 0, y: 15))
		arcbackgroundPath.curve(to: CGPoint(x: 15, y: 0), controlPoint1: CGPoint(x: 0, y: 6.72), controlPoint2: CGPoint(x: 6.72, y: -0))
		arcbackgroundPath.line(to: CGPoint(x: 19.03, y: 0))
		arcbackgroundPath.curve(to: CGPoint(x: 21, y: 0), controlPoint1: CGPoint(x: 20.12, y: 0), controlPoint2: CGPoint(x: 21, y: 0))
		arcbackgroundPath.curve(to: CGPoint(x: 74.96, y: -0), controlPoint1: CGPoint(x: 21.02, y: -0), controlPoint2: CGPoint(x: 74.96, y: -0))
		arcbackgroundPath.curve(to: CGPoint(x: 83.64, y: 2.74), controlPoint1: CGPoint(x: 78.22, y: -0), controlPoint2: CGPoint(x: 81.2, y: 1.01))
		arcbackgroundPath.curve(to: CGPoint(x: 90, y: 15), controlPoint1: CGPoint(x: 87.49, y: 5.45), controlPoint2: CGPoint(x: 90, y: 9.93))
		arcbackgroundPath.curve(to: CGPoint(x: 90, y: 64), controlPoint1: CGPoint(x: 90, y: 15), controlPoint2: CGPoint(x: 90, y: 46.68))
		arcbackgroundPath.curve(to: CGPoint(x: 90, y: 70.97), controlPoint1: CGPoint(x: 90, y: 64), controlPoint2: CGPoint(x: 90, y: 67.83))
		arcbackgroundPath.curve(to: CGPoint(x: 90, y: 75), controlPoint1: CGPoint(x: 90, y: 73.15), controlPoint2: CGPoint(x: 90, y: 75))
		arcbackgroundPath.curve(to: CGPoint(x: 75, y: 90), controlPoint1: CGPoint(x: 90, y: 83.28), controlPoint2: CGPoint(x: 83.28, y: 90))
		arcbackgroundPath.line(to: CGPoint(x: 52, y: 90))
		arcbackgroundPath.curve(to: CGPoint(x: 51.47, y: 89.99), controlPoint1: CGPoint(x: 51.82, y: 90), controlPoint2: CGPoint(x: 51.65, y: 90))
		arcbackgroundPath.curve(to: CGPoint(x: 50.5, y: 90), controlPoint1: CGPoint(x: 51.15, y: 90), controlPoint2: CGPoint(x: 50.82, y: 90))
		arcbackgroundPath.curve(to: CGPoint(x: 0.01, y: 40.6), controlPoint1: CGPoint(x: 22.98, y: 90), controlPoint2: CGPoint(x: 0.6, y: 67.98))
		arcbackgroundPath.close()
	}
