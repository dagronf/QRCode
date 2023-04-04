//
//  QRCode+Types.swift
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

public extension QRCode {
	/// A corners definition
	struct Corners: OptionSet, Codable {
		public let rawValue: Int
		/// Top left
		public static let tl = Corners(rawValue: 1 << 0)
		/// Top right
		public static let tr = Corners(rawValue: 1 << 1)
		/// Bottom left
		public static let bl = Corners(rawValue: 1 << 2)
		/// Bottom right
		public static let br = Corners(rawValue: 1 << 3)
		/// All corners
		public static let all: Corners = [.tl, .tr, .bl, .br]
		/// All corners
		public static let none: Corners = []
		/// Create a Corners struct
		public init(rawValue: Int) { self.rawValue = rawValue }
	}
}
