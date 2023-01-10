//
//  QRCode+ASCII.swift
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

import Foundation

// MARK: - Ascii representations

public extension QRCode {
	/// Return an ASCII representation of the QR code using the extended ASCII code set
	///
	/// Only makes sense if presented using a fixed-width font
	@objc func asciiRepresentation() -> String {
		var result = ""
		for row in 0 ..< self.current.dimension {
			for col in 0 ..< self.current.dimension {
				if self.current[row, col] == true {
					result += "██"
				}
				else {
					result += "  "
				}
			}
			result += "\n"
		}
		return result
	}

	/// Returns an small ASCII representation of the QR code (about 1/2 the regular size) using the extended ASCII code set
	///
	/// Only makes sense if presented using a fixed-width font
	@objc func smallAsciiRepresentation() -> String {
		var result = ""
		for row in stride(from: 0, to: self.current.dimension, by: 2) {
			for col in 0 ..< self.current.dimension {
				let top = self.current[row, col]

				if row <= self.current.dimension - 2 {
					let bottom = self.current[row + 1, col]
					if top,!bottom { result += "▀" }
					if !top, bottom { result += "▄" }
					if top, bottom { result += "█" }
					if !top, !bottom { result += " " }
				}
				else {
					if top { result += "▀" }
					else { result += " " }
				}
			}
			result += "\n"
		}
		return result
	}
}
