//
//  QRCodeGeneratorWrapper.swift
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
import QRCodeGenerator

// We have to separate this out as there is a namespace clash between our QRCode module
// and the QRCodeGenerator module's class type.

extension QRCodeGenerator_External {

	func _generate(_ data: Data, errorCorrection: String) -> [[Bool]]? {
		guard
			let mappedECC = mapECC(errorCorrection),
			let qrCode = try? QRCodeGenerator.QRCode.encode(binary: [UInt8](data), ecl: mappedECC)
		else {
			return nil
		}
		return mapResult(qrCode)
	}


	func _generate(_ text: String, errorCorrection: String) -> [[Bool]]? {
		guard
			let mappedECC = mapECC(errorCorrection),
			let qrCode = try? QRCodeGenerator.QRCode.encode(text: text, ecl: mappedECC)
		else {
			return nil
		}
		return mapResult(qrCode)
	}

	// - Private

	fileprivate func mapECC(_ errorCorrection: String) -> QRCodeECC? {
		switch errorCorrection {
		case "L": return QRCodeECC.low
		case "M": return QRCodeECC.medium
		case "Q": return QRCodeECC.quartile
		case "H": return QRCodeECC.high
		default:
			assert(false)
			return nil
		}
	}

	fileprivate func mapResult(_ qrCode: QRCodeGenerator.QRCode) -> [[Bool]]? {
		var result = Array<[Bool]>(
			repeating: Array<Bool>(repeating: false, count: qrCode.size + 2),
			count: qrCode.size + 2)

		for row in 0 ..< qrCode.size {
			for col in 0 ..< qrCode.size {
				result[row + 1][col + 1] = qrCode.getModule(x: col, y: row)
			}
		}
		return result
	}
}
