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

/// Decimal formatter for SVG output
///
/// Note that SVG _expects_ the decimal separator to be '.', which means we have to force the separator
/// so that locales that use ',' as the decimal separator don't produce a garbled SVG
/// See [Issue 19](https://github.com/dagronf/QRCode/issues/19)
private let _svgFloatFormatter: NumberFormatter = {
	let f = NumberFormatter()
	f.decimalSeparator = "."
	f.usesGroupingSeparator = false
	#if os(macOS)
	f.hasThousandSeparators = false
	#endif
	f.maximumFractionDigits = 3
	f.minimumFractionDigits = 0
	return f
}()

func _SVGF<ValueType: BinaryFloatingPoint>(_ val: ValueType) -> String {
	_svgFloatFormatter.string(from: NSNumber(floatLiteral: Double(val)))!
}

extension CGPath {
	/// Convert a CGPath to an SVG data path instance
	///
	/// Converts the CGPath instance to an SVG path's "d" value
	///
	/// eg. `<path fill="#ffffff" fill-opacity="1.0" d="<<this part>>" />`
	func svgDataPath() -> String {
		var svg = ""

		self.applyWithBlockSafe { elem in
			let elementType = elem.pointee.type

			let command: String = {
				switch elementType {
				case .moveToPoint:
					let xVal = elem.pointee.points[0]
					return "M\(_SVGF(xVal.x)) \(_SVGF(xVal.y))"
				case .addLineToPoint:
					let xVal = elem.pointee.points[0]
					return "L\(_SVGF(xVal.x)) \(_SVGF(xVal.y))"
				case .addQuadCurveToPoint:
					let endPoint = elem.pointee.points[1]
					let controlPoint = elem.pointee.points[0]
					return "Q\(_SVGF(endPoint.x)),\(_SVGF(endPoint.y)) \(_SVGF(controlPoint.x)),\(_SVGF(controlPoint.y))"
				case .addCurveToPoint:
					let toPoint = elem.pointee.points[2]
					let control1 = elem.pointee.points[0]
					let control2 = elem.pointee.points[1]
					return "C\(_SVGF(control1.x)),\(_SVGF(control1.y)) \(_SVGF(control2.x)),\(_SVGF(control2.y)) \(_SVGF(toPoint.x)),\(_SVGF(toPoint.y))"
				case .closeSubpath: return "Z"
				default: return "Z"
				}
			}()

			svg.append("\(command) ")
		}

		return svg
	}
}
