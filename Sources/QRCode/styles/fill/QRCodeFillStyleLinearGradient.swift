//
//  QRCodeFillStyleLinearGradient.swift
//
//  Created by Darren Ford on 16/11/21.
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

public extension QRCode.FillStyle {
	/// A simple linear gradient fill style
	@objc(QRCodeFillStyleLinearGradient)
	class LinearGradient: NSObject, QRCodeFillStyleGenerator {
		let gradient: DSFGradient

		// For linear
		@objc public var startPoint: CGPoint
		@objc public var endPoint: CGPoint

		/// Fill the specified path/rect with a gradient
		/// - Parameters:
		///   - gradient: The color gradient to use
		///   - startPoint: The fractional position within the fill rect to start the gradient (0.0 -> 1.0)
		///   - endPoint: The fractional position within the fill rect to end the gradient (0.0 -> 1.0)
		@objc public init(
			_ gradient: DSFGradient,
			startPoint: CGPoint = CGPoint(x: 0, y: 0),
			endPoint: CGPoint = CGPoint(x: 1, y: 1)
		) {
			self.gradient = gradient
			self.startPoint = startPoint
			self.endPoint = endPoint
		}

		/// Fill the specified rect with the gradient
		public func fill(ctx: CGContext, rect: CGRect) {
			ctx.drawLinearGradient(
				self.gradient.cgGradient,
				start: self.gradientStartPt(forSize: rect.width),
				end: self.gradientEndPt(forSize: rect.width),
				options: [.drawsAfterEndLocation, .drawsBeforeStartLocation])
		}

		/// Fill the specified path with the gradient
		public func fill(ctx: CGContext, rect: CGRect, path: CGPath) {
			ctx.addPath(path)
			ctx.clip()
			ctx.drawLinearGradient(
				self.gradient.cgGradient,
				start: self.gradientStartPt(forSize: rect.width),
				end: self.gradientEndPt(forSize: rect.width),
				options: [.drawsAfterEndLocation, .drawsBeforeStartLocation])
		}

		/// Create a copy of the style
		public func copyStyle() -> QRCodeFillStyleGenerator {
			return LinearGradient(
				self.gradient.copyGradient(),
				startPoint: self.startPoint,
				endPoint: self.endPoint)
		}

		private func gradientStartPt(forSize: CGFloat) -> CGPoint {
			return CGPoint(x: self.startPoint.x * forSize, y: self.startPoint.y * forSize)
		}

		private func gradientEndPt(forSize: CGFloat) -> CGPoint {
			return CGPoint(x: self.endPoint.x * forSize, y: self.endPoint.y * forSize)
		}
	}
}
