//
//  FileManager+extensions.swift
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

extension FileManager {
	/// Returns a unique URL for the specified filename and directory. Not thread safe
	/// - Parameter filename: the `lastPathComponent` of a URL (for example, `IMG-2002.jpg`)
	/// - Parameter directory: the directory in which to check
	/// - Returns: a unique URL
	static func UniqueFileURL(for filename: String, in directory: URL) -> URL {
		// Filename is lastPathComponent
		let fm = FileManager.default

		var counter: Int = 1
		var url = directory.appendingPathComponent(filename)

		let originalFilename = url.deletingPathExtension().lastPathComponent
		let extn = url.pathExtension

		while true {
			counter += 1
			if !fm.fileExists(atPath: url.path) {
				return url
			}

			let newFile = "\(originalFilename)-\(counter).\(extn)"
			url = directory.appendingPathComponent(newFile)
		}
	}
}
