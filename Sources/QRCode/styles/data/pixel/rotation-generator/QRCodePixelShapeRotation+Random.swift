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

public extension QRCode.PixelRotation {
	/// A random rotation generator.
	///
	/// Each pixel will be given a repeatable random inset value, up to a maximum `insetFraction` value
	@objc(QRCodePixelRotationRandom)
	class Random: NSObject, QRCodePixelRotationGenerator {
		public static var Name: String { "random" }
		public static func Create() -> QRCodePixelRotationGenerator { QRCode.PixelRotation.Random() }
		public func copyRotationGenerator() -> QRCodePixelRotationGenerator { QRCode.PixelRotation.Random() }
		public func reset() {
			self.randomGenerator = SplitMix64(seed: 308653205)
		}
		public func rotationValue(for matrix: BoolMatrix, row: Int, column: Int, rotationFraction: CGFloat) -> CGFloat {
			assert(rotationFraction.in(0 ... 1))
			return CGFloat.random(in: 0 ... rotationFraction, using: &randomGenerator)
		}
		@objc public override init() {
			self.randomGenerator = SplitMix64(seed: 308653205)
			super.init()
		}

		private var randomGenerator: SplitMix64
	}
}
