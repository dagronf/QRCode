//
//  QRCode+ErrorCorrection.swift
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
	/// The error correction level
	@objc(QRCodeErrorCorrection) enum ErrorCorrection: Int, CaseIterable {
		/// Lowest error correction (L - Recovers 7% of data)
		case low = 0
		/// Medium error correction (M - Recovers 15% of data)
		case medium = 1
		/// Quantize error correction (Q - Recovers 25% of data)
		case quantize = 2
		/// High error correction (H - Recovers 30% of data)
		case high = 3

		/// The default error correction level if it is not specified by the user
		public static let `default` = ErrorCorrection.quantize

		/// Returns the EC Level identifier for the error correction type (L, M, Q, H)
		public var ECLevel: String {
			switch self {
			case .low: return "L"
			case .medium: return "M"
			case .quantize: return "Q"
			case .high: return "H"
			}
		}
		
		/// Create an error correction object from a character representation, or nil if there was no match
		public static func Create(_ type: Character) -> ErrorCorrection? {
			switch type.lowercased() {
			case "l": return .low
			case "m": return .medium
			case "q": return .quantize
			case "h": return .high
			default: return nil
			}
		}
	}
}
