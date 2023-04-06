//
//  NSSecureCodingCodable.swift
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

// MARK: - Codable wrapper for NSSecureCoding

/// A codable wrapper for classes that support NSSecureCoding
///
/// Some of the built-in NS- types don't implement codable.
/// This struct provides a codable wrapper around any class that supports `NSSecureCoding`.
///
/// Example:
///
/// ```swift
/// typealias NSBezierPathCodable = NSSecureCodingCodable<NSBezierPath>
/// ```
@available(macOS 10.13, iOS 11, tvOS 11, watchOS 4, macCatalyst 13, *)
struct NSSecureCodingCodable<CodingType: NSSecureCoding> {
	let object: CodingType

	enum CodableError: Error {
		case unableToDecode
	}

	/// Create a wrapped codable object
	init(_ object: CodingType) {
		self.object = object
	}
}

@available(macOS 10.13, iOS 11, tvOS 11, watchOS 4, macCatalyst 13, *)
extension NSSecureCodingCodable: Codable {
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let data = try container.decode(Data.self)
		self.object = try Self.object(from: data)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		let data = try Self.data(for: self.object)
		try container.encode(data)
	}
}

@available(macOS 10.13, iOS 11, tvOS 11, watchOS 4, macCatalyst 13, *)
extension NSSecureCodingCodable {
	/// Returns a `Data` representation for the provided `CodingType`
	@inlinable static func data(for object: CodingType) throws -> Data {
		try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: true)
	}

	/// Returns a `CodingType` from the provided `Data`
	@inlinable static func object(from data: Data) throws -> CodingType {
		let obj = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
		guard let value = obj as? CodingType else { throw CodableError.unableToDecode }
		return value
	}
}

// MARK: - Codable wrapper for NSCoding

/// A codable wrapper for adding `Codable` support to an `NSCoding`-capable object
///
/// **YOU SHOULD USE NSSecureCodingCodable FOR ALL MODERN Apple OSes**
///
/// Provided for backwards compatibility for `10.11` which has some classes that don't yet support NSSecureCoding
struct NSUnsafeCodingCodable<CodingType: NSCoding> {
	let object: CodingType

	enum CodableError: Error {
		case unableToDecode
	}

	/// Create a wrapped codable object
	init(_ object: CodingType) {
		self.object = object
	}
}

extension NSUnsafeCodingCodable: Codable {
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let data = try container.decode(Data.self)
		self.object = try Self.object(from: data)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		let data = try Self.data(for: self.object)
		try container.encode(data)
	}
}

extension NSUnsafeCodingCodable {
	/// Returns a `Data` representation for the provided `CodingType`
	@inlinable static func data(for object: CodingType) throws -> Data {
		NSKeyedArchiver.archivedData(withRootObject: object)
	}

	/// Returns a `CodingType` from the provided `Data`
	@inlinable static func object(from data: Data) throws -> CodingType {
		let obj = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
		guard let value = obj as? CodingType else { throw CodableError.unableToDecode }
		return value
	}
}
