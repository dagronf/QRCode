//
//  CGPath+RoundedRectExtensions.swift
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

import CoreGraphics.CGPath

extension CGPath {
	static func RoundedRect(rect: CGRect, topLeftRadius: CGSize = .zero, topRightRadius: CGSize = .zero, bottomLeftRadius: CGSize = .zero, bottomRightRadius: CGSize = .zero) -> CGPath {
		let path = CGMutablePath()

		let topLeft = rect.origin
		let topRight = CGPoint(x: rect.maxX, y: rect.minY)
		let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
		let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)

		if topLeftRadius != .zero {
			path.move(to: CGPoint(x: topLeft.x + topLeftRadius.width, y: topLeft.y))
		}
		else {
			path.move(to: CGPoint(x: topLeft.x, y: topLeft.y))
		}

		if topRightRadius != .zero {
			path.addLine(to: CGPoint(x: topRight.x - topRightRadius.width, y: topRight.y))
			path.addCurve(to: CGPoint(x: topRight.x, y: topRight.y + topRightRadius.height),
							  control1: CGPoint(x: topRight.x, y: topRight.y),
							  control2: CGPoint(x: topRight.x, y: topRight.y + topRightRadius.height))
		}
		else {
			path.addLine(to: CGPoint(x: topRight.x, y: topRight.y))
		}

		if bottomRightRadius != .zero {
			path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y - bottomRightRadius.height))
			path.addCurve(to: CGPoint(x: bottomRight.x - bottomRightRadius.width, y: bottomRight.y),
							  control1: CGPoint(x: bottomRight.x, y: bottomRight.y),
							  control2: CGPoint(x: bottomRight.x - bottomRightRadius.width, y: bottomRight.y))
		}
		else {
			path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y))
		}

		if bottomLeftRadius != .zero {
			path.addLine(to: CGPoint(x: bottomLeft.x + bottomLeftRadius.width, y: bottomLeft.y))
			path.addCurve(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y - bottomLeftRadius.height),
							  control1: CGPoint(x: bottomLeft.x, y: bottomLeft.y),
							  control2: CGPoint(x: bottomLeft.x, y: bottomLeft.y - bottomLeftRadius.height))
		}
		else {
			path.addLine(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y))
		}

		if topLeftRadius != .zero {
			path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y + topLeftRadius.height))
			path.addCurve(to: CGPoint(x: topLeft.x + topLeftRadius.width, y: topLeft.y),
							  control1: CGPoint(x: topLeft.x, y: topLeft.y),
							  control2: CGPoint(x: topLeft.x + topLeftRadius.width, y: topLeft.y))
		}
		else {
			path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y))
		}

		path.closeSubpath()
		return path
	}

	struct RoundedRectCorner: OptionSet {
		public let rawValue: Int8
		public static let none: RoundedRectCorner = []
		public static let topLeft = RoundedRectCorner(rawValue: 1 << 0)
		public static let topRight = RoundedRectCorner(rawValue: 1 << 1)
		public static let bottomRight = RoundedRectCorner(rawValue: 1 << 2)
		public static let bottomLeft = RoundedRectCorner(rawValue: 1 << 3)
		public static let all = [RoundedRectCorner.topLeft, RoundedRectCorner.topRight, RoundedRectCorner.bottomRight, RoundedRectCorner.bottomLeft]
	}

	static func RoundedRect(rect: CGRect, cornerRadius: CGFloat, byRoundingCorners corners: RoundedRectCorner) -> CGPath {
		var topLeft: CGSize = .zero
		var topRight: CGSize = .zero
		var bottomLeft: CGSize = .zero
		var bottomRight: CGSize = .zero

		let fixedSize = CGSize(width: cornerRadius, height: cornerRadius)

		if corners.contains(.topLeft) { topLeft = fixedSize }
		if corners.contains(.topRight) { topRight = fixedSize }
		if corners.contains(.bottomLeft) { bottomLeft = fixedSize }
		if corners.contains(.bottomRight) { bottomRight = fixedSize }

		return Self.RoundedRect(rect: rect, topLeftRadius: topLeft, topRightRadius: topRight, bottomLeftRadius: bottomLeft, bottomRightRadius: bottomRight)
	}
}
