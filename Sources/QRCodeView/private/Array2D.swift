/*
 Two-dimensional array with a fixed number of rows and columns.
 This is mostly handy for games that are played on a grid, such as chess.
 Performance is always O(1).
 */
public struct Array2D<T> {
	public let columns: Int
	public let rows: Int
	fileprivate var array: [T]
	
	public init(rows: Int, columns: Int, initialValue: T) {
		self.columns = columns
		self.rows = rows
		self.array = .init(repeating: initialValue, count: rows*columns)
	}

	public init(rows: Int, columns: Int, flattened: [T]) {
		precondition(rows * columns == flattened.count, "row/column counts don't match initial flattened data count")
		self.columns = columns
		self.rows = rows
		self.array = flattened
	}
	
	public subscript(row: Int, column: Int) -> T {
		get {
			precondition(column < self.columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
			precondition(row < self.rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
			return self.array[row*columns + column]
		}
		set {
			precondition(column < self.columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
			precondition(row < self.rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
			self.array[row*columns + column] = newValue
		}
	}
	
	mutating func setIndexed(_ index: Int, value: T) {
		self.array[index] = value
	}
}
