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
	@objc(QRCodeEyeShapeCloud) class Cloud : NSObject, QRCodeEyeShapeGenerator {
		@objc public static let Name: String = "cloud"
		@objc public static var Title: String { "Cloud" }

		@objc static public func Create(_ settings: [String: Any]?) -> any QRCodeEyeShapeGenerator {
			return QRCode.EyeShape.Cloud()
		}

		// Has no configurable settings
		@objc public func settings() -> [String : Any] { return [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodeEyeShapeGenerator {
			QRCode.EyeShape.Cloud()
		}

		/// Reset the eye shape generator back to defaults
		@objc public func reset() { }

		private static let _defaultPupil = QRCode.PupilShape.Cloud()
		public func defaultPupil() -> any QRCodePupilShapeGenerator { Self._defaultPupil }
	}
}

public extension QRCode.EyeShape.Cloud {
	@objc func eyePath() -> CGPath { generatedEyePath__ }
	@objc func eyeBackgroundPath() -> CGPath { generatedEyeBackgroundPath__ }
}

public extension QRCodeEyeShapeGenerator where Self == QRCode.EyeShape.Cloud {
	/// Create a circle eye shape generator
	/// - Returns: An eye shape generator
	@inlinable static func cloud() -> QRCodeEyeShapeGenerator { QRCode.EyeShape.Cloud() }
}

// MARK: - Paths

private let generatedEyePath__: CGPath = {
	CGPath.make { eyeouterPath in
		eyeouterPath.move(to: CGPoint(x: 80, y: 75))
		eyeouterPath.curve(to: CGPoint(x: 78.03, y: 71.02), controlPoint1: CGPoint(x: 80, y: 73.38), controlPoint2: CGPoint(x: 79.23, y: 71.94))
		eyeouterPath.curve(to: CGPoint(x: 79.75, y: 67.25), controlPoint1: CGPoint(x: 79.08, y: 70.11), controlPoint2: CGPoint(x: 79.75, y: 68.76))
		eyeouterPath.curve(to: CGPoint(x: 78.32, y: 63.75), controlPoint1: CGPoint(x: 79.75, y: 65.89), controlPoint2: CGPoint(x: 79.2, y: 64.65))
		eyeouterPath.curve(to: CGPoint(x: 79.75, y: 60.25), controlPoint1: CGPoint(x: 79.2, y: 62.85), controlPoint2: CGPoint(x: 79.75, y: 61.61))
		eyeouterPath.curve(to: CGPoint(x: 77.75, y: 56.25), controlPoint1: CGPoint(x: 79.75, y: 58.61), controlPoint2: CGPoint(x: 78.96, y: 57.16))
		eyeouterPath.curve(to: CGPoint(x: 79.75, y: 52.25), controlPoint1: CGPoint(x: 78.96, y: 55.34), controlPoint2: CGPoint(x: 79.75, y: 53.89))
		eyeouterPath.curve(to: CGPoint(x: 78.32, y: 48.75), controlPoint1: CGPoint(x: 79.75, y: 50.89), controlPoint2: CGPoint(x: 79.2, y: 49.65))
		eyeouterPath.curve(to: CGPoint(x: 79.75, y: 45.25), controlPoint1: CGPoint(x: 79.2, y: 47.85), controlPoint2: CGPoint(x: 79.75, y: 46.61))
		eyeouterPath.curve(to: CGPoint(x: 77.75, y: 41.25), controlPoint1: CGPoint(x: 79.75, y: 43.61), controlPoint2: CGPoint(x: 78.96, y: 42.16))
		eyeouterPath.curve(to: CGPoint(x: 79.75, y: 37.25), controlPoint1: CGPoint(x: 78.96, y: 40.34), controlPoint2: CGPoint(x: 79.75, y: 38.89))
		eyeouterPath.curve(to: CGPoint(x: 78.32, y: 33.75), controlPoint1: CGPoint(x: 79.75, y: 35.89), controlPoint2: CGPoint(x: 79.2, y: 34.65))
		eyeouterPath.curve(to: CGPoint(x: 79.75, y: 30.25), controlPoint1: CGPoint(x: 79.2, y: 32.85), controlPoint2: CGPoint(x: 79.75, y: 31.61))
		eyeouterPath.curve(to: CGPoint(x: 78.06, y: 26.5), controlPoint1: CGPoint(x: 79.75, y: 28.76), controlPoint2: CGPoint(x: 79.1, y: 27.42))
		eyeouterPath.curve(to: CGPoint(x: 79.75, y: 22.75), controlPoint1: CGPoint(x: 79.1, y: 25.58), controlPoint2: CGPoint(x: 79.75, y: 24.24))
		eyeouterPath.curve(to: CGPoint(x: 78.03, y: 18.98), controlPoint1: CGPoint(x: 79.75, y: 21.24), controlPoint2: CGPoint(x: 79.08, y: 19.89))
		eyeouterPath.curve(to: CGPoint(x: 80, y: 15), controlPoint1: CGPoint(x: 79.23, y: 18.06), controlPoint2: CGPoint(x: 80, y: 16.62))
		eyeouterPath.curve(to: CGPoint(x: 75, y: 10), controlPoint1: CGPoint(x: 80, y: 12.24), controlPoint2: CGPoint(x: 77.76, y: 10))
		eyeouterPath.curve(to: CGPoint(x: 71, y: 12), controlPoint1: CGPoint(x: 73.36, y: 10), controlPoint2: CGPoint(x: 71.91, y: 10.79))
		eyeouterPath.curve(to: CGPoint(x: 67, y: 10), controlPoint1: CGPoint(x: 70.09, y: 10.79), controlPoint2: CGPoint(x: 68.64, y: 10))
		eyeouterPath.curve(to: CGPoint(x: 63.5, y: 11.43), controlPoint1: CGPoint(x: 65.64, y: 10), controlPoint2: CGPoint(x: 64.4, y: 10.55))
		eyeouterPath.curve(to: CGPoint(x: 60, y: 10), controlPoint1: CGPoint(x: 62.6, y: 10.55), controlPoint2: CGPoint(x: 61.36, y: 10))
		eyeouterPath.curve(to: CGPoint(x: 56, y: 12), controlPoint1: CGPoint(x: 58.36, y: 10), controlPoint2: CGPoint(x: 56.91, y: 10.79))
		eyeouterPath.curve(to: CGPoint(x: 52, y: 10), controlPoint1: CGPoint(x: 55.09, y: 10.79), controlPoint2: CGPoint(x: 53.64, y: 10))
		eyeouterPath.curve(to: CGPoint(x: 48.5, y: 11.43), controlPoint1: CGPoint(x: 50.64, y: 10), controlPoint2: CGPoint(x: 49.4, y: 10.55))
		eyeouterPath.curve(to: CGPoint(x: 45, y: 10), controlPoint1: CGPoint(x: 47.6, y: 10.55), controlPoint2: CGPoint(x: 46.36, y: 10))
		eyeouterPath.curve(to: CGPoint(x: 41, y: 12), controlPoint1: CGPoint(x: 43.36, y: 10), controlPoint2: CGPoint(x: 41.91, y: 10.79))
		eyeouterPath.curve(to: CGPoint(x: 37, y: 10), controlPoint1: CGPoint(x: 40.09, y: 10.79), controlPoint2: CGPoint(x: 38.64, y: 10))
		eyeouterPath.curve(to: CGPoint(x: 33.5, y: 11.43), controlPoint1: CGPoint(x: 35.64, y: 10), controlPoint2: CGPoint(x: 34.4, y: 10.55))
		eyeouterPath.curve(to: CGPoint(x: 30, y: 10), controlPoint1: CGPoint(x: 32.6, y: 10.55), controlPoint2: CGPoint(x: 31.36, y: 10))
		eyeouterPath.curve(to: CGPoint(x: 28.86, y: 10.13), controlPoint1: CGPoint(x: 29.61, y: 10), controlPoint2: CGPoint(x: 29.23, y: 10.05))
		eyeouterPath.curve(to: CGPoint(x: 26.25, y: 11.69), controlPoint1: CGPoint(x: 27.83, y: 10.37), controlPoint2: CGPoint(x: 26.92, y: 10.93))
		eyeouterPath.curve(to: CGPoint(x: 22.5, y: 10), controlPoint1: CGPoint(x: 25.33, y: 10.65), controlPoint2: CGPoint(x: 23.99, y: 10))
		eyeouterPath.curve(to: CGPoint(x: 19.95, y: 10.7), controlPoint1: CGPoint(x: 21.57, y: 10), controlPoint2: CGPoint(x: 20.7, y: 10.25))
		eyeouterPath.curve(to: CGPoint(x: 18.75, y: 11.69), controlPoint1: CGPoint(x: 19.5, y: 10.97), controlPoint2: CGPoint(x: 19.09, y: 11.3))
		eyeouterPath.curve(to: CGPoint(x: 15, y: 10), controlPoint1: CGPoint(x: 17.83, y: 10.65), controlPoint2: CGPoint(x: 16.49, y: 10))
		eyeouterPath.curve(to: CGPoint(x: 11.88, y: 11.1), controlPoint1: CGPoint(x: 13.82, y: 10), controlPoint2: CGPoint(x: 12.73, y: 10.41))
		eyeouterPath.curve(to: CGPoint(x: 11.26, y: 11.69), controlPoint1: CGPoint(x: 11.65, y: 11.27), controlPoint2: CGPoint(x: 11.45, y: 11.47))
		eyeouterPath.curve(to: CGPoint(x: 10, y: 15), controlPoint1: CGPoint(x: 10.47, y: 12.57), controlPoint2: CGPoint(x: 10, y: 13.73))
		eyeouterPath.curve(to: CGPoint(x: 11.72, y: 18.77), controlPoint1: CGPoint(x: 10, y: 16.51), controlPoint2: CGPoint(x: 10.67, y: 17.86))
		eyeouterPath.curve(to: CGPoint(x: 10.71, y: 19.8), controlPoint1: CGPoint(x: 11.34, y: 19.07), controlPoint2: CGPoint(x: 11, y: 19.41))
		eyeouterPath.curve(to: CGPoint(x: 9.75, y: 22.75), controlPoint1: CGPoint(x: 10.11, y: 20.63), controlPoint2: CGPoint(x: 9.75, y: 21.65))
		eyeouterPath.curve(to: CGPoint(x: 11.44, y: 26.5), controlPoint1: CGPoint(x: 9.75, y: 24.24), controlPoint2: CGPoint(x: 10.4, y: 25.58))
		eyeouterPath.line(to: CGPoint(x: 11.33, y: 26.6))
		eyeouterPath.curve(to: CGPoint(x: 10.49, y: 27.63), controlPoint1: CGPoint(x: 11.01, y: 26.91), controlPoint2: CGPoint(x: 10.72, y: 27.25))
		eyeouterPath.curve(to: CGPoint(x: 9.78, y: 29.7), controlPoint1: CGPoint(x: 10.11, y: 28.24), controlPoint2: CGPoint(x: 9.86, y: 28.95))
		eyeouterPath.curve(to: CGPoint(x: 9.75, y: 30.25), controlPoint1: CGPoint(x: 9.76, y: 29.88), controlPoint2: CGPoint(x: 9.75, y: 30.06))
		eyeouterPath.curve(to: CGPoint(x: 11.08, y: 33.65), controlPoint1: CGPoint(x: 9.75, y: 31.56), controlPoint2: CGPoint(x: 10.25, y: 32.75))
		eyeouterPath.line(to: CGPoint(x: 11.18, y: 33.75))
		eyeouterPath.curve(to: CGPoint(x: 9.75, y: 37.25), controlPoint1: CGPoint(x: 10.28, y: 34.7), controlPoint2: CGPoint(x: 9.75, y: 35.91))
		eyeouterPath.curve(to: CGPoint(x: 11.75, y: 41.25), controlPoint1: CGPoint(x: 9.75, y: 38.89), controlPoint2: CGPoint(x: 10.54, y: 40.34))
		eyeouterPath.curve(to: CGPoint(x: 9.75, y: 45.25), controlPoint1: CGPoint(x: 10.54, y: 42.16), controlPoint2: CGPoint(x: 9.75, y: 43.61))
		eyeouterPath.curve(to: CGPoint(x: 11.18, y: 48.75), controlPoint1: CGPoint(x: 9.75, y: 46.61), controlPoint2: CGPoint(x: 10.3, y: 47.85))
		eyeouterPath.curve(to: CGPoint(x: 9.75, y: 52.25), controlPoint1: CGPoint(x: 10.3, y: 49.65), controlPoint2: CGPoint(x: 9.75, y: 50.89))
		eyeouterPath.curve(to: CGPoint(x: 11.75, y: 56.25), controlPoint1: CGPoint(x: 9.75, y: 53.89), controlPoint2: CGPoint(x: 10.54, y: 55.34))
		eyeouterPath.curve(to: CGPoint(x: 9.75, y: 60.25), controlPoint1: CGPoint(x: 10.54, y: 57.16), controlPoint2: CGPoint(x: 9.75, y: 58.61))
		eyeouterPath.curve(to: CGPoint(x: 11.18, y: 63.75), controlPoint1: CGPoint(x: 9.75, y: 61.61), controlPoint2: CGPoint(x: 10.3, y: 62.85))
		eyeouterPath.curve(to: CGPoint(x: 9.75, y: 67.25), controlPoint1: CGPoint(x: 10.3, y: 64.65), controlPoint2: CGPoint(x: 9.75, y: 65.89))
		eyeouterPath.curve(to: CGPoint(x: 11.72, y: 71.23), controlPoint1: CGPoint(x: 9.75, y: 68.87), controlPoint2: CGPoint(x: 10.52, y: 70.31))
		eyeouterPath.curve(to: CGPoint(x: 10, y: 75), controlPoint1: CGPoint(x: 10.67, y: 72.14), controlPoint2: CGPoint(x: 10, y: 73.49))
		eyeouterPath.curve(to: CGPoint(x: 15, y: 80), controlPoint1: CGPoint(x: 10, y: 77.76), controlPoint2: CGPoint(x: 12.24, y: 80))
		eyeouterPath.curve(to: CGPoint(x: 18.75, y: 78.31), controlPoint1: CGPoint(x: 16.49, y: 80), controlPoint2: CGPoint(x: 17.83, y: 79.35))
		eyeouterPath.curve(to: CGPoint(x: 22.5, y: 80), controlPoint1: CGPoint(x: 19.67, y: 79.35), controlPoint2: CGPoint(x: 21.01, y: 80))
		eyeouterPath.curve(to: CGPoint(x: 26.25, y: 78.31), controlPoint1: CGPoint(x: 23.99, y: 80), controlPoint2: CGPoint(x: 25.33, y: 79.35))
		eyeouterPath.curve(to: CGPoint(x: 30, y: 80), controlPoint1: CGPoint(x: 27.17, y: 79.35), controlPoint2: CGPoint(x: 28.51, y: 80))
		eyeouterPath.curve(to: CGPoint(x: 33.5, y: 78.57), controlPoint1: CGPoint(x: 31.36, y: 80), controlPoint2: CGPoint(x: 32.6, y: 79.45))
		eyeouterPath.curve(to: CGPoint(x: 37, y: 80), controlPoint1: CGPoint(x: 34.4, y: 79.45), controlPoint2: CGPoint(x: 35.64, y: 80))
		eyeouterPath.curve(to: CGPoint(x: 41, y: 78), controlPoint1: CGPoint(x: 38.64, y: 80), controlPoint2: CGPoint(x: 40.09, y: 79.21))
		eyeouterPath.curve(to: CGPoint(x: 45, y: 80), controlPoint1: CGPoint(x: 41.91, y: 79.21), controlPoint2: CGPoint(x: 43.36, y: 80))
		eyeouterPath.curve(to: CGPoint(x: 48.5, y: 78.57), controlPoint1: CGPoint(x: 46.36, y: 80), controlPoint2: CGPoint(x: 47.6, y: 79.45))
		eyeouterPath.curve(to: CGPoint(x: 52, y: 80), controlPoint1: CGPoint(x: 49.4, y: 79.45), controlPoint2: CGPoint(x: 50.64, y: 80))
		eyeouterPath.curve(to: CGPoint(x: 56, y: 78), controlPoint1: CGPoint(x: 53.64, y: 80), controlPoint2: CGPoint(x: 55.09, y: 79.21))
		eyeouterPath.curve(to: CGPoint(x: 60, y: 80), controlPoint1: CGPoint(x: 56.91, y: 79.21), controlPoint2: CGPoint(x: 58.36, y: 80))
		eyeouterPath.curve(to: CGPoint(x: 63.5, y: 78.57), controlPoint1: CGPoint(x: 61.36, y: 80), controlPoint2: CGPoint(x: 62.6, y: 79.45))
		eyeouterPath.curve(to: CGPoint(x: 67, y: 80), controlPoint1: CGPoint(x: 64.4, y: 79.45), controlPoint2: CGPoint(x: 65.64, y: 80))
		eyeouterPath.curve(to: CGPoint(x: 71, y: 78), controlPoint1: CGPoint(x: 68.64, y: 80), controlPoint2: CGPoint(x: 70.09, y: 79.21))
		eyeouterPath.curve(to: CGPoint(x: 75, y: 80), controlPoint1: CGPoint(x: 71.91, y: 79.21), controlPoint2: CGPoint(x: 73.36, y: 80))
		eyeouterPath.curve(to: CGPoint(x: 80, y: 75), controlPoint1: CGPoint(x: 77.76, y: 80), controlPoint2: CGPoint(x: 80, y: 77.76))
		eyeouterPath.close()
		eyeouterPath.move(to: CGPoint(x: 71, y: 72))
		eyeouterPath.curve(to: CGPoint(x: 67.44, y: 70.02), controlPoint1: CGPoint(x: 70.17, y: 70.9), controlPoint2: CGPoint(x: 68.9, y: 70.15))
		eyeouterPath.curve(to: CGPoint(x: 67, y: 70), controlPoint1: CGPoint(x: 67.29, y: 70.01), controlPoint2: CGPoint(x: 67.15, y: 70))
		eyeouterPath.curve(to: CGPoint(x: 63.5, y: 71.43), controlPoint1: CGPoint(x: 65.64, y: 70), controlPoint2: CGPoint(x: 64.4, y: 70.55))
		eyeouterPath.curve(to: CGPoint(x: 60.95, y: 70.09), controlPoint1: CGPoint(x: 62.81, y: 70.76), controlPoint2: CGPoint(x: 61.93, y: 70.28))
		eyeouterPath.curve(to: CGPoint(x: 60, y: 70), controlPoint1: CGPoint(x: 60.64, y: 70.03), controlPoint2: CGPoint(x: 60.32, y: 70))
		eyeouterPath.curve(to: CGPoint(x: 56, y: 72), controlPoint1: CGPoint(x: 58.36, y: 70), controlPoint2: CGPoint(x: 56.91, y: 70.79))
		eyeouterPath.curve(to: CGPoint(x: 52, y: 70), controlPoint1: CGPoint(x: 55.09, y: 70.79), controlPoint2: CGPoint(x: 53.64, y: 70))
		eyeouterPath.curve(to: CGPoint(x: 48.5, y: 71.43), controlPoint1: CGPoint(x: 50.64, y: 70), controlPoint2: CGPoint(x: 49.4, y: 70.55))
		eyeouterPath.curve(to: CGPoint(x: 45, y: 70), controlPoint1: CGPoint(x: 47.6, y: 70.55), controlPoint2: CGPoint(x: 46.36, y: 70))
		eyeouterPath.curve(to: CGPoint(x: 41, y: 72), controlPoint1: CGPoint(x: 43.36, y: 70), controlPoint2: CGPoint(x: 41.91, y: 70.79))
		eyeouterPath.curve(to: CGPoint(x: 39.87, y: 70.9), controlPoint1: CGPoint(x: 40.68, y: 71.58), controlPoint2: CGPoint(x: 40.3, y: 71.21))
		eyeouterPath.curve(to: CGPoint(x: 37, y: 70), controlPoint1: CGPoint(x: 39.01, y: 70.32), controlPoint2: CGPoint(x: 38.04, y: 70))
		eyeouterPath.curve(to: CGPoint(x: 33.5, y: 71.43), controlPoint1: CGPoint(x: 35.64, y: 70), controlPoint2: CGPoint(x: 34.4, y: 70.55))
		eyeouterPath.line(to: CGPoint(x: 33.4, y: 71.34))
		eyeouterPath.curve(to: CGPoint(x: 30, y: 70), controlPoint1: CGPoint(x: 32.5, y: 70.5), controlPoint2: CGPoint(x: 31.31, y: 70))
		eyeouterPath.curve(to: CGPoint(x: 26.25, y: 71.69), controlPoint1: CGPoint(x: 28.51, y: 70), controlPoint2: CGPoint(x: 27.17, y: 70.65))
		eyeouterPath.curve(to: CGPoint(x: 22.5, y: 70), controlPoint1: CGPoint(x: 25.33, y: 70.65), controlPoint2: CGPoint(x: 23.99, y: 70))
		eyeouterPath.curve(to: CGPoint(x: 18.75, y: 71.69), controlPoint1: CGPoint(x: 21.01, y: 70), controlPoint2: CGPoint(x: 19.67, y: 70.65))
		eyeouterPath.curve(to: CGPoint(x: 18.03, y: 71.02), controlPoint1: CGPoint(x: 18.53, y: 71.45), controlPoint2: CGPoint(x: 18.29, y: 71.22))
		eyeouterPath.curve(to: CGPoint(x: 19.75, y: 67.25), controlPoint1: CGPoint(x: 19.08, y: 70.11), controlPoint2: CGPoint(x: 19.75, y: 68.76))
		eyeouterPath.curve(to: CGPoint(x: 19.08, y: 64.76), controlPoint1: CGPoint(x: 19.75, y: 66.34), controlPoint2: CGPoint(x: 19.51, y: 65.49))
		eyeouterPath.curve(to: CGPoint(x: 18.32, y: 63.75), controlPoint1: CGPoint(x: 18.87, y: 64.39), controlPoint2: CGPoint(x: 18.62, y: 64.05))
		eyeouterPath.curve(to: CGPoint(x: 19.75, y: 60.25), controlPoint1: CGPoint(x: 19.2, y: 62.85), controlPoint2: CGPoint(x: 19.75, y: 61.61))
		eyeouterPath.curve(to: CGPoint(x: 18.95, y: 57.53), controlPoint1: CGPoint(x: 19.75, y: 59.25), controlPoint2: CGPoint(x: 19.45, y: 58.31))
		eyeouterPath.curve(to: CGPoint(x: 17.75, y: 56.25), controlPoint1: CGPoint(x: 18.63, y: 57.04), controlPoint2: CGPoint(x: 18.22, y: 56.6))
		eyeouterPath.curve(to: CGPoint(x: 18.35, y: 55.72), controlPoint1: CGPoint(x: 17.96, y: 56.09), controlPoint2: CGPoint(x: 18.16, y: 55.91))
		eyeouterPath.curve(to: CGPoint(x: 19.75, y: 52.25), controlPoint1: CGPoint(x: 19.22, y: 54.82), controlPoint2: CGPoint(x: 19.75, y: 53.6))
		eyeouterPath.curve(to: CGPoint(x: 18.66, y: 49.13), controlPoint1: CGPoint(x: 19.75, y: 51.07), controlPoint2: CGPoint(x: 19.34, y: 49.98))
		eyeouterPath.curve(to: CGPoint(x: 18.32, y: 48.75), controlPoint1: CGPoint(x: 18.55, y: 49), controlPoint2: CGPoint(x: 18.44, y: 48.87))
		eyeouterPath.curve(to: CGPoint(x: 19.75, y: 45.25), controlPoint1: CGPoint(x: 19.2, y: 47.85), controlPoint2: CGPoint(x: 19.75, y: 46.61))
		eyeouterPath.curve(to: CGPoint(x: 17.75, y: 41.25), controlPoint1: CGPoint(x: 19.75, y: 43.61), controlPoint2: CGPoint(x: 18.96, y: 42.16))
		eyeouterPath.curve(to: CGPoint(x: 19.75, y: 37.25), controlPoint1: CGPoint(x: 18.96, y: 40.34), controlPoint2: CGPoint(x: 19.75, y: 38.89))
		eyeouterPath.curve(to: CGPoint(x: 18.32, y: 33.75), controlPoint1: CGPoint(x: 19.75, y: 35.89), controlPoint2: CGPoint(x: 19.2, y: 34.65))
		eyeouterPath.curve(to: CGPoint(x: 19.75, y: 30.25), controlPoint1: CGPoint(x: 19.2, y: 32.85), controlPoint2: CGPoint(x: 19.75, y: 31.61))
		eyeouterPath.curve(to: CGPoint(x: 18.06, y: 26.5), controlPoint1: CGPoint(x: 19.75, y: 28.76), controlPoint2: CGPoint(x: 19.1, y: 27.42))
		eyeouterPath.curve(to: CGPoint(x: 19.75, y: 22.75), controlPoint1: CGPoint(x: 19.1, y: 25.58), controlPoint2: CGPoint(x: 19.75, y: 24.24))
		eyeouterPath.curve(to: CGPoint(x: 18.03, y: 18.98), controlPoint1: CGPoint(x: 19.75, y: 21.24), controlPoint2: CGPoint(x: 19.08, y: 19.89))
		eyeouterPath.line(to: CGPoint(x: 18.17, y: 18.87))
		eyeouterPath.curve(to: CGPoint(x: 18.75, y: 18.31), controlPoint1: CGPoint(x: 18.38, y: 18.7), controlPoint2: CGPoint(x: 18.57, y: 18.51))
		eyeouterPath.curve(to: CGPoint(x: 21.23, y: 19.84), controlPoint1: CGPoint(x: 19.4, y: 19.04), controlPoint2: CGPoint(x: 20.26, y: 19.58))
		eyeouterPath.curve(to: CGPoint(x: 22.5, y: 20), controlPoint1: CGPoint(x: 21.64, y: 19.94), controlPoint2: CGPoint(x: 22.06, y: 20))
		eyeouterPath.curve(to: CGPoint(x: 26.25, y: 18.31), controlPoint1: CGPoint(x: 23.99, y: 20), controlPoint2: CGPoint(x: 25.33, y: 19.35))
		eyeouterPath.curve(to: CGPoint(x: 30, y: 20), controlPoint1: CGPoint(x: 27.17, y: 19.35), controlPoint2: CGPoint(x: 28.51, y: 20))
		eyeouterPath.curve(to: CGPoint(x: 33.5, y: 18.57), controlPoint1: CGPoint(x: 31.36, y: 20), controlPoint2: CGPoint(x: 32.6, y: 19.45))
		eyeouterPath.curve(to: CGPoint(x: 37, y: 20), controlPoint1: CGPoint(x: 34.4, y: 19.45), controlPoint2: CGPoint(x: 35.64, y: 20))
		eyeouterPath.curve(to: CGPoint(x: 41, y: 18), controlPoint1: CGPoint(x: 38.64, y: 20), controlPoint2: CGPoint(x: 40.09, y: 19.21))
		eyeouterPath.curve(to: CGPoint(x: 45, y: 20), controlPoint1: CGPoint(x: 41.91, y: 19.21), controlPoint2: CGPoint(x: 43.36, y: 20))
		eyeouterPath.curve(to: CGPoint(x: 48.5, y: 18.57), controlPoint1: CGPoint(x: 46.36, y: 20), controlPoint2: CGPoint(x: 47.6, y: 19.45))
		eyeouterPath.curve(to: CGPoint(x: 52, y: 20), controlPoint1: CGPoint(x: 49.4, y: 19.45), controlPoint2: CGPoint(x: 50.64, y: 20))
		eyeouterPath.curve(to: CGPoint(x: 56, y: 18), controlPoint1: CGPoint(x: 53.64, y: 20), controlPoint2: CGPoint(x: 55.09, y: 19.21))
		eyeouterPath.curve(to: CGPoint(x: 60, y: 20), controlPoint1: CGPoint(x: 56.91, y: 19.21), controlPoint2: CGPoint(x: 58.36, y: 20))
		eyeouterPath.curve(to: CGPoint(x: 63.5, y: 18.57), controlPoint1: CGPoint(x: 61.36, y: 20), controlPoint2: CGPoint(x: 62.6, y: 19.45))
		eyeouterPath.curve(to: CGPoint(x: 67, y: 20), controlPoint1: CGPoint(x: 64.4, y: 19.45), controlPoint2: CGPoint(x: 65.64, y: 20))
		eyeouterPath.curve(to: CGPoint(x: 71, y: 18), controlPoint1: CGPoint(x: 68.64, y: 20), controlPoint2: CGPoint(x: 70.09, y: 19.21))
		eyeouterPath.curve(to: CGPoint(x: 71.72, y: 18.77), controlPoint1: CGPoint(x: 71.21, y: 18.28), controlPoint2: CGPoint(x: 71.45, y: 18.54))
		eyeouterPath.curve(to: CGPoint(x: 69.75, y: 22.75), controlPoint1: CGPoint(x: 70.52, y: 19.69), controlPoint2: CGPoint(x: 69.75, y: 21.13))
		eyeouterPath.curve(to: CGPoint(x: 71.31, y: 26.37), controlPoint1: CGPoint(x: 69.75, y: 24.18), controlPoint2: CGPoint(x: 70.35, y: 25.46))
		eyeouterPath.line(to: CGPoint(x: 71.44, y: 26.5))
		eyeouterPath.curve(to: CGPoint(x: 69.75, y: 30.25), controlPoint1: CGPoint(x: 70.4, y: 27.42), controlPoint2: CGPoint(x: 69.75, y: 28.76))
		eyeouterPath.curve(to: CGPoint(x: 71.18, y: 33.75), controlPoint1: CGPoint(x: 69.75, y: 31.61), controlPoint2: CGPoint(x: 70.3, y: 32.85))
		eyeouterPath.curve(to: CGPoint(x: 69.75, y: 37.25), controlPoint1: CGPoint(x: 70.3, y: 34.65), controlPoint2: CGPoint(x: 69.75, y: 35.89))
		eyeouterPath.curve(to: CGPoint(x: 71.75, y: 41.25), controlPoint1: CGPoint(x: 69.75, y: 38.89), controlPoint2: CGPoint(x: 70.54, y: 40.34))
		eyeouterPath.curve(to: CGPoint(x: 69.75, y: 45.25), controlPoint1: CGPoint(x: 70.54, y: 42.16), controlPoint2: CGPoint(x: 69.75, y: 43.61))
		eyeouterPath.curve(to: CGPoint(x: 71.18, y: 48.75), controlPoint1: CGPoint(x: 69.75, y: 46.61), controlPoint2: CGPoint(x: 70.3, y: 47.85))
		eyeouterPath.curve(to: CGPoint(x: 69.75, y: 52.25), controlPoint1: CGPoint(x: 70.3, y: 49.65), controlPoint2: CGPoint(x: 69.75, y: 50.89))
		eyeouterPath.curve(to: CGPoint(x: 71.75, y: 56.25), controlPoint1: CGPoint(x: 69.75, y: 53.89), controlPoint2: CGPoint(x: 70.54, y: 55.34))
		eyeouterPath.curve(to: CGPoint(x: 69.97, y: 58.78), controlPoint1: CGPoint(x: 70.91, y: 56.88), controlPoint2: CGPoint(x: 70.28, y: 57.76))
		eyeouterPath.curve(to: CGPoint(x: 69.75, y: 60.25), controlPoint1: CGPoint(x: 69.83, y: 59.25), controlPoint2: CGPoint(x: 69.75, y: 59.74))
		eyeouterPath.curve(to: CGPoint(x: 71.18, y: 63.75), controlPoint1: CGPoint(x: 69.75, y: 61.61), controlPoint2: CGPoint(x: 70.3, y: 62.85))
		eyeouterPath.curve(to: CGPoint(x: 69.75, y: 67.25), controlPoint1: CGPoint(x: 70.3, y: 64.65), controlPoint2: CGPoint(x: 69.75, y: 65.89))
		eyeouterPath.curve(to: CGPoint(x: 71.72, y: 71.23), controlPoint1: CGPoint(x: 69.75, y: 68.87), controlPoint2: CGPoint(x: 70.52, y: 70.31))
		eyeouterPath.curve(to: CGPoint(x: 71, y: 72), controlPoint1: CGPoint(x: 71.45, y: 71.46), controlPoint2: CGPoint(x: 71.21, y: 71.72))
		eyeouterPath.close()
	}
}()

private let generatedEyeBackgroundPath__: CGPath = {
	CGPath.make { eyebackgroundPath in
		eyebackgroundPath.move(to: CGPoint(x: 90, y: 75))
		eyebackgroundPath.curve(to: CGPoint(x: 88.27, y: 68), controlPoint1: CGPoint(x: 90, y: 72.47), controlPoint2: CGPoint(x: 89.37, y: 70.09))
		eyebackgroundPath.curve(to: CGPoint(x: 90, y: 61), controlPoint1: CGPoint(x: 89.37, y: 65.91), controlPoint2: CGPoint(x: 90, y: 63.53))
		eyebackgroundPath.curve(to: CGPoint(x: 87.69, y: 53), controlPoint1: CGPoint(x: 90, y: 58.06), controlPoint2: CGPoint(x: 89.15, y: 55.32))
		eyebackgroundPath.curve(to: CGPoint(x: 90, y: 45), controlPoint1: CGPoint(x: 89.15, y: 50.68), controlPoint2: CGPoint(x: 90, y: 47.94))
		eyebackgroundPath.curve(to: CGPoint(x: 88.27, y: 38), controlPoint1: CGPoint(x: 90, y: 42.47), controlPoint2: CGPoint(x: 89.37, y: 40.09))
		eyebackgroundPath.curve(to: CGPoint(x: 90, y: 31), controlPoint1: CGPoint(x: 89.37, y: 35.91), controlPoint2: CGPoint(x: 90, y: 33.53))
		eyebackgroundPath.curve(to: CGPoint(x: 87.69, y: 23), controlPoint1: CGPoint(x: 90, y: 28.06), controlPoint2: CGPoint(x: 89.15, y: 25.32))
		eyebackgroundPath.curve(to: CGPoint(x: 90, y: 15), controlPoint1: CGPoint(x: 89.15, y: 20.68), controlPoint2: CGPoint(x: 90, y: 17.94))
		eyebackgroundPath.curve(to: CGPoint(x: 75, y: 0), controlPoint1: CGPoint(x: 90, y: 6.72), controlPoint2: CGPoint(x: 83.28, y: -0))
		eyebackgroundPath.curve(to: CGPoint(x: 67.5, y: 2.01), controlPoint1: CGPoint(x: 72.27, y: 0), controlPoint2: CGPoint(x: 69.71, y: 0.73))
		eyebackgroundPath.curve(to: CGPoint(x: 60, y: 0), controlPoint1: CGPoint(x: 65.29, y: 0.73), controlPoint2: CGPoint(x: 62.73, y: -0))
		eyebackgroundPath.curve(to: CGPoint(x: 52.5, y: 2.01), controlPoint1: CGPoint(x: 57.27, y: 0), controlPoint2: CGPoint(x: 54.71, y: 0.73))
		eyebackgroundPath.curve(to: CGPoint(x: 45, y: 0), controlPoint1: CGPoint(x: 50.29, y: 0.73), controlPoint2: CGPoint(x: 47.73, y: -0))
		eyebackgroundPath.curve(to: CGPoint(x: 37.5, y: 2.01), controlPoint1: CGPoint(x: 42.27, y: 0), controlPoint2: CGPoint(x: 39.71, y: 0.73))
		eyebackgroundPath.curve(to: CGPoint(x: 30, y: 0), controlPoint1: CGPoint(x: 35.29, y: 0.73), controlPoint2: CGPoint(x: 32.73, y: -0))
		eyebackgroundPath.curve(to: CGPoint(x: 22.5, y: 2.01), controlPoint1: CGPoint(x: 27.27, y: 0), controlPoint2: CGPoint(x: 24.71, y: 0.73))
		eyebackgroundPath.curve(to: CGPoint(x: 15, y: 0), controlPoint1: CGPoint(x: 20.29, y: 0.73), controlPoint2: CGPoint(x: 17.73, y: -0))
		eyebackgroundPath.curve(to: CGPoint(x: 4.81, y: 3.99), controlPoint1: CGPoint(x: 11.07, y: 0), controlPoint2: CGPoint(x: 7.49, y: 1.51))
		eyebackgroundPath.curve(to: CGPoint(x: 2.62, y: 6.52), controlPoint1: CGPoint(x: 3.99, y: 4.75), controlPoint2: CGPoint(x: 3.26, y: 5.6))
		eyebackgroundPath.curve(to: CGPoint(x: 0, y: 15), controlPoint1: CGPoint(x: 0.97, y: 8.94), controlPoint2: CGPoint(x: 0, y: 11.85))
		eyebackgroundPath.curve(to: CGPoint(x: 2.31, y: 23), controlPoint1: CGPoint(x: 0, y: 17.94), controlPoint2: CGPoint(x: 0.85, y: 20.68))
		eyebackgroundPath.curve(to: CGPoint(x: 0, y: 31), controlPoint1: CGPoint(x: 0.85, y: 25.32), controlPoint2: CGPoint(x: 0, y: 28.06))
		eyebackgroundPath.curve(to: CGPoint(x: 1.73, y: 38), controlPoint1: CGPoint(x: 0, y: 33.53), controlPoint2: CGPoint(x: 0.63, y: 35.91))
		eyebackgroundPath.curve(to: CGPoint(x: 0, y: 45), controlPoint1: CGPoint(x: 0.63, y: 40.09), controlPoint2: CGPoint(x: 0, y: 42.47))
		eyebackgroundPath.curve(to: CGPoint(x: 2.31, y: 53), controlPoint1: CGPoint(x: 0, y: 47.94), controlPoint2: CGPoint(x: 0.85, y: 50.68))
		eyebackgroundPath.curve(to: CGPoint(x: 0, y: 61), controlPoint1: CGPoint(x: 0.85, y: 55.32), controlPoint2: CGPoint(x: 0, y: 58.06))
		eyebackgroundPath.curve(to: CGPoint(x: 1.73, y: 68), controlPoint1: CGPoint(x: 0, y: 63.53), controlPoint2: CGPoint(x: 0.63, y: 65.91))
		eyebackgroundPath.curve(to: CGPoint(x: 0, y: 75), controlPoint1: CGPoint(x: 0.63, y: 70.09), controlPoint2: CGPoint(x: 0, y: 72.47))
		eyebackgroundPath.curve(to: CGPoint(x: 15, y: 90), controlPoint1: CGPoint(x: 0, y: 83.28), controlPoint2: CGPoint(x: 6.72, y: 90))
		eyebackgroundPath.curve(to: CGPoint(x: 22.5, y: 87.99), controlPoint1: CGPoint(x: 17.73, y: 90), controlPoint2: CGPoint(x: 20.29, y: 89.27))
		eyebackgroundPath.curve(to: CGPoint(x: 30, y: 90), controlPoint1: CGPoint(x: 24.71, y: 89.27), controlPoint2: CGPoint(x: 27.27, y: 90))
		eyebackgroundPath.curve(to: CGPoint(x: 37.5, y: 87.99), controlPoint1: CGPoint(x: 32.73, y: 90), controlPoint2: CGPoint(x: 35.29, y: 89.27))
		eyebackgroundPath.curve(to: CGPoint(x: 45, y: 90), controlPoint1: CGPoint(x: 39.71, y: 89.27), controlPoint2: CGPoint(x: 42.27, y: 90))
		eyebackgroundPath.curve(to: CGPoint(x: 52.5, y: 87.99), controlPoint1: CGPoint(x: 47.73, y: 90), controlPoint2: CGPoint(x: 50.29, y: 89.27))
		eyebackgroundPath.curve(to: CGPoint(x: 60, y: 90), controlPoint1: CGPoint(x: 54.71, y: 89.27), controlPoint2: CGPoint(x: 57.27, y: 90))
		eyebackgroundPath.curve(to: CGPoint(x: 67.5, y: 87.99), controlPoint1: CGPoint(x: 62.73, y: 90), controlPoint2: CGPoint(x: 65.29, y: 89.27))
		eyebackgroundPath.curve(to: CGPoint(x: 75, y: 90), controlPoint1: CGPoint(x: 69.71, y: 89.27), controlPoint2: CGPoint(x: 72.27, y: 90))
		eyebackgroundPath.curve(to: CGPoint(x: 90, y: 75), controlPoint1: CGPoint(x: 83.28, y: 90), controlPoint2: CGPoint(x: 90, y: 83.28))
		eyebackgroundPath.close()
	}
}()
