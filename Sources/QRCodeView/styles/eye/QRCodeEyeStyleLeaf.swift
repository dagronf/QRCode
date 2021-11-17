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

import Foundation
import CoreGraphics

@objc public class QRCodeEyeStyleLeaf: NSObject, QRCodeEyeShape {

	public func copyShape() -> QRCodeEyeShape {
		return QRCodeEyeStyleLeaf()
	}

	public func eyePath() -> CGPath {
		let eyePath = CGMutablePath()
		eyePath.move(to: CGPoint(x: 20, y: 20))
		eyePath.addLine(to: CGPoint(x: 60, y: 20))
		eyePath.addCurve(to: CGPoint(x: 70, y: 30), control1: CGPoint(x: 65.52, y: 20), control2: CGPoint(x: 70, y: 24.48))
		eyePath.addLine(to: CGPoint(x: 70, y: 70))
		eyePath.addLine(to: CGPoint(x: 30, y: 70))
		eyePath.addCurve(to: CGPoint(x: 20, y: 60), control1: CGPoint(x: 24.48, y: 70), control2: CGPoint(x: 20, y: 65.52))
		eyePath.addLine(to: CGPoint(x: 20, y: 20))
		eyePath.close()
		eyePath.move(to: CGPoint(x: 10, y: 10))
		eyePath.addCurve(to: CGPoint(x: 10, y: 60), control1: CGPoint(x: 10, y: 10), control2: CGPoint(x: 10, y: 60))
		eyePath.addCurve(to: CGPoint(x: 30, y: 80), control1: CGPoint(x: 10, y: 71.05), control2: CGPoint(x: 18.95, y: 80))
		eyePath.addLine(to: CGPoint(x: 80, y: 80))
		eyePath.addLine(to: CGPoint(x: 80, y: 30))
		eyePath.addCurve(to: CGPoint(x: 60, y: 10), control1: CGPoint(x: 80, y: 18.95), control2: CGPoint(x: 71.05, y: 10))
		eyePath.addLine(to: CGPoint(x: 10, y: 10))
		eyePath.addLine(to: CGPoint(x: 10, y: 10))
		eyePath.close()
		return eyePath
	}

	public func pupilPath() -> CGPath {
//		let pupilCornerRadius: CGFloat = 4
//		let pupilRect = CGRect(x: 30, y: 30, width: 30, height: 30)
//		let pupilInnerRect = pupilRect.insetBy(dx: pupilCornerRadius, dy: pupilCornerRadius)
//		let pupilPath = CGMutablePath()
//		pupilPath.addArc(center: CGPoint(x: pupilInnerRect.minX, y: pupilInnerRect.minY), radius: pupilCornerRadius, startAngle:  180, endAngle: 270, clockwise: true)
//		pupilPath.line(to: CGPoint(x: pupilRect.maxX, y: pupilRect.minY))
//		pupilPath.addArc(center: CGPoint(x: pupilInnerRect.maxX, y: pupilInnerRect.maxY), radius: pupilCornerRadius, startAngle: 0, endAngle: 90, clockwise: false)
//		pupilPath.line(to: CGPoint(x: pupilRect.minX, y: pupilRect.maxY))
//		pupilPath.close()
//		return pupilPath

		let roundedPupil = CGPath.RoundRect(
			rect: CGRect(x: 30, y: 30, width: 30, height: 30),
			cornerRadius: 6,
			byRoundingCorners: [.topRight, .bottomLeft]
		)
		return roundedPupil
	}

}
