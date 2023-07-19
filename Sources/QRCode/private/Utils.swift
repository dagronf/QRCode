//
//  Utils.swift
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
import CoreGraphics

/// Attempt to convert an opaque type to a CGFloat value.
@inlinable @inline(__always) internal func CGFloatValue(_ opaque: Any?) -> CGFloat? {
	if let value = DoubleValue(opaque) {
		return CGFloat(value)
	}
	return nil
}

/// Attempt to convert an opaque type to a double value.
@inlinable @inline(__always) internal func DoubleValue(_ opaque: Any?) -> Double? {
	return (opaque as? NSNumber)?.doubleValue
}

/// Attempt to convert an opaque type to a bool value.
@inlinable @inline(__always) internal func BoolValue(_ opaque: Any?) -> Bool? {
	return (opaque as? NSNumber)?.boolValue
}

/// Attempt to convert an opaque type to a int value.
@inlinable @inline(__always) internal func IntValue(_ opaque: Any?) -> Int? {
	return (opaque as? NSNumber)?.intValue
}

/// Attempt to convert an opaque type to a uint value.
@inlinable @inline(__always) internal func UIntValue(_ opaque: Any?) -> UInt? {
	return (opaque as? NSNumber)?.uintValue
}

/// Attempt to convert an opaque b64 string type to a CGImage.
internal func CGImageValueFromB64String(_ opaque: Any?) -> CGImage? {
	if let imageb64 = opaque as? String,
		let imageb64Data = imageb64.data(using: .ascii, allowLossyConversion: false),
		let imageData = Data(base64Encoded: imageb64Data)
	{
		return try? CGImage.load(imageData: imageData)
	}
	return nil
}
