//
//  File.swift
//
//
//  Created by Darren Ford on 20/11/21.
//

import AppKit

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
	to url: URL
) throws {
	if let size = size {
		image.size = size
	}
	let rep = unscaledBitmapImageRep(forImage: image)

	guard let data = rep.representation(using: type, properties: [.compressionFactor: 1.0]) else {
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
