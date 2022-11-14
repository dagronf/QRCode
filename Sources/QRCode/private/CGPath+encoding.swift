//
//  CGPath+encoding.swift
//
//  Copyright © 2022 Darren Ford. All rights reserved.
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

// MARK: - Data encode/decode

internal func encodeCGPath(path: CGPath) -> Data {
	var elements = [_PathElement]()

	path.applyWithBlock { elem in
		let elementType = elem.pointee.type
		let n = _numPoints(forType: elementType)
		var points: [CGPoint]?
		if n > 0 {
			points = Array(UnsafeBufferPointer(start: elem.pointee.points, count: n))
		}
		elements.append(_PathElement(type: Int(elementType.rawValue), points: points))
	}

	do {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		return try encoder.encode(elements)
	}
	catch {
		return Data()
	}
}

internal func decodeCGPath(data: Data) throws -> CGPath {
	let decoder = JSONDecoder()
	let elements = try decoder.decode([_PathElement].self, from: data)

	let path = CGMutablePath()

	for elem in elements {
		switch elem.type {
		case 0:
			path.move(to: elem.points![0])
		case 1:
			path.addLine(to: elem.points![0])
		case 2:
			path.addQuadCurve(to: elem.points![1], control: elem.points![0])
		case 3:
			path.addCurve(to: elem.points![2], control1: elem.points![0], control2: elem.points![1])
		case 4:
			path.closeSubpath()
		default:
			break
		}
	}
	return path
}

// MARK: - Base64 encode/decode

internal func encodeCGPathBase64(path: CGPath) -> String? {
	let data = encodeCGPath(path: path)
	return String(data: data.base64EncodedData(), encoding: .ascii)
}

internal func decodeCGPathBase64(string: String) throws -> CGPath? {
	guard let pathData = Data(base64Encoded: string) else {
		return nil
	}
	return try decodeCGPath(data: pathData)
}

// MARK: Private

private struct _PathElement: Codable {
	var type: Int
	var points: [CGPoint]?
}

private func _numPoints(forType type: CGPathElementType) -> Int {
	switch type {
	case .moveToPoint: return 1
	case .addLineToPoint: return 1
	case .addQuadCurveToPoint: return 2
	case .addCurveToPoint: return 3
	case .closeSubpath: return 0
	default: return 0
	}
}

func pathToSVG(_ path: CGPath) -> String {
	var svg = ""

	path.applyWithBlock { elem in
		let elementType = elem.pointee.type

		let command: String = {
			switch elementType {
			case .moveToPoint:
				let xVal = elem.pointee.points[0]
				return "M\(xVal.x) \(xVal.y)"
			case .addLineToPoint:
				let xVal = elem.pointee.points[0]
				return "L\(xVal.x) \(xVal.y)"
			case .addQuadCurveToPoint:
				let endPoint = elem.pointee.points[1]
				let controlPoint = elem.pointee.points[0]
				return "Q\(endPoint.x),\(endPoint.y) \(controlPoint.x),\(controlPoint.y)"
			case .addCurveToPoint:
				//path.addCurve(to: elem.points![2], control1: elem.points![0], control2: elem.points![1])

				let toPoint = elem.pointee.points[2]
				let control1 = elem.pointee.points[0]
				let control2 = elem.pointee.points[1]
				return "C\(control1.x),\(control1.y) \(control2.x),\(control2.y) \(toPoint.x),\(toPoint.y)"
			case .closeSubpath: return "Z"
			default: return "Z"
			}
		}()

		svg.append("\(command) ")
	}

	return svg
}
