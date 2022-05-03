//
//  QRCodeEyeStyleLeaf.swift
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
	@objc(QRCodeEyeStyleRoundedPointingIn) class RoundedPointingIn: NSObject, QRCodeEyeShapeGenerator {

		@objc public static let Name: String = "roundedpointingin"
		@objc static public func Create(_ settings: [String: Any]?) -> QRCodeEyeShapeGenerator {
			return QRCode.EyeShape.RoundedPointingIn()
		}
		@objc public func settings() -> [String : Any] { return [:] }
		
		public func copyShape() -> QRCodeEyeShapeGenerator {
			return RoundedPointingIn()
		}

		public func eyePath() -> CGPath {
			let tearEyePath = CGMutablePath()
			tearEyePath.move(to: CGPoint(x: 57, y: 20))
			tearEyePath.addLine(to: CGPoint(x: 33, y: 20))
			tearEyePath.addCurve(to: CGPoint(x: 20, y: 33), control1: CGPoint(x: 25.82, y: 20), control2: CGPoint(x: 20, y: 25.82))
			tearEyePath.addLine(to: CGPoint(x: 20, y: 57))
			tearEyePath.addCurve(to: CGPoint(x: 33, y: 70), control1: CGPoint(x: 20, y: 64.18), control2: CGPoint(x: 25.82, y: 70))
			tearEyePath.addLine(to: CGPoint(x: 70, y: 70))
			tearEyePath.addLine(to: CGPoint(x: 70, y: 33))
			tearEyePath.addCurve(to: CGPoint(x: 57, y: 20), control1: CGPoint(x: 70, y: 25.82), control2: CGPoint(x: 64.18, y: 20))
			tearEyePath.close()
			tearEyePath.move(to: CGPoint(x: 80, y: 33))
			tearEyePath.addLine(to: CGPoint(x: 80, y: 80))
			tearEyePath.addLine(to: CGPoint(x: 33, y: 80))
			tearEyePath.addCurve(to: CGPoint(x: 10, y: 57), control1: CGPoint(x: 20.3, y: 80), control2: CGPoint(x: 10, y: 69.7))
			tearEyePath.addLine(to: CGPoint(x: 10, y: 33))
			tearEyePath.addCurve(to: CGPoint(x: 33, y: 10), control1: CGPoint(x: 10, y: 20.3), control2: CGPoint(x: 20.3, y: 10))
			tearEyePath.addLine(to: CGPoint(x: 57, y: 10))
			tearEyePath.addCurve(to: CGPoint(x: 80, y: 33), control1: CGPoint(x: 69.7, y: 10), control2: CGPoint(x: 80, y: 20.3))
			tearEyePath.close()
			return tearEyePath
		}

		public func pupilPath() -> CGPath {
			let roundedPupil = CGPath.RoundedRect(
				rect: CGRect(x: 30, y: 30, width: 30, height: 30),
				cornerRadius: 6,
				byRoundingCorners: [.topLeft, .bottomLeft, .topRight]
			)
			return roundedPupil
		}
	}
}
