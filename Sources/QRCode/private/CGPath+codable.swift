//
//  CGPath+codable.swift
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

// Codable support for CGImage

#if canImport(CoreGraphics)

import CoreGraphics.CGPath
import Foundation

/// A codable wrapper for CGPath
struct CGPathCodable {
	let path: CGPath
	init(_ path: CGPath) { self.path = path }
}

extension CGPathCodable {
	/// Errors that can be thrown with CGPathCodable
	enum CGPathCodableError: Error {
		case cannotConvertDataToBase64
	}
}

extension CGPathCodable: Codable {
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let pathData = try container.decode(Data.self)
		self.path = try Self.decode(pathData)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		let s = try Self.encode(self.path)
		try container.encode(s)
	}
}

/// Functions for encoding CGPath instances
extension CGPathCodable {
	/// Encode a CGPath to a data representation
	static func encode(_ path: CGPath) throws -> Data {
		let elements = Self.elements(for: path)
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		return try encoder.encode(elements)
	}

	/// Encode a CGPath into a base-64-encoded string representation
	static func encodeBase64(_ path: CGPath) throws -> String {
		let data = try Self.encode(path)
		guard let b64 = String(data: data.base64EncodedData(), encoding: .ascii) else {
			throw CGPathCodableError.cannotConvertDataToBase64
		}
		return b64
	}

	/// Encode a CGPath into a base-64-encoded string representation. Crashes if an error occurs
	static func encodeBase64Enforced(_ path: CGPath) -> String {
		let data = try! Self.encode(path)
		guard let b64 = String(data: data.base64EncodedData(), encoding: .ascii) else { fatalError() }
		return b64
	}
}

/// Functions for decoding CGPath instances
extension CGPathCodable {
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
		return try Self.decode(pathData)
	}
}

// MARK: Private

private extension CGPathCodable {
	private struct _PathElement: Codable {
		var type: Int
		var points: [CGPoint]?
	}

	private static func _numPoints(forType type: CGPathElementType) -> Int {
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

private extension CGPathCodable {
	// Return the path elements for the path
	private static func elements(for path: CGPath) -> [_PathElement] {
		var elements: [_PathElement] = []
		path.applyWithBlockSafe { elem in
			let elementType = elem.pointee.type
			let n = Self._numPoints(forType: elementType)
			var points: [CGPoint]?
			if n > 0 {
				points = Array(UnsafeBufferPointer(start: elem.pointee.points, count: n))
			}
			elements.append(_PathElement(type: Int(elementType.rawValue), points: points))
		}
		return elements
	}
}

#endif
