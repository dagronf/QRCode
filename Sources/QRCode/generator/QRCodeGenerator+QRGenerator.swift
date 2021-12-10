//
//  QRCodeGenerator+QRGenerator.swift
//
//  Created by Darren Ford on 10/12/21.
//  Copyright © 2021 Darren Ford. All rights reserved.
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
import QRCodeGenerator

internal class QRCodeGenerator_QRCodeGenerator: QRCodeEngine {

	/// A generator that uses swift-qrcode-generator as the generation engine
	/// See: - 
	public func generate(_ data: Data, errorCorrection: QRCode.ErrorCorrection) -> Array2D<Bool>? {

		let mappedECC: QRCodeECC = {
			switch errorCorrection {
			case .low: return QRCodeECC.low
			case .medium: return QRCodeECC.medium
			case .quantize: return QRCodeECC.quartile
			case .high: return QRCodeECC.high
			}
		}()

		guard let qrCode = try? QRCodeGenerator.QRCode.encode(binary: [UInt8](data), ecl: mappedECC) else {
			return nil
		}

		var result = Array2D<Bool>(rows: qrCode.size + 2, columns: qrCode.size + 2, initialValue: false)
		for row in 0 ..< qrCode.size {
			for col in 0 ..< qrCode.size {
				result[row + 1, col + 1] = qrCode.getModule(x: col, y: row)
			}
		}
		return result
	}
}
