//
//  CGColor+extensions.swift
//
//  Copyright © 2023 Darren Ford. All rights reserved.
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

// Default colorspace for RGBA archiving/unarchiving
private let ArchiveRGBAColorSpace = CGColorSpace(name: CGColorSpace.sRGB)!

@objc public class RGBAComponents: NSObject {
	@objc public let r: CGFloat
	@objc public let g: CGFloat
	@objc public let b: CGFloat
	@objc public let a: CGFloat
	@objc public init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
		self.r = r
		self.g = g
		self.b = b
		self.a = a
	}
	
	/// Archive the color to an "r,g,b,a" string (eg. "1.0,0.0,0.0,0.5")
	@objc public var stringValue: String {
		"\(self.r),\(self.g),\(self.b),\(self.a)"
	}
}

public extension CGColor {
	func sRGBAComponents() -> RGBAComponents? {
		guard
			let c = self.converted(
				to: ArchiveRGBAColorSpace,
				intent: .defaultIntent,
				options: nil
			),
			let comps = c.components,
			comps.count == 4
		else {
			return nil
		}
		return RGBAComponents(r: comps[0], g: comps[1], b: comps[2], a: comps[3])
	}
	
	/// Archive the color to an "r,g,b,a" string (eg. "1.0,0.0,0.0,0.5")
	func archiveSRGBA() -> String? {
		return self.sRGBAComponents()?.stringValue
	}
	
	/// Create a CGColor from an archive string for the format "r,g,b,a" (eg. "1.0,0.0,0.0,0.5")
	static func UnarchiveSRGBA(_ archive: String) -> CGColor? {
		let comps = archive
			.split(separator: ",")
			.map { $0.trimmingCharacters(in: .whitespaces) }
			.compactMap { CGFloat($0) }
			.compactMap { $0.clamped(to: 0.0 ... 1.0) }
		guard comps.count == 4 else {
			return nil
		}
		return CGColor(colorSpace: ArchiveRGBAColorSpace, components: comps)
	}
}

#if !os(macOS)
extension CGColor {
	static let white = CGColor(gray: 1, alpha: 1)
	static let black = CGColor(gray: 0, alpha: 1)
	static let clear = CGColor(gray: 0, alpha: 0)
}
#endif

extension CGColor {
	/// Return an RGBA hex code (eg. "#00000000")
	func hexCode() -> String? {
		guard let comps = sRGBAComponents() else {
			return nil
		}
		let rv = Int(comps.r * 255.0)
		let gv = Int(comps.g * 255.0)
		let bv = Int(comps.b * 255.0)
		let av = Int(comps.a * 255.0)
		return String(format: "#%02x%02x%02x%02x", rv, gv, bv, av)
	}

	/// Return an RGBA hex code (eg. "#00000000")
	func hexRGBCode() -> String? {
		guard let comps = sRGBAComponents() else {
			return nil
		}
		let rv = Int(comps.r * 255.0)
		let gv = Int(comps.g * 255.0)
		let bv = Int(comps.b * 255.0)
		return String(format: "#%02x%02x%02x", rv, gv, bv)
	}
}
