//
//  QRCodeGenerator+QRGenerator.swift
//
//  Created by Darren Ford on 10/12/21.
//  Copyright © 2022 Darren Ford. All rights reserved.
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
import QRCode

/// A qr code generator that uses QRCodeGenerator (https://github.com/dagronf/swift-qrcode-generator) as its generator.
/// This is primarily used for WatchOS, which doesn't support CoreImage filters.
///
/// The generator library (https://github.com/fwcd/swift-qrcode-generator) is not automatically imported into the
/// core QRCode module as some projects may not want to link against a 3rd party library for their
/// macOS/iOS or tvOS application.
///
/// By wrapping the 3rd party library in a separate Swift module it provides the flexibility to ignore it if you
/// don't need it.
public class QRCodeGenerator_External: QRCodeEngine {

	public init() {}

	/// Generate the QR code using the custom generator
	public func generate(_ data: Data, errorCorrection: QRCode.ErrorCorrection) -> BoolMatrix? {
		// Call out to the third-party qr code generator
		guard
			let qrCode = _generate(data, errorCorrection: errorCorrection.ECLevel),
			qrCode.count > 0,
			qrCode[0].count > 0 else
		{
			return nil
		}
		let sz = qrCode[0].count

		// Map the generic [[Bool]] result to our safer Array2d type
		let result = BoolMatrix(dimension: sz)
		for row in 0 ..< sz {
			for col in 0 ..< sz {
				result[row, col] = qrCode[row][col]
			}
		}
		return result
	}
}
