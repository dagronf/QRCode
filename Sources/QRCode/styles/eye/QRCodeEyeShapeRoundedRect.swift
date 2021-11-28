//
//  QRCodeEyeStyleRoundedRect.swift
//
//  Created by Darren Ford on 17/11/21.
//  Copyright © 2021 Darren Ford. All rights reserved.
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
	/// A 'rounded rect with a pointy bit facing inwards' style eye design
	@objc(QRCodeEyeStyleRoundedRect) class RoundedRect: NSObject, QRCodeEyeShapeHandler {

		public let name: String = "roundedrect"

		public func copyShape() -> QRCodeEyeShapeHandler {
			return RoundedRect()
		}

		public func eyePath() -> CGPath {
			let roundedRectEyePath = CGMutablePath()
			roundedRectEyePath.move(to: CGPoint(x: 65, y: 20))
			roundedRectEyePath.line(to: CGPoint(x: 25, y: 20))
			roundedRectEyePath.curve(to: CGPoint(x: 20, y: 25), controlPoint1: CGPoint(x: 22.24, y: 20), controlPoint2: CGPoint(x: 20, y: 22.24))
			roundedRectEyePath.line(to: CGPoint(x: 20, y: 65))
			roundedRectEyePath.curve(to: CGPoint(x: 25, y: 70), controlPoint1: CGPoint(x: 20, y: 67.76), controlPoint2: CGPoint(x: 22.24, y: 70))
			roundedRectEyePath.line(to: CGPoint(x: 65, y: 70))
			roundedRectEyePath.curve(to: CGPoint(x: 70, y: 65), controlPoint1: CGPoint(x: 67.76, y: 70), controlPoint2: CGPoint(x: 70, y: 67.76))
			roundedRectEyePath.line(to: CGPoint(x: 70, y: 25))
			roundedRectEyePath.curve(to: CGPoint(x: 65, y: 20), controlPoint1: CGPoint(x: 70, y: 22.24), controlPoint2: CGPoint(x: 67.76, y: 20))
			roundedRectEyePath.close()
			roundedRectEyePath.move(to: CGPoint(x: 80, y: 20))
			roundedRectEyePath.line(to: CGPoint(x: 80, y: 70))
			roundedRectEyePath.curve(to: CGPoint(x: 70, y: 80), controlPoint1: CGPoint(x: 80, y: 75.52), controlPoint2: CGPoint(x: 75.52, y: 80))
			roundedRectEyePath.line(to: CGPoint(x: 20, y: 80))
			roundedRectEyePath.curve(to: CGPoint(x: 10, y: 70), controlPoint1: CGPoint(x: 14.48, y: 80), controlPoint2: CGPoint(x: 10, y: 75.52))
			roundedRectEyePath.line(to: CGPoint(x: 10, y: 20))
			roundedRectEyePath.curve(to: CGPoint(x: 20, y: 10), controlPoint1: CGPoint(x: 10, y: 14.48), controlPoint2: CGPoint(x: 14.48, y: 10))
			roundedRectEyePath.line(to: CGPoint(x: 70, y: 10))
			roundedRectEyePath.curve(to: CGPoint(x: 80, y: 20), controlPoint1: CGPoint(x: 75.52, y: 10), controlPoint2: CGPoint(x: 80, y: 14.48))
			roundedRectEyePath.close()

			return roundedRectEyePath
		}

		public func pupilPath() -> CGPath {
			// NSBezierPath(roundedRect: NSRect(x: 30, y: 30, width: 30, height: 30), xRadius: 4, yRadius: 4)
			return CGPath(roundedRect: CGRect(x: 30, y: 30, width: 30, height: 30), cornerWidth: 4, cornerHeight: 4, transform: nil)
		}
	}
}
