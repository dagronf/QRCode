//
//  CGPathCoder.swift
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

#if canImport(CoreGraphics)

import CoreGraphics
import Foundation

/// Functions for supporting encoding and decoding CGPath instances
class CGPathCoder {
	/// Encode a CGPath to a data representation
	static func encode(_ path: CGPath) -> Data {
		let elements: [_PathElement]
		if #available(macOS 10.13, *) {
			elements = Self.elements(for: path)
		}
		else {
			elements = Self.elementsLegacy(for: path)
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

	/// Encode a CGPath into a base-64-encoded string representation
	static func encodeBase64(_ path: CGPath) -> String? {
		let data = CGPathCoder.encode(path)
		return String(data: data.base64EncodedData(), encoding: .ascii)
	}
}

extension CGPathCoder {
	/// Decode a CGPath from a data representation
	static func decode(_ data: Data) throws -> CGPath {
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

	/// Decode a CGPath from a base-64 encoded string representation
	static func decodeBase64(_ string: String) throws -> CGPath? {
		guard let pathData = Data(base64Encoded: string) else {
			return nil
		}
		return try CGPathCoder.decode(pathData)
	}
}

// MARK: Private

private extension CGPathCoder {
	private struct _PathElement: Codable {
		var type: Int
		var points: [CGPoint]?
	}

	static private func _numPoints(forType type: CGPathElementType) -> Int {
		switch type {
		case .moveToPoint: return 1
		case .addLineToPoint: return 1
		case .addQuadCurveToPoint: return 2
		case .addCurveToPoint: return 3
		case .closeSubpath: return 0
		default: return 0
		}
	}
}

private extension CGPathCoder {
	// Return the path elements for the path
	private static func elements(for path: CGPath) -> [_PathElement] {
		var elements:  [_PathElement] = []
		path.applyWithBlock { elem in
			let elementType = elem.pointee.type
			let n = CGPathCoder._numPoints(forType: elementType)
			var points: [CGPoint]?
			if n > 0 {
				points = Array(UnsafeBufferPointer(start: elem.pointee.points, count: n))
			}
			elements.append(_PathElement(type: Int(elementType.rawValue), points: points))
		}
		return elements
	}

	// Return the path elements for the path using the legacy C api for macOS 10.12 and earlier
	private static func elementsLegacy(for path: CGPath) -> [_PathElement] {
		class ResultData {
			var elements = [_PathElement]()
		}

		var resultData = ResultData()
		withUnsafeMutablePointer(to: &resultData) { results in
			path.apply(info: results) { (results, elementPointer) in
				let element = elementPointer.pointee
				let pointCount: Int
				switch element.type {
				case .moveToPoint:          // command = "moveTo"
					pointCount = 1
				case .addLineToPoint:       // command = "lineTo"
					pointCount = 1
				case .addQuadCurveToPoint:  // command = "quadCurveTo"
					pointCount = 2
				case .addCurveToPoint:      // command = "curveTo"
					pointCount = 3
				case .closeSubpath:         // command = "close"
					pointCount = 0
				default:
					pointCount = 0
				}
				var points: [CGPoint]?
				if pointCount > 0 {
					points = Array(UnsafeBufferPointer(start: element.points, count: pointCount))
				}

				if let results = results?.assumingMemoryBound(to: ResultData.self).pointee {
					results.elements.append(_PathElement(type: Int(element.type.rawValue), points: points))
				}
			}
		}
		return resultData.elements
	}
}

#endif
