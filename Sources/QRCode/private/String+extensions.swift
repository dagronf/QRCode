//
//  String+extensions.swift
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

extension String {
	/// Returns a new string by removing any instances of the specified characters
	///
	/// - Parameter
	///   - replacementChars: String containing the characters to replace
	/// - Returns: a new string filtering out the specified characters
	func removing(charactersIn replacementChars: String) -> String {
		return filter { replacementChars.contains($0) == false }
	}

	/// Removes any instances of the specified characters
	///
	/// - Parameter
	///   - replacementChars: String containing the characters to replace
	/// - Returns: a new string filtering out the specified characters
	mutating func remove(charactersFrom replacementChars: String) {
		self = self.removing(charactersIn: replacementChars)
	}

	/// Returns a new string by replacing any instances of the specified characters with a new character
	///
	/// - Parameters:
	///   - charactersIn: String containing the characters to replace
	///   - replacement: replacement character
	func replacing(charactersIn replacementChars: String, with replacement: Character) -> String {
		return String(map { replacementChars.contains($0) ? replacement : $0 })
	}

	/// Replaces any instances of the specified characters with a new character
	///
	/// - Parameters:
	///   - charactersIn: String containing the characters to replace
	///   - replacement: replacement character
	mutating func replace(charactersFrom replacementChars: String, with replacement: Character) {
		self = self.replacing(charactersIn: replacementChars, with: replacement)
	}
}

// MARK: - Progressive Find

public extension String {
	/// Enumerate the contents of the string, character by character
	/// - Parameter block: A callback block for each character.  Return false if you want the enumeration to stop.
	func enumerateCharacters(block: (Character, String.Index) -> Bool) {
		var currentTextIndex = self.startIndex
		while currentTextIndex < self.endIndex {
			let shouldContinue = block(self[currentTextIndex], currentTextIndex)
			if !shouldContinue {
				return
			}
			currentTextIndex = self.index(currentTextIndex, offsetBy: 1)
		}
	}
}

extension String {
	/// Retrieve the contents of the string as a Bool value.
	///
	/// This property is true on encountering one of "Y", "y", "T", "t", or a digit 1-9—the method ignores any trailing characters. This property is false if the receiver doesn’t begin with a valid decimal text representation of a number.
	///
	/// The property assumes a decimal representation and skips whitespace at the beginning of the string. It also skips initial whitespace characters, or optional -/+ sign followed by zeroes.
	///
	/// See: [NSString boolValue](https://developer.apple.com/documentation/foundation/nsstring/1409420-boolvalue)
	var boolValue: Bool {
		return (self as NSString).boolValue
	}
}

extension String {
	/// Return a string that is safe to use within the query component of a URL
	var urlQuerySafe: String? {
		self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
	}
}
