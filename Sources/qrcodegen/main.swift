//
//  File.swift
//
//
//  Created by Darren Ford on 19/11/21.
//

import AppKit
import ArgumentParser
import Foundation
import QRCode

struct QRCodeGen: ParsableCommand {
	// @Flag(help: "Generate a QR code.")

	@Argument(help: "The QR code dimension.")
	var dimension: Double

	@Option(name: [.customShort("i"), .long], help: "The input file")
	var inputFile: String?

	@Option(name: [.customShort("o"), .long], help: "The output file")
	var outputFile: String?

	@Option(name: [.customShort("t"), .long], help: "The text")
	var text: String?

	@Option(name: [.customShort("f"), .long], help: "The output format (png [default], pdf)")
	var format: String?

	@Option(name: [.customShort("c"), .long], help: "The level of error correction. (low [\"L\"], medium [\"M\", default], high [\"Q\"], max [\"H\"])")
	var errorCorrection: String?

	@Option(name: [.customShort("e"), .long], help: "The eye shape to use. Available shapes are \(EyeShapeFactory.knownTypes.joined(separator: ", "))")
	var eyeShape: String?

	@Option(name: [.customShort("d"), .long], help: "The data shape to use. Available shapes are \(DataShapeFactory.knownTypes.joined(separator: ", "))")
	var dataShape: String?

	/// Inset for the data shape.  Not all data shapes support this
	@Option(name: [.customShort("n"), .long], help: "The data shape inset")
	var inset: Double?

	@Option(name: [.long], help: "The background color to use (format r,g,b,a - 1.0,0.5,0.5,1.0)")
	var bgc: String?

	@Option(name: [.long], help: "The data color to use (format r,g,b,a - 1.0,0.5,0.5,1.0)")
	var dc: String?

	/// The corner radius fraction for the data shape.  Not all data shapes support this
	@Option(name: [.customShort("r"), .long], help: "The data shape corner radius fractional value (0.0 -> 1.0)")
	var dataShapeCornerRadius: Double?

	func run() throws {
		let data: Data

		Swift.print("got here")

		let outputSize = CGSize(width: self.dimension, height: self.dimension)

		if let inputFile = self.inputFile {
			data = try Data(contentsOf: URL(fileURLWithPath: inputFile))
		}
		else if let t = text {
			guard let s = t.data(using: .utf8) else { return }
			data = s
		}
		else if let t = stdinText {
			Swift.print("reading from stdin")
			guard let s = t.data(using: .utf8) else { return }
			data = s
		}
		else {
			return
		}

		let style = QRCode.Style()

		// Colors

		if let backgroundColor = parseColor(self.bgc) {
			style.backgroundStyle = QRCode.FillStyle.Solid(backgroundColor)
		}

		if let dataColor = parseColor(self.dc) {
			style.foregroundStyle = QRCode.FillStyle.Solid(dataColor)
		}

		// The eye shape

		if let name = eyeShape {
			guard let shape = EyeShapeFactory.named(name) else {
				Swift.print("Unknown eye style '\(name)'.")
				let known = EyeShapeFactory.knownTypes.joined(separator: ", ")
				Swift.print("Available eye styles are \(known) ")
				return
			}
			style.shape.eyeShape = shape
		}

		// The data shape

		let dataShapeName = dataShape ?? "square"
		guard let shape = DataShapeFactory.named(dataShapeName, inset: inset ?? 0, cornerRadiusFraction: dataShapeCornerRadius ?? 0) else {
			Swift.print("Unknown data style '\(dataShapeName)'.")
			let known = DataShapeFactory.knownTypes.joined(separator: ",")
			Swift.print("Available data styles are \(known) ")
			return
		}
		style.shape.dataShape = shape

		// Error correction

		var errorCorrection: QRCode.ErrorCorrection = .default
		if let ec = self.errorCorrection {
			switch ec {
			case "low": errorCorrection = .low
			case "medium": errorCorrection = .medium
			case "high": errorCorrection = .high
			case "max": errorCorrection = .max
			default:
				Swift.print("Unknown error correction level '\(ec)'.")
				// QRCodeGen.exit(withError: error)
				return
			}
		}

		// Output format

		let outputExtn: String = {
			if format == nil || format == "png" {
				return "png"
			}
			else if format == "pdf" {
				return format!
			}
			else {
				fatalError()
			}
		}()

		// Output URL

		let outURL: URL = {
			if let o = outputFile {
				return URL(fileURLWithPath: o)
			}
			else {
				return temporaryFile(extn: outputExtn)
			}
		}()

		let qrCode = QRCode(data, errorCorrection: errorCorrection)

		if format == nil || format == "png" {
			guard
				let image = qrCode.image(outputSize, scale: 1, style: style)
			else {
				return
			}
			let nsImage = NSImage(cgImage: image, size: .zero)
			try writeImage(image: nsImage, usingType: .png, withSizeInPixels: outputSize, to: outURL)
		}
		else if format == "pdf" {
			guard
				let data = qrCode.pdfData(outputSize, style: style),
				let _ = try? data.write(to: outURL, options: .atomic)
			else {
				return
			}
		}
		else {
			return
		}

		if outputFile == nil {
			// If the output file isn't specified, just open it using the default application
			NSWorkspace.shared.open(outURL)
		}
	}
}

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

var stdinText: String?

if CommandLine.arguments.count == 1 || CommandLine.arguments.last == "-" {
	if CommandLine.arguments.last == "-" {
		CommandLine.arguments.removeLast()
	}
	stdinText = readSTDIN()
}

// Remove the application name
let args = [String](CommandLine.arguments.dropFirst())

let command = QRCodeGen.parseOrExit(args)
do {
	try command.run()
}
catch {
	QRCodeGen.exit(withError: error)
}
