//
//  QRCodePupilShapeBlobby.swift
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

import CoreGraphics
import Foundation

extension QRCode.PupilShape {
	/// A hexagonal leaf pupil design
	@objc(QRCodePupilShapeBlobby) public class Blobby: NSObject, QRCodePupilShapeGenerator {
		/// Generator name
		@objc public static var Name: String { "blobby" }
		/// Generator title
		@objc public static var Title: String { "Blobby" }
		/// Create a hexagon leaf pupil shape, using the specified settings
		@objc public static func Create(_ settings: [String : Any]?) -> any QRCodePupilShapeGenerator { Blobby() }
		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePupilShapeGenerator { Blobby() }

		@objc public func settings() -> [String: Any] { [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_: Any?, forKey _: String) -> Bool { false }

		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath { _path() }
	}
}

private func _path() -> CGPath {
	let bezierPath = CGMutablePath()
	bezierPath.move(to: CGPoint(x: 60, y: 55))
	bezierPath.curve(to: CGPoint(x: 56, y: 50.1), controlPoint1: CGPoint(x: 60, y: 52.58), controlPoint2: CGPoint(x: 58.28, y: 50.56))
	bezierPath.line(to: CGPoint(x: 56, y: 49.9))
	bezierPath.curve(to: CGPoint(x: 60, y: 45), controlPoint1: CGPoint(x: 58.28, y: 49.44), controlPoint2: CGPoint(x: 60, y: 47.42))
	bezierPath.curve(to: CGPoint(x: 56, y: 40.1), controlPoint1: CGPoint(x: 60, y: 42.58), controlPoint2: CGPoint(x: 58.28, y: 40.56))
	bezierPath.line(to: CGPoint(x: 56, y: 39.9))
	bezierPath.curve(to: CGPoint(x: 60, y: 35), controlPoint1: CGPoint(x: 58.28, y: 39.44), controlPoint2: CGPoint(x: 60, y: 37.42))
	bezierPath.curve(to: CGPoint(x: 55, y: 30), controlPoint1: CGPoint(x: 60, y: 32.24), controlPoint2: CGPoint(x: 57.76, y: 30))
	bezierPath.curve(to: CGPoint(x: 52.74, y: 30.54), controlPoint1: CGPoint(x: 54.19, y: 30), controlPoint2: CGPoint(x: 53.42, y: 30.19))
	bezierPath.curve(to: CGPoint(x: 50.1, y: 34), controlPoint1: CGPoint(x: 51.4, y: 31.22), controlPoint2: CGPoint(x: 50.41, y: 32.49))
	bezierPath.curve(to: CGPoint(x: 49.9, y: 34), controlPoint1: CGPoint(x: 50.1, y: 34), controlPoint2: CGPoint(x: 50.03, y: 34))
	bezierPath.curve(to: CGPoint(x: 45, y: 30), controlPoint1: CGPoint(x: 49.44, y: 31.72), controlPoint2: CGPoint(x: 47.42, y: 30))
	bezierPath.curve(to: CGPoint(x: 43.5, y: 30.23), controlPoint1: CGPoint(x: 44.48, y: 30), controlPoint2: CGPoint(x: 43.97, y: 30.08))
	bezierPath.curve(to: CGPoint(x: 40.1, y: 34), controlPoint1: CGPoint(x: 41.78, y: 30.77), controlPoint2: CGPoint(x: 40.46, y: 32.21))
	bezierPath.line(to: CGPoint(x: 39.9, y: 34))
	bezierPath.curve(to: CGPoint(x: 35, y: 30), controlPoint1: CGPoint(x: 39.44, y: 31.72), controlPoint2: CGPoint(x: 37.42, y: 30))
	bezierPath.curve(to: CGPoint(x: 31.47, y: 31.46), controlPoint1: CGPoint(x: 33.62, y: 30), controlPoint2: CGPoint(x: 32.37, y: 30.56))
	bezierPath.curve(to: CGPoint(x: 30, y: 35), controlPoint1: CGPoint(x: 30.56, y: 32.37), controlPoint2: CGPoint(x: 30, y: 33.62))
	bezierPath.curve(to: CGPoint(x: 34, y: 39.9), controlPoint1: CGPoint(x: 30, y: 37.42), controlPoint2: CGPoint(x: 31.72, y: 39.44))
	bezierPath.line(to: CGPoint(x: 34, y: 40.1))
	bezierPath.curve(to: CGPoint(x: 30.84, y: 42.22), controlPoint1: CGPoint(x: 32.69, y: 40.37), controlPoint2: CGPoint(x: 31.56, y: 41.15))
	bezierPath.curve(to: CGPoint(x: 30, y: 45), controlPoint1: CGPoint(x: 30.31, y: 43.01), controlPoint2: CGPoint(x: 30, y: 43.97))
	bezierPath.curve(to: CGPoint(x: 34, y: 49.9), controlPoint1: CGPoint(x: 30, y: 47.42), controlPoint2: CGPoint(x: 31.72, y: 49.44))
	bezierPath.line(to: CGPoint(x: 34, y: 50.1))
	bezierPath.curve(to: CGPoint(x: 30, y: 55), controlPoint1: CGPoint(x: 31.72, y: 50.56), controlPoint2: CGPoint(x: 30, y: 52.58))
	bezierPath.curve(to: CGPoint(x: 35, y: 60), controlPoint1: CGPoint(x: 30, y: 57.76), controlPoint2: CGPoint(x: 32.24, y: 60))
	bezierPath.curve(to: CGPoint(x: 39.9, y: 56), controlPoint1: CGPoint(x: 37.42, y: 60), controlPoint2: CGPoint(x: 39.44, y: 58.28))
	bezierPath.line(to: CGPoint(x: 40.1, y: 56))
	bezierPath.curve(to: CGPoint(x: 45, y: 60), controlPoint1: CGPoint(x: 40.56, y: 58.28), controlPoint2: CGPoint(x: 42.58, y: 60))
	bezierPath.curve(to: CGPoint(x: 49.9, y: 56), controlPoint1: CGPoint(x: 47.42, y: 60), controlPoint2: CGPoint(x: 49.44, y: 58.28))
	bezierPath.line(to: CGPoint(x: 50.1, y: 56))
	bezierPath.curve(to: CGPoint(x: 55, y: 60), controlPoint1: CGPoint(x: 50.56, y: 58.28), controlPoint2: CGPoint(x: 52.58, y: 60))
	bezierPath.curve(to: CGPoint(x: 60, y: 55), controlPoint1: CGPoint(x: 57.76, y: 60), controlPoint2: CGPoint(x: 60, y: 57.76))
	bezierPath.close()
	return bezierPath
}
