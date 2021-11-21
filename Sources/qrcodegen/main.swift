//
//  main.swift
//
//  Created by Darren Ford on 19/11/21.
//  Copyright © 2021 Darren Ford. All rights reserved.
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

// Command line access to qrcode

import AppKit
import ArgumentParser
import Foundation
import QRCode

enum SupportedExtensions: String {
	case png
	case pdf
	case jpg
	case ascii
	case smallascii

	var fileBased: Bool {
		return self == .png || self == .pdf || self == .jpg
	}
}

struct QRCodeGen: ParsableCommand {
	// @Flag(help: "Generate a QR code.")

	static var configuration: CommandConfiguration {
		CommandConfiguration(
			abstract: "Create a qr code",
			discussion: """
* If you don't specify either -t or --input-file, the qrcode content will be read from STDIN
* If you don't specify an output file, the generated qr code will be written to a temporary file
  and opened in the default application.
"""
		)
	}

	@Argument(help: "The QR code dimension.")
	var dimension: Double

	@Option(help: "The file containing the content for the QR code")
	var inputFile: String?

	@Option(help: "The output file")
	var outputFile: String?

	@Option(help: "The output format (png [default],pdf,ascii,smallascii)")
	var outputFormat: String?

	@Option(help: "The output format compression factor (if the output format supports it, png,jpg)")
	var outputCompression: Double?

	@Option(name: [.customShort("t"), .long], help: "The text to be stored in the QR code")
	var text: String?

	@Flag(name: [.customShort("s"), .long], help: "Silence any output")
	var silence = false

	@Option(name: [.customShort("c"), .long], help: "The level of error correction. (low [\"L\"], medium [\"M\", default], high [\"Q\"], max [\"H\"])")
	var errorCorrection: String?

	@Option(name: [.customShort("e"), .long], help: "The eye shape to use. Available shapes are \(EyeShapeFactory.knownTypes.joined(separator: ", "))")
	var eyeShape: String?

	@Option(name: [.customShort("d"), .long], help: "The data shape to use. Available shapes are \(DataShapeFactory.knownTypes.joined(separator: ", "))")
	var dataShape: String?

	/// Inset for the data shape.  Not all data shapes support this
	@Option(name: [.customShort("n"), .long], help: "The spacing around each individual pixel in the data section")
	var inset: Double?

	/// The corner radius fraction for the data shape.  Not all data shapes support this
	@Option(name: [.customShort("r"), .long], help: "The data shape corner radius fractional value (0.0 -> 1.0)")
	var dataShapeCornerRadius: Double?

	@Option(name: [.long], help: "The background color to use (format r,g,b,a - 1.0,0.5,0.5,1.0)")
	var bgColor: String?

	@Option(name: [.long], help: "The data color to use (format r,g,b,a - 1.0,0.5,0.5,1.0)")
	var dataColor: String?

	@Option(name: [.long], help: "The eye color to use (format r,g,b,a - 1.0,0.5,0.5,1.0)")
	var eyeColor: String?

	@Option(name: [.long], help: "The pupil color to use (format r,g,b,a - 1.0,0.5,0.5,1.0)")
	var pupilColor: String?

	func run() throws {
		let data: Data

		let outputSize = CGSize(width: self.dimension, height: self.dimension)

		if let inputFile = self.inputFile {
			data = try Data(contentsOf: URL(fileURLWithPath: inputFile))
		}
		else if let t = text {
			guard let s = t.data(using: .utf8) else { return }
			data = s
		}
		else if let t = readSTDIN() {
			Swift.print("reading from stdin")
			guard let s = t.data(using: .utf8) else { return }
			data = s
		}
		else {
			QRCodeGen.exit(withError: ExitCode(-1))
		}

		// Create the design to use
		let design = QRCode.Design()

		// Colors

		if let backgroundColor = parseColor(self.bgColor) {
			design.style.background = QRCode.FillStyle.Solid(backgroundColor)
		}

		if let dataColor = parseColor(self.dataColor) {
			design.style.data = QRCode.FillStyle.Solid(dataColor)
		}

		if let eyeColor = parseColor(self.eyeColor) {
			design.style.eye = QRCode.FillStyle.Solid(eyeColor)
		}

		if let pupilColor = parseColor(self.pupilColor) {
			design.style.pupil = QRCode.FillStyle.Solid(pupilColor)
		}

		// The eye shape

		if let name = eyeShape {
			guard let shape = EyeShapeFactory.named(name) else {
				Swift.print("Unknown eye style '\(name)'.")
				let known = EyeShapeFactory.knownTypes.joined(separator: ",")
				Swift.print("Available eye styles are \(known)")
				QRCodeGen.exit(withError: ExitCode(-2))
			}
			design.shape.eye = shape
		}

		// The data shape

		let dataShapeName = self.dataShape ?? "square"
		guard let shape = DataShapeFactory.named(dataShapeName, inset: inset ?? 0, cornerRadiusFraction: dataShapeCornerRadius ?? 0) else {
			Swift.print("Unknown data style '\(dataShapeName)'.")
			let known = DataShapeFactory.knownTypes.joined(separator: ",")
			Swift.print("Available data styles are \(known) ")
			QRCodeGen.exit(withError: ExitCode(-3))
		}
		design.shape.data = shape

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
				QRCodeGen.exit(withError: ExitCode(-4))
			}
		}

		// Output format
		let extnString = self.outputFormat ?? "png"
		guard let outputType = SupportedExtensions(rawValue: extnString) else {
			Swift.print("Unknown output format '\(self.outputFormat ?? "")'. Supported formats are png,jpg,pdf,ascii,smallascii.")
			QRCodeGen.exit(withError: ExitCode(-5))
		}

		let outputCompr = max(0.0, min(1.0, outputCompression ?? 1.0))

		if !self.silence, self.dimension > 8192 {
			Swift.print("WARNING: Large image size. Suggest using PDF output at a smaller size")
		}

		// Output URL

		let outURL: URL = {
			if let o = outputFile {
				return URL(fileURLWithPath: o)
			}
			else {
				return temporaryFile(extn: outputType.rawValue)
			}
		}()

		let qrCode = QRCode(data, errorCorrection: errorCorrection)

		switch outputType {
		case .png:
			guard let image = qrCode.image(outputSize, scale: 1, design: design) else {
				Swift.print("Unable to generate image from qrcode")
				QRCodeGen.exit(withError: ExitCode(-6))
			}
			let nsImage = NSImage(cgImage: image, size: .zero)
			do {
				try writeImage(
					image: nsImage,
					usingType: .png,
					withSizeInPixels: outputSize,
					compressionFactor: outputCompr,
					to: outURL)
			}
			catch {
				Swift.print("Unable to write to output file \(outURL.absoluteString) - error was \(error)")
				QRCodeGen.exit(withError: ExitCode(-7))
			}

		case .jpg:
			guard let image = qrCode.image(outputSize, scale: 1, design: design) else {
				Swift.print("Unable to generate image from qrcode")
				QRCodeGen.exit(withError: ExitCode(-6))
			}
			let nsImage = NSImage(cgImage: image, size: .zero)
			do {
				try writeImage(
					image: nsImage,
					usingType: .jpeg,
					withSizeInPixels: outputSize,
					compressionFactor: outputCompr,
					to: outURL)
			}
			catch {
				Swift.print("Unable to write to output file \(outURL.absoluteString) - error was \(error)")
				QRCodeGen.exit(withError: ExitCode(-7))
			}

		case .pdf:
			guard let data = qrCode.pdfData(outputSize, design: design) else {
				Swift.print("Unable to write to output file \(outURL.absoluteString)")
				QRCodeGen.exit(withError: ExitCode(-8))
			}
			do {
				try data.write(to: outURL, options: .atomic)
			}
			catch {
				Swift.print("Unable to write to output file \(outURL.absoluteString)")
				QRCodeGen.exit(withError: ExitCode(-9))
			}

		case .ascii:
			for row in 0 ..< qrCode.current.rows {
				var rowString = ""
				for col in 0 ..< qrCode.current.columns {
					if qrCode.current[row, col] == true {
						rowString += "██"
					}
					else {
						rowString += "  "
					}
				}
				Swift.print(rowString)
			}

		case .smallascii:
			for row in stride(from: 0, to: qrCode.current.rows, by: 2) {
				var rowString = ""
				for col in 0 ..< qrCode.current.columns {
					let top = qrCode.current[row, col]

					if row <= qrCode.current.rows - 2 {
						let bottom = qrCode.current[row + 1, col]
						if top,!bottom { rowString += "▀" }
						if !top, bottom { rowString += "▄" }
						if top, bottom { rowString += "█" }
						if !top, !bottom { rowString += " " }
					}
					else {
						if top { rowString += "▀" }
						else { rowString += " " }
					}
				}
				Swift.print(rowString)
			}
			if qrCode.current.rows.isOdd {
				Swift.print(String(repeating: " ", count: qrCode.current.columns))
			}
		}

		if outputType.fileBased && self.outputFile == nil {
			// If the output file isn't specified, just open it using the default application
			NSWorkspace.shared.open(outURL)
		}
	}
}

// MARK: - main application

// Remove the application name
let args = [String](CommandLine.arguments.dropFirst())

let command = QRCodeGen.parseOrExit(args)
do {
	try command.run()
}
catch {
	QRCodeGen.exit(withError: error)
}
