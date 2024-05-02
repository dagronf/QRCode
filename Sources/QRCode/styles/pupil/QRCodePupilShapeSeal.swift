//
//  QRCodePupilShapeSeal.swift
//
//  Copyright © 2024 Darren Ford, Aydin Aghayev. All rights reserved.
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

extension QRCode.PupilShape {
	/// A seal pupil design
	@objc(QRCodePupilShapeSeal) public class Seal: NSObject, QRCodePupilShapeGenerator {
		/// Generator name
		@objc public static var Name: String { "seal" }
		/// Generator title
		@objc public static var Title: String { "Seal" }
		/// Create a seal pupil shape, using the specified settings
		@objc public static func Create(_ settings: [String : Any]?) -> any QRCodePupilShapeGenerator { Seal() }
		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePupilShapeGenerator { Seal() }

		@objc public func settings() -> [String: Any] { [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_: Any?, forKey _: String) -> Bool { false }

		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath { _pupilPath() }
	}
}

private func _pupilPath() -> CGPath {
	let shieldPath = CGMutablePath()
	shieldPath.move(to: CGPoint(x: 37.04, y: 33.54))
	shieldPath.curve(to: CGPoint(x: 34.39, y: 34.4), controlPoint1: CGPoint(x: 35.84, y: 33.54), controlPoint2: CGPoint(x: 34.96, y: 33.82))
	shieldPath.curve(to: CGPoint(x: 33.53, y: 37.04), controlPoint1: CGPoint(x: 33.81, y: 34.97), controlPoint2: CGPoint(x: 33.53, y: 35.85))
	shieldPath.line(to: CGPoint(x: 33.53, y: 39.87))
	shieldPath.curve(to: CGPoint(x: 33.27, y: 40.52), controlPoint1: CGPoint(x: 33.53, y: 40.12), controlPoint2: CGPoint(x: 33.44, y: 40.34))
	shieldPath.line(to: CGPoint(x: 31.27, y: 42.53))
	shieldPath.curve(to: CGPoint(x: 30, y: 45), controlPoint1: CGPoint(x: 30.43, y: 43.37), controlPoint2: CGPoint(x: 30, y: 44.19))
	shieldPath.curve(to: CGPoint(x: 31.27, y: 47.48), controlPoint1: CGPoint(x: 30, y: 45.8), controlPoint2: CGPoint(x: 30.42, y: 46.63))
	shieldPath.line(to: CGPoint(x: 33.27, y: 49.48))
	shieldPath.curve(to: CGPoint(x: 33.53, y: 50.13), controlPoint1: CGPoint(x: 33.44, y: 49.66), controlPoint2: CGPoint(x: 33.53, y: 49.88))
	shieldPath.line(to: CGPoint(x: 33.53, y: 52.96))
	shieldPath.curve(to: CGPoint(x: 34.38, y: 55.62), controlPoint1: CGPoint(x: 33.53, y: 54.17), controlPoint2: CGPoint(x: 33.81, y: 55.05))
	shieldPath.curve(to: CGPoint(x: 37.04, y: 56.47), controlPoint1: CGPoint(x: 34.96, y: 56.19), controlPoint2: CGPoint(x: 35.84, y: 56.47))
	shieldPath.line(to: CGPoint(x: 39.87, y: 56.47))
	shieldPath.curve(to: CGPoint(x: 40.5, y: 56.73), controlPoint1: CGPoint(x: 40.12, y: 56.47), controlPoint2: CGPoint(x: 40.33, y: 56.56))
	shieldPath.line(to: CGPoint(x: 42.52, y: 58.73))
	shieldPath.curve(to: CGPoint(x: 45, y: 60), controlPoint1: CGPoint(x: 43.37, y: 59.57), controlPoint2: CGPoint(x: 44.2, y: 60))
	shieldPath.curve(to: CGPoint(x: 47.47, y: 58.73), controlPoint1: CGPoint(x: 45.8, y: 60), controlPoint2: CGPoint(x: 46.63, y: 59.58))
	shieldPath.line(to: CGPoint(x: 49.48, y: 56.73))
	shieldPath.curve(to: CGPoint(x: 50.13, y: 56.47), controlPoint1: CGPoint(x: 49.65, y: 56.56), controlPoint2: CGPoint(x: 49.87, y: 56.47))
	shieldPath.line(to: CGPoint(x: 52.96, y: 56.47))
	shieldPath.curve(to: CGPoint(x: 55.61, y: 55.61), controlPoint1: CGPoint(x: 54.16, y: 56.47), controlPoint2: CGPoint(x: 55.04, y: 56.19))
	shieldPath.curve(to: CGPoint(x: 56.46, y: 52.96), controlPoint1: CGPoint(x: 56.18, y: 55.03), controlPoint2: CGPoint(x: 56.46, y: 54.15))
	shieldPath.line(to: CGPoint(x: 56.46, y: 50.13))
	shieldPath.curve(to: CGPoint(x: 56.73, y: 49.48), controlPoint1: CGPoint(x: 56.46, y: 49.88), controlPoint2: CGPoint(x: 56.55, y: 49.66))
	shieldPath.line(to: CGPoint(x: 58.72, y: 47.48))
	shieldPath.curve(to: CGPoint(x: 60, y: 45), controlPoint1: CGPoint(x: 59.57, y: 46.63), controlPoint2: CGPoint(x: 60, y: 45.8))
	shieldPath.curve(to: CGPoint(x: 58.72, y: 42.53), controlPoint1: CGPoint(x: 60, y: 44.19), controlPoint2: CGPoint(x: 59.58, y: 43.37))
	shieldPath.line(to: CGPoint(x: 56.73, y: 40.52))
	shieldPath.curve(to: CGPoint(x: 56.46, y: 39.87), controlPoint1: CGPoint(x: 56.55, y: 40.34), controlPoint2: CGPoint(x: 56.46, y: 40.12))
	shieldPath.line(to: CGPoint(x: 56.46, y: 37.04))
	shieldPath.curve(to: CGPoint(x: 55.6, y: 34.39), controlPoint1: CGPoint(x: 56.46, y: 35.84), controlPoint2: CGPoint(x: 56.18, y: 34.96))
	shieldPath.curve(to: CGPoint(x: 52.96, y: 33.54), controlPoint1: CGPoint(x: 55.03, y: 33.82), controlPoint2: CGPoint(x: 54.15, y: 33.54))
	shieldPath.line(to: CGPoint(x: 50.13, y: 33.54))
	shieldPath.curve(to: CGPoint(x: 49.48, y: 33.27), controlPoint1: CGPoint(x: 49.87, y: 33.54), controlPoint2: CGPoint(x: 49.65, y: 33.45))
	shieldPath.line(to: CGPoint(x: 47.47, y: 31.28))
	shieldPath.curve(to: CGPoint(x: 45, y: 30), controlPoint1: CGPoint(x: 46.63, y: 30.43), controlPoint2: CGPoint(x: 45.81, y: 30))
	shieldPath.curve(to: CGPoint(x: 42.52, y: 31.28), controlPoint1: CGPoint(x: 44.2, y: 30), controlPoint2: CGPoint(x: 43.37, y: 30.42))
	shieldPath.line(to: CGPoint(x: 40.5, y: 33.27))
	shieldPath.curve(to: CGPoint(x: 39.87, y: 33.54), controlPoint1: CGPoint(x: 40.33, y: 33.45), controlPoint2: CGPoint(x: 40.12, y: 33.54))
	shieldPath.line(to: CGPoint(x: 37.04, y: 33.54))
	shieldPath.close()
	return shieldPath
}
