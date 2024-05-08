//
//  Neighbours.swift
//
//  Copyright © 2024 Darren Ford. All rights reserved.
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

/// Convenience for determining pixel neighbours
internal struct Neighbours: CustomDebugStringConvertible {
	/// Has a leading neighbour
	let leading: Bool
	/// Has a top neighbour
	let top: Bool
	/// Has a trailing neighbour
	let trailing: Bool
	/// Has a bottom neighbour
	let bottom: Bool

	/// Has a top leading neighbour
	let topLeading: Bool
	/// Has a top trailing neighbour
	let topTrailing: Bool
	/// Has a bottom leading neighbour
	let bottomLeading: Bool
	/// Has a bottom trailing neighbour
	let bottomTrailing: Bool

	/// No neighbours
	var none: Bool {
		!(leading || trailing || top || bottom || topLeading || topTrailing || bottomLeading || bottomTrailing)
	}

	var debugDescription: String {
		var map: [String] = []
		if self.top { map.append(".top") }
		if self.bottom { map.append(".bottom") }
		if self.leading { map.append(".leading") }
		if self.trailing { map.append(".trailing") }

		if self.topLeading { map.append(".topLeading") }
		if self.topTrailing { map.append(".topTrailing") }
		if self.bottomLeading { map.append(".bottomLeading") }
		if self.bottomTrailing { map.append(".bottomTrailing") }
		return "[" + map.joined(separator: ", ") + "]"
	}

	init(matrix: BoolMatrix, row: Int, col: Int) {
		let dim = matrix.dimension
		assert(row < dim)
		assert(col < dim)

		self.leading = {
			if col <= 0 || col >= dim { return false }
			return matrix[row, col - 1]
		}()

		self.trailing = {
			if col < 0 || col >= (dim - 1) { return false }
			return matrix[row, col + 1]
		}()

		self.top = {
			if row <= 0 || row >= dim { return false }
			return matrix[row - 1, col]
		}()

		self.bottom = {
			if row < 0 || row >= (dim - 1) { return false }
			return matrix[row + 1, col]
		}()

		self.topLeading = {
			if col <= 0 || row <= 0 { return false }
			if col >= dim || row <= 0 { return false }
			return matrix[row - 1, col - 1]
		}()

		self.bottomLeading = {
			if col <= 0 { return false }
			if row >= (dim - 1) { return false }
			return matrix[row + 1, col - 1]
		}()

		self.topTrailing = {
			if col >= (dim - 1) || row <= 0 { return false }
			return matrix[row - 1, col + 1]
		}()

		self.bottomTrailing = {
			if col >= (dim - 1) || row >= (dim - 1) { return false }
			return matrix[row + 1, col + 1]
		}()
	}
}
