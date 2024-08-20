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

/// A generator for generating inset patterns across a QR code
@objc public protocol QRCodePixelInsetGenerator {
	/// The generator name
	static var Name: String { get }
	/// Create an instance of this generator
	static func Create() -> QRCodePixelInsetGenerator

	/// Called before the QRCode shape is generated.
	///
	/// Used to reset the inset generator back to bog-standard to allow repeatable results
	func reset()
	/// Make a copy of this generator
	func duplicate() -> QRCodePixelInsetGenerator
	/// Return the inset value (0 -> 1) for a row and column within the qr code matrix
	/// - Parameters:
	///   - matrix: The QR code matrix
	///   - row: The pixel's row offset
	///   - column: The pixel's column offset
	///   - insetFraction: The pixel generator's maximum fractional value
	/// - Returns: An inset value
	func insetValue(for matrix: BoolMatrix, row: Int, column: Int, insetFraction: CGFloat) -> CGFloat
}

extension QRCodePixelInsetGenerator {
	/// The generators name
	var name: String { Self.Name }
}

extension QRCode {
	@objc public class PixelInset: NSObject {
		private override init() { fatalError() }
		@objc public static let generators: [QRCodePixelInsetGenerator.Type] = [
			QRCode.PixelInset.Fixed.self,
			QRCode.PixelInset.Random.self,
			QRCode.PixelInset.Punch.self,
			QRCode.PixelInset.HorizontalWave.self,
			QRCode.PixelInset.VerticalWave.self,
		]

		static func generator(named name: String) -> QRCodePixelInsetGenerator? {
			Self.generators.first(where: { $0.Name == name })?.Create()
		}
	}
}

public extension QRCode.PixelInset {
	/// A fixed inset size generator.  All pixels will be given the same inset value
	@objc(QRCodePixelInsetFixed)
	class Fixed: NSObject, QRCodePixelInsetGenerator {
		public static var Name: String { "fixed" }
		public static func Create() -> QRCodePixelInsetGenerator { QRCode.PixelInset.Fixed() }
		public func duplicate() -> QRCodePixelInsetGenerator { QRCode.PixelInset.Fixed() }
		public func reset() {}
		public func insetValue(for matrix: BoolMatrix, row: Int, column: Int, insetFraction: CGFloat) -> CGFloat {
			insetFraction
		}
	}

	/// A random inset size generator.
	///
	/// Each pixel will be given a repeatable random inset value, up to a maximum `insetFraction` value
	@objc(QRCodePixelInsetRandom)
	class Random: NSObject, QRCodePixelInsetGenerator {
		public static var Name: String { "random" }
		public static func Create() -> QRCodePixelInsetGenerator { QRCode.PixelInset.Random() }
		public func duplicate() -> QRCodePixelInsetGenerator { QRCode.PixelInset.Random() }
		public func reset() {
			self.insetRandomGenerator = SplitMix64(seed: 308653205)
		}
		public func insetValue(for matrix: BoolMatrix, row: Int, column: Int, insetFraction: CGFloat) -> CGFloat {
			CGFloat.random(in: 0.0 ... insetFraction, using: &insetRandomGenerator)
		}

		private var insetRandomGenerator: SplitMix64
		@objc public override init() {
			self.insetRandomGenerator = SplitMix64(seed: 308653205)
			super.init()
		}
	}

	/// A pixel inset generator that creates a bigger inset the closer to the center of the QR code
	@objc(QRCodePixelInsetPunch)
	class Punch: NSObject, QRCodePixelInsetGenerator {
		public static var Name: String { "punch" }
		public static func Create() -> QRCodePixelInsetGenerator { QRCode.PixelInset.Punch() }
		public func reset() {}
		public func duplicate() -> QRCodePixelInsetGenerator { QRCode.PixelInset.Punch() }
		public func insetValue(for matrix: BoolMatrix, row: Int, column: Int, insetFraction: CGFloat) -> CGFloat {
			let half = Double(matrix.dimension) / 2
			let sy: Double = {
				let r = Double(row)
				if r < half { return (r / half) }
				else { return (1 - ((r - half) / half)) }
			}()
			let sx: Double = {
				let c = Double(column)
				if c < half { return (c / half) }
				else { return (1 - ((c - half) / half)) }
			}()
			return min(sx * insetFraction, sy * insetFraction)
		}
	}

	/// A pixel inset generator that creates a bigger inset the closer to the horizontal center of the QR code
	@objc(QRCodePixelInsetHorizontalWave)
	class HorizontalWave: NSObject, QRCodePixelInsetGenerator {
		public static var Name: String { "horizontalWave" }
		public static func Create() -> QRCodePixelInsetGenerator { QRCode.PixelInset.HorizontalWave() }

		public func reset() {}
		public func duplicate() -> QRCodePixelInsetGenerator { QRCode.PixelInset.HorizontalWave() }

		public func insetValue(for matrix: BoolMatrix, row: Int, column: Int, insetFraction: CGFloat) -> CGFloat {
			let half = Double(matrix.dimension) / 2
			let sx: Double = {
				let c = Double(column)
				if c < half { return (c / half) }
				else { return (1 - ((c - half) / half)) }
			}()
			return sx * insetFraction
		}
	}

	/// A pixel inset generator that creates a bigger inset the closer to the vertical center of the QR code
	@objc(QRCodePixelInsetVerticalWave)
	class VerticalWave: NSObject, QRCodePixelInsetGenerator {
		public static var Name: String { "verticalWave" }
		public static func Create() -> QRCodePixelInsetGenerator { QRCode.PixelInset.VerticalWave() }
		public func reset() {}
		public func duplicate() -> QRCodePixelInsetGenerator { QRCode.PixelInset.VerticalWave() }
		public func insetValue(for matrix: BoolMatrix, row: Int, column: Int, insetFraction: CGFloat) -> CGFloat {
			let half = Double(matrix.dimension) / 2
			let sy: Double = {
				let r = Double(row)
				if r < half { return (r / half) }
				else { return (1 - ((r - half) / half)) }
			}()
			return sy * insetFraction
		}
	}
}
