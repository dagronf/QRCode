//
//  Copyright © 2025 Darren Ford. All rights reserved.
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
	/// A random inset size generator.
	///
	/// Each pixel will be given a repeatable random inset value, up to a maximum `insetFraction` value
	@objc(QRCodePixelInsetRandom)
	class Random: NSObject, QRCodePixelInsetGenerator {
		public static var Name: String { "random" }
		public static func Create() -> QRCodePixelInsetGenerator { QRCode.PixelInset.Random() }
		public func copyInsetGenerator() -> QRCodePixelInsetGenerator { QRCode.PixelInset.Random() }
		public func reset() {
			self.insetRandomGenerator = SplitMix64(seed: 308653205)
		}
		public func insetValue(for matrix: BoolMatrix, row: Int, column: Int, insetFraction: CGFloat) -> CGFloat {
			assert(insetFraction.in(0 ... 1))
			return CGFloat.random(in: 0.0 ... insetFraction, using: &insetRandomGenerator)
		}

		private var insetRandomGenerator: SplitMix64
		@objc public override init() {
			self.insetRandomGenerator = SplitMix64(seed: 308653205)
			super.init()
		}
	}
}
