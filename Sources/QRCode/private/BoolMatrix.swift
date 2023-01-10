//
//  BoolMatrix.swift
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

/// A boolean matrix (Array2D<Bool> wrapper) with equal dimensions in row and column
@objc(QRCodeBoolMatrix) public class BoolMatrix: NSObject {

	@objc public override init() {
		super.init()
	}

	@objc public func copyMatrix() -> BoolMatrix {
		BoolMatrix(dimension: dimension, flattened: flattened)
	}

	@objc public init(dimension: Int) {
		self.content = Array2D(
			rows: dimension,
			columns: dimension,
			initialValue: false)
	}

	@objc public init(dimension: Int, flattened: [Bool]) {
		self.content = Array2D(
			rows: dimension,
			columns: dimension,
			flattened: flattened)
	}

	/// A simple initializer to use [0, 1, 1, 0, 1, 0, 0, 0, 0, 1] as the bool initializer
	@objc public init(dimension: Int, rawFlattenedInt: [Int]) {
		let settings = rawFlattenedInt.map { $0 != 0 }
		self.content = Array2D(
			rows: dimension,
			columns: dimension,
			flattened: settings)
	}

	/// The dimension of the QR code
	@objc public var dimension: Int {
		return content.rows
	}

	/// Return a flattened version of the bool matrix
	@objc public var flattened: [Bool] {
		content.flattened
	}

	/// Returns a new matrix with toggled values
	@objc public var flipped: BoolMatrix {
		BoolMatrix(dimension: content.columns, flattened: flattened.map { !$0 })
	}

	/// get/set the value at the row/column position. Does not check for out of bounds (that's your responsibility!)
	@objc public subscript(row: Int, column: Int) -> Bool {
		get {
			return content[row, column]
		}
		set {
			content[row, column] = newValue
		}
	}

	public override var description: String {
		var str = ""
		for y in 0 ..< dimension {
			for x in 0 ..< dimension {
				str.append(self[y, x] ? "#" : ".")
			}
			str.append("\n")
		}
		return str
	}

	private var content: Array2D<Bool> = Array2D(rows: 0, columns: 0, initialValue: false)
}

extension BoolMatrix {
	/// Returns a new copy of this matrix with the eyes and 'quiet' space (the 1px border) masked to false
	/// - Parameter inverted: If true, inverts the mask content before returning
	/// - Returns: A new masked copy of this matrix
	func maskingQREyes(inverted: Bool) -> BoolMatrix {
		let maskedResult = self.copyMatrix()
		for row in 0 ..< maskedResult.dimension {
			for col in 0 ..< maskedResult.dimension {
				if (row == 0 || row == (maskedResult.dimension - 1)) ||
					(col == 0 || col == (maskedResult.dimension - 1)) ||
					(row < 9 && col < 9) ||
					(col < 9 && row >= maskedResult.dimension - 9) ||
					(row < 9 && col >= maskedResult.dimension - 9)
				{
					// Masking out the eye component
					maskedResult[row, col] = false
				}
				else if inverted {
					// Flip true->false and vice-versa
					maskedResult[row, col].toggle()
				}
			}
		}
		return maskedResult
	}

	func inverted() -> BoolMatrix {
		BoolMatrix(dimension: self.dimension, flattened: self.flattened.map { !$0 } )
	}

	func applyingMask(_ mask: BoolMatrix) -> BoolMatrix {
		assert(mask.dimension == self.dimension)
		let result = BoolMatrix(dimension: self.dimension)
		for row in 0 ..< mask.dimension {
			for col in 0 ..< mask.dimension {
				if mask[row, col] == true {
					result[row, col] = self[row, col]
				}
			}
		}
		return result
	}
}
