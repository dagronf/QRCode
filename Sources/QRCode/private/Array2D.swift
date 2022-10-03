/*
 Two-dimensional array with a fixed number of rows and columns.
 This is mostly handy for games that are played on a grid, such as chess.
 Performance is always O(1).
 */

// Code tweaked from the Swift Algorithm Club (swap row/column in the function definitions, custom init)
// All content is licensed under the terms of the MIT open source license.
// http://raywenderlich.github.io/swift-algorithm-club/Array2D/

public struct Array2D<T> {
	public let columns: Int
	public let rows: Int
	fileprivate var array: [T]

	public init(rows: Int, columns: Int, initialValue: T) {
		self.rows = rows
		self.columns = columns
		self.array = .init(repeating: initialValue, count: rows*columns)
	}

	public init(rows: Int, columns: Int, flattened: [T]) {
		precondition(rows * columns == flattened.count, "row/column counts don't match initial flattened data count")
		self.rows = rows
		self.columns = columns
		self.array = flattened
	}

	public subscript(row: Int, column: Int) -> T {
		get {
			precondition(row < self.rows, "Row \(row) Index is out of range. Array2D<T>(rows:\(rows), columns: \(columns))")
			precondition(column < self.columns, "Column \(column) Index is out of range. Array2D<T>(rows:\(rows), columns: \(columns))")
			return self.array[(row * self.columns) + column]
		}
		set {
			precondition(row < self.rows, "Row \(row) Index is out of range. Array2D<T>(rows:\(rows), columns: \(columns))")
			precondition(column < self.columns, "Column \(column) Index is out of range. Array2D<T>(rows:\(rows), columns: \(columns))")
			self.array[(row * self.columns) + column] = newValue
		}
	}

	mutating func setIndexed(_ index: Int, value: T) {
		self.array[index] = value
	}

	/// Returns a flattened version of the array
	///
	/// eg.
	///
	///   1  2  3  4
	///   5  6  7  8
	///   9 10 11 12
	///
	/// returns
	///
	///  [1 2 3 4 5 6 7 8 9 10 11 12]
	///
	public var flattened: [T] {
		return array
	}
}

extension Array2D where T == Bool {
	/// Returns a flipped version of a Bool Array2D
	@inlinable func flipped() -> Array2D<T> {
		Array2D<T>(rows: self.rows, columns: self.columns, flattened: self.flattened.map { !$0 })
	}
}
