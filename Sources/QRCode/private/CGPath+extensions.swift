//
//  CGPath+extensions.swift
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

#if canImport(CoreGraphics)

import Foundation
import CoreGraphics

// MARK: - CGPath/CGMutablePath

extension CGPath {
	/// Convenience for creating a CGPath
	static func make(_ block: (CGMutablePath) -> Void) -> CGPath {
		let pth = CGMutablePath()
		block(pth)
		return pth
	}

	/// Convenience for creating a CGMutablePath
	static func makeMutable(_ block: (CGMutablePath) -> Void) -> CGMutablePath {
		let pth = CGMutablePath()
		block(pth)
		return pth
	}
}

extension CGPath {
	/// A safe wrapper around applyWithBlock and applyWithBlockLegacy
	func applyWithBlockSafe(_ block: @escaping (UnsafePointer<CGPathElement>) -> Void) {
		if #available(macOS 10.13, iOS 11, tvOS 11, watchOS 4, *) {
			self.applyWithBlock(block)
		}
		else {
			self.applyWithBlockLegacy(block)
		}
	}

	/// A backwards compatible version of `applyWithBlock` for use before macOS 10.13
	func applyWithBlockLegacy(_ block: @escaping (UnsafePointer<CGPathElement>) -> Void) {
		class BlockWrapper {
			let block: (UnsafePointer<CGPathElement>) -> Void
			init(block: @escaping (UnsafePointer<CGPathElement>) -> Void) {
				self.block = block
			}
		}

		var resultData = BlockWrapper(block: block)
		withUnsafeMutablePointer(to: &resultData) { results in
			self.apply(info: results) { (results, elementPointer) in
				guard let results = results?.assumingMemoryBound(to: BlockWrapper.self).pointee else {
					fatalError()
				}
				results.block(elementPointer)
			}
		}
	}
}

#endif
