//
//  Optional+extensions.swift
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

/// Unwrap an optional value, and if the unwrap is successful call the supplied block with the unwrapped value.
/// - Returns: nil if the optional value is nil, otherwise the result of calling the block
///
/// Useful for when you have an optional value that needs to be passed to a function which takes a non-optional
/// parameter.
///
/// ```swift
/// var selectedIndex: Int?
///  ...
/// let result = Unwrapping(selectedIndex) { self.content[$0] }
/// ```swift
///
@inlinable @inline(__always) func Unwrapping<Wrapped, S>(
	_ value: Optional<Wrapped>,
	_ block: (Wrapped) throws -> S) rethrows -> S?
{
	if let v1 = value {
		return try block(v1)
	}
	return nil
}

@inlinable @inline(__always) func Unwrapping<Wrapped1, Wrapped2, S>(
	_ value1: Optional<Wrapped1>,
	_ value2: Optional<Wrapped2>,
	_ block: (Wrapped1, Wrapped2) throws -> S) rethrows -> S?
{
	if let v1 = value1, let v2 = value2 {
		return try block(v1, v2)
	}
	return nil
}

@inlinable @inline(__always) func Unwrapping<Wrapped1, Wrapped2, Wrapped3, S>(
	_ value1: Optional<Wrapped1>,
	_ value2: Optional<Wrapped2>,
	_ value3: Optional<Wrapped3>,
	_ block: (Wrapped1, Wrapped2, Wrapped3) throws -> S) rethrows -> S?
{
	if let v1 = value1, let v2 = value2, let v3 = value3 {
		return try block(v1, v2, v3)
	}
	return nil
}

extension Optional {
	/// Unwrap an optional value, and if the unwrap is successful call the supplied block with the unwrapped value.
	/// - Returns: nil if the optional value is nil, otherwise the result of calling the block
	///
	/// Useful for when you have an optional value that needs to be passed to a function which takes a non-optional
	/// parameter.
	///
	/// ```swift
	/// var selectedIndex: Int?
	///  ...
	/// let result = selectedIndex.unwrapping { self.content[$0] }
	/// ```swift
	func unwrapping<T>(_ block: (Wrapped) throws -> T) rethrows -> T? {
		if let item = self {
			return try block(item)
		}
		return nil
	}
}
