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

import Foundation
import CoreGraphics

// The template pixel generator size is 10x10
private let _templateSize = CGSize(width: 10, height: 10)
private let _cornerSize = CGSize(width: 5, height: 5)

// MARK: - 2x2 Grid

public extension QRCode.PixelShape {
	@objc(QRCodePixelShapeAbstract) class Abstract: NSObject, QRCodePixelShapeGenerator {
		/// The generator name
		@objc public static let Name: String = "abstract"
		/// The generator title
		@objc public static var Title: String { "Abstract" }
		/// This pupil generator can be used when generating eye and pupil shapes
		@objc public var canGenerateEyeAndPupilShapes: Bool { true }
		/// Create an instance of this path generator with the specified settings
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodePixelShapeGenerator { Abstract() }
		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePixelShapeGenerator { Abstract() }
		/// Does the shape generator support setting values for a particular key?
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		/// Returns a storable representation of the shape handler
		@objc public func settings() -> [String: Any] { [:] }
		/// Reset
		@objc public func reset() { }
		/// Set a configuration value for a particular setting string
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }
		/// Generate a CGPath from the matrix contents
		/// - Parameters:
		///   - matrix: The matrix to generate
		///   - size: The size of the resulting CGPath
		/// - Returns: A path
		@objc public func generatePath(from matrix: BoolMatrix, size: CGSize) -> CGPath {
			let dx = size.width / CGFloat(matrix.dimension)
			let dy = size.height / CGFloat(matrix.dimension)
			let dm = min(dx, dy)

			let xoff = (size.width - (CGFloat(matrix.dimension) * dm)) / 2.0
			let yoff = (size.height - (CGFloat(matrix.dimension) * dm)) / 2.0

			// The scale required to convert our template paths to output path size
			let w = _templateSize.width
			let scaleTransform = CGAffineTransform(scaleX: dm / w, y: dm / w)

			let path = CGMutablePath()

			// Make sure we generate stable results for equal inputs
			var insetRandomGenerator = SplitMix64(seed: 123456)

			for row in 0 ..< matrix.dimension {
				for col in 0 ..< matrix.dimension {
					guard matrix[row, col] == true else { continue }
					let translate = CGAffineTransform(translationX: CGFloat(col) * dm + xoff, y: CGFloat(row) * dm + yoff)

					let tl = (insetRandomGenerator.next() % 2 == 0) ? _cornerSize : .zero
					let tr = (insetRandomGenerator.next() % 2 == 0) ? _cornerSize : .zero
					let bl = (insetRandomGenerator.next() % 2 == 0) ? _cornerSize : .zero
					let br = (insetRandomGenerator.next() % 2 == 0) ? _cornerSize : .zero

					let pth = CGPath.RoundedRect(
						rect: CGRect(origin: .zero, size: _templateSize),
						topLeftRadius: tl,
						topRightRadius: tr,
						bottomLeftRadius: bl,
						bottomRightRadius: br
					)

					path.addPath(pth, transform: scaleTransform.concatenating(translate))
				}
			}
			return path
		}
	}
}
