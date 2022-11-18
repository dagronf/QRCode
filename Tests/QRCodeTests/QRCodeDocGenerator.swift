import XCTest

import AppKit

#if !os(watchOS)

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

final class QRCodeDocGeneratorTests: XCTestCase {
	func disabled_testGeneration() throws {

		let settings: [String: Any] = [
			QRCode.SettingsKey.cornerRadiusFraction: 0.8,
			QRCode.SettingsKey.insetFraction: 0.1,
			QRCode.SettingsKey.hasInnerCorners: true
		]

		NSWorkspace.shared.activateFileViewerSelecting([__genFolder])

		let imagesFolder = __genFolder.appendingPathComponent("images")
		try! FileManager.default.createDirectory(at: imagesFolder, withIntermediateDirectories: true)

		var markdownText = ""

		let text = "QR Code generation test for the QRCode library"
		do {
			let doc = QRCode.Document(utf8String: text, errorCorrection: .high)

			markdownText += "## Pixel Shapes (CoreImage)\n\n"
			markdownText += "|       |   L   |   M   |   Q   |   H   |  SVG  |\n"
			markdownText += "|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|\n"

			let names = QRCodePixelShapeFactory.shared.availableGeneratorNames.sorted()
			for name in names {
				markdownText += "|\(name)|"
				let generator = QRCodePixelShapeFactory.shared.named(name, settings: settings)!
				for enc in QRCode.ErrorCorrection.allCases {
					doc.errorCorrection = enc
					doc.design.shape.onPixels = generator

					let cgImage = try XCTUnwrap(doc.cgImage(dimension: 600))
					let fs = QRCode.DetectQRCodes(cgImage)
					let detected = fs.count == 1 && fs[0].messageString == text
					let detect = detected ? "✅" : "❌"
					let name = "pixelint - \(name) - \(enc.ECLevel).png"
					try cgImage.pngRepresentation()!.write(to: imagesFolder.appendingPathComponent(name))
					markdownText += "<a href=\"./images/\(name)\"><img src=\"./images/\(name)\" width=\"125\" /></a><br/>\(detect)|"
				}

				do {
					let svgImage = doc.svg(dimension: 600)
					let filename = "pixelint - \(name).svg"
					try svgImage.write(to: imagesFolder.appendingPathComponent(filename), atomically: true, encoding: .utf8)
					markdownText += "<a href=\"./images/\(filename)\"><img src=\"./images/\(filename)\" width=\"125\" /></a><br/>⚖️|"
				}

				markdownText += "\n"
			}
			markdownText += "\n"
		}

		do {
			let doc = QRCode.Document(utf8String: text, errorCorrection: .high, generator: QRCodeGenerator_External())

			markdownText += "## Pixel Shapes (3rd party Generator)\n\n"
			markdownText += "|       |   L   |   M   |   Q   |   H   |  SVG  |\n"
			markdownText += "|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|\n"

			let names = QRCodePixelShapeFactory.shared.availableGeneratorNames.sorted()
			for name in names {
				markdownText += "|\(name)|"
				let generator = QRCodePixelShapeFactory.shared.named(name, settings: settings)!
				for enc in QRCode.ErrorCorrection.allCases {
					doc.errorCorrection = enc
					doc.design.shape.onPixels = generator

					let cgImage = try XCTUnwrap(doc.cgImage(dimension: 600))
					let fs = QRCode.DetectQRCodes(cgImage)
					let detected = fs.count == 1 && fs[0].messageString == text
					let detect = detected ? "✅" : "❌"
					let name = "pixelext - \(name) - \(enc.ECLevel).png"
					try cgImage.pngRepresentation()!.write(to: imagesFolder.appendingPathComponent(name))
					markdownText += "<a href=\"./images/\(name)\"><img src=\"./images/\(name)\" width=\"125\" /></a><br/>\(detect)|"
				}
				do {
					let svgImage = doc.svg(dimension: 600)
					let filename = "pixelext - \(name).svg"
					try svgImage.write(to: imagesFolder.appendingPathComponent(filename), atomically: true, encoding: .utf8)
					markdownText += "<a href=\"./images/\(filename)\"><img src=\"./images/\(filename)\" width=\"125\" /></a><br/>⚖️|"
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

			markdownText += "## Eye Shapes\n\n"
			markdownText += "|      |      |      |      |\n"
			markdownText += "|:----:|:----:|:----:|:----:|\n"

			let names = QRCodeEyeShapeFactory.shared.availableGeneratorNames.sorted()
			for name in names {

				markdownText += "| \(name) |"

				let generator = QRCodePupilShapeFactory.shared.named(name)!
				doc.design.shape.pupil = generator

				do {
					let cgImage = try XCTUnwrap(doc.cgImage(dimension: 600))
					let fs = QRCode.DetectQRCodes(cgImage)
					let detected = fs.count == 1 && fs[0].messageString == "QR Code generation test"
					let detect = detected ? "✅" : "❌"

					let filename = "eye - \(name).png"
					let content = try XCTUnwrap(cgImage.pngRepresentation())
					try content.write(to: imagesFolder.appendingPathComponent(filename))
					markdownText += "<a href=\"./images/\(filename)\"><img src=\"./images/\(filename)\" width=\"125\" /></a><br/>png \(detect)|"
				}

				do {
					let filename = "eye - \(name).svg"
					let svg = doc.svg(dimension: 600)
					try svg.write(to: imagesFolder.appendingPathComponent(filename), atomically: false, encoding: .utf8)
					markdownText += "<a href=\"./images/\(filename)\"><img src=\"./images/\(filename)\" width=\"125\" /></a><br/>svg|"
				}

				do {
					let filename = "eye - \(name).pdf"
					let pdf = try XCTUnwrap(doc.pdfData(dimension: 600))
					try pdf.write(to: imagesFolder.appendingPathComponent(filename))
					markdownText += "<a href=\"./images/\(filename)\"><img src=\"./images/\(filename)\" width=\"125\" /></a><br/>pdf|"
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

			markdownText += "## Pupil Shapes\n\n"
			markdownText += "|       |        |        |        |\n"
			markdownText += "|:------|:------:|:------:|:------:|\n"

			let names = QRCodePupilShapeFactory.shared.availableGeneratorNames
			for name in names {

				markdownText += "| \(name) |"

				let generator = QRCodePupilShapeFactory.shared.named(name)!
				doc.design.shape.pupil = generator

				do {
					let cgImage = try XCTUnwrap(doc.cgImage(dimension: 600))
					let fs = QRCode.DetectQRCodes(cgImage)
					let detected = fs.count == 1 && fs[0].messageString == "QR Code generation test"
					let detect = detected ? "✅" : "❌"

					let filename = "pupil - \(name).png"
					let content = try XCTUnwrap(cgImage.pngRepresentation())
					try content.write(to: imagesFolder.appendingPathComponent(filename))
					markdownText += "<a href=\"./images/\(filename)\"><img src=\"./images/\(filename)\" width=\"125\" /></a><br/>png \(detect)|"
				}

				do {
					let filename = "pupil - \(name).svg"
					let svg = doc.svg(dimension: 600)
					try svg.write(to: imagesFolder.appendingPathComponent(filename), atomically: false, encoding: .utf8)
					markdownText += "<a href=\"./images/\(filename)\"><img src=\"./images/\(filename)\" width=\"125\" /></a><br/>svg|"
				}

				do {
					let filename = "pupil - \(name).pdf"
					let pdf = try XCTUnwrap(doc.pdfData(dimension: 600))
					try pdf.write(to: imagesFolder.appendingPathComponent(filename))
					markdownText += "<a href=\"./images/\(filename)\"><img src=\"./images/\(filename)\" width=\"125\" /></a><br/>pdf|"
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
				let cgImage = try XCTUnwrap(doc.cgImage(dimension: 600))
				let content = try XCTUnwrap(cgImage.pngRepresentation())
				let filename = "fillstyle-solid-\(item.offset).png"
				try content.write(to: imagesFolder.appendingPathComponent(filename))
				markdownText += "<a href=\"./images/\(filename)\"><img src=\"./images/\(filename)\" width=\"125\" /></a>|"
			}
			markdownText += "\n"

			markdownText += " svg |"
			for item in styles.enumerated() {
				doc.design.style.setForegroundStyle(item.element)
				let svgImage = doc.svg(dimension: 600)
				let filename = "fillstyle-solid-\(item.offset).svg"
				try svgImage.write(to: imagesFolder.appendingPathComponent(filename), atomically: true, encoding: .utf8)
				markdownText += "<a href=\"./images/\(filename)\"><img src=\"./images/\(filename)\" width=\"125\" /></a>|"
			}
			markdownText += "\n"

			markdownText += " pdf |"
			for item in styles.enumerated() {
				doc.design.style.setForegroundStyle(item.element)
				let image = try XCTUnwrap(doc.pdfData(dimension: 600))
				let filename = "fillstyle-solid-\(item.offset).pdf"
				try image.write(to: imagesFolder.appendingPathComponent(filename))
				markdownText += "<a href=\"./images/\(filename)\"><img src=\"./images/\(filename)\" width=\"125\" /></a>|"
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
				let cgImage1 = try XCTUnwrap(doc.cgImage(dimension: 600))
				let content1 = try XCTUnwrap(cgImage1.pngRepresentation())
				let filename1 = "fillstyle-linear-\(item.offset).png"
				try content1.write(to: imagesFolder.appendingPathComponent(filename1))
				markdownText += "<a href=\"./images/\(filename1)\"><img src=\"./images/\(filename1)\" width=\"125\" /></a>|"
			}

			markdownText += "\n"

			markdownText += " svg |"
			for item in items.enumerated() {
				doc.design.style.setForegroundStyle(item.element)
				let svgImage = doc.svg(dimension: 600)
				let filename = "fillstyle-linear-\(item.offset).svg"
				try svgImage.write(to: imagesFolder.appendingPathComponent(filename), atomically: true, encoding: .utf8)
				markdownText += "<a href=\"./images/\(filename)\"><img src=\"./images/\(filename)\" width=\"125\" /></a>|"
			}

			markdownText += "\n"

			markdownText += " pdf |"
			for item in items.enumerated() {
				doc.design.style.setForegroundStyle(item.element)
				let image = try XCTUnwrap(doc.pdfData(dimension: 600))
				let filename = "fillstyle-linear-\(item.offset).pdf"
				try image.write(to: imagesFolder.appendingPathComponent(filename))
				markdownText += "<a href=\"./images/\(filename)\"><img src=\"./images/\(filename)\" width=\"125\" /></a>|"
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

			markdownText += "|        |        |        |        |        |        |\n"
			markdownText += "|:------:|:------:|:------:|:------:|:------:|:------:|\n"

			markdownText += "|"

			let gradient = DSFGradient(
				pins: [
					DSFGradient.Pin(CGColor(red: 1, green: 0, blue: 0, alpha: 1), 0.1),
					DSFGradient.Pin(CGColor(red: 0, green: 1, blue: 0, alpha: 1), 0.5),
					DSFGradient.Pin(CGColor(red: 0, green: 0, blue: 1, alpha: 1), 0.9),
				]
			)!

			let items = [
				QRCode.FillStyle.RadialGradient(gradient),
				QRCode.FillStyle.RadialGradient(gradient, centerPoint: CGPoint(x: 0.1, y: 0.1)),
				QRCode.FillStyle.RadialGradient(gradient, centerPoint: CGPoint(x: 0.9, y: 0.9)),
				QRCode.FillStyle.RadialGradient(gradient, centerPoint: CGPoint(x: 0.9, y: 0.1)),
				QRCode.FillStyle.RadialGradient(gradient, centerPoint: CGPoint(x: 0.1, y: 0.9)),
			]

			markdownText += " png |"
			for item in items.enumerated() {
				doc.design.style.setForegroundStyle(item.element)
				let image = try XCTUnwrap(doc.cgImage(dimension: 600))
				let content = try XCTUnwrap(image.pngRepresentation())
				let filename = "fillstyle-radial-\(item.offset).png"
				try content.write(to: imagesFolder.appendingPathComponent(filename))
				markdownText += "<a href=\"./images/\(filename)\"><img src=\"./images/\(filename)\" width=\"125\" /></a>|"
			}
			markdownText += "\n"

			markdownText += " svg |"
			for item in items.enumerated() {
				doc.design.style.setForegroundStyle(item.element)
				let svgcontent = doc.svg(dimension: 600)
				let filename = "fillstyle-radial-\(item.offset).svg"
				try svgcontent.write(to: imagesFolder.appendingPathComponent(filename), atomically: true, encoding: .utf8)
				markdownText += "<a href=\"./images/\(filename)\"><img src=\"./images/\(filename)\" width=\"125\" /></a>|"
			}
			markdownText += "\n"

			markdownText += " pdf |"
			for item in items.enumerated() {
				doc.design.style.setForegroundStyle(item.element)
				let image = try XCTUnwrap(doc.pdfData(dimension: 600))
				let filename = "fillstyle-radial-\(item.offset).pdf"
				try image.write(to: imagesFolder.appendingPathComponent(filename))
				markdownText += "<a href=\"./images/\(filename)\"><img src=\"./images/\(filename)\" width=\"125\" /></a>|"
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
				let image = try XCTUnwrap(doc.cgImage(dimension: 600))
				let content = try XCTUnwrap(image.pngRepresentation())
				let filename = "logo-\(item.offset).png"
				try content.write(to: imagesFolder.appendingPathComponent(filename))
				markdownText += "<a href=\"./images/\(filename)\"><img src=\"./images/\(filename)\" width=\"125\" /></a>|"
			}
			markdownText += "\n"

			markdownText += "| svg |"
			for item in items.enumerated() {
				doc.logoTemplate = item.element
				let svgcontent = doc.svg(dimension: 600)
				let filename = "logo-\(item.offset).svg"
				try svgcontent.write(to: imagesFolder.appendingPathComponent(filename), atomically: true, encoding: .utf8)
				markdownText += "<a href=\"./images/\(filename)\"><img src=\"./images/\(filename)\" width=\"125\" /></a>|"
			}
			markdownText += "\n"

			markdownText += " pdf |"

			for item in items.enumerated() {
				doc.logoTemplate = item.element
				let image = try XCTUnwrap(doc.pdfData(dimension: 600))
				let filename = "logo-\(item.offset).pdf"
				try image.write(to: imagesFolder.appendingPathComponent(filename))
				markdownText += "<a href=\"./images/\(filename)\"><img src=\"./images/\(filename)\" width=\"125\" /></a>|"
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
				let image = NSImage(size: CGSize(dimension: 600), flipped: true) { rect in
					let ctx = NSGraphicsContext.current!.cgContext

					ctx.saveGState()
					ctx.setFillColor(CGColor(gray: 0, alpha: 0.05))
					ctx.fill([rect])
					ctx.setStrokeColor(CGColor(gray: 0, alpha: 0.8))
					ctx.setLineWidth(0.5)
					ctx.stroke(rect)
					ctx.restoreGState()

					for item in items {
						let path = doc.path(dimension: 600, components: item.0)
						ctx.addPath(path)
						ctx.setFillColor(item.2.cgColor)
						ctx.fillPath()
					}

					return true
				}
				let filename = "components-all.png"
				try image.pngRepresentation()!.write(to: imagesFolder.appendingPathComponent(filename))
				markdownText += "<a href=\"./images/\(filename)\"><img src=\"./images/\(filename)\" width=\"125\" /></a><br/>|"
			}

			// Now each individually

			for item in items.enumerated() {
				let path = doc.path(dimension: 600, components: item.element.0)
				let image = NSImage(size: CGSize(dimension: 600), flipped: true) { rect in
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
				let filename = "components-\(item.offset).png"
				try image.pngRepresentation()!.write(to: imagesFolder.appendingPathComponent(filename))
				markdownText += "<a href=\"./images/\(filename)\"><img src=\"./images/\(filename)\" width=\"125\" /></a>|"
			}
		}
		markdownText += "\n"

		// Write out the markdown

		let mdt = __genFolder.appendingPathComponent("styles.md")
		try markdownText.write(to: mdt, atomically: true, encoding: .utf8)
	}
}

#endif
