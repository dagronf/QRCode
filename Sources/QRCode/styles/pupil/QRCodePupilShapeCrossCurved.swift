//
//  QRCodePupilShapeCrossCurved.swift
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

// MARK: - Pupil shape

public extension QRCode.PupilShape {
	/// A cross style pupil design with curved inset edges
	@objc(QRCodePupilShapeCrossCurved) class CrossCurved: NSObject, QRCodePupilShapeGenerator {
		@objc public static var Name: String { "crossCurved" }
		/// The generator title
		@objc public static var Title: String { "CrossCurved" }
		/// Creator
		@objc public static func Create(_ settings: [String : Any]?) -> any QRCodePupilShapeGenerator { CrossCurved() }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePupilShapeGenerator {
			CrossCurved()
		}

		// Settings

		@objc public func settings() -> [String : Any] { [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath {
			let crossPath = CGMutablePath()
			crossPath.move(to: CGPoint(x: 30, y: 50))
			crossPath.curve(to: CGPoint(x: 34, y: 45), controlPoint1: CGPoint(x: 30, y: 50), controlPoint2: CGPoint(x: 34, y: 49))
			crossPath.curve(to: CGPoint(x: 30, y: 40), controlPoint1: CGPoint(x: 34, y: 41), controlPoint2: CGPoint(x: 30, y: 40))
			crossPath.line(to: CGPoint(x: 30, y: 30))
			crossPath.line(to: CGPoint(x: 40, y: 30))
			crossPath.curve(to: CGPoint(x: 45, y: 34), controlPoint1: CGPoint(x: 40, y: 30), controlPoint2: CGPoint(x: 41, y: 34))
			crossPath.curve(to: CGPoint(x: 50, y: 30), controlPoint1: CGPoint(x: 49, y: 34), controlPoint2: CGPoint(x: 50, y: 30))
			crossPath.line(to: CGPoint(x: 60, y: 30))
			crossPath.line(to: CGPoint(x: 60, y: 40))
			crossPath.curve(to: CGPoint(x: 56, y: 45), controlPoint1: CGPoint(x: 60, y: 40), controlPoint2: CGPoint(x: 56, y: 41))
			crossPath.curve(to: CGPoint(x: 60, y: 50), controlPoint1: CGPoint(x: 56, y: 49), controlPoint2: CGPoint(x: 60, y: 50))
			crossPath.line(to: CGPoint(x: 60, y: 60))
			crossPath.line(to: CGPoint(x: 50, y: 60))
			crossPath.curve(to: CGPoint(x: 45, y: 56), controlPoint1: CGPoint(x: 50, y: 60), controlPoint2: CGPoint(x: 49, y: 56))
			crossPath.curve(to: CGPoint(x: 40, y: 60), controlPoint1: CGPoint(x: 41, y: 56), controlPoint2: CGPoint(x: 40, y: 60))
			crossPath.line(to: CGPoint(x: 30, y: 60))
			crossPath.line(to: CGPoint(x: 30, y: 50))
			crossPath.close()
			return crossPath
		}
	}
}
