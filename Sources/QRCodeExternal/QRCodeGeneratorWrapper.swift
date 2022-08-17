//
//  QRCodeGeneratorWrapper.swift
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
import QRCodeGenerator

// We have to separate this out as there is a namespace clash between our QRCode module
// and the QRCodeGenerator module's class type.

internal func _generate(_ data: Data, errorCorrection: String) -> [[Bool]]? {
	let mappedECC: QRCodeECC
	switch errorCorrection {
	case "L": mappedECC = QRCodeECC.low
	case "M": mappedECC = QRCodeECC.medium
	case "Q": mappedECC = QRCodeECC.quartile
	case "H": mappedECC = QRCodeECC.high
	default:
		assert(false)
		return nil
	}

	guard let qrCode = try? QRCodeGenerator.QRCode.encode(binary: [UInt8](data), ecl: mappedECC) else {
		return nil
	}

	// Map the QRCodeGenerator result type to a generic 2d array of bool
	// We can't use Array2D here due to the namespace clash

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
