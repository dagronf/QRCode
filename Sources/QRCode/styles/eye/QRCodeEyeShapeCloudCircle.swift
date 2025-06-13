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

import Foundation
import CoreGraphics

public extension QRCode.EyeShape {
	/// A cloudy-circle style eye shape generator
	@objc(QRCodeEyeShapeCloudCircle) class CloudCircle : NSObject, QRCodeEyeShapeGenerator {
		@objc public static let Name: String = "cloudCircle"
		@objc public static var Title: String { "Cloud Circle" }

		@objc static public func Create(_ settings: [String: Any]?) -> any QRCodeEyeShapeGenerator {
			return QRCode.EyeShape.CloudCircle()
		}

		// Has no configurable settings
		@objc public func settings() -> [String : Any] { return [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodeEyeShapeGenerator { CloudCircle() }

		/// Reset the eye shape generator back to defaults
		@objc public func reset() { }

		@objc public func eyePath() -> CGPath { eyePath__ }
		@objc public func eyeBackgroundPath() -> CGPath { eyeBackgroundPath__ }

		private static let _defaultPupil = QRCode.PupilShape.CloudCircle()
		public func defaultPupil() -> any QRCodePupilShapeGenerator { Self._defaultPupil }
	}
}

public extension QRCodeEyeShapeGenerator where Self == QRCode.EyeShape.CloudCircle {
	/// Create a circle eye shape generator
	/// - Returns: An eye shape generator
	@inlinable static func cloudCircle() -> QRCodeEyeShapeGenerator { QRCode.EyeShape.CloudCircle() }
}

// MARK: - Design

private let eyeBackgroundPath__ = CGPath.make { eyeBackgroundPath in
	eyeBackgroundPath.move(to: CGPoint(x: 90, y: 45))
	eyeBackgroundPath.curve(to: CGPoint(x: 45, y: 0), controlPoint1: CGPoint(x: 90, y: 20.15), controlPoint2: CGPoint(x: 69.85, y: 0))
	eyeBackgroundPath.curve(to: CGPoint(x: 0, y: 45), controlPoint1: CGPoint(x: 20.15, y: 0), controlPoint2: CGPoint(x: 0, y: 20.15))
	eyeBackgroundPath.curve(to: CGPoint(x: 45, y: 90), controlPoint1: CGPoint(x: 0, y: 69.85), controlPoint2: CGPoint(x: 20.15, y: 90))
	eyeBackgroundPath.curve(to: CGPoint(x: 90, y: 45), controlPoint1: CGPoint(x: 69.85, y: 90), controlPoint2: CGPoint(x: 90, y: 69.85))
	eyeBackgroundPath.close()
}

private let eyePath__ = CGPath.make { eyePath in
	eyePath.move(to: CGPoint(x: 48.62, y: 79.78))
	eyePath.curve(to: CGPoint(x: 52.19, y: 80.15), controlPoint1: CGPoint(x: 49.71, y: 80.25), controlPoint2: CGPoint(x: 50.94, y: 80.4))
	eyePath.curve(to: CGPoint(x: 55.29, y: 78.45), controlPoint1: CGPoint(x: 53.42, y: 79.9), controlPoint2: CGPoint(x: 54.48, y: 79.29))
	eyePath.curve(to: CGPoint(x: 58.81, y: 78.11), controlPoint1: CGPoint(x: 56.43, y: 78.69), controlPoint2: CGPoint(x: 57.65, y: 78.59))
	eyePath.curve(to: CGPoint(x: 61.57, y: 75.79), controlPoint1: CGPoint(x: 59.99, y: 77.62), controlPoint2: CGPoint(x: 60.93, y: 76.79))
	eyePath.curve(to: CGPoint(x: 65.02, y: 74.77), controlPoint1: CGPoint(x: 62.75, y: 75.81), controlPoint2: CGPoint(x: 63.96, y: 75.48))
	eyePath.curve(to: CGPoint(x: 67.24, y: 72.02), controlPoint1: CGPoint(x: 66.06, y: 74.07), controlPoint2: CGPoint(x: 66.81, y: 73.1))
	eyePath.curve(to: CGPoint(x: 70.37, y: 70.37), controlPoint1: CGPoint(x: 68.39, y: 71.8), controlPoint2: CGPoint(x: 69.48, y: 71.25))
	eyePath.curve(to: CGPoint(x: 72.03, y: 67.19), controlPoint1: CGPoint(x: 71.27, y: 69.47), controlPoint2: CGPoint(x: 71.82, y: 68.35))
	eyePath.curve(to: CGPoint(x: 75.04, y: 64.84), controlPoint1: CGPoint(x: 73.22, y: 66.77), controlPoint2: CGPoint(x: 74.29, y: 65.97))
	eyePath.curve(to: CGPoint(x: 76.03, y: 61.43), controlPoint1: CGPoint(x: 75.73, y: 63.79), controlPoint2: CGPoint(x: 76.05, y: 62.6))
	eyePath.curve(to: CGPoint(x: 78.29, y: 58.7), controlPoint1: CGPoint(x: 77.01, y: 60.79), controlPoint2: CGPoint(x: 77.81, y: 59.86))
	eyePath.curve(to: CGPoint(x: 78.6, y: 55.09), controlPoint1: CGPoint(x: 78.78, y: 57.51), controlPoint2: CGPoint(x: 78.86, y: 56.26))
	eyePath.curve(to: CGPoint(x: 80.33, y: 51.92), controlPoint1: CGPoint(x: 79.46, y: 54.27), controlPoint2: CGPoint(x: 80.08, y: 53.18))
	eyePath.curve(to: CGPoint(x: 79.95, y: 48.39), controlPoint1: CGPoint(x: 80.57, y: 50.68), controlPoint2: CGPoint(x: 80.42, y: 49.46))
	eyePath.curve(to: CGPoint(x: 81, y: 45), controlPoint1: CGPoint(x: 80.61, y: 47.42), controlPoint2: CGPoint(x: 81, y: 46.26))
	eyePath.curve(to: CGPoint(x: 79.8, y: 41.4), controlPoint1: CGPoint(x: 81, y: 43.65), controlPoint2: CGPoint(x: 80.55, y: 42.41))
	eyePath.curve(to: CGPoint(x: 80.24, y: 37.66), controlPoint1: CGPoint(x: 80.33, y: 40.28), controlPoint2: CGPoint(x: 80.51, y: 38.98))
	eyePath.curve(to: CGPoint(x: 78.52, y: 34.54), controlPoint1: CGPoint(x: 79.99, y: 36.42), controlPoint2: CGPoint(x: 79.37, y: 35.35))
	eyePath.curve(to: CGPoint(x: 78.18, y: 31.03), controlPoint1: CGPoint(x: 78.75, y: 33.4), controlPoint2: CGPoint(x: 78.66, y: 32.18))
	eyePath.curve(to: CGPoint(x: 75.82, y: 28.25), controlPoint1: CGPoint(x: 77.68, y: 29.84), controlPoint2: CGPoint(x: 76.84, y: 28.89))
	eyePath.curve(to: CGPoint(x: 74.8, y: 24.8), controlPoint1: CGPoint(x: 75.84, y: 27.07), controlPoint2: CGPoint(x: 75.51, y: 25.86))
	eyePath.curve(to: CGPoint(x: 72.02, y: 22.57), controlPoint1: CGPoint(x: 74.1, y: 23.75), controlPoint2: CGPoint(x: 73.11, y: 23))
	eyePath.curve(to: CGPoint(x: 70.37, y: 19.46), controlPoint1: CGPoint(x: 71.8, y: 21.43), controlPoint2: CGPoint(x: 71.25, y: 20.34))
	eyePath.curve(to: CGPoint(x: 67.12, y: 17.78), controlPoint1: CGPoint(x: 69.45, y: 18.54), controlPoint2: CGPoint(x: 68.31, y: 17.98))
	eyePath.curve(to: CGPoint(x: 64.84, y: 14.96), controlPoint1: CGPoint(x: 66.69, y: 16.67), controlPoint2: CGPoint(x: 65.91, y: 15.67))
	eyePath.curve(to: CGPoint(x: 61.43, y: 13.97), controlPoint1: CGPoint(x: 63.79, y: 14.27), controlPoint2: CGPoint(x: 62.6, y: 13.95))
	eyePath.curve(to: CGPoint(x: 58.7, y: 11.71), controlPoint1: CGPoint(x: 60.79, y: 12.99), controlPoint2: CGPoint(x: 59.86, y: 12.19))
	eyePath.curve(to: CGPoint(x: 55.09, y: 11.4), controlPoint1: CGPoint(x: 57.51, y: 11.22), controlPoint2: CGPoint(x: 56.26, y: 11.14))
	eyePath.curve(to: CGPoint(x: 51.92, y: 9.67), controlPoint1: CGPoint(x: 54.27, y: 10.54), controlPoint2: CGPoint(x: 53.18, y: 9.92))
	eyePath.curve(to: CGPoint(x: 48.39, y: 10.05), controlPoint1: CGPoint(x: 50.68, y: 9.43), controlPoint2: CGPoint(x: 49.46, y: 9.58))
	eyePath.curve(to: CGPoint(x: 45, y: 9), controlPoint1: CGPoint(x: 47.42, y: 9.39), controlPoint2: CGPoint(x: 46.26, y: 9))
	eyePath.curve(to: CGPoint(x: 41.56, y: 10.08), controlPoint1: CGPoint(x: 43.72, y: 9), controlPoint2: CGPoint(x: 42.54, y: 9.4))
	eyePath.curve(to: CGPoint(x: 37.76, y: 9.61), controlPoint1: CGPoint(x: 40.42, y: 9.53), controlPoint2: CGPoint(x: 39.1, y: 9.33))
	eyePath.curve(to: CGPoint(x: 34.64, y: 11.32), controlPoint1: CGPoint(x: 36.52, y: 9.86), controlPoint2: CGPoint(x: 35.45, y: 10.48))
	eyePath.curve(to: CGPoint(x: 31.1, y: 11.66), controlPoint1: CGPoint(x: 33.49, y: 11.08), controlPoint2: CGPoint(x: 32.26, y: 11.17))
	eyePath.curve(to: CGPoint(x: 28.32, y: 14), controlPoint1: CGPoint(x: 29.91, y: 12.15), controlPoint2: CGPoint(x: 28.96, y: 12.99))
	eyePath.curve(to: CGPoint(x: 24.84, y: 15.02), controlPoint1: CGPoint(x: 27.13, y: 13.98), controlPoint2: CGPoint(x: 25.91, y: 14.3))
	eyePath.curve(to: CGPoint(x: 22.61, y: 17.8), controlPoint1: CGPoint(x: 23.79, y: 15.73), controlPoint2: CGPoint(x: 23.04, y: 16.71))
	eyePath.curve(to: CGPoint(x: 19.46, y: 19.46), controlPoint1: CGPoint(x: 21.45, y: 18.01), controlPoint2: CGPoint(x: 20.35, y: 18.56))
	eyePath.curve(to: CGPoint(x: 17.75, y: 22.89), controlPoint1: CGPoint(x: 18.49, y: 20.42), controlPoint2: CGPoint(x: 17.92, y: 21.63))
	eyePath.curve(to: CGPoint(x: 14.97, y: 25.14), controlPoint1: CGPoint(x: 16.66, y: 23.33), controlPoint2: CGPoint(x: 15.68, y: 24.09))
	eyePath.curve(to: CGPoint(x: 13.97, y: 28.57), controlPoint1: CGPoint(x: 14.27, y: 26.21), controlPoint2: CGPoint(x: 13.95, y: 27.4))
	eyePath.curve(to: CGPoint(x: 11.71, y: 31.3), controlPoint1: CGPoint(x: 12.99, y: 29.21), controlPoint2: CGPoint(x: 12.19, y: 30.14))
	eyePath.curve(to: CGPoint(x: 11.4, y: 34.91), controlPoint1: CGPoint(x: 11.22, y: 32.49), controlPoint2: CGPoint(x: 11.14, y: 33.74))
	eyePath.curve(to: CGPoint(x: 9.67, y: 38.08), controlPoint1: CGPoint(x: 10.54, y: 35.73), controlPoint2: CGPoint(x: 9.92, y: 36.82))
	eyePath.curve(to: CGPoint(x: 10.05, y: 41.61), controlPoint1: CGPoint(x: 9.43, y: 39.32), controlPoint2: CGPoint(x: 9.58, y: 40.54))
	eyePath.curve(to: CGPoint(x: 9, y: 45), controlPoint1: CGPoint(x: 9.39, y: 42.58), controlPoint2: CGPoint(x: 9, y: 43.74))
	eyePath.curve(to: CGPoint(x: 10.1, y: 48.46), controlPoint1: CGPoint(x: 9, y: 46.29), controlPoint2: CGPoint(x: 9.41, y: 47.48))
	eyePath.curve(to: CGPoint(x: 9.71, y: 52.09), controlPoint1: CGPoint(x: 9.61, y: 49.56), controlPoint2: CGPoint(x: 9.45, y: 50.82))
	eyePath.curve(to: CGPoint(x: 11.39, y: 55.19), controlPoint1: CGPoint(x: 9.96, y: 53.32), controlPoint2: CGPoint(x: 10.56, y: 54.38))
	eyePath.curve(to: CGPoint(x: 11.73, y: 58.74), controlPoint1: CGPoint(x: 11.15, y: 56.34), controlPoint2: CGPoint(x: 11.24, y: 57.57))
	eyePath.curve(to: CGPoint(x: 14.04, y: 61.49), controlPoint1: CGPoint(x: 12.22, y: 59.92), controlPoint2: CGPoint(x: 13.04, y: 60.86))
	eyePath.curve(to: CGPoint(x: 15.06, y: 64.99), controlPoint1: CGPoint(x: 14.01, y: 62.69), controlPoint2: CGPoint(x: 14.34, y: 63.91))
	eyePath.curve(to: CGPoint(x: 17.8, y: 67.21), controlPoint1: CGPoint(x: 15.76, y: 66.02), controlPoint2: CGPoint(x: 16.72, y: 66.77))
	eyePath.curve(to: CGPoint(x: 19.46, y: 70.37), controlPoint1: CGPoint(x: 18.01, y: 68.36), controlPoint2: CGPoint(x: 18.56, y: 69.47))
	eyePath.curve(to: CGPoint(x: 22.82, y: 72.06), controlPoint1: CGPoint(x: 20.4, y: 71.32), controlPoint2: CGPoint(x: 21.59, y: 71.88))
	eyePath.curve(to: CGPoint(x: 25.16, y: 75.04), controlPoint1: CGPoint(x: 23.24, y: 73.24), controlPoint2: CGPoint(x: 24.04, y: 74.3))
	eyePath.curve(to: CGPoint(x: 28.57, y: 76.03), controlPoint1: CGPoint(x: 26.21, y: 75.73), controlPoint2: CGPoint(x: 27.4, y: 76.05))
	eyePath.curve(to: CGPoint(x: 31.3, y: 78.29), controlPoint1: CGPoint(x: 29.21, y: 77.01), controlPoint2: CGPoint(x: 30.14, y: 77.81))
	eyePath.curve(to: CGPoint(x: 34.91, y: 78.6), controlPoint1: CGPoint(x: 32.49, y: 78.78), controlPoint2: CGPoint(x: 33.74, y: 78.86))
	eyePath.curve(to: CGPoint(x: 38.08, y: 80.33), controlPoint1: CGPoint(x: 35.73, y: 79.46), controlPoint2: CGPoint(x: 36.82, y: 80.08))
	eyePath.curve(to: CGPoint(x: 41.61, y: 79.95), controlPoint1: CGPoint(x: 39.32, y: 80.57), controlPoint2: CGPoint(x: 40.54, y: 80.42))
	eyePath.curve(to: CGPoint(x: 45, y: 81), controlPoint1: CGPoint(x: 42.58, y: 80.61), controlPoint2: CGPoint(x: 43.74, y: 81))
	eyePath.curve(to: CGPoint(x: 48.62, y: 79.78), controlPoint1: CGPoint(x: 46.36, y: 81), controlPoint2: CGPoint(x: 47.61, y: 80.55))
	eyePath.close()
	eyePath.move(to: CGPoint(x: 42.63, y: 69.49))
	eyePath.curve(to: CGPoint(x: 40.9, y: 68.68), controlPoint1: CGPoint(x: 42.11, y: 69.13), controlPoint2: CGPoint(x: 41.53, y: 68.86))
	eyePath.curve(to: CGPoint(x: 40.39, y: 68.55), controlPoint1: CGPoint(x: 40.74, y: 68.63), controlPoint2: CGPoint(x: 40.56, y: 68.59))
	eyePath.curve(to: CGPoint(x: 37.91, y: 68.59), controlPoint1: CGPoint(x: 39.54, y: 68.39), controlPoint2: CGPoint(x: 38.7, y: 68.41))
	eyePath.curve(to: CGPoint(x: 35.87, y: 67.2), controlPoint1: CGPoint(x: 37.35, y: 68), controlPoint2: CGPoint(x: 36.67, y: 67.52))
	eyePath.curve(to: CGPoint(x: 35.16, y: 66.95), controlPoint1: CGPoint(x: 35.63, y: 67.1), controlPoint2: CGPoint(x: 35.4, y: 67.02))
	eyePath.curve(to: CGPoint(x: 33.49, y: 66.74), controlPoint1: CGPoint(x: 34.6, y: 66.8), controlPoint2: CGPoint(x: 34.04, y: 66.73))
	eyePath.curve(to: CGPoint(x: 31.78, y: 65.03), controlPoint1: CGPoint(x: 33.05, y: 66.08), controlPoint2: CGPoint(x: 32.48, y: 65.49))
	eyePath.curve(to: CGPoint(x: 31.12, y: 64.65), controlPoint1: CGPoint(x: 31.56, y: 64.89), controlPoint2: CGPoint(x: 31.35, y: 64.76))
	eyePath.curve(to: CGPoint(x: 29.35, y: 64.1), controlPoint1: CGPoint(x: 30.55, y: 64.37), controlPoint2: CGPoint(x: 29.95, y: 64.19))
	eyePath.curve(to: CGPoint(x: 27.94, y: 61.88), controlPoint1: CGPoint(x: 29.06, y: 63.29), controlPoint2: CGPoint(x: 28.59, y: 62.53))
	eyePath.curve(to: CGPoint(x: 25.94, y: 60.56), controlPoint1: CGPoint(x: 27.35, y: 61.29), controlPoint2: CGPoint(x: 26.67, y: 60.85))
	eyePath.curve(to: CGPoint(x: 25.02, y: 58.29), controlPoint1: CGPoint(x: 25.8, y: 59.77), controlPoint2: CGPoint(x: 25.49, y: 59))
	eyePath.curve(to: CGPoint(x: 23.26, y: 56.58), controlPoint1: CGPoint(x: 24.54, y: 57.58), controlPoint2: CGPoint(x: 23.94, y: 57.01))
	eyePath.curve(to: CGPoint(x: 22.8, y: 54.12), controlPoint1: CGPoint(x: 23.28, y: 55.76), controlPoint2: CGPoint(x: 23.14, y: 54.93))
	eyePath.curve(to: CGPoint(x: 21.45, y: 52.14), controlPoint1: CGPoint(x: 22.48, y: 53.35), controlPoint2: CGPoint(x: 22.02, y: 52.68))
	eyePath.curve(to: CGPoint(x: 21.46, y: 49.69), controlPoint1: CGPoint(x: 21.62, y: 51.35), controlPoint2: CGPoint(x: 21.63, y: 50.52))
	eyePath.curve(to: CGPoint(x: 20.49, y: 47.43), controlPoint1: CGPoint(x: 21.29, y: 48.85), controlPoint2: CGPoint(x: 20.95, y: 48.09))
	eyePath.curve(to: CGPoint(x: 21, y: 45), controlPoint1: CGPoint(x: 20.82, y: 46.69), controlPoint2: CGPoint(x: 21, y: 45.87))
	eyePath.curve(to: CGPoint(x: 20.51, y: 42.63), controlPoint1: CGPoint(x: 21, y: 44.16), controlPoint2: CGPoint(x: 20.83, y: 43.35))
	eyePath.curve(to: CGPoint(x: 21.45, y: 40.39), controlPoint1: CGPoint(x: 20.96, y: 41.97), controlPoint2: CGPoint(x: 21.28, y: 41.22))
	eyePath.curve(to: CGPoint(x: 21.41, y: 37.91), controlPoint1: CGPoint(x: 21.61, y: 39.54), controlPoint2: CGPoint(x: 21.59, y: 38.7))
	eyePath.curve(to: CGPoint(x: 22.8, y: 35.87), controlPoint1: CGPoint(x: 22, y: 37.35), controlPoint2: CGPoint(x: 22.48, y: 36.67))
	eyePath.curve(to: CGPoint(x: 23.23, y: 34.2), controlPoint1: CGPoint(x: 23.03, y: 35.32), controlPoint2: CGPoint(x: 23.17, y: 34.76))
	eyePath.curve(to: CGPoint(x: 23.26, y: 33.49), controlPoint1: CGPoint(x: 23.25, y: 33.96), controlPoint2: CGPoint(x: 23.26, y: 33.72))
	eyePath.curve(to: CGPoint(x: 24.97, y: 31.78), controlPoint1: CGPoint(x: 23.92, y: 33.05), controlPoint2: CGPoint(x: 24.51, y: 32.48))
	eyePath.curve(to: CGPoint(x: 25.91, y: 29.28), controlPoint1: CGPoint(x: 25.49, y: 31), controlPoint2: CGPoint(x: 25.8, y: 30.14))
	eyePath.curve(to: CGPoint(x: 27.94, y: 27.94), controlPoint1: CGPoint(x: 26.65, y: 28.98), controlPoint2: CGPoint(x: 27.34, y: 28.54))
	eyePath.curve(to: CGPoint(x: 29.28, y: 25.9), controlPoint1: CGPoint(x: 28.54, y: 27.34), controlPoint2: CGPoint(x: 28.99, y: 26.65))
	eyePath.curve(to: CGPoint(x: 31.54, y: 24.98), controlPoint1: CGPoint(x: 30.06, y: 25.76), controlPoint2: CGPoint(x: 30.83, y: 25.46))
	eyePath.curve(to: CGPoint(x: 33.27, y: 23.2), controlPoint1: CGPoint(x: 32.26, y: 24.5), controlPoint2: CGPoint(x: 32.84, y: 23.89))
	eyePath.curve(to: CGPoint(x: 35.71, y: 22.73), controlPoint1: CGPoint(x: 34.08, y: 23.21), controlPoint2: CGPoint(x: 34.91, y: 23.07))
	eyePath.curve(to: CGPoint(x: 37.73, y: 21.36), controlPoint1: CGPoint(x: 36.5, y: 22.41), controlPoint2: CGPoint(x: 37.17, y: 21.93))
	eyePath.curve(to: CGPoint(x: 40.16, y: 21.36), controlPoint1: CGPoint(x: 38.51, y: 21.52), controlPoint2: CGPoint(x: 39.33, y: 21.53))
	eyePath.curve(to: CGPoint(x: 42.4, y: 20.41), controlPoint1: CGPoint(x: 40.99, y: 21.2), controlPoint2: CGPoint(x: 41.75, y: 20.86))
	eyePath.curve(to: CGPoint(x: 45, y: 21), controlPoint1: CGPoint(x: 43.18, y: 20.79), controlPoint2: CGPoint(x: 44.07, y: 21))
	eyePath.curve(to: CGPoint(x: 47.37, y: 20.51), controlPoint1: CGPoint(x: 45.84, y: 21), controlPoint2: CGPoint(x: 46.65, y: 20.83))
	eyePath.curve(to: CGPoint(x: 49.61, y: 21.45), controlPoint1: CGPoint(x: 48.03, y: 20.96), controlPoint2: CGPoint(x: 48.78, y: 21.28))
	eyePath.curve(to: CGPoint(x: 52.09, y: 21.41), controlPoint1: CGPoint(x: 50.46, y: 21.61), controlPoint2: CGPoint(x: 51.3, y: 21.59))
	eyePath.curve(to: CGPoint(x: 54.13, y: 22.8), controlPoint1: CGPoint(x: 52.65, y: 22), controlPoint2: CGPoint(x: 53.33, y: 22.48))
	eyePath.curve(to: CGPoint(x: 56.51, y: 23.26), controlPoint1: CGPoint(x: 54.91, y: 23.13), controlPoint2: CGPoint(x: 55.72, y: 23.27))
	eyePath.curve(to: CGPoint(x: 58.22, y: 24.97), controlPoint1: CGPoint(x: 56.95, y: 23.92), controlPoint2: CGPoint(x: 57.52, y: 24.51))
	eyePath.curve(to: CGPoint(x: 60.54, y: 25.88), controlPoint1: CGPoint(x: 58.95, y: 25.45), controlPoint2: CGPoint(x: 59.73, y: 25.75))
	eyePath.curve(to: CGPoint(x: 61.88, y: 27.94), controlPoint1: CGPoint(x: 60.83, y: 26.63), controlPoint2: CGPoint(x: 61.28, y: 27.34))
	eyePath.curve(to: CGPoint(x: 63.93, y: 29.28), controlPoint1: CGPoint(x: 62.48, y: 28.54), controlPoint2: CGPoint(x: 63.18, y: 28.99))
	eyePath.curve(to: CGPoint(x: 64.84, y: 31.5), controlPoint1: CGPoint(x: 64.08, y: 30.05), controlPoint2: CGPoint(x: 64.38, y: 30.81))
	eyePath.curve(to: CGPoint(x: 66.64, y: 33.24), controlPoint1: CGPoint(x: 65.33, y: 32.22), controlPoint2: CGPoint(x: 65.95, y: 32.81))
	eyePath.curve(to: CGPoint(x: 67.1, y: 35.65), controlPoint1: CGPoint(x: 66.63, y: 34.04), controlPoint2: CGPoint(x: 66.77, y: 34.86))
	eyePath.curve(to: CGPoint(x: 68.49, y: 37.67), controlPoint1: CGPoint(x: 67.43, y: 36.43), controlPoint2: CGPoint(x: 67.91, y: 37.11))
	eyePath.curve(to: CGPoint(x: 68.49, y: 40.07), controlPoint1: CGPoint(x: 68.33, y: 38.44), controlPoint2: CGPoint(x: 68.32, y: 39.25))
	eyePath.curve(to: CGPoint(x: 69.56, y: 42.46), controlPoint1: CGPoint(x: 68.67, y: 40.96), controlPoint2: CGPoint(x: 69.05, y: 41.77))
	eyePath.curve(to: CGPoint(x: 69, y: 45), controlPoint1: CGPoint(x: 69.2, y: 43.23), controlPoint2: CGPoint(x: 69, y: 44.09))
	eyePath.curve(to: CGPoint(x: 69.49, y: 47.37), controlPoint1: CGPoint(x: 69, y: 45.84), controlPoint2: CGPoint(x: 69.17, y: 46.65))
	eyePath.curve(to: CGPoint(x: 68.55, y: 49.61), controlPoint1: CGPoint(x: 69.04, y: 48.03), controlPoint2: CGPoint(x: 68.72, y: 48.78))
	eyePath.curve(to: CGPoint(x: 68.59, y: 52.09), controlPoint1: CGPoint(x: 68.39, y: 50.46), controlPoint2: CGPoint(x: 68.41, y: 51.3))
	eyePath.curve(to: CGPoint(x: 67.2, y: 54.13), controlPoint1: CGPoint(x: 68, y: 52.65), controlPoint2: CGPoint(x: 67.52, y: 53.33))
	eyePath.curve(to: CGPoint(x: 66.74, y: 56.51), controlPoint1: CGPoint(x: 66.87, y: 54.91), controlPoint2: CGPoint(x: 66.73, y: 55.72))
	eyePath.curve(to: CGPoint(x: 65.03, y: 58.22), controlPoint1: CGPoint(x: 66.08, y: 56.95), controlPoint2: CGPoint(x: 65.49, y: 57.52))
	eyePath.curve(to: CGPoint(x: 64.13, y: 60.47), controlPoint1: CGPoint(x: 64.56, y: 58.93), controlPoint2: CGPoint(x: 64.27, y: 59.69))
	eyePath.curve(to: CGPoint(x: 61.88, y: 61.88), controlPoint1: CGPoint(x: 63.31, y: 60.75), controlPoint2: CGPoint(x: 62.54, y: 61.23))
	eyePath.curve(to: CGPoint(x: 60.55, y: 63.89), controlPoint1: CGPoint(x: 61.29, y: 62.48), controlPoint2: CGPoint(x: 60.85, y: 63.16))
	eyePath.curve(to: CGPoint(x: 58.32, y: 64.81), controlPoint1: CGPoint(x: 59.78, y: 64.04), controlPoint2: CGPoint(x: 59.02, y: 64.34))
	eyePath.curve(to: CGPoint(x: 56.61, y: 66.57), controlPoint1: CGPoint(x: 57.61, y: 65.29), controlPoint2: CGPoint(x: 57.04, y: 65.89))
	eyePath.curve(to: CGPoint(x: 54.19, y: 67.04), controlPoint1: CGPoint(x: 55.8, y: 66.56), controlPoint2: CGPoint(x: 54.98, y: 66.71))
	eyePath.curve(to: CGPoint(x: 52.2, y: 68.39), controlPoint1: CGPoint(x: 53.42, y: 67.36), controlPoint2: CGPoint(x: 52.74, y: 67.82))
	eyePath.curve(to: CGPoint(x: 49.79, y: 68.39), controlPoint1: CGPoint(x: 51.42, y: 68.23), controlPoint2: CGPoint(x: 50.61, y: 68.22))
	eyePath.curve(to: CGPoint(x: 47.36, y: 69.48), controlPoint1: CGPoint(x: 48.88, y: 68.58), controlPoint2: CGPoint(x: 48.06, y: 68.96))
	eyePath.curve(to: CGPoint(x: 47.13, y: 69.39), controlPoint1: CGPoint(x: 47.29, y: 69.45), controlPoint2: CGPoint(x: 47.21, y: 69.42))
	eyePath.curve(to: CGPoint(x: 45, y: 69), controlPoint1: CGPoint(x: 46.47, y: 69.14), controlPoint2: CGPoint(x: 45.75, y: 69))
	eyePath.curve(to: CGPoint(x: 42.63, y: 69.49), controlPoint1: CGPoint(x: 44.16, y: 69), controlPoint2: CGPoint(x: 43.35, y: 69.17))
	eyePath.close()
}
