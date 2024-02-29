//
//  CGPath+hexagon.swift
//
//  Copyright © 2024 Aydin Aghayev. All rights reserved.
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

import CoreGraphics.CGPath

internal extension CGPath {
	/// Create a path containing a rounded hexagon
	static func RoundedHexagon(
		rect: CGRect,
		topLeftRadius: CGSize = .zero,
		topMiddleRadius: CGSize = .zero,
		rightMiddleRadius: CGSize = .zero,
		bottomRightRadius: CGSize = .zero,
		bottomMiddleRadius: CGSize = .zero,
		leftMiddleRadius: CGSize = .zero
	) -> CGPath {
		let path = CGMutablePath()

		let topLeft = rect.origin
		let topMiddle = CGPoint(x: rect.midX, y: rect.minY)
		let rightMiddle = CGPoint(x: rect.maxX, y: rect.midY)
		let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
		let bottomMiddle = CGPoint(x: rect.midX, y: rect.maxY)
		let leftMiddle = CGPoint(x: rect.minX, y: rect.midY)

		if topLeftRadius != .zero {
			path.move(to: CGPoint(x: topLeft.x + topLeftRadius.width, y: topLeft.y))
		}
		else {
			path.move(to: CGPoint(x: topLeft.x, y: topLeft.y))
		}

		if topMiddleRadius != .zero {
			path.addLine(to: .init(x: topMiddle.x - topMiddleRadius.width, y: topMiddle.y))
			path.addCurve(
				to: .init(x: topMiddle.x + topMiddleRadius.width, y: topMiddle.y + topMiddleRadius.height),
				control1: .init(x: topMiddle.x, y: topMiddle.y),
				control2: .init(x: topMiddle.x + topMiddleRadius.width, y: topMiddle.y + topMiddleRadius.height)
			)
		}
		else {
			path.addLine(to: .init(x: topMiddle.x, y: topMiddle.y))
		}

		if rightMiddleRadius != .zero {
			path.addLine(to: .init(x: rightMiddle.x - rightMiddleRadius.width, y: rightMiddle.y - rightMiddleRadius.height))
			path.addCurve(
				to: .init(x: rightMiddle.x, y: rightMiddle.y + rightMiddleRadius.height),
				control1: .init(x: rightMiddle.x, y: rightMiddle.y),
				control2: .init(x: rightMiddle.x, y: rightMiddle.y + rightMiddleRadius.height)
			)
		}
		else {
			path.addLine(to: .init(x: rightMiddle.x, y: rightMiddle.y))
		}

		if bottomRightRadius != .zero {
			path.addLine(to: .init(x: bottomRight.x, y: bottomRight.y - bottomRightRadius.height))
			path.addCurve(
				to: .init(x: bottomRight.x - bottomRightRadius.width, y: bottomRight.y),
				control1: .init(x: bottomRight.x, y: bottomRight.y),
				control2: .init(x: bottomRight.x - bottomRightRadius.width, y: bottomRight.y)
			)
		}
		else {
			path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y))
		}

		if bottomMiddleRadius != .zero {
			path.addLine(to: .init(x: bottomMiddle.x + bottomRightRadius.width, y: bottomMiddle.y))
			path.addCurve(
				to: .init(x: bottomMiddle.x - bottomMiddleRadius.width, y: bottomMiddle.y - bottomMiddleRadius.height),
				control1: .init(x: bottomMiddle.x, y: bottomMiddle.y),
				control2: .init(x: bottomMiddle.x - bottomMiddleRadius.width, y: bottomMiddle.y - bottomMiddleRadius.height)
			)
		}
		else {
			path.addLine(to: .init(x: bottomMiddle.x, y: bottomMiddle.y))
		}

		if leftMiddleRadius != .zero {
			path.addLine(to: .init(x: leftMiddle.x + leftMiddleRadius.width, y: leftMiddle.y + leftMiddleRadius.height))
			path.addCurve(
				to: .init(x: leftMiddle.x, y: leftMiddle.y - leftMiddleRadius.height),
				control1: .init(x: leftMiddle.x, y: leftMiddle.y),
				control2: .init(x: leftMiddle.x, y: leftMiddle.y - leftMiddleRadius.height)
			)
		}
		else {
			path.addLine(to: .init(x: leftMiddle.x, y: leftMiddle.y))
		}

		if topLeftRadius != .zero {
			path.addLine(to: .init(x: topLeft.x, y: topLeft.y + topLeftRadius.height))
			path.addCurve(
				to: .init(x: topLeft.x + topLeftRadius.width, y: topLeft.y),
				control1: .init(x: topLeft.x, y: topLeft.y),
				control2: .init(x: topLeft.x + topLeftRadius.width, y: topLeft.y)
			)
		}
		else {
			path.addLine(to: .init(x: topLeft.x, y: topLeft.y))
		}

		return path
	}

	struct RoundedHexagonCorner: OptionSet {
		public let rawValue: Int8
		public static let none: RoundedHexagonCorner = []
		public static let topLeft = RoundedHexagonCorner(rawValue: 1 << 0)
		public static let topMiddle = RoundedHexagonCorner(rawValue: 1 << 0)
		public static let rightMiddle = RoundedHexagonCorner(rawValue: 1 << 0)
		public static let bottomRight = RoundedHexagonCorner(rawValue: 1 << 0)
		public static let bottomMiddle = RoundedHexagonCorner(rawValue: 1 << 0)
		public static let leftMiddle = RoundedHexagonCorner(rawValue: 1 << 0)
		public static let all = [
			RoundedHexagonCorner.topLeft,
			RoundedHexagonCorner.topMiddle,
			RoundedHexagonCorner.rightMiddle,
			RoundedHexagonCorner.bottomRight,
			RoundedHexagonCorner.bottomMiddle,
			RoundedHexagonCorner.leftMiddle
		]
	}

	static func RoundedHexagon(
		rect: CGRect,
		cornerRadius: CGFloat,
		byRoundingCorners corners: RoundedHexagonCorner
	) -> CGPath {
		var topLeft: CGSize = .zero
		var topMiddle: CGSize = .zero
		var rightMiddle: CGSize = .zero
		var bottomRight: CGSize = .zero
		var bottomMiddle: CGSize = .zero
		var leftMiddle: CGSize = .zero

		let fixedSize = CGSize(width: cornerRadius, height: cornerRadius)

		if corners.contains(.topLeft) { topLeft = fixedSize }
		if corners.contains(.topMiddle) { topMiddle = fixedSize }
		if corners.contains(.rightMiddle) { rightMiddle = fixedSize }
		if corners.contains(.bottomRight) { bottomRight = fixedSize }
		if corners.contains(.bottomMiddle) { bottomMiddle = fixedSize }
		if corners.contains(.leftMiddle) { leftMiddle = fixedSize }

		return Self.RoundedHexagon(rect: rect, topLeftRadius: topLeft, topMiddleRadius: topMiddle, rightMiddleRadius: rightMiddle, bottomRightRadius: bottomRight, bottomMiddleRadius: bottomMiddle, leftMiddleRadius: leftMiddle)
	}
}
