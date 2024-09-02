//
//  Copyright © 2024 Darren Ford. All rights reserved.
//
//  MIT License
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import CoreGraphics
import Foundation

// Hex utilities for CGColor

// The default colorspace for hex (standard RGB)
let WCGDefaultHexColorSpace__ = CGColorSpace(name: CGColorSpace.sRGB)!

extension CGColor {
	/// Create a CGColor color from a hex string
	/// - Parameters:
	///   - hexString: The hex string representing the color
	///   - colorSpace: The colorspace to use (expecting RGBA). Defaults to sRGB.
	/// - Returns: A color
	/// - Throws: `QRCodeError.invalidHexColorString` if the hex color could not be decoded
	///
	/// Usage:
	///
	/// ```swift
	///   let color = try CGColor.fromHexString("#A1B2C3FF")
	/// ```
	///
	/// Supported formats:
	/// * [#]fff (rgb, alpha = 1)
	/// * [#]ffff (rgba)
	/// * [#]ffffff (rgb, alpha = 1)
	/// * [#]ffffffff (rgba)
	static func fromHexString(
		_ hexString: String,
		usingColorSpace colorSpace: CGColorSpace = WCGDefaultHexColorSpace__
	) throws -> CGColor {
		var string = hexString.lowercased()
		if hexString.hasPrefix("#") {
			string = String(string.dropFirst())
		}
		switch string.count {
		case 3:
			string += "f"
			fallthrough
		case 4:
			let chars = Array(string)
			let red = chars[0]
			let green = chars[1]
			let blue = chars[2]
			let alpha = chars[3]
			string = "\(red)\(red)\(green)\(green)\(blue)\(blue)\(alpha)\(alpha)"
		case 6:
			string += "ff"
		case 8:
			break
		default:
			throw QRCodeError.invalidHexColorString
		}

		guard let rgba = Double("0x" + string)
			.flatMap( {UInt32(exactly: $0) } )
		else {
			throw QRCodeError.invalidHexColorString
		}
		let red = Double((rgba & 0xFF00_0000) >> 24) / 255
		let green = Double((rgba & 0x00FF_0000) >> 16) / 255
		let blue = Double((rgba & 0x0000_FF00) >> 8) / 255
		let alpha = Double((rgba & 0x0000_00FF) >> 0) / 255

		guard let c = CGColor(colorSpace: colorSpace, components: [red, green, blue, alpha]) else {
			throw QRCodeError.invalidHexColorString
		}
		return c
	}

	/// Returns a lowercased hex RGBA string representation of this color (eg "#ff6512C5")
	var hexRGBA256: String? {
		guard
			let converted = self.converted(to: WCGDefaultHexColorSpace__, intent: .defaultIntent, options: nil),
			let r = converted.components?[0],
			let g = converted.components?[1],
			let b = converted.components?[2],
			let a = converted.components?[3]
		else {
			return nil
		}

		let cr = UInt8(r * 255).clamped(to: 0 ... 255)
		let cg = UInt8(g * 255).clamped(to: 0 ... 255)
		let cb = UInt8(b * 255).clamped(to: 0 ... 255)
		let ca = UInt8(a * 255).clamped(to: 0 ... 255)

		return String(format: "#%02x%02x%02x%02x", cr, cg, cb, ca)
	}

	/// Returns a lowercased hex RGB (no alpha) string representation of this color (eg "#ff6512")
	var hexRGB256: String? {
		guard
			let converted = self.converted(to: WCGDefaultHexColorSpace__, intent: .defaultIntent, options: nil),
			let r = converted.components?[0],
			let g = converted.components?[1],
			let b = converted.components?[2]
		else {
			return nil
		}

		let cr = UInt8(r * 255).clamped(to: 0 ... 255)
		let cg = UInt8(g * 255).clamped(to: 0 ... 255)
		let cb = UInt8(b * 255).clamped(to: 0 ... 255)

		return String(format: "#%02x%02x%02x", cr, cg, cb)
	}

	/// Returns a lowercased hex RGB (no alpha) string representation of this color (eg "#f61")
	var hexRGB16: String? {
		guard
			let converted = self.converted(to: WCGDefaultHexColorSpace__, intent: .defaultIntent, options: nil),
			let r = converted.components?[0],
			let g = converted.components?[1],
			let b = converted.components?[2]
		else {
			return nil
		}

		let cr = UInt8(r * 15).clamped(to: 0 ... 15)
		let cg = UInt8(g * 15).clamped(to: 0 ... 15)
		let cb = UInt8(b * 15).clamped(to: 0 ... 15)

		return String(format: "#%1x%1x%1x", cr, cg, cb)
	}
}
