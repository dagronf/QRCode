//
//  CGPath+SVG.swift
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

import Foundation
import CoreGraphics

private let _numFormatter: NumberFormatter = {
	let f = NumberFormatter()
	f.maximumFractionDigits = 3
	f.minimumFractionDigits = 0
	return f
}()

private func F(_ val: CGFloat) -> String {
	_numFormatter.string(from: NSNumber(floatLiteral: val))!
}

extension CGPath {
	/// Convert a CGPath to an SVG data path instance
	///
	/// Converts the CGPath instance to an SVG path's "d" value
	///
	/// eg. `<path fill="#ffffff" fill-opacity="1.0" d="<<this part>>" />`
	func svgDataPath() -> String {
		var svg = ""

		self.applyWithBlock { elem in
			let elementType = elem.pointee.type

			let command: String = {
				switch elementType {
				case .moveToPoint:
					let xVal = elem.pointee.points[0]
					return "M\(F(xVal.x)) \(F(xVal.y))"
				case .addLineToPoint:
					let xVal = elem.pointee.points[0]
					return "L\(F(xVal.x)) \(F(xVal.y))"
				case .addQuadCurveToPoint:
					let endPoint = elem.pointee.points[1]
					let controlPoint = elem.pointee.points[0]
					return "Q\(F(endPoint.x)),\(F(endPoint.y)) \(F(controlPoint.x)),\(F(controlPoint.y))"
				case .addCurveToPoint:
					let toPoint = elem.pointee.points[2]
					let control1 = elem.pointee.points[0]
					let control2 = elem.pointee.points[1]
					return "C\(F(control1.x)),\(F(control1.y)) \(F(control2.x)),\(F(control2.y)) \(F(toPoint.x)),\(F(toPoint.y))"
				case .closeSubpath: return "Z"
				default: return "Z"
				}
			}()

			svg.append("\(command) ")
		}

		return svg
	}
}
