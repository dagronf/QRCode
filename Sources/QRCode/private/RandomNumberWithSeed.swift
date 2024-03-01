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

import Foundation

/// This is a fixed-increment version of Java 8's SplittableRandom generator.
/// It is a very fast generator passing BigCrush, with 64 bits of state.
/// See http://dx.doi.org/10.1145/2714064.2660195 and
/// http://docs.oracle.com/javase/8/docs/api/java/util/SplittableRandom.html
///
/// Derived from public domain C implementation by Sebastiano Vigna
/// See
/// * https://web.archive.org/web/20240507015322/https://xoshiro.di.unimi.it/splitmix64.c
/// * https://web.archive.org/web/20240610071933/https://rosettacode.org/wiki/Pseudo-random_numbers/Splitmix64
struct SplitMix64: RandomNumberGenerator {
	private var state: UInt64
	private static let divisor: Float64 = 1.0 / pow(2.0, 64)

	init(seed: UInt64) {
		self.state = seed
	}

	/// Return a new random UInt64 value
	mutating func next() -> UInt64 {
		self.state &+= 0x9E37_79B9_7F4A_7C15
		var z = self.state
		z = (z ^ (z &>> 30)) &* 0xBF58_476D_1CE4_E5B9
		z = (z ^ (z &>> 27)) &* 0x94D0_49BB_1331_11EB
		return z ^ (z &>> 31)
	}

	/// Return a new random Float64 value
	mutating func nextFloat() -> Float64 {
		Float64(self.next()) * SplitMix64.divisor
	}
}
