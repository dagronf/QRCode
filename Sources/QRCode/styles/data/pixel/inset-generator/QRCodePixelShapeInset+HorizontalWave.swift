//
//  Copyright © 2024 Darren Ford. All rights reserved.
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

public extension QRCode.PixelInset {
	/// A pixel inset generator that creates a bigger inset the closer to the horizontal center of the QR code
	@objc(QRCodePixelInsetHorizontalWave)
	class HorizontalWave: NSObject, QRCodePixelInsetGenerator {
		public static var Name: String { "horizontalWave" }
		public static func Create() -> QRCodePixelInsetGenerator { QRCode.PixelInset.HorizontalWave() }

		public func reset() {}
		public func copyInsetGenerator() -> QRCodePixelInsetGenerator { QRCode.PixelInset.HorizontalWave() }

		public func insetValue(for matrix: BoolMatrix, row: Int, column: Int, insetFraction: CGFloat) -> CGFloat {
			assert(insetFraction.in(0 ... 1))
			let half = Double(matrix.dimension) / 2
			let sx: Double = {
				let c = Double(column)
				if c < half { return (c / half) }
				else { return (1 - ((c - half) / half)) }
			}()
			return sx * insetFraction
		}
	}
}
