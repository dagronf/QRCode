//
//  NSBezierPath+extensions.swift
//
//  Copyright © 2023 Darren Ford. All rights reserved.
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

//  Conversion routines for NSBezierPath <--> CGPath

#if os(macOS)

import Foundation
import AppKit

extension NSBezierPath {
	/// Create a CGPath
	var cgPath: CGPath {
		let path = CGMutablePath()
		var points = [CGPoint](repeating: .zero, count: 3)
		for i in 0 ..< self.elementCount {
			let type = self.element(at: i, associatedPoints: &points)
			switch type {
			case .moveTo: path.move(to: points[0])
			case .lineTo: path.addLine(to: points[0])
			case .curveTo: path.addCurve(to: points[2], control1: points[0], control2: points[1])
			case .closePath: path.closeSubpath()
			default:
				// Ignore
				print("Unexpected path type?")
			}
		}
		return path
	}

	/// Create an NSBezierPath from a cgPath
	///
	/// See:
	///
	///   - [Stack Overflow](https://stackoverflow.com/a/49011112)
	///   - [Internet Archive](https://web.archive.org/web/20230110234822/https://stackoverflow.com/questions/45967240/convert-cgpathref-to-nsbezierpath/49011112)
	///   - [FontForge Conversion Algorithm](https://web.archive.org/web/20171206011021/http://fontforge.github.io/bezier.html)
	convenience init(cgPath: CGPath) {
		self.init()
		cgPath.applyWithBlockSafe { [weak self] (elementPointer: UnsafePointer<CGPathElement>) in
			guard let `self` = self else { return }
			let element = elementPointer.pointee
			let points = element.points
			switch element.type {
			case .moveToPoint:
				self.move(to: points.pointee)
			case .addLineToPoint:
				self.line(to: points.pointee)
			case .addQuadCurveToPoint:
				let qp0 = self.currentPoint
				let qp1 = points.pointee
				let qp2 = points.successor().pointee
				let m = 2.0/3.0
				let cp1 = NSPoint(
					x: qp0.x + ((qp1.x - qp0.x) * m),
					y: qp0.y + ((qp1.y - qp0.y) * m)
				)
				let cp2 = NSPoint(
					x: qp2.x + ((qp1.x - qp2.x) * m),
					y: qp2.y + ((qp1.y - qp2.y) * m)
				)
				self.curve(to: qp2, controlPoint1: cp1, controlPoint2: cp2)
			case .addCurveToPoint:
				let cp1 = points.pointee
				let cp2 = points.advanced(by: 1).pointee
				let target = points.advanced(by: 2).pointee
				self.curve(to: target, controlPoint1: cp1, controlPoint2: cp2)
			case .closeSubpath:
				self.close()
			@unknown default:
				fatalError("Unknown type \(element.type)")
			}
		}
	}
}

#endif
