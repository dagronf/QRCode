import XCTest

#if os(macOS)

import AppKit

@testable import QRCode
@testable import QRCodeExternal

let __genFolder: URL = {
	let u = FileManager.default
		.temporaryDirectory
		.appendingPathComponent("qrcodeTests")
		.appendingPathComponent("generated")

	try? FileManager.default.removeItem(at: u)
	try! FileManager.default.createDirectory(at: u, withIntermediateDirectories: true)
	Swift.print("Generated files at: \(u)")
	return u
}()

class ImageOutput {

	let _imagesFolder = __genFolder.appendingPathComponent("images")

	init() {
		try! FileManager.default.createDirectory(at: _imagesFolder, withIntermediateDirectories: true)
	}

	func store(_ data: Data, filename: String) throws -> String {
		try data.write(to: _imagesFolder.appendingPathComponent(filename))
		return "./images/\(filename)"
	}

	func store(_ string: String, filename: String) throws -> String {
		try string.write(to: _imagesFolder.appendingPathComponent(filename), atomically: false, encoding: .utf8)
		return "./images/\(filename)"
	}
}


final class QRCodeDocGeneratorTests: XCTestCase {

	// Generate a markdown document with generated test images
	//func disabled_testGeneration() throws {
	func testGeneration() throws {

		let settings: [String: Any] = [
			QRCode.SettingsKey.cornerRadiusFraction: 0.8,
			QRCode.SettingsKey.insetFraction: 0.1,
			QRCode.SettingsKey.hasInnerCorners: true
		]

		// The dimension for all the generated images
		let dimension: Int = 400

		NSWorkspace.shared.activateFileViewerSelecting([__genFolder])

		let imageStore = ImageOutput()

		var markdownText = ""

		let text = "QR Code generation test for the QRCode library"
		do {
			let doc = QRCode.Document(utf8String: text, errorCorrection: .high)

			markdownText += "## Pixel Shapes (CoreImage)\n\n"

			markdownText += "|       |   L   |   M   |   Q   |   H   |  SVG  |  neg  |\n"
			markdownText += "|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|\n"

			doc.design.style.onPixels = QRCode.FillStyle.Solid(0.6, 0, 0)
			doc.design.style.eye = QRCode.FillStyle.Solid(0, 0, 0)

			let names = QRCodePixelShapeFactory.shared.availableGeneratorNames.sorted()
			for name in names {
				doc.design.shape.negatedOnPixelsOnly = false
				markdownText += "|\(name)|"
				let generator = QRCodePixelShapeFactory.shared.named(name, settings: settings)!
				for enc in QRCode.ErrorCorrection.allCases {
					doc.errorCorrection = enc
					doc.design.shape.onPixels = generator

					let cgImage = try XCTUnwrap(doc.cgImage(dimension: dimension))
					let fs = QRCode.DetectQRCodes(cgImage)
					let detected = fs.count == 1 && fs[0].messageString == text
					let detect = detected ? "✅" : "❌"
					let name = "pixelint - \(name) - \(enc.ECLevel).png"
					let link = try imageStore.store(cgImage.pngRepresentation()!, filename: name)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a><br/>\(detect)|"
				}

				do {
					let svgImage = doc.svg(dimension: dimension)
					let filename = "pixelint - \(name).svg"
					let link = try imageStore.store(svgImage, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a><br/>⚖️|"
				}

				do {
					doc.design.shape.negatedOnPixelsOnly = true
					let inverted = try XCTUnwrap(doc.pdfData(dimension: dimension))
					let filename = "pixelnegated - \(name).pdf"
					let link = try imageStore.store(inverted, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a><br/>⚖️|"
				}

				markdownText += "\n"
			}
			markdownText += "\n"
		}

		do {
			let doc = QRCode.Document(utf8String: text, errorCorrection: .high, generator: QRCodeGenerator_External())
			doc.design.style.onPixels = QRCode.FillStyle.Solid(0.6, 0, 0)
			doc.design.style.eye = QRCode.FillStyle.Solid(0, 0, 0)

			markdownText += "## Pixel Shapes (3rd party Generator)\n\n"

			markdownText += "|       |   L   |   M   |   Q   |   H   |  SVG  |  neg  |\n"
			markdownText += "|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|\n"

			let names = QRCodePixelShapeFactory.shared.availableGeneratorNames.sorted()
			for name in names {
				markdownText += "|\(name)|"
				let generator = QRCodePixelShapeFactory.shared.named(name, settings: settings)!
				for enc in QRCode.ErrorCorrection.allCases {
					doc.errorCorrection = enc
					doc.design.shape.onPixels = generator
					doc.design.shape.negatedOnPixelsOnly = false

					let cgImage = try XCTUnwrap(doc.cgImage(dimension: dimension))
					let fs = QRCode.DetectQRCodes(cgImage)
					let detected = fs.count == 1 && fs[0].messageString == text
					let detect = detected ? "✅" : "❌"
					let filename = "pixelext - \(name) - \(enc.ECLevel).png"
					let link = try imageStore.store(cgImage.pngRepresentation()!, filename: filename)
					markdownText += "<a href=\"./images/\(name)\"><img src=\"\(link)\" width=\"125\" /></a><br/>\(detect)|"
				}
				do {
					let svgImage = doc.svg(dimension: dimension)
					let filename = "pixelext - \(name).svg"
					let link = try imageStore.store(svgImage, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a><br/>⚖️|"
				}
				do {
					doc.design.shape.negatedOnPixelsOnly = true
					let inverted = try XCTUnwrap(doc.pdfData(dimension: dimension))
					let filename = "pixelnegated - \(name).pdf"
					let link = try imageStore.store(inverted, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a><br/>⚖️|"
				}
				markdownText += "\n"
			}
			markdownText += "\n"
		}

		do {
			let doc = QRCode.Document(
				utf8String: "QR Code generation test",
				errorCorrection: .high
			)
			doc.design.style.onPixels = QRCode.FillStyle.Solid(gray: 0, alpha: 0.3)

			markdownText += "## Eye Shapes\n\n"
			markdownText += "|      |      |      |      |\n"
			markdownText += "|:----:|:----:|:----:|:----:|\n"

			let names = QRCodeEyeShapeFactory.shared.availableGeneratorNames.sorted()
			for name in names {

				markdownText += "| \(name) |"

				let generator = QRCodeEyeShapeFactory.shared.named(name)!
				doc.design.shape.eye = generator
				doc.design.style.eye = QRCode.FillStyle.Solid(0.6, 0, 0)

				do {
					let cgImage = try XCTUnwrap(doc.cgImage(dimension: dimension))
					let fs = QRCode.DetectQRCodes(cgImage)
					let detected = fs.count == 1 && fs[0].messageString == "QR Code generation test"
					let detect = detected ? "✅" : "❌"

					let filename = "eye - \(name).png"
					let content = try XCTUnwrap(cgImage.pngRepresentation())
					let link = try imageStore.store(content, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a><br/>png \(detect)|"
				}

				do {
					let filename = "eye - \(name).svg"
					let svgImage = doc.svg(dimension: dimension)
					let link = try imageStore.store(svgImage, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a><br/>svg|"
				}

				do {
					let filename = "eye - \(name).pdf"
					let pdf = try XCTUnwrap(doc.pdfData(dimension: dimension))
					let link = try imageStore.store(pdf, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a><br/>pdf|"
				}
				markdownText += "\n"
			}
			markdownText += "\n"
		}

		do {
			let doc = QRCode.Document(
				utf8String: "QR Code generation test",
				errorCorrection: .high
			)

			doc.design.style.onPixels = QRCode.FillStyle.Solid(gray: 0, alpha: 0.3)

			markdownText += "## Pupil Shapes\n\n"
			markdownText += "|       |        |        |        |\n"
			markdownText += "|:------|:------:|:------:|:------:|\n"

			let names = QRCodePupilShapeFactory.shared.availableGeneratorNames
			for name in names {

				markdownText += "| \(name) |"

				let generator = QRCodePupilShapeFactory.shared.named(name)!
				doc.design.shape.pupil = generator
				doc.design.style.pupil = QRCode.FillStyle.Solid(0.6, 0, 0)

				do {
					let cgImage = try XCTUnwrap(doc.cgImage(dimension: dimension))
					let fs = QRCode.DetectQRCodes(cgImage)
					let detected = fs.count == 1 && fs[0].messageString == "QR Code generation test"
					let detect = detected ? "✅" : "❌"

					let filename = "pupil - \(name).png"
					let content = try XCTUnwrap(cgImage.pngRepresentation())
					let link = try imageStore.store(content, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a><br/>png \(detect)|"
				}

				do {
					let filename = "pupil - \(name).svg"
					let svg = doc.svg(dimension: dimension)
					let link = try imageStore.store(svg, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a><br/>svg|"
				}

				do {
					let filename = "pupil - \(name).pdf"
					let pdf = try XCTUnwrap(doc.pdfData(dimension: dimension))
					let link = try imageStore.store(pdf, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a><br/>pdf|"
				}
				markdownText += "\n"
			}
			markdownText += "\n"
		}

		markdownText += "## Fill Styles\n\n"

		markdownText += "### Solid\n\n"
		do {
			let doc = QRCode.Document(
				utf8String: "QR Code generation test",
				errorCorrection: .medium
			)
			doc.design.shape.eye = QRCode.EyeShape.RoundedOuter()
			doc.design.shape.onPixels = QRCode.PixelShape.CurvePixel(cornerRadiusFraction: 1)

			let styles = [
				QRCode.FillStyle.Solid(1, 0, 0),
				QRCode.FillStyle.Solid(0, 1, 0),
				QRCode.FillStyle.Solid(0, 0, 1),
				QRCode.FillStyle.Solid(1, 1, 0)
			]

			markdownText += "|        |        |        |        |        |\n"
			markdownText += "|:-------|:------:|:------:|:------:|:------:|\n"

			markdownText += "|"

			markdownText += " png |"
			for item in styles.enumerated() {
				doc.design.style.setForegroundStyle(item.element)
				let cgImage = try XCTUnwrap(doc.cgImage(dimension: dimension))
				let content = try XCTUnwrap(cgImage.pngRepresentation())
				let filename = "fillstyle-solid-\(item.offset).png"
				let link = try imageStore.store(content, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a>|"
			}
			markdownText += "\n"

			markdownText += " svg |"
			for item in styles.enumerated() {
				doc.design.style.setForegroundStyle(item.element)
				let svgImage = doc.svg(dimension: dimension)
				let filename = "fillstyle-solid-\(item.offset).svg"
				let link = try imageStore.store(svgImage, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a>|"
			}
			markdownText += "\n"

			markdownText += " pdf |"
			for item in styles.enumerated() {
				doc.design.style.setForegroundStyle(item.element)
				let image = try XCTUnwrap(doc.pdfData(dimension: dimension))
				let filename = "fillstyle-solid-\(item.offset).pdf"
				let link = try imageStore.store(image, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a>|"
			}
			markdownText += "\n"
		}

		markdownText += "### Linear\n\n"
		do {
			let doc = QRCode.Document(
				utf8String: "QR Code generation test",
				errorCorrection: .medium
			)
			doc.design.shape.eye = QRCode.EyeShape.Leaf()
			doc.design.shape.onPixels = QRCode.PixelShape.Squircle(insetFraction: 0.1)

			markdownText += "|        |        |        |        |        |\n"
			markdownText += "|:-------|:------:|:------:|:------:|:------:|\n"

			markdownText += "|"

			let gradient = DSFGradient(
				pins: [
					DSFGradient.Pin(CGColor(red: 1, green: 0, blue: 0, alpha: 1), 0.1),
					DSFGradient.Pin(CGColor(red: 0, green: 1, blue: 0, alpha: 1), 0.5),
					DSFGradient.Pin(CGColor(red: 0, green: 0, blue: 1, alpha: 1), 0.9),
				]
			)!

			let items = [
				QRCode.FillStyle.LinearGradient(gradient),
				QRCode.FillStyle.LinearGradient(gradient, startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 0)),
				QRCode.FillStyle.LinearGradient(gradient, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 0)),
				QRCode.FillStyle.LinearGradient(gradient, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 1)),
			]

			markdownText += " png |"
			for item in items.enumerated() {
				doc.design.style.setForegroundStyle(item.element)
				let cgImage = try XCTUnwrap(doc.cgImage(dimension: dimension))
				let content = try XCTUnwrap(cgImage.pngRepresentation())
				let filename = "fillstyle-linear-\(item.offset).png"
				let link = try imageStore.store(content, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a>|"
			}

			markdownText += "\n"

			markdownText += " svg |"
			for item in items.enumerated() {
				doc.design.style.setForegroundStyle(item.element)
				let svgImage = doc.svg(dimension: dimension)
				let filename = "fillstyle-linear-\(item.offset).svg"
				let link = try imageStore.store(svgImage, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a>|"
			}

			markdownText += "\n"

			markdownText += " pdf |"
			for item in items.enumerated() {
				doc.design.style.setForegroundStyle(item.element)
				let image = try XCTUnwrap(doc.pdfData(dimension: dimension))
				let filename = "fillstyle-linear-\(item.offset).pdf"
				let link = try imageStore.store(image, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a>|"
			}

			markdownText += "\n"
		}

		markdownText += "### Radial\n\n"
		do {
			let doc = QRCode.Document(
				utf8String: "QR Code generation test",
				errorCorrection: .medium
			)
			doc.design.shape.eye = QRCode.EyeShape.BarsHorizontal()
			doc.design.shape.onPixels = QRCode.PixelShape.Vertical(insetFraction: 0.1, cornerRadiusFraction: 1)

			markdownText += "|     | (0.5,0.5) | (0,0) | (1,0) | (1,1) | (0,1) |\n"
			markdownText += "|:---:|:---------:|:-----:|:-----:|:-----:|:-----:|\n"

			markdownText += "|"

			let gradient = DSFGradient(
				pins: [
					DSFGradient.Pin(CGColor(red: 1, green: 0, blue: 0, alpha: 1), 0.1),
					DSFGradient.Pin(CGColor(red: 0, green: 1, blue: 0, alpha: 1), 0.5),
					DSFGradient.Pin(CGColor(red: 0, green: 0, blue: 1, alpha: 1), 0.9),
				]
			)!

			let items: [(String, QRCodeFillStyleGenerator)] = [
				("(0.5,0.5)", QRCode.FillStyle.RadialGradient(gradient)),
				("(0,0)", QRCode.FillStyle.RadialGradient(gradient, centerPoint: CGPoint(x: 0.1, y: 0.1))),
				("(1,0)", QRCode.FillStyle.RadialGradient(gradient, centerPoint: CGPoint(x: 0.9, y: 0.1))),
				("(1,1)", QRCode.FillStyle.RadialGradient(gradient, centerPoint: CGPoint(x: 0.9, y: 0.9))),
				("(0,1)", QRCode.FillStyle.RadialGradient(gradient, centerPoint: CGPoint(x: 0.1, y: 0.9))),
			]

			markdownText += " png |"
			for item in items.enumerated() {
				doc.design.style.setForegroundStyle(item.element.1)
				let image = try XCTUnwrap(doc.cgImage(dimension: dimension))
				let content = try XCTUnwrap(image.pngRepresentation())
				let filename = "fillstyle-radial-\(item.offset)-\(item.element.0).png"
				let link = try imageStore.store(content, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a>|"
			}
			markdownText += "\n"

			markdownText += " svg |"
			for item in items.enumerated() {
				doc.design.style.setForegroundStyle(item.element.1)
				let svgcontent = doc.svg(dimension: dimension)
				let filename = "fillstyle-radial-\(item.offset)-\(item.element.0).svg"
				let link = try imageStore.store(svgcontent, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a>|"
			}
			markdownText += "\n"

			markdownText += " pdf |"
			for item in items.enumerated() {
				doc.design.style.setForegroundStyle(item.element.1)
				let image = try XCTUnwrap(doc.pdfData(dimension: dimension))
				let filename = "fillstyle-radial-\(item.offset)-\(item.element.0).pdf"
				let link = try imageStore.store(image, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a>|"
			}
			markdownText += "\n"
		}

		markdownText += "## Logo\n\n"
		do {
			let doc = QRCode.Document(
				utf8String: "QR Code generation test with a lot of content to display!",
				errorCorrection: .high
			)

			let logoURL = try XCTUnwrap(Bundle.module.url(forResource: "instagram-icon", withExtension: "png"))
			let logoImage = try XCTUnwrap(CommonImage(contentsOfFile: logoURL.path)?.cgImage())

			let logoURL1 = try XCTUnwrap(Bundle.module.url(forResource: "square-logo", withExtension: "png"))
			let logoImage1 = try XCTUnwrap(CommonImage(contentsOfFile: logoURL1.path)?.cgImage())

			let logoURL2 = try XCTUnwrap(Bundle.module.url(forResource: "apple", withExtension: "png"))
			let logoImage2 = try XCTUnwrap(CommonImage(contentsOfFile: logoURL2.path))

			let items = [
				QRCode.LogoTemplate.CircleCenter(image: logoImage, inset: 8),
				QRCode.LogoTemplate.CircleBottomRight(image: logoImage, inset: 8),
				QRCode.LogoTemplate.SquareCenter(image: logoImage1, inset: 8),
				QRCode.LogoTemplate.SquareBottomRight(image: logoImage1, inset: 8),
				QRCode.LogoTemplate(
					path: CGPath(rect: CGRect(x: 0.40, y: 0.365, width: 0.55, height: 0.25), transform: nil),
					inset: 8,
					image: logoImage2.cgImage()
				)
			]

			markdownText += "|        |        |        |        |        |        |\n"
			markdownText += "|:------:|:------:|:------:|:------:|:------:|:------:|\n"

			markdownText += "| png |"
			for item in items.enumerated() {
				doc.logoTemplate = item.element
				let image = try XCTUnwrap(doc.cgImage(dimension: dimension))
				let content = try XCTUnwrap(image.pngRepresentation())
				let filename = "logo-\(item.offset).png"
				let link = try imageStore.store(content, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a>|"
			}
			markdownText += "\n"

			markdownText += "| svg |"
			for item in items.enumerated() {
				doc.logoTemplate = item.element
				let svgcontent = doc.svg(dimension: dimension)
				let filename = "logo-\(item.offset).svg"
				let link = try imageStore.store(svgcontent, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a>|"
			}
			markdownText += "\n"

			markdownText += " pdf |"

			for item in items.enumerated() {
				doc.logoTemplate = item.element
				let image = try XCTUnwrap(doc.pdfData(dimension: dimension))
				let filename = "logo-\(item.offset).pdf"
				let link = try imageStore.store(image, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a>|"
			}
		}
		markdownText += "\n"

		// Components

		do {
			markdownText += "## Component paths\n\n"

			markdownText += "| all | on pixels | off pixels | eye background | eye outer | eye pupil |\n"
			markdownText += "|:------:|:------:|:------:|:------:|:------:|:------:|\n"

			let doc = QRCode.Document(
				utf8String: "QR Code generation test with a lot of content to display!",
				errorCorrection: .high
			)

			let items = [
				(QRCode.Components.onPixels, "onPixels", NSColor(calibratedHue: 0.6, saturation: 1, brightness: 1, alpha: 1)),
				(QRCode.Components.offPixels, "offPixels", NSColor(calibratedHue: 0.8, saturation: 1, brightness: 1, alpha: 1)),
				(QRCode.Components.eyeBackground, "eyeBackground", NSColor(calibratedHue: 0, saturation: 1, brightness: 0, alpha: 1)),
				(QRCode.Components.eyeOuter, "eyeOuter", NSColor(calibratedHue: 0.0, saturation: 1, brightness: 1, alpha: 1)),
				(QRCode.Components.eyePupil, "eyePupil", NSColor(calibratedHue: 0.4, saturation: 1, brightness: 1, alpha: 1)),
			]

			// Do all first

			do {
				let image = NSImage(size: CGSize(dimension: dimension), flipped: true) { rect in
					let ctx = NSGraphicsContext.current!.cgContext

					ctx.saveGState()
					ctx.setFillColor(CGColor(gray: 0, alpha: 0.05))
					ctx.fill([rect])
					ctx.setStrokeColor(CGColor(gray: 0, alpha: 0.8))
					ctx.setLineWidth(0.5)
					ctx.stroke(rect)
					ctx.restoreGState()

					for item in items {
						let path = doc.path(dimension: dimension, components: item.0)
						ctx.addPath(path)
						ctx.setFillColor(item.2.cgColor)
						ctx.fillPath()
					}
					return true
				}

				let content = try XCTUnwrap(image.pngRepresentation())
				let filename = "components-all.png"
				let link = try imageStore.store(content, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a><br/>|"
			}

			// Now each individually

			for item in items.enumerated() {
				let path = doc.path(dimension: dimension, components: item.element.0)
				let image = NSImage(size: CGSize(dimension: dimension), flipped: true) { rect in
					let ctx = NSGraphicsContext.current!.cgContext

					ctx.saveGState()
					ctx.setFillColor(CGColor(gray: 0, alpha: 0.05))
					ctx.fill([rect])
					ctx.setStrokeColor(CGColor(gray: 0, alpha: 0.8))
					ctx.setLineWidth(0.5)
					ctx.stroke(rect)
					ctx.restoreGState()

					ctx.addPath(path)
					ctx.setFillColor(item.element.2.cgColor)
					ctx.fillPath()
					return true
				}

				let content = try XCTUnwrap(image.pngRepresentation())
				let filename = "components-\(item.offset).png"
				let link = try imageStore.store(content, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a>|"
			}
		}
		markdownText += "\n"

		// On path, off path check

		do {
			let doc = QRCode.Document(utf8String: "Checking on/off paths", errorCorrection: .low)

			markdownText += "## On path/Off Path\n\n"

			markdownText += "|       |  on/off  |  on  |  off  |\n"
			markdownText += "|:-----:|:-----:|:-----:|:-----:|\n"

			let items = [
				("on/off", [QRCode.Components.onPixels, QRCode.Components.offPixels]),
				("on", QRCode.Components.onPixels),
				("on", QRCode.Components.offPixels),
			]

			let names = QRCodePixelShapeFactory.shared.availableGeneratorNames.sorted()
			for name in names {

				let generator = QRCodePixelShapeFactory.shared.named(name, settings: settings)!
				doc.design.shape.onPixels = generator
				doc.design.shape.offPixels = generator

				markdownText += "|\(name)|"

				for item in items.enumerated() {
					let image = NSImage(size: CGSize(dimension: dimension), flipped: true) { rect in
						let ctx = NSGraphicsContext.current!.cgContext
						ctx.saveGState()
						ctx.setFillColor(CGColor(gray: 0, alpha: 0.05))
						ctx.fill([rect])
						ctx.setStrokeColor(CGColor(gray: 0, alpha: 0.8))
						ctx.setLineWidth(0.5)
						ctx.stroke(rect)
						ctx.restoreGState()

						if item.element.1.contains(QRCode.Components.onPixels) {
							ctx.saveGState()
							let path = doc.path(dimension: dimension, components: .onPixels)
							ctx.addPath(path)
							ctx.setFillColor(CGColor(red: 0.8, green: 0, blue: 0, alpha: 1))
							ctx.fillPath()
							ctx.restoreGState()
						}

						if item.element.1.contains(QRCode.Components.offPixels) {
							ctx.saveGState()
							let path = doc.path(dimension: dimension, components: .offPixels)
							ctx.addPath(path)
							ctx.setFillColor(CGColor(red: 0, green: 0, blue: 0.8, alpha: 1))
							ctx.fillPath()
							ctx.restoreGState()
						}

						ctx.saveGState()
						let path = doc.path(dimension: dimension, components: .eyeAll)
						ctx.addPath(path)
						ctx.setFillColor(CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1))
						ctx.fillPath()
						ctx.restoreGState()

						return true
					}

					let content = try XCTUnwrap(image.pngRepresentation())
					let filename = "onpathcheck-\(name)-\(item.offset).png"
					let link = try imageStore.store(content, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a>|"
				}
				markdownText += "\n"
			}
			markdownText += "\n"
		}

		markdownText += "## Style export equivalence checks \n\n"

		do {
			let exporters: [QRCode.Document.ExportType] = [.png(), .pdf(), .svg]
			let sampleDocs: [(String, QRCode.Document)] = [
				{
					let doc = QRCode.Document(utf8String: "QRCode stylish design - Blue wavy", errorCorrection: .medium)
					doc.design.shape.eye = QRCode.EyeShape.RoundedRect()
					doc.design.shape.onPixels = QRCode.PixelShape.RoundedPath(cornerRadiusFraction: 1, hasInnerCorners: true)
					doc.design.style.onPixels = QRCode.FillStyle.LinearGradient(
						DSFGradient(pins: [
							DSFGradient.Pin(CGColor(red:0, green:0.589, blue:1, alpha:1), 0),
							DSFGradient.Pin(CGColor(red:0.016, green:0.198, blue:1, alpha:1), 1),
						])!
					)
					doc.design.shape.offPixels = QRCode.PixelShape.Circle(insetFraction: 0.1)
					doc.design.style.offPixels = QRCode.FillStyle.Solid(0, 0, 0, alpha: 0.1)
					return ("design-funky-blue", doc)
				}(),
				// -------------------
				{
					let doc = QRCode.Document(utf8String: "QRCode stylish design - Speck highlights", errorCorrection: .quantize)
					doc.design.style.background = QRCode.FillStyle.Solid(0.937, 0.714, 0.502)
					doc.design.shape.eye = QRCode.EyeShape.RoundedOuter()
					doc.design.style.eyeBackground = CGColor.white
					doc.design.shape.onPixels = QRCode.PixelShape.Square(insetFraction: 0.3)
					doc.design.style.onPixels = QRCode.FillStyle.Solid(gray: 0.0)
					doc.design.style.onPixelsBackground = CGColor(gray: 0, alpha: 0.2)
					doc.design.shape.offPixels = QRCode.PixelShape.Square(insetFraction: 0.75)
					doc.design.style.offPixels = QRCode.FillStyle.Solid(gray: 1.0)
					doc.design.style.offPixelsBackground = CGColor(gray: 1, alpha: 0.1)
					return ("design-speck", doc)
				}(),
				// -------------------
				{
					let msg = QRCode.Message.Link(URL(string: "https://github.com/dagronf/QRCode")!)
					let doc = QRCode.Document(message: msg, errorCorrection: .quantize)
					doc.design.style.background = QRCode.FillStyle.Solid(.clear)
					doc.design.shape.onPixels = QRCode.PixelShape.RoundedRect(insetFraction: 0.1, cornerRadiusFraction: 0.5)
					doc.design.shape.eye = QRCode.EyeShape.RoundedRect()
					doc.design.style.setForegroundStyle(
						QRCode.FillStyle.LinearGradient(
							DSFGradient(pins: [
								DSFGradient.Pin(CGColor(red:0.556, green:0.979, blue:0, alpha:1), 0),
								DSFGradient.Pin(CGColor(red:0.016, green:0.444, blue:0.018, alpha:1), 1),
							])!,
							startPoint: CGPoint(x: 0, y: 0),
							endPoint: CGPoint(x: 0.5, y: 1)
						)
					)
					doc.design.style.eye = QRCode.FillStyle.Solid(0.116, 0.544, 0.118)
					doc.design.style.pupil = QRCode.FillStyle.Solid(0.556, 0.979, 0)
					return ("design-github", doc)
				}(),
				// -------------------
				{
					let doc = QRCode.Document(utf8String: "QRCode stylish design - landscape", errorCorrection: .quantize)
					doc.design.shape.onPixels = QRCode.PixelShape.Vertical(insetFraction: 0.1, cornerRadiusFraction: 1)
					doc.design.style.setForegroundStyle(
						QRCode.FillStyle.LinearGradient(
							DSFGradient(pins: [
								DSFGradient.Pin(CGColor(red:0.004, green:0.096, blue:0.574, alpha:1), 0),
								DSFGradient.Pin(CGColor(red:0, green:0.903, blue:0.997, alpha:1), 0.55),
								DSFGradient.Pin(CGColor(red:0, green:0.154, blue:0, alpha:1), 0.556),
								DSFGradient.Pin(CGColor(red:0, green:0.586, blue:0, alpha:1), 1),
							])!,
							startPoint: CGPoint(x: 0, y: 0),
							endPoint: CGPoint(x: 0, y: 1)
						)
					)
					doc.design.shape.offPixels = QRCode.PixelShape.Vertical(insetFraction: 0.8, cornerRadiusFraction: 1)
					doc.design.style.offPixels = QRCode.FillStyle.Solid(gray: 0, alpha: 0.1)
					return ("design-landscape", doc)
				}(),
				// -------------------
				{
					let doc = QRCode.Document(utf8String: "QRCode stylish design - radial sepia", errorCorrection: .medium)
					doc.design.foregroundStyle(QRCode.FillStyle.Solid(CGColor(red:0.356, green:0.209, blue:0.014, alpha:1)))
					doc.design.shape.onPixels = QRCode.PixelShape.Square(insetFraction: 0.05)
					doc.design.shape.eye = QRCode.EyeShape.RoundedPointingIn()
					doc.design.style.background = QRCode.FillStyle.RadialGradient(
						DSFGradient(pins: [
							DSFGradient.Pin(CGColor(red:0.999, green:1, blue:1, alpha:1), 0),
							DSFGradient.Pin(CGColor(red:0.907, green:0.765, blue:0.428, alpha:1), 1),
						])!
					)
					return ("design-radialsepia", doc)
				}(),
				// -------------------
				try {
					let doc = QRCode.Document(utf8String: "QRCode stylish design - bottom right corner masking", errorCorrection: .high)

					let logoURL = try XCTUnwrap(Bundle.module.url(forResource: "corner-heart", withExtension: "png"))
					let logoImage = try XCTUnwrap(CommonImage(contentsOfFile: logoURL.path)?.cgImage())

					doc.design.backgroundColor(.black)
					doc.design.foregroundStyle(
						QRCode.FillStyle.LinearGradient(
							DSFGradient(pins: [
								DSFGradient.Pin(CGColor(red:1, green:0.149, blue:0, alpha:1), 0),
								DSFGradient.Pin(CGColor(red:1, green:0.578, blue:0, alpha:1), 0.2),
								DSFGradient.Pin(CGColor(red:0.999, green:0.985, blue:0, alpha:1), 0.4),
								DSFGradient.Pin(CGColor(red:0, green:0.976, blue:0, alpha:1), 0.6),
								DSFGradient.Pin(CGColor(red:0.016, green:0.198, blue:1, alpha:1), 0.8),
								DSFGradient.Pin(CGColor(red:0.581, green:0.215, blue:1, alpha:1), 1),
							])!,
							startPoint: CGPoint(x: 0, y: 0),
							endPoint: CGPoint(x: 1, y: 0)
						)
					)

					let path = CGMutablePath()
					path.move(to: CGPoint(x: 1, y: 1))
					path.line(to: CGPoint(x: 0.5, y: 1))
					path.line(to: CGPoint(x: 1, y: 0.5))
					path.line(to: CGPoint(x: 1, y: 1))
					path.close()
					doc.logoTemplate = QRCode.LogoTemplate(path: path, inset: 0, image: logoImage)
					return ("design-bottomright-masked", doc)
				}(),
				// -------------------
				{
					let doc = QRCode.Document(utf8String: "QRCode drawing only the 'off' pixels of the qr code", errorCorrection: .high)
					doc.design.shape.onPixels = QRCode.PixelShape.Circle(insetFraction: 0.05)
					doc.design.shape.negatedOnPixelsOnly = true
					doc.design.style.background = QRCode.FillStyle.Solid(gray: 0)
					doc.design.foregroundStyle(QRCode.FillStyle.Solid(gray: 1))
					return ("design-negated", doc)
				}(),
				// -------------------
				try {
					let logoURL = try XCTUnwrap(Bundle.module.url(forResource: "instagram-icon", withExtension: "png"))
					let logoImage = try XCTUnwrap(CommonImage(contentsOfFile: logoURL.path)?.cgImage())

					let doc = QRCode.Document(utf8String: "QRCode drawing only the 'off' pixels of the qr code using fancy path", errorCorrection: .high)
					doc.design.shape.onPixels = QRCode.PixelShape.CurvePixel(cornerRadiusFraction: 0.8)
					doc.design.shape.negatedOnPixelsOnly = true
					doc.design.style.background = QRCode.FillStyle.Solid(0.999, 0.988, 0.472, alpha:1)
					doc.design.foregroundStyle(QRCode.FillStyle.Solid(0.087, 0.015, 0.356, alpha:1))
					doc.logoTemplate = QRCode.LogoTemplate(
						path: CGPath(ellipseIn: CGRect(x: 0.7, y: 0.7, width: 0.28, height: 0.28), transform: nil),
						image: logoImage
					)
					return ("design-negated-with-path", doc)
				}()
			]

			markdownText += "\n\n"
			for doc in sampleDocs {
				markdownText += "### \(doc.1.utf8String ?? "<none>") \n\n"
				markdownText += "|  png  |  pdf  |  svg  |\n"
				markdownText += "|:-----:|:-----:|:-----:|\n"

				for item in exporters {
					let data = try XCTUnwrap(doc.1.imageData(item, dimension: dimension))
					let filename = "\(doc.0).\(item.fileExtension)"
					let link = try imageStore.store(data, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a> |"
				}
				markdownText += "\n\n"
			}
		}

		// Write out the markdown

		let mdt = __genFolder.appendingPathComponent("styles.md")
		try markdownText.write(to: mdt, atomically: false, encoding: .utf8)
	}
}



#endif
