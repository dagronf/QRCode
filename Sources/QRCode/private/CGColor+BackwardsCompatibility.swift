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

// Some basic support routines to abstract away differences between OS versions

import CoreGraphics
import Foundation

extension CGColor {
	/// Creates a color in the Generic gray color space
	/// - Parameters:
	///   - gray: A grayscale value (0.0 - 1.0)
	///   - alpha: An alpha value (0.0 - 1.0)
	/// - Returns: A color object
	@inlinable static func gray(_ gray: CGFloat, _ a: CGFloat = 1.0) -> CGColor {
		if #available(iOS 13, tvOS 13, watchOS 6, *) {
			return CGColor(gray: gray, alpha: a)
		}
		return CGColor(colorSpace: _grayColorSpace, components: [gray, a]) ?? .commonBlack
	}

	/// Creates a color in the Generic RGB color space
	/// - Parameters:
	///   - red: A red component value (0.0 - 1.0)
	///   - green: A green component value (0.0 - 1.0)
	///   - blue: A blue component value (0.0 - 1.0)
	///   - alpha: An alpha value (0.0 - 1.0)
	/// - Returns: A color object
	@inlinable static func RGBA(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1.0) -> CGColor {
		if #available(iOS 13, tvOS 13, watchOS 6, *) {
			return CGColor(red: red, green: green, blue: blue, alpha: alpha)
		}
		return CGColor(colorSpace: _rgbaColorSpace, components: [red, green, blue, alpha]) ?? .commonBlack
	}

	/// Creates a color in the sRGB color space.
	/// - Parameters:
	///   - red: A red component value (0.0 - 1.0)
	///   - green: A green component value (0.0 - 1.0)
	///   - blue: A blue component value (0.0 - 1.0)
	///   - alpha: An alpha value (0.0 - 1.0)
	/// - Returns: A color object
	@inlinable static func sRGBA(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1.0) -> CGColor {
		if #available(macOS 15, iOS 13, tvOS 13, watchOS 6, *) {
			return CGColor(srgbRed: red, green: green, blue: blue, alpha: alpha)
		}
		return CGColor(colorSpace: _sRGBAColorSpace, components: [red, green, blue, alpha]) ?? .commonBlack
	}
}

// cached colorspaces

@usableFromInline internal let _sRGBAColorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
@usableFromInline internal let _rgbaColorSpace = CGColorSpace(name: CGColorSpace.genericRGBLinear)!
@usableFromInline internal let _grayColorSpace = CGColorSpace(name: CGColorSpace.extendedGray)!

extension CGColor {
	@usableFromInline internal static let commonWhite = CGColor.gray(1)
	@usableFromInline internal static let commonBlack = CGColor.gray(0)
	@usableFromInline internal static let commonClear = CGColor.gray(0, 0)
}
