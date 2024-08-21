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
	func copyInsetGenerator() -> QRCodePixelInsetGenerator
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
	public var name: String { Self.Name }
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
