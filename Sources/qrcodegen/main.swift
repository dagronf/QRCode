//
//  main.swift
//
//  Copyright © 2024 Darren Ford. All rights reserved.
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

#if os(macOS)

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
	case clipboard
	case json

	var fileBased: Bool {
		return self == .png || self == .pdf || self == .jpg || self == .svg || self == .json
	}
}

struct QRCodeGen: ParsableCommand {
	// @Flag(help: "Generate a QR code.")

	static var configuration: CommandConfiguration {
		CommandConfiguration(
			abstract: "Create a qr code",
			discussion: """
Examples:
   qrcodegen -t "This is a QR code" --output-file "fish.png" 512
   qrcodegen -t "QRCode on the clipboard" --output-format clipboard 1024
   qrcodegen --style-template-file qrtemplate.json -t "QRCode on the clipboard" --output-format clipboard 1024

* If you don't specify either -t or --input-file, the qrcode content will be read from STDIN
* If you don't specify an output file, the generated qr code will be written to a temporary file
  and opened in the default application.
* You can generate a style template file by exporting to json format.
"""
		)
	}

	@Argument(help: "The QR code dimension.")
	var dimension: Double

	@Option(help: "The file containing the content for the QR code")
	var inputFile: String?

	@Option(help: "The output file")
	var outputFile: String?

	@Option(help: "The output format (png [default],pdf,svg,ascii,smallascii,clipboard,json)")
	var outputFormat: String?

	@Option(help: "The output format compression factor (if the output format supports it, png,jpg)")
	var outputCompression: Double?

	@Option(name: [.long], help: "The QR code file to use as a style template")
	var styleTemplateFile: String?

	@Option(name: [.long], help: "The image file to use as a logo if the style template file defines a logo template")
	var logoImageFile: String?

	@Option(name: [.customShort("t"), .long], help: "The text to be stored in the QR code")
	var text: String?

	@Flag(name: [.customShort("s"), .long], help: "Silence any output")
	var silence = false

	@Option(name: [.customShort("c"), .long], help: #"The level of error correction. Available levels are "L" (low), "M" (medium), "Q" (quantize), "H" (high)"#)
	var errorCorrection: String?

	// On Pixels

	@Option(name: [.long], help: "Print all the available pixel shapes.")
	var allPixelShapes: Bool?

	@Option(name: [.customShort("d"), .long], help: "The onPixels shape to use. Available shapes are \(QRCodePixelShapeFactory.shared.availableGeneratorNames.joined(separator: ", ")).")
	var onPixelShape: String?

	/// Inset for the data shape.  Not all data shapes support this
	@Option(name: [.customShort("n"), .long], help: "The spacing around each individual pixel in the onPixels section")
	var onPixelInsetFraction: Double?

	/// The corner radius fraction for the data shape.  Not all data shapes support this
	@Option(name: [.customShort("r"), .long], help: "The onPixels shape corner radius fractional value (0.0 -> 1.0)")
	var onPixelShapeCornerRadius: Double?

	/// Should we draw inner corners on the pixel shape. Not all data shapes support this
	@Option(name: [.customShort("a"), .long], help: "The onPixels 'has inner corners' value (true/false)")
	var onPixelShapeHasInnerCorners: Bool?

	// Eye shape

	@Option(name: [.long], help: "Print all the available eye shapes.")
	var allEyeShapes: Bool?

	@Option(name: [.customShort("e"), .long], help: "The eye shape to use. Available shapes are \(QRCodeEyeShapeFactory.shared.availableGeneratorNames.joined(separator: ", ")).")
	var eyeShape: String?

	@Option(name: [.long], help: "The fractional (0 ... 1) corner radius to use for the eye shape IF the eye shape supports it.")
	var eyeShapeCornerRadius: Double?

	// Pupil shape

	@Option(name: [.long], help: "Print all the available pupil shapes.")
	var allPupilShapes: Bool?

	@Option(name: [.customShort("p"), .long], help: "The pupil shape to use. Available shapes are \(QRCodePupilShapeFactory.shared.availableGeneratorNames.joined(separator: ", ")).")
	var pupilShape: String?

	@Option(name: [.long], help: "The fractional (0 ... 1) corner radius to apply to the pupil shape IF the pupil shape supports it.")
	var pupilShapeCornerRadius: Double?

	@Option(name: [.long], help: "The background color to use (format r,g,b,a - 1.0,0.5,0.5,1.0)")
	var bgColor: String?

	@Option(name: [.long], help: "The onPixels color to use (format r,g,b,a - 1.0,0.5,0.5,1.0)")
	var dataColor: String?

	@Option(name: [.long], help: "The eye color to use (format r,g,b,a - 1.0,0.5,0.5,1.0)")
	var eyeColor: String?

	@Option(name: [.long], help: "The pupil color to use (format r,g,b,a - 1.0,0.5,0.5,1.0)")
	var pupilColor: String?

	func run() throws {

		let outputSize = CGSize(width: self.dimension, height: self.dimension)

		let doc = QRCode.Document()

		//
		// Content
		//

		if let inputFile = self.inputFile {
			doc.data = try Data(contentsOf: URL(fileURLWithPath: inputFile))
		}
		else if let t = text {
			doc.utf8String = t
		}
		else if let t = readSTDIN() {
			Swift.print("reading from stdin")
			guard let s = t.data(using: .utf8) else { return }
			doc.data = s
		}
		else {
			QRCodeGen.exit(withError: ExitCode(-1))
		}

		//
		// Template Design
		//

		var templateDocument: QRCode.Document?

		doc.design = {
			if let styleTemplateFile = styleTemplateFile {
				let templateURL = URL(fileURLWithPath: styleTemplateFile)
				do {
					templateDocument = try QRCode.Document(jsonData: try Data(contentsOf: templateURL))
					return templateDocument!.design
				}
				catch {
					Swift.print("Invalid style template file '\(styleTemplateFile)'.")
					QRCodeGen.exit(withError: ExitCode(-10))
				}
			}
			else {
				return QRCode.Design()
			}
		}()

		//
		// Logo template
		//

		doc.logoTemplate = {
			if let styleDocument = templateDocument,
				let template = styleDocument.logoTemplate,
				let logoImageFile = logoImageFile,
				let path = Optional(URL(fileURLWithPath: logoImageFile)),
				let image = NSImage(contentsOf: path),
				let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)
			{
				return template.copyWithImage(cgImage)
			}
			return nil
		}()

		//
		// Colors
		//

		if let archive = self.bgColor {
			let backgroundColor = try CGColor.UnarchiveSRGBA(archive)
			doc.design.style.background = QRCode.FillStyle.Solid(backgroundColor)
		}

		if let archive = self.dataColor {
			let dataColor = try CGColor.UnarchiveSRGBA(archive)
			doc.design.style.onPixels = QRCode.FillStyle.Solid(dataColor)
		}

		if let archive = self.eyeColor {
			let eyeColor = try CGColor.UnarchiveSRGBA(archive)
			doc.design.style.eye = QRCode.FillStyle.Solid(eyeColor)
		}

		if let archive = self.pupilColor {
			let pupilColor = try CGColor.UnarchiveSRGBA(archive)
			doc.design.style.pupil = QRCode.FillStyle.Solid(pupilColor)
		}

		//
		// The eye shape
		//

		if let name = eyeShape {
			var settings: [String: Any] = [:]
			if let cf = eyeShapeCornerRadius {
				settings[QRCode.SettingsKey.cornerRadiusFraction] = cf
			}
			
			do {
				doc.design.shape.eye = try QRCodeEyeShapeFactory.shared.named(name, settings: settings)
			}
			catch {
				Swift.print("Unknown eye style '\(name)'.")
				let known = QRCodeEyeShapeFactory.shared.availableGeneratorNames.joined(separator: ",")
				Swift.print("Available eye styles are \(known)")
				QRCodeGen.exit(withError: ExitCode(-2))
			}
		}

		if let cf = eyeShapeCornerRadius {
			_ = doc.design.shape.eye.setSettingValue(cf, forKey: QRCode.SettingsKey.cornerRadiusFraction)
		}

		//
		// Pupil shape
		//

		if let name = pupilShape {
			do {
				doc.design.shape.pupil = try QRCodePupilShapeFactory.shared.named(name)
			}
			catch {
				Swift.print("Unknown pupil style '\(name)'.")
				let known = QRCodeEyeShapeFactory.shared.availableGeneratorNames.joined(separator: ",")
				Swift.print("Available pupil styles are \(known)")
				QRCodeGen.exit(withError: ExitCode(-2))
			}
		}

		if let cf = pupilShapeCornerRadius {
			_ = doc.design.shape.actualPupilShape.setSettingValue(cf, forKey: QRCode.SettingsKey.cornerRadiusFraction)
		}

		//
		// The onPixels shape
		//

		let dataShapeName = self.onPixelShape ?? "square"
		var settings: [String: Any] = [:]
		if let v = onPixelInsetFraction {
			settings[QRCode.SettingsKey.insetFraction] = v
		}
		if let v = onPixelShapeCornerRadius {
			settings[QRCode.SettingsKey.cornerRadiusFraction] = v
		}
		if let v = onPixelShapeHasInnerCorners {
			settings[QRCode.SettingsKey.hasInnerCorners] = v
		}

		do {
			doc.design.shape.onPixels = try QRCodePixelShapeFactory.shared.named(dataShapeName, settings: settings)
		}
		catch {
			Swift.print("Unknown 'onPixels' style '\(dataShapeName)'.")
			let known = QRCodePixelShapeFactory.shared.availableGeneratorNames.joined(separator: ",")
			Swift.print("Available 'onPixels' styles are \(known)")
			QRCodeGen.exit(withError: ExitCode(-3))
		}

		//
		// Error correction
		//

		if let ec = self.errorCorrection {
			guard
				let ch = ec.first,
				let eet =  QRCode.ErrorCorrection.Create(ch)
			else {
				Swift.print("Unknown error correction level '\(ec)'.")
				QRCodeGen.exit(withError: ExitCode(-4))
			}
			doc.errorCorrection = eet
		}

		let outputCompr = max(0.0, min(1.0, outputCompression ?? 1.0))

		if !self.silence, self.dimension > 8192 {
			Swift.print("WARNING: Large image size. Suggest using PDF output at a smaller size")
		}

		//
		// Output format
		//

		let extnString = self.outputFormat ?? "png"
		guard let outputType = SupportedExtensions(rawValue: extnString) else {
			Swift.print("Unknown output format '\(self.outputFormat ?? "")'. Supported formats are png,jpg,pdf,ascii,smallascii,json.")
			QRCodeGen.exit(withError: ExitCode(-5))
		}
		
		//
		// Output URL
		//

		let outURL: URL = {
			if let o = outputFile {
				return URL(fileURLWithPath: o)
			}
			else {
				return temporaryFile(extn: outputType.rawValue)
			}
		}()

		//
		// Generate output
		//

		switch outputType {
		case .clipboard:
			doc.addToPasteboard(outputSize)
		case .png:
			let pngData = try doc.pngData(dimension: Int(outputSize.width))
			try pngData.write(to: outURL, options: .atomic)
		case .jpg:
			let jpgData = try doc.jpegData(dimension: Int(self.dimension), compression: outputCompr)
			try jpgData.write(to: outURL, options: .atomic)
		case .pdf:
			let pdfData = try doc.pdfData(dimension: Int(self.dimension))
			try pdfData.write(to: outURL, options: .atomic)
		case .svg:
			let svgData = try doc.svgData(dimension: Int(self.dimension))
			try svgData.write(to: outURL, options: .atomic)
		case .ascii:
			Swift.print(doc.asciiRepresentation)
		case .smallascii:
			Swift.print(doc.smallAsciiRepresentation)
		case .json:
			Swift.print(try doc.jsonStringFormatted())
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

if args.contains("--all-eye-shapes") {
	let names = QRCodeEyeShapeFactory.shared.availableGeneratorNames.joined(separator: " ")
	Swift.print(names)
	QRCodeGen.exit()
}

if args.contains("--all-pixel-shapes") {
	let names = QRCodePixelShapeFactory.shared.availableGeneratorNames.joined(separator: " ")
	Swift.print(names)
	QRCodeGen.exit()
}

if args.contains("--all-pupil-shapes") {
	let names = QRCodePupilShapeFactory.shared.availableGeneratorNames.joined(separator: " ")
	Swift.print(names)
	QRCodeGen.exit()
}

let command = QRCodeGen.parseOrExit(args)
do {
	try command.run()
}
catch {
	QRCodeGen.exit(withError: error)
}

#endif
