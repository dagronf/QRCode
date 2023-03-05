//
//  QRCodeGenerator+QRGenerator.swift
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

/// A qr code generator that uses QRCodeGenerator (https://github.com/dagronf/swift-qrcode-generator) as its generator.
/// This is primarily used for WatchOS, which doesn't support CoreImage filters.
@objc public class QRCodeGenerator_External: NSObject, QRCodeEngine {
	/// Create an engine
	@objc public override init() {
		super.init()
	}

	/// Generate the QR code using the custom generator
	@objc public func generate(data: Data, errorCorrection: QRCode.ErrorCorrection) -> BoolMatrix? {
		let qrCode = self._generate(data, errorCorrection: errorCorrection.ECLevel)
		return mapResult(qrCode)
	}

	@objc public func generate(text: String, errorCorrection: QRCode.ErrorCorrection) -> BoolMatrix? {
		let qrCode = self._generate(text, errorCorrection: errorCorrection.ECLevel)
		return mapResult(qrCode)
	}

	private func mapResult(_ qrCode: [[Bool]]?) -> BoolMatrix? {
		guard
			let qrCode = qrCode,
			qrCode.count > 0,
			qrCode[0].count > 0
		else {
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
