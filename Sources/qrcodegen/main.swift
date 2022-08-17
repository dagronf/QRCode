//
//  main.swift
//
//  Created by Darren Ford on 19/11/21.
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

// Command line access to qrcode

import AppKit
import ArgumentParser
import Foundation
import QRCode

enum SupportedExtensions: String {
	case png
	case pdf
	case jpg
	case svg
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
Example: qrcodegen -t "This is a QR code" --output-file "fish.png" 512

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

	@Option(help: "The output format (png [default],pdf,svg,ascii,smallascii)")
	var outputFormat: String?

	@Option(help: "The output format compression factor (if the output format supports it, png,jpg)")
	var outputCompression: Double?

	@Option(name: [.customShort("t"), .long], help: "The text to be stored in the QR code")
	var text: String?

	@Flag(name: [.customShort("s"), .long], help: "Silence any output")
	var silence = false

	@Option(name: [.customShort("c"), .long], help: #"The level of error correction. Available levels are "L" (low), "M" (medium), "Q" (high), "H" (max)"#)
	var errorCorrection: String?

	@Option(name: [.customShort("e"), .long], help: "The eye shape to use. Available shapes are \(QRCodeEyeShapeFactory.shared.availableGeneratorNames.joined(separator: ", ")).")
	var eyeShape: String?

	@Option(name: [.customShort("d"), .long], help: "The onPixels shape to use. Available shapes are \(QRCodePixelShapeFactory.shared.availableGeneratorNames.joined(separator: ", ")).")
	var onPixelShape: String?

	/// Inset for the data shape.  Not all data shapes support this
	@Option(name: [.customShort("n"), .long], help: "The spacing around each individual pixel in the onPixels section")
	var inset: Double?

	/// The corner radius fraction for the data shape.  Not all data shapes support this
	@Option(name: [.customShort("r"), .long], help: "The onPixels shape corner radius fractional value (0.0 -> 1.0)")
	var onPixelShapeCornerRadius: Double?

	@Option(name: [.long], help: "The background color to use (format r,g,b,a - 1.0,0.5,0.5,1.0)")
	var bgColor: String?

	@Option(name: [.long], help: "The onPixels color to use (format r,g,b,a - 1.0,0.5,0.5,1.0)")
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

		if let archive = self.bgColor,
			let backgroundColor = CGColor.UnarchiveSRGBA(archive) {
			design.style.background = QRCode.FillStyle.Solid(backgroundColor)
		}

		if let archive = self.dataColor,
			let dataColor = CGColor.UnarchiveSRGBA(archive) {
			design.style.onPixels = QRCode.FillStyle.Solid(dataColor)
		}

		if let archive = self.eyeColor,
			let eyeColor = CGColor.UnarchiveSRGBA(archive) {
			design.style.eye = QRCode.FillStyle.Solid(eyeColor)
		}

		if let archive = self.pupilColor,
			let pupilColor = CGColor.UnarchiveSRGBA(archive) {
			design.style.pupil = QRCode.FillStyle.Solid(pupilColor)
		}

		// The eye shape

		if let name = eyeShape {
			guard let shape = QRCodeEyeShapeFactory.shared.named(name) else {
				Swift.print("Unknown eye style '\(name)'.")
				let known = QRCodeEyeShapeFactory.shared.availableGeneratorNames.joined(separator: ",")
				Swift.print("Available eye styles are \(known)")
				QRCodeGen.exit(withError: ExitCode(-2))
			}
			design.shape.eye = shape
		}

		// The onPixels shape

		let dataShapeName = self.onPixelShape ?? "square"
		let settings: [String: Any] = [
			"inset": inset ?? 0,
			"cornerRadiusFraction": onPixelShapeCornerRadius ?? 0
		]

		guard let shape = QRCodePixelShapeFactory.shared.named(dataShapeName, settings: settings) else {
			Swift.print("Unknown 'onPixels' style '\(dataShapeName)'.")
			let known = QRCodePixelShapeFactory.shared.availableGeneratorNames.joined(separator: ",")
			Swift.print("Available 'onPixels' styles are \(known)")
			QRCodeGen.exit(withError: ExitCode(-3))
		}
		design.shape.onPixels = shape

		// Error correction

		var errorCorrection: QRCode.ErrorCorrection = .default
		if let ec = self.errorCorrection {
			guard
				let ch = ec.first,
				let eet =  QRCode.ErrorCorrection.Create(ch)
			else {
				Swift.print("Unknown error correction level '\(ec)'.")
				QRCodeGen.exit(withError: ExitCode(-4))
			}
			errorCorrection = eet
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
			guard let nsImage = qrCode.nsImage(outputSize, scale: 1, design: design) else {
				Swift.print("Unable to generate image from qrcode")
				QRCodeGen.exit(withError: ExitCode(-6))
			}
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
			guard let nsImage = qrCode.nsImage(outputSize, scale: 1, design: design) else {
				Swift.print("Unable to generate image from qrcode")
				QRCodeGen.exit(withError: ExitCode(-6))
			}
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

		case .svg:
			let str = qrCode.svg(
				foreground: (design.style.onPixels as? QRCode.FillStyle.Solid)?.color ?? .black,
				background: (design.style.background as? QRCode.FillStyle.Solid)?.color
			)
			do {
				try str.write(to: outURL, atomically: true, encoding: .utf8)
			}
			catch {
				Swift.print("Unable to write to output file \(outURL.absoluteString)")
				QRCodeGen.exit(withError: ExitCode(-9))
			}

		case .ascii:
			Swift.print(qrCode.asciiRepresentation())

		case .smallascii:
			Swift.print(qrCode.smallAsciiRepresentation())
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
