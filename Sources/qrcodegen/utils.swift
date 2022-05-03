//
//  utils.swift
//
//  Created by Darren Ford on 20/11/21.
//  Copyright © 2022 Darren Ford. All rights reserved.
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

import AppKit

// MARK: - stdin handling

func readSTDIN() -> String? {
	var input: String?

	while let line = readLine() {
		if input == nil {
			input = line
		}
		else {
			input! += "\n" + line
		}
	}

	return input
}

// MARK: - Image output handling

func unscaledBitmapImageRep(forImage image: NSImage) -> NSBitmapImageRep {
	guard let rep = NSBitmapImageRep(
		bitmapDataPlanes: nil,
		pixelsWide: Int(image.size.width),
		pixelsHigh: Int(image.size.height),
		bitsPerSample: 8,
		samplesPerPixel: 4,
		hasAlpha: true,
		isPlanar: false,
		colorSpaceName: .deviceRGB,
		bytesPerRow: 0,
		bitsPerPixel: 0
	) else {
		preconditionFailure()
	}

	NSGraphicsContext.saveGraphicsState()
	NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
	image.draw(at: .zero, from: .zero, operation: .sourceOver, fraction: 1.0)
	NSGraphicsContext.restoreGraphicsState()

	return rep
}

func writeImage(
	image: NSImage,
	usingType type: NSBitmapImageRep.FileType,
	withSizeInPixels size: NSSize?,
	compressionFactor: CGFloat = 1.0,
	to url: URL
) throws {
	if let size = size {
		image.size = size
	}
	let rep = unscaledBitmapImageRep(forImage: image)

	guard let data = rep.representation(using: type, properties: [.compressionFactor: compressionFactor]) else {
		preconditionFailure()
	}

	try data.write(to: url)
}

// MARK: - Temporary files

func temporaryFile(extn: String) -> URL {
	return try! FileManager.default.url(
		for: .documentDirectory,
			in: .userDomainMask,
			appropriateFor: URL(fileURLWithPath: NSTemporaryDirectory()),
			create: true
	)
	.appendingPathComponent(UUID().uuidString + "." + extn)
}
