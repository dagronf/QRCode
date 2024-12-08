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

import Foundation
import CoreGraphics

public extension QRCode.EyeShape {
	@objc(QRCodeEyeShapeSpikyCircle) class SpikyCircle : NSObject, QRCodeEyeShapeGenerator {
		@objc public static let Name: String = "spikyCircle"
		@objc public static var Title: String { "Spiky Circle" }

		@objc static public func Create(_ settings: [String: Any]?) -> any QRCodeEyeShapeGenerator {
			return QRCode.EyeShape.SpikyCircle()
		}

		// Has no configurable settings
		@objc public func settings() -> [String : Any] { return [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodeEyeShapeGenerator {
			QRCode.EyeShape.SpikyCircle()
		}

		/// Reset the eye shape generator back to defaults
		@objc public func reset() { }

		private static let _defaultPupil = QRCode.PupilShape.SpikyCircle()
		public func defaultPupil() -> any QRCodePupilShapeGenerator { Self._defaultPupil }
	}
}

public extension QRCode.EyeShape.SpikyCircle {
	@objc func eyePath() -> CGPath { generatedEyePath__ }
	@objc func eyeBackgroundPath() -> CGPath { generatedEyeBackgroundPath__ }
}

public extension QRCodeEyeShapeGenerator where Self == QRCode.EyeShape.SpikyCircle {
	/// Create a circle eye shape generator
	/// - Returns: An eye shape generator
	@inlinable static func spikyCircle() -> QRCodeEyeShapeGenerator { QRCode.EyeShape.SpikyCircle() }
}


// MARK: - Paths

private let generatedEyePath__: CGPath = {
	return CGPath.make { eyeouterPath in
		eyeouterPath.move(to: CGPoint(x: 48.18, y: 80))
		eyeouterPath.curve(to: CGPoint(x: 53.14, y: 75.98), controlPoint1: CGPoint(x: 48.18, y: 80), controlPoint2: CGPoint(x: 51.28, y: 76.45))
		eyeouterPath.curve(to: CGPoint(x: 59.42, y: 77.15), controlPoint1: CGPoint(x: 55, y: 75.51), controlPoint2: CGPoint(x: 59.42, y: 77.15))
		eyeouterPath.curve(to: CGPoint(x: 62.8, y: 71.74), controlPoint1: CGPoint(x: 59.42, y: 77.15), controlPoint2: CGPoint(x: 61.19, y: 72.79))
		eyeouterPath.curve(to: CGPoint(x: 69.13, y: 70.82), controlPoint1: CGPoint(x: 64.4, y: 70.7), controlPoint2: CGPoint(x: 69.13, y: 70.82))
		eyeouterPath.curve(to: CGPoint(x: 70.56, y: 64.61), controlPoint1: CGPoint(x: 69.13, y: 70.82), controlPoint2: CGPoint(x: 69.38, y: 66.12))
		eyeouterPath.curve(to: CGPoint(x: 76.24, y: 61.69), controlPoint1: CGPoint(x: 71.74, y: 63.1), controlPoint2: CGPoint(x: 76.24, y: 61.69))
		eyeouterPath.curve(to: CGPoint(x: 75.58, y: 55.35), controlPoint1: CGPoint(x: 76.24, y: 61.69), controlPoint2: CGPoint(x: 74.95, y: 57.16))
		eyeouterPath.curve(to: CGPoint(x: 80, y: 50.75), controlPoint1: CGPoint(x: 76.2, y: 53.54), controlPoint2: CGPoint(x: 80, y: 50.75))
		eyeouterPath.curve(to: CGPoint(x: 77.3, y: 44.97), controlPoint1: CGPoint(x: 80, y: 50.75), controlPoint2: CGPoint(x: 77.3, y: 46.89))
		eyeouterPath.curve(to: CGPoint(x: 79.99, y: 39.19), controlPoint1: CGPoint(x: 77.3, y: 43.06), controlPoint2: CGPoint(x: 79.99, y: 39.19))
		eyeouterPath.curve(to: CGPoint(x: 75.56, y: 34.6), controlPoint1: CGPoint(x: 79.99, y: 39.19), controlPoint2: CGPoint(x: 76.18, y: 36.41))
		eyeouterPath.curve(to: CGPoint(x: 76.21, y: 28.26), controlPoint1: CGPoint(x: 74.93, y: 32.79), controlPoint2: CGPoint(x: 76.21, y: 28.26))
		eyeouterPath.curve(to: CGPoint(x: 70.53, y: 25.35), controlPoint1: CGPoint(x: 76.21, y: 28.26), controlPoint2: CGPoint(x: 71.7, y: 26.86))
		eyeouterPath.curve(to: CGPoint(x: 69.08, y: 19.14), controlPoint1: CGPoint(x: 69.35, y: 23.84), controlPoint2: CGPoint(x: 69.08, y: 19.14))
		eyeouterPath.curve(to: CGPoint(x: 62.75, y: 18.23), controlPoint1: CGPoint(x: 69.08, y: 19.14), controlPoint2: CGPoint(x: 64.36, y: 19.28))
		eyeouterPath.curve(to: CGPoint(x: 61.65, y: 17.09), controlPoint1: CGPoint(x: 62.39, y: 17.99), controlPoint2: CGPoint(x: 62.01, y: 17.58))
		eyeouterPath.curve(to: CGPoint(x: 59.36, y: 12.83), controlPoint1: CGPoint(x: 60.42, y: 15.42), controlPoint2: CGPoint(x: 59.36, y: 12.83))
		eyeouterPath.curve(to: CGPoint(x: 53.08, y: 14.01), controlPoint1: CGPoint(x: 59.36, y: 12.83), controlPoint2: CGPoint(x: 54.94, y: 14.48))
		eyeouterPath.curve(to: CGPoint(x: 48.12, y: 10), controlPoint1: CGPoint(x: 51.22, y: 13.55), controlPoint2: CGPoint(x: 48.12, y: 10))
		eyeouterPath.curve(to: CGPoint(x: 44.65, y: 12.38), controlPoint1: CGPoint(x: 48.12, y: 10), controlPoint2: CGPoint(x: 46.36, y: 11.44))
		eyeouterPath.curve(to: CGPoint(x: 42.56, y: 13.15), controlPoint1: CGPoint(x: 43.9, y: 12.79), controlPoint2: CGPoint(x: 43.15, y: 13.11))
		eyeouterPath.curve(to: CGPoint(x: 36.56, y: 10.96), controlPoint1: CGPoint(x: 40.65, y: 13.31), controlPoint2: CGPoint(x: 36.56, y: 10.96))
		eyeouterPath.curve(to: CGPoint(x: 32.33, y: 15.75), controlPoint1: CGPoint(x: 36.56, y: 10.96), controlPoint2: CGPoint(x: 34.09, y: 14.98))
		eyeouterPath.curve(to: CGPoint(x: 25.94, y: 15.62), controlPoint1: CGPoint(x: 30.57, y: 16.52), controlPoint2: CGPoint(x: 25.94, y: 15.62))
		eyeouterPath.curve(to: CGPoint(x: 23.5, y: 21.51), controlPoint1: CGPoint(x: 25.94, y: 15.62), controlPoint2: CGPoint(x: 24.91, y: 20.21))
		eyeouterPath.curve(to: CGPoint(x: 17.41, y: 23.46), controlPoint1: CGPoint(x: 22.09, y: 22.81), controlPoint2: CGPoint(x: 17.41, y: 23.46))
		eyeouterPath.curve(to: CGPoint(x: 17.02, y: 29.82), controlPoint1: CGPoint(x: 17.41, y: 23.46), controlPoint2: CGPoint(x: 17.93, y: 28.13))
		eyeouterPath.curve(to: CGPoint(x: 11.9, y: 33.63), controlPoint1: CGPoint(x: 16.11, y: 31.5), controlPoint2: CGPoint(x: 11.9, y: 33.63))
		eyeouterPath.curve(to: CGPoint(x: 13.6, y: 39.77), controlPoint1: CGPoint(x: 11.9, y: 33.63), controlPoint2: CGPoint(x: 13.92, y: 37.88))
		eyeouterPath.curve(to: CGPoint(x: 10, y: 45.03), controlPoint1: CGPoint(x: 13.29, y: 41.66), controlPoint2: CGPoint(x: 10, y: 45.03))
		eyeouterPath.curve(to: CGPoint(x: 13.61, y: 50.29), controlPoint1: CGPoint(x: 10, y: 45.03), controlPoint2: CGPoint(x: 13.3, y: 48.41))
		eyeouterPath.curve(to: CGPoint(x: 11.92, y: 56.44), controlPoint1: CGPoint(x: 13.93, y: 52.18), controlPoint2: CGPoint(x: 11.92, y: 56.44))
		eyeouterPath.curve(to: CGPoint(x: 17.05, y: 60.24), controlPoint1: CGPoint(x: 11.92, y: 56.44), controlPoint2: CGPoint(x: 16.14, y: 58.56))
		eyeouterPath.curve(to: CGPoint(x: 17.45, y: 66.6), controlPoint1: CGPoint(x: 17.96, y: 61.92), controlPoint2: CGPoint(x: 17.45, y: 66.6))
		eyeouterPath.curve(to: CGPoint(x: 23.54, y: 68.54), controlPoint1: CGPoint(x: 17.45, y: 66.6), controlPoint2: CGPoint(x: 22.13, y: 67.24))
		eyeouterPath.curve(to: CGPoint(x: 25.99, y: 74.42), controlPoint1: CGPoint(x: 24.95, y: 69.83), controlPoint2: CGPoint(x: 25.99, y: 74.42))
		eyeouterPath.curve(to: CGPoint(x: 32.38, y: 74.28), controlPoint1: CGPoint(x: 25.99, y: 74.42), controlPoint2: CGPoint(x: 30.63, y: 73.52))
		eyeouterPath.curve(to: CGPoint(x: 36.62, y: 79.06), controlPoint1: CGPoint(x: 34.14, y: 75.05), controlPoint2: CGPoint(x: 36.62, y: 79.06))
		eyeouterPath.curve(to: CGPoint(x: 42.62, y: 76.86), controlPoint1: CGPoint(x: 36.62, y: 79.06), controlPoint2: CGPoint(x: 40.71, y: 76.7))
		eyeouterPath.curve(to: CGPoint(x: 48.18, y: 80), controlPoint1: CGPoint(x: 44.53, y: 77.01), controlPoint2: CGPoint(x: 48.18, y: 80))
		eyeouterPath.line(to: CGPoint(x: 48.18, y: 80))
		eyeouterPath.close()
		eyeouterPath.move(to: CGPoint(x: 47.27, y: 70))
		eyeouterPath.curve(to: CGPoint(x: 43.3, y: 67.75), controlPoint1: CGPoint(x: 47.27, y: 70), controlPoint2: CGPoint(x: 44.66, y: 67.87))
		eyeouterPath.curve(to: CGPoint(x: 39.01, y: 69.33), controlPoint1: CGPoint(x: 41.93, y: 67.64), controlPoint2: CGPoint(x: 39.01, y: 69.33))
		eyeouterPath.curve(to: CGPoint(x: 35.99, y: 65.92), controlPoint1: CGPoint(x: 39.01, y: 69.33), controlPoint2: CGPoint(x: 37.24, y: 66.46))
		eyeouterPath.curve(to: CGPoint(x: 31.42, y: 66.02), controlPoint1: CGPoint(x: 34.73, y: 65.37), controlPoint2: CGPoint(x: 31.42, y: 66.02))
		eyeouterPath.curve(to: CGPoint(x: 29.67, y: 61.81), controlPoint1: CGPoint(x: 31.42, y: 66.02), controlPoint2: CGPoint(x: 30.68, y: 62.73))
		eyeouterPath.curve(to: CGPoint(x: 25.32, y: 60.43), controlPoint1: CGPoint(x: 28.66, y: 60.89), controlPoint2: CGPoint(x: 25.32, y: 60.43))
		eyeouterPath.curve(to: CGPoint(x: 25.04, y: 55.88), controlPoint1: CGPoint(x: 25.32, y: 60.43), controlPoint2: CGPoint(x: 25.69, y: 57.09))
		eyeouterPath.curve(to: CGPoint(x: 21.37, y: 53.17), controlPoint1: CGPoint(x: 24.38, y: 54.68), controlPoint2: CGPoint(x: 21.37, y: 53.17))
		eyeouterPath.curve(to: CGPoint(x: 22.58, y: 48.78), controlPoint1: CGPoint(x: 21.37, y: 53.17), controlPoint2: CGPoint(x: 22.81, y: 50.13))
		eyeouterPath.curve(to: CGPoint(x: 20, y: 45.02), controlPoint1: CGPoint(x: 22.35, y: 47.43), controlPoint2: CGPoint(x: 20, y: 45.02))
		eyeouterPath.curve(to: CGPoint(x: 22.57, y: 41.27), controlPoint1: CGPoint(x: 20, y: 45.02), controlPoint2: CGPoint(x: 22.35, y: 42.61))
		eyeouterPath.curve(to: CGPoint(x: 21.36, y: 36.88), controlPoint1: CGPoint(x: 22.8, y: 39.92), controlPoint2: CGPoint(x: 21.36, y: 36.88))
		eyeouterPath.curve(to: CGPoint(x: 25.02, y: 34.15), controlPoint1: CGPoint(x: 21.36, y: 36.88), controlPoint2: CGPoint(x: 24.37, y: 35.36))
		eyeouterPath.curve(to: CGPoint(x: 25.29, y: 29.61), controlPoint1: CGPoint(x: 25.67, y: 32.95), controlPoint2: CGPoint(x: 25.29, y: 29.61))
		eyeouterPath.curve(to: CGPoint(x: 29.64, y: 28.22), controlPoint1: CGPoint(x: 25.29, y: 29.61), controlPoint2: CGPoint(x: 28.63, y: 29.15))
		eyeouterPath.curve(to: CGPoint(x: 31.38, y: 24.01), controlPoint1: CGPoint(x: 30.65, y: 27.29), controlPoint2: CGPoint(x: 31.38, y: 24.01))
		eyeouterPath.curve(to: CGPoint(x: 35.95, y: 24.1), controlPoint1: CGPoint(x: 31.38, y: 24.01), controlPoint2: CGPoint(x: 34.7, y: 24.65))
		eyeouterPath.curve(to: CGPoint(x: 38.97, y: 20.69), controlPoint1: CGPoint(x: 37.2, y: 23.55), controlPoint2: CGPoint(x: 38.97, y: 20.69))
		eyeouterPath.curve(to: CGPoint(x: 43.26, y: 22.25), controlPoint1: CGPoint(x: 38.97, y: 20.69), controlPoint2: CGPoint(x: 41.89, y: 22.37))
		eyeouterPath.curve(to: CGPoint(x: 47.11, y: 20.1), controlPoint1: CGPoint(x: 44.45, y: 22.15), controlPoint2: CGPoint(x: 46.58, y: 20.51))
		eyeouterPath.curve(to: CGPoint(x: 47.23, y: 20), controlPoint1: CGPoint(x: 47.18, y: 20.03), controlPoint2: CGPoint(x: 47.23, y: 20))
		eyeouterPath.curve(to: CGPoint(x: 47.44, y: 20.24), controlPoint1: CGPoint(x: 47.23, y: 20), controlPoint2: CGPoint(x: 47.3, y: 20.09))
		eyeouterPath.curve(to: CGPoint(x: 50.77, y: 22.87), controlPoint1: CGPoint(x: 48.03, y: 20.88), controlPoint2: CGPoint(x: 49.69, y: 22.6))
		eyeouterPath.curve(to: CGPoint(x: 53.13, y: 22.67), controlPoint1: CGPoint(x: 51.35, y: 23.01), controlPoint2: CGPoint(x: 52.27, y: 22.87))
		eyeouterPath.curve(to: CGPoint(x: 55.26, y: 22.02), controlPoint1: CGPoint(x: 54.25, y: 22.4), controlPoint2: CGPoint(x: 55.26, y: 22.02))
		eyeouterPath.curve(to: CGPoint(x: 56.21, y: 23.98), controlPoint1: CGPoint(x: 55.26, y: 22.02), controlPoint2: CGPoint(x: 55.66, y: 22.99))
		eyeouterPath.curve(to: CGPoint(x: 57.68, y: 25.88), controlPoint1: CGPoint(x: 56.64, y: 24.76), controlPoint2: CGPoint(x: 57.17, y: 25.55))
		eyeouterPath.curve(to: CGPoint(x: 62.2, y: 26.53), controlPoint1: CGPoint(x: 58.83, y: 26.63), controlPoint2: CGPoint(x: 62.2, y: 26.53))
		eyeouterPath.curve(to: CGPoint(x: 63.23, y: 30.96), controlPoint1: CGPoint(x: 62.2, y: 26.53), controlPoint2: CGPoint(x: 62.39, y: 29.89))
		eyeouterPath.curve(to: CGPoint(x: 67.29, y: 33.04), controlPoint1: CGPoint(x: 64.07, y: 32.04), controlPoint2: CGPoint(x: 67.29, y: 33.04))
		eyeouterPath.curve(to: CGPoint(x: 66.83, y: 37.57), controlPoint1: CGPoint(x: 67.29, y: 33.04), controlPoint2: CGPoint(x: 66.38, y: 36.28))
		eyeouterPath.curve(to: CGPoint(x: 69.99, y: 40.85), controlPoint1: CGPoint(x: 67.27, y: 38.86), controlPoint2: CGPoint(x: 69.99, y: 40.85))
		eyeouterPath.curve(to: CGPoint(x: 68.07, y: 44.98), controlPoint1: CGPoint(x: 69.99, y: 40.85), controlPoint2: CGPoint(x: 68.07, y: 43.62))
		eyeouterPath.curve(to: CGPoint(x: 70, y: 49.11), controlPoint1: CGPoint(x: 68.07, y: 46.35), controlPoint2: CGPoint(x: 70, y: 49.11))
		eyeouterPath.curve(to: CGPoint(x: 66.84, y: 52.4), controlPoint1: CGPoint(x: 70, y: 49.11), controlPoint2: CGPoint(x: 67.28, y: 51.1))
		eyeouterPath.curve(to: CGPoint(x: 67.32, y: 56.92), controlPoint1: CGPoint(x: 66.4, y: 53.69), controlPoint2: CGPoint(x: 67.32, y: 56.92))
		eyeouterPath.curve(to: CGPoint(x: 63.26, y: 59.01), controlPoint1: CGPoint(x: 67.32, y: 56.92), controlPoint2: CGPoint(x: 64.1, y: 57.93))
		eyeouterPath.curve(to: CGPoint(x: 62.23, y: 63.44), controlPoint1: CGPoint(x: 62.42, y: 60.09), controlPoint2: CGPoint(x: 62.23, y: 63.44))
		eyeouterPath.curve(to: CGPoint(x: 57.71, y: 64.1), controlPoint1: CGPoint(x: 62.23, y: 63.44), controlPoint2: CGPoint(x: 58.86, y: 63.35))
		eyeouterPath.curve(to: CGPoint(x: 55.3, y: 67.97), controlPoint1: CGPoint(x: 56.57, y: 64.85), controlPoint2: CGPoint(x: 55.3, y: 67.97))
		eyeouterPath.curve(to: CGPoint(x: 50.81, y: 67.13), controlPoint1: CGPoint(x: 55.3, y: 67.97), controlPoint2: CGPoint(x: 52.14, y: 66.79))
		eyeouterPath.curve(to: CGPoint(x: 47.27, y: 70), controlPoint1: CGPoint(x: 49.48, y: 67.46), controlPoint2: CGPoint(x: 47.27, y: 70))
		eyeouterPath.close()
	}
}()

private let generatedEyeBackgroundPath__: CGPath = {
	CGPath.make { eyebackgroundPath in
		eyebackgroundPath.move(to: CGPoint(x: 75.94, y: 11.76))
		eyebackgroundPath.curve(to: CGPoint(x: 67.8, y: 10.59), controlPoint1: CGPoint(x: 75.94, y: 11.76), controlPoint2: CGPoint(x: 69.87, y: 11.93))
		eyebackgroundPath.curve(to: CGPoint(x: 63.45, y: 3.64), controlPoint1: CGPoint(x: 65.74, y: 9.25), controlPoint2: CGPoint(x: 63.45, y: 3.64))
		eyebackgroundPath.curve(to: CGPoint(x: 55.37, y: 5.17), controlPoint1: CGPoint(x: 63.45, y: 3.64), controlPoint2: CGPoint(x: 57.76, y: 5.77))
		eyebackgroundPath.curve(to: CGPoint(x: 48.99, y: 0.01), controlPoint1: CGPoint(x: 52.98, y: 4.57), controlPoint2: CGPoint(x: 48.99, y: 0.01))
		eyebackgroundPath.curve(to: CGPoint(x: 41.85, y: 4.06), controlPoint1: CGPoint(x: 48.99, y: 0.01), controlPoint2: CGPoint(x: 44.31, y: 3.86))
		eyebackgroundPath.curve(to: CGPoint(x: 34.13, y: 1.25), controlPoint1: CGPoint(x: 39.39, y: 4.27), controlPoint2: CGPoint(x: 34.13, y: 1.25))
		eyebackgroundPath.curve(to: CGPoint(x: 28.7, y: 7.39), controlPoint1: CGPoint(x: 34.13, y: 1.25), controlPoint2: CGPoint(x: 30.96, y: 6.41))
		eyebackgroundPath.curve(to: CGPoint(x: 20.48, y: 7.23), controlPoint1: CGPoint(x: 26.44, y: 8.39), controlPoint2: CGPoint(x: 20.48, y: 7.23))
		eyebackgroundPath.curve(to: CGPoint(x: 17.35, y: 14.8), controlPoint1: CGPoint(x: 20.48, y: 7.23), controlPoint2: CGPoint(x: 19.16, y: 13.14))
		eyebackgroundPath.curve(to: CGPoint(x: 9.53, y: 17.31), controlPoint1: CGPoint(x: 15.54, y: 16.47), controlPoint2: CGPoint(x: 9.53, y: 17.31))
		eyebackgroundPath.curve(to: CGPoint(x: 9.03, y: 25.48), controlPoint1: CGPoint(x: 9.53, y: 17.31), controlPoint2: CGPoint(x: 10.2, y: 23.32))
		eyebackgroundPath.curve(to: CGPoint(x: 2.44, y: 30.38), controlPoint1: CGPoint(x: 7.85, y: 27.65), controlPoint2: CGPoint(x: 2.44, y: 30.38))
		eyebackgroundPath.curve(to: CGPoint(x: 4.63, y: 38.28), controlPoint1: CGPoint(x: 2.44, y: 30.38), controlPoint2: CGPoint(x: 5.04, y: 35.85))
		eyebackgroundPath.curve(to: CGPoint(x: -0, y: 45.05), controlPoint1: CGPoint(x: 4.23, y: 40.7), controlPoint2: CGPoint(x: -0, y: 45.05))
		eyebackgroundPath.curve(to: CGPoint(x: 4.64, y: 51.8), controlPoint1: CGPoint(x: -0, y: 45.05), controlPoint2: CGPoint(x: 4.24, y: 49.38))
		eyebackgroundPath.curve(to: CGPoint(x: 2.47, y: 59.7), controlPoint1: CGPoint(x: 5.05, y: 54.23), controlPoint2: CGPoint(x: 2.47, y: 59.7))
		eyebackgroundPath.curve(to: CGPoint(x: 9.06, y: 64.59), controlPoint1: CGPoint(x: 2.47, y: 59.7), controlPoint2: CGPoint(x: 7.89, y: 62.43))
		eyebackgroundPath.curve(to: CGPoint(x: 9.57, y: 72.77), controlPoint1: CGPoint(x: 10.24, y: 66.75), controlPoint2: CGPoint(x: 9.57, y: 72.77))
		eyebackgroundPath.curve(to: CGPoint(x: 17.4, y: 75.26), controlPoint1: CGPoint(x: 9.57, y: 72.77), controlPoint2: CGPoint(x: 15.59, y: 73.59))
		eyebackgroundPath.curve(to: CGPoint(x: 20.55, y: 82.82), controlPoint1: CGPoint(x: 19.22, y: 76.92), controlPoint2: CGPoint(x: 20.55, y: 82.82))
		eyebackgroundPath.curve(to: CGPoint(x: 28.77, y: 82.64), controlPoint1: CGPoint(x: 20.55, y: 82.82), controlPoint2: CGPoint(x: 26.51, y: 81.66))
		eyebackgroundPath.curve(to: CGPoint(x: 34.21, y: 88.78), controlPoint1: CGPoint(x: 31.03, y: 83.63), controlPoint2: CGPoint(x: 34.21, y: 88.78))
		eyebackgroundPath.curve(to: CGPoint(x: 41.92, y: 85.95), controlPoint1: CGPoint(x: 34.21, y: 88.78), controlPoint2: CGPoint(x: 39.47, y: 85.75))
		eyebackgroundPath.curve(to: CGPoint(x: 49.07, y: 89.99), controlPoint1: CGPoint(x: 44.38, y: 86.15), controlPoint2: CGPoint(x: 49.07, y: 89.99))
		eyebackgroundPath.curve(to: CGPoint(x: 55.44, y: 84.82), controlPoint1: CGPoint(x: 49.07, y: 89.99), controlPoint2: CGPoint(x: 53.06, y: 85.43))
		eyebackgroundPath.curve(to: CGPoint(x: 63.52, y: 86.33), controlPoint1: CGPoint(x: 57.83, y: 84.22), controlPoint2: CGPoint(x: 63.52, y: 86.33))
		eyebackgroundPath.curve(to: CGPoint(x: 67.86, y: 79.38), controlPoint1: CGPoint(x: 63.52, y: 86.33), controlPoint2: CGPoint(x: 65.8, y: 80.73))
		eyebackgroundPath.curve(to: CGPoint(x: 76, y: 78.19), controlPoint1: CGPoint(x: 69.93, y: 78.03), controlPoint2: CGPoint(x: 76, y: 78.19))
		eyebackgroundPath.curve(to: CGPoint(x: 77.84, y: 70.21), controlPoint1: CGPoint(x: 76, y: 78.19), controlPoint2: CGPoint(x: 76.32, y: 72.15))
		eyebackgroundPath.curve(to: CGPoint(x: 85.14, y: 66.46), controlPoint1: CGPoint(x: 79.35, y: 68.27), controlPoint2: CGPoint(x: 85.14, y: 66.46))
		eyebackgroundPath.curve(to: CGPoint(x: 84.28, y: 58.31), controlPoint1: CGPoint(x: 85.14, y: 66.46), controlPoint2: CGPoint(x: 83.48, y: 60.64))
		eyebackgroundPath.curve(to: CGPoint(x: 89.97, y: 52.4), controlPoint1: CGPoint(x: 85.08, y: 55.99), controlPoint2: CGPoint(x: 89.97, y: 52.4))
		eyebackgroundPath.curve(to: CGPoint(x: 86.5, y: 44.97), controlPoint1: CGPoint(x: 89.97, y: 52.4), controlPoint2: CGPoint(x: 86.51, y: 47.43))
		eyebackgroundPath.curve(to: CGPoint(x: 89.96, y: 37.53), controlPoint1: CGPoint(x: 86.5, y: 42.51), controlPoint2: CGPoint(x: 89.96, y: 37.53))
		eyebackgroundPath.curve(to: CGPoint(x: 84.26, y: 31.63), controlPoint1: CGPoint(x: 89.96, y: 37.53), controlPoint2: CGPoint(x: 85.06, y: 33.95))
		eyebackgroundPath.curve(to: CGPoint(x: 85.1, y: 23.48), controlPoint1: CGPoint(x: 83.46, y: 29.31), controlPoint2: CGPoint(x: 85.1, y: 23.48))
		eyebackgroundPath.curve(to: CGPoint(x: 77.79, y: 19.74), controlPoint1: CGPoint(x: 85.1, y: 23.48), controlPoint2: CGPoint(x: 79.31, y: 21.68))
		eyebackgroundPath.curve(to: CGPoint(x: 75.94, y: 11.76), controlPoint1: CGPoint(x: 76.28, y: 17.8), controlPoint2: CGPoint(x: 75.94, y: 11.76))
		eyebackgroundPath.close()
	}
}()
