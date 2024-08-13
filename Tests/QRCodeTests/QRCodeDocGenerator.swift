import XCTest

@testable import QRCode

class ImageOutput {

	let _imagesFolder: TestFilesContainer.Subfolder

	init(_ folder: TestFilesContainer.Subfolder) {
		_imagesFolder = folder
	}

	func store(_ data: Data, filename: String) throws -> String {
		try _imagesFolder.write(data, to: filename)
		return "./images/\(filename)"
	}

	func store(_ string: String, filename: String) throws -> String {
		try _imagesFolder.write(string, to: filename)
		return "./images/\(filename)"
	}
}

private var markdownText = ""
private let outputFolder = try! testResultsContainer.subfolder(with: "generation")
private let imagesFolder = try! outputFolder.subfolder(with: "images")
private let imageStore = ImageOutput(imagesFolder)

let osstring: String = {
#if os(watchOS)
	"watchOS"
#elseif os(macOS)
	"macOS"
#elseif os(iOS)
	"iOS"
#elseif os(tvOS)
	"tvOS"
#elseif os(visionOS)
	"visionOS"
#endif
}()

final class QRCodeDocGeneratorTests: XCTestCase {

	// The dimension for all the generated images
	let dimension: Int = 600

	// Common text
	let text = "QR Code generation test for the QRCode library"

	// Common settings
	let commonsettings: [String: Any] = [
		QRCode.SettingsKey.cornerRadiusFraction: 0.8,
		QRCode.SettingsKey.insetFraction: 0.1,
		QRCode.SettingsKey.hasInnerCorners: true
	]

	override class func setUp() {
		markdownText += "# QRCode Generation (\(osstring))\n\n"
	}

	// Called when the test _class_ completes
	override class func tearDown() {
		// Write out the markdown
		try! outputFolder.write(markdownText, to: "styles-\(osstring).md", encoding: .utf8)
	}

	func testPixelShapesCoreImage() throws {
		do {
			let doc = try QRCode.Document(utf8String: text, errorCorrection: .high)

			markdownText += "## Pixel Shapes (CoreImage)\n\n"

			do {
				markdownText += "### Generators\n\n"

				// Generate sample images for each type
				let samples = try QRCodePixelShapeFactory.shared.generateSampleImages(
					dimension: 200, foregroundColor: .commonBlack, backgroundColor: .commonWhite)

				markdownText += "| Generator Name | Sample Image   |\n"
				markdownText += "|:------|:-----:|\n"

				try samples.forEach { sample in
					let filename = "shape-pixel - \(sample.name).png"
					let link = try imageStore.store(try sample.image.representation.png(), filename: filename)
					markdownText += "| \(sample.name) | <a href=\"\(link)\"><img src=\"\(link)\" width=\"36\" /></a> |\n"
				}

				markdownText += "\n"
			}

			markdownText += "### Samples\n\n"

			markdownText += "|       |   L   |   M   |   Q   |   H   |  SVG  |  PDF  |  neg  |\n"
			markdownText += "|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|\n"

			doc.design.style.onPixels = .solid(0.6, 0, 0)
			doc.design.style.eye = .solid(0, 0, 0)

			let names = QRCodePixelShapeFactory.shared.availableGeneratorNames.sorted()
			for name in names {
				doc.design.shape.negatedOnPixelsOnly = false
				markdownText += "|\(name)|"
				let generator = try QRCodePixelShapeFactory.shared.named(name, settings: commonsettings)
				for enc in QRCode.ErrorCorrection.allCases {
					doc.errorCorrection = enc
					doc.design.shape.onPixels = generator

					let cgImage = try doc.cgImage(dimension: dimension)
#if !os(watchOS)
					let fs = QRCode.DetectQRCodes(cgImage)
					let detected = fs.count == 1 && fs[0].messageString == text
					let detect = detected ? "✅" : "❌"
#else
					let detect = "???"
#endif
					let name = "pixelint - \(name) - \(enc.ECLevel).png"
					let link = try imageStore.store(try cgImage.representation.png(), filename: name)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a><br/>\(detect)|"
				}

				do {
					let svgImage = try doc.svg(dimension: dimension)
					let filename = "pixelint - \(name).svg"
					let link = try imageStore.store(svgImage, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a><br/>⚖️|"
				}

				do {
					let pdf = try doc.pdfData(dimension: dimension)
					let filename = "pixelint - \(name).pdf"
					let link = try imageStore.store(pdf, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a><br/>⚖️|"
				}

				do {
					doc.design.shape.negatedOnPixelsOnly = true
					let inverted = try doc.pdfData(dimension: dimension)
					let filename = "pixelnegated - \(name).pdf"
					let link = try imageStore.store(inverted, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a><br/>⚖️|"
				}

				markdownText += "\n"
			}
			markdownText += "\n"
		}
	}

	func testPixelShapesExternalGenerator() throws {
		let doc = try QRCode.Document(utf8String: text, errorCorrection: .high, engine: QRCodeEngineExternal())
		doc.design.style.onPixels = QRCode.FillStyle.Solid(0.6, 0, 0)
		doc.design.style.eye = QRCode.FillStyle.Solid(0, 0, 0)

		markdownText += "## Pixel Shapes (3rd party Generator)\n\n"

		markdownText += "|       |   L   |   M   |   Q   |   H   |  SVG  |  PDF  |  neg  |\n"
		markdownText += "|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|\n"

		let names = QRCodePixelShapeFactory.shared.availableGeneratorNames.sorted()
		for name in names {
			markdownText += "|\(name)|"
			let generator = try QRCodePixelShapeFactory.shared.named(name, settings: commonsettings)
			for enc in QRCode.ErrorCorrection.allCases {
				doc.errorCorrection = enc
				doc.design.shape.onPixels = generator
				doc.design.shape.negatedOnPixelsOnly = false

				let cgImage = try doc.cgImage(dimension: dimension)
#if !os(watchOS)
				let fs = QRCode.DetectQRCodes(cgImage)
				let detected = fs.count == 1 && fs[0].messageString == text
				let detect = detected ? "✅" : "❌"
#else
				let detect = "???"
#endif
				let filename = "pixelext - \(name) - \(enc.ECLevel).png"
				let link = try imageStore.store(try cgImage.representation.png(), filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a><br/>\(detect)|"
			}
			do {
				let svgImage = try doc.svg(dimension: dimension)
				let filename = "pixelext - \(name).svg"
				let link = try imageStore.store(svgImage, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a><br/>⚖️|"
			}

			do {
				let pdf = try doc.pdfData(dimension: dimension)
				let filename = "pixelext - \(name).pdf"
				let link = try imageStore.store(pdf, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a><br/>⚖️|"
			}

			do {
				doc.design.shape.negatedOnPixelsOnly = true
				let inverted = try doc.pdfData(dimension: dimension)
				let filename = "pixelnegated - \(name).pdf"
				let link = try imageStore.store(inverted, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a><br/>⚖️|"
			}
			markdownText += "\n"
		}
		markdownText += "\n"
	}

	func testEyeShapes() throws {
		let doc = try QRCode.Document(
			utf8String: "QR Code generation test",
			errorCorrection: .high
		)
		doc.design.style.onPixels = QRCode.FillStyle.Solid(gray: 0, alpha: 0.3)

		markdownText += "## Eye Shapes\n\n"

		do {
			markdownText += "### Generators\n\n"

			// Generate sample images for each type
			let samples = try QRCodeEyeShapeFactory.shared.generateSampleImages(
				dimension: 200, foregroundColor: .commonBlack, backgroundColor: .commonWhite)

			markdownText += "| Generator Name | Sample Image   |\n"
			markdownText += "|:------|:-----:|\n"

			try samples.forEach { sample in
				let filename = "shape-eye - \(sample.name).png"
				let link = try imageStore.store(try sample.image.representation.png(), filename: filename)
				markdownText += "| \(sample.name) | <a href=\"\(link)\"><img src=\"\(link)\" width=\"36\" /></a> |\n"
			}

			markdownText += "\n"
		}

		markdownText += "### Samples\n\n"

		markdownText += "|      |      |      |      |\n"
		markdownText += "|:----:|:----:|:----:|:----:|\n"

		let names = QRCodeEyeShapeFactory.shared.availableGeneratorNames.sorted()
		for name in names {

			markdownText += "| \(name) |"

			let generator = try QRCodeEyeShapeFactory.shared.named(name)
			doc.design.shape.eye = generator
			doc.design.style.eye = QRCode.FillStyle.Solid(0.6, 0, 0)

			do {
				let cgImage = try doc.cgImage(dimension: dimension)
#if !os(watchOS)
				let fs = QRCode.DetectQRCodes(cgImage)
				let detected = fs.count == 1 && fs[0].messageString == "QR Code generation test"
				let detect = detected ? "✅" : "❌"
#else
				let detect = "???"
#endif

				let filename = "eye - \(name).png"
				let content = try cgImage.representation.png()
				let link = try imageStore.store(content, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a><br/>png \(detect)|"
			}

			do {
				let filename = "eye - \(name).svg"
				let svgImage = try doc.svg(dimension: dimension)
				let link = try imageStore.store(svgImage, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a><br/>svg|"
			}

			do {
				let filename = "eye - \(name).pdf"
				let pdf = try doc.pdfData(dimension: dimension)
				let link = try imageStore.store(pdf, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a><br/>pdf|"
			}
			markdownText += "\n"
		}
		markdownText += "\n"
	}

	func testPupilShapes() throws {
		let doc = try QRCode.Document(
			utf8String: "QR Code generation test",
			errorCorrection: .high
		)

		doc.design.style.onPixels = QRCode.FillStyle.Solid(gray: 0, alpha: 0.3)

		markdownText += "## Pupil Shapes\n\n"

		do {
			markdownText += "### Generators\n\n"

			// Generate sample images for each type
			let samples = try QRCodePupilShapeFactory.shared.generateSampleImages(
				dimension: 200, foregroundColor: .commonBlack, backgroundColor: .commonWhite)

			markdownText += "| Generator Name | Sample Image   |\n"
			markdownText += "|:------|:-----:|\n"

			try samples.forEach { sample in
				let filename = "shape-pupil - \(sample.name).png"
				let link = try imageStore.store(try sample.image.representation.png(), filename: filename)
				markdownText += "| \(sample.name) | <a href=\"\(link)\"><img src=\"\(link)\" width=\"36\" /></a> |\n"
			}

			markdownText += "\n"
		}

		markdownText += "### Samples\n\n"

		markdownText += "|       |        |        |        |\n"
		markdownText += "|:------|:------:|:------:|:------:|\n"

		let names = QRCodePupilShapeFactory.shared.availableGeneratorNames
		for name in names {

			markdownText += "| \(name) |"

			let generator = try QRCodePupilShapeFactory.shared.named(name)
			doc.design.shape.pupil = generator
			doc.design.style.pupil = QRCode.FillStyle.Solid(0.6, 0, 0)

			do {
				let cgImage = try doc.cgImage(dimension: dimension)

#if !os(watchOS)
				let fs = QRCode.DetectQRCodes(cgImage)
				let detected = fs.count == 1 && fs[0].messageString == "QR Code generation test"
				let detect = detected ? "✅" : "❌"
#else
				let detect = "???"
#endif

				let filename = "pupil - \(name).png"
				let content = try cgImage.representation.png()
				let link = try imageStore.store(content, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a><br/>png \(detect)|"
			}

			do {
				let filename = "pupil - \(name).svg"
				let svg = try doc.svg(dimension: dimension)
				let link = try imageStore.store(svg, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a><br/>svg|"
			}

			do {
				let filename = "pupil - \(name).pdf"
				let pdf = try doc.pdfData(dimension: dimension)
				let link = try imageStore.store(pdf, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a><br/>pdf|"
			}
			markdownText += "\n"
		}
		markdownText += "\n"
	}

	func testFillStyles() throws {
		markdownText += "## Fill Styles\n\n"

		do {
			markdownText += "### Solid\n\n"

			let doc = try QRCode.Document(
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
				let cgImage = try doc.cgImage(dimension: dimension)
				let content = try cgImage.representation.png()
				let filename = "fillstyle-solid-\(item.offset).png"
				let link = try imageStore.store(content, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a>|"
			}
			markdownText += "\n"

			markdownText += " svg |"
			for item in styles.enumerated() {
				doc.design.style.setForegroundStyle(item.element)
				let svgImage = try doc.svg(dimension: dimension)
				let filename = "fillstyle-solid-\(item.offset).svg"
				let link = try imageStore.store(svgImage, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a>|"
			}
			markdownText += "\n"

			markdownText += " pdf |"
			for item in styles.enumerated() {
				doc.design.style.setForegroundStyle(item.element)
				let image = try doc.pdfData(dimension: dimension)
				let filename = "fillstyle-solid-\(item.offset).pdf"
				let link = try imageStore.store(image, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a>|"
			}
			markdownText += "\n"
		}

		do {
			markdownText += "### Linear\n\n"

			let doc = try QRCode.Document(
				utf8String: "QR Code generation test",
				errorCorrection: .medium
			)
			doc.design.shape.eye = QRCode.EyeShape.Leaf()
			doc.design.shape.onPixels = QRCode.PixelShape.Squircle(insetFraction: 0.1)
			doc.design.backgroundColor(CGColor.gray(0.1, 0.1))

			markdownText += "|        | (0,0->1,1) | (0,1->1,0) | (0,0->1,0) | (0,0->0,1) |\n"
			markdownText += "|:-------|:-----:|:-----:|:-----:|:-----:|\n"

			markdownText += "|"

			let gradient = try DSFGradient(
				pins: [
					DSFGradient.Pin(CGColor.RGBA(1, 0, 0, 1), 0.1),
					DSFGradient.Pin(CGColor.RGBA(0, 1, 0, 1), 0.7),
					DSFGradient.Pin(CGColor.RGBA(0, 0, 1, 1), 0.9),
				]
			)

			let items = [
				QRCode.FillStyle.LinearGradient(gradient),
				QRCode.FillStyle.LinearGradient(gradient, startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 0)),
				QRCode.FillStyle.LinearGradient(gradient, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 0)),
				QRCode.FillStyle.LinearGradient(gradient, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 1)),
			]

			markdownText += " png |"
			for item in items.enumerated() {
				try [0, 5, 10].forEach { aqs in
					doc.design.additionalQuietZonePixels = UInt(aqs)
					doc.design.style.setForegroundStyle(item.element)
					let cgImage = try doc.cgImage(dimension: dimension)
					let content = try cgImage.representation.png()
					let filename = "fillstyle-linear-\(item.offset)-qs\(aqs).png"
					let link = try imageStore.store(content, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a>"
				}
				markdownText += "|"
			}

			markdownText += "\n"

			markdownText += " svg |"
			for item in items.enumerated() {
				try [0, 5, 10].forEach { aqs in
					doc.design.additionalQuietZonePixels = UInt(aqs)
					doc.design.style.setForegroundStyle(item.element)
					let svgImage = try doc.svg(dimension: dimension)
					let filename = "fillstyle-linear-\(item.offset)-qs\(aqs).svg"
					let link = try imageStore.store(svgImage, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a>"
				}
				markdownText += "|"
			}

			markdownText += "\n"

			markdownText += " pdf |"
			for item in items.enumerated() {
				try [0, 5, 10].forEach { aqs in
					doc.design.additionalQuietZonePixels = UInt(aqs)
					doc.design.style.setForegroundStyle(item.element)
					let image = try doc.pdfData(dimension: dimension)
					let filename = "fillstyle-linear-\(item.offset)-qs\(aqs).pdf"
					let link = try imageStore.store(image, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a>"
				}
				markdownText += "|"
			}

			markdownText += "\n"
		}

		do {
			markdownText += "### Radial\n\n"

			let doc = try QRCode.Document(
				utf8String: "QR Code generation test",
				errorCorrection: .medium
			)
			doc.design.shape.eye = QRCode.EyeShape.BarsHorizontal()
			doc.design.shape.onPixels = QRCode.PixelShape.Vertical(insetFraction: 0.1, cornerRadiusFraction: 1)

			doc.design.backgroundColor(CGColor.gray(0.1, 0.1))

			markdownText += "|     | (0.5,0.5) | (0,0) | (1,0) | (1,1) | (0,1) |\n"
			markdownText += "|:---:|:---------:|:-----:|:-----:|:-----:|:-----:|\n"

			markdownText += "|"

			let gradient = try DSFGradient(
				pins: [
					DSFGradient.Pin(CGColor.RGBA(1, 0, 0, 1), 0.1),
					DSFGradient.Pin(CGColor.RGBA(0, 1, 0, 1), 0.5),
					DSFGradient.Pin(CGColor.RGBA(0, 0, 1, 1), 0.9),
				]
			)

			let items: [(String, QRCodeFillStyleGenerator)] = [
				("(0.5,0.5)", QRCode.FillStyle.RadialGradient(gradient)),
				("(0,0)", QRCode.FillStyle.RadialGradient(gradient, centerPoint: CGPoint(x: 0.1, y: 0.1))),
				("(1,0)", QRCode.FillStyle.RadialGradient(gradient, centerPoint: CGPoint(x: 0.9, y: 0.1))),
				("(1,1)", QRCode.FillStyle.RadialGradient(gradient, centerPoint: CGPoint(x: 0.9, y: 0.9))),
				("(0,1)", QRCode.FillStyle.RadialGradient(gradient, centerPoint: CGPoint(x: 0.1, y: 0.9))),
			]

			markdownText += " png |"
			for item in items.enumerated() {
				try [0, 5, 10].forEach { aqs in
					doc.design.style.setForegroundStyle(item.element.1)
					doc.design.additionalQuietZonePixels = UInt(aqs)
					let image = try doc.cgImage(dimension: dimension)
					let content = try image.representation.png()
					let filename = "fillstyle-radial-\(item.offset)-\(item.element.0)-qs\(aqs).png"
					let link = try imageStore.store(content, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a>"
				}
				markdownText += "|"
			}
			markdownText += "\n"

			markdownText += " svg |"
			for item in items.enumerated() {
				try [0, 5, 10].forEach { aqs in
					doc.design.style.setForegroundStyle(item.element.1)
					doc.design.additionalQuietZonePixels = UInt(aqs)
					let svgcontent = try doc.svg(dimension: dimension)
					let filename = "fillstyle-radial-\(item.offset)-\(item.element.0)-qs\(aqs).svg"
					let link = try imageStore.store(svgcontent, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a>"
				}
				markdownText += "|"
			}
			markdownText += "\n"

			markdownText += " pdf |"
			for item in items.enumerated() {
				try [0, 5, 10].forEach { aqs in
					doc.design.additionalQuietZonePixels = UInt(aqs)
					doc.design.style.setForegroundStyle(item.element.1)
					let image = try doc.pdfData(dimension: dimension)
					let filename = "fillstyle-radial-\(item.offset)-\(item.element.0)-qs\(aqs).pdf"
					let link = try imageStore.store(image, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a>"
				}
				markdownText += "|"
			}
			markdownText += "\n"
		}

		do {
			markdownText += "## Logo\n\n"

			let doc = try QRCode.Document(
				utf8String: "QR Code generation test with a lot of content to display!",
				errorCorrection: .high
			)

			doc.design.backgroundColor(CGColor.RGBA(0.977, 1.000, 0.875, 1))

			let logoImage = try resourceImage(for: "instagram-icon", extension: "png")
			let logoImage1 = try resourceImage(for: "square-logo", extension: "png")
			let logoImage2 = try resourceImage(for: "apple", extension: "png")

			let items = [
				QRCode.LogoTemplate.CircleCenter(image: logoImage, inset: 8),
				QRCode.LogoTemplate.CircleBottomRight(image: logoImage, inset: 8),
				QRCode.LogoTemplate.SquareCenter(image: logoImage1, inset: 8),
				QRCode.LogoTemplate.SquareBottomRight(image: logoImage1, inset: 8),
				QRCode.LogoTemplate(
					image: logoImage2,
					path: CGPath(rect: CGRect(x: 0.40, y: 0.365, width: 0.55, height: 0.25), transform: nil),
					inset: 8
				)
			]

			markdownText += "|        |        |        |        |        |        |\n"
			markdownText += "|:------:|:------:|:------:|:------:|:------:|:------:|\n"

			markdownText += "| png |"
			for item in items.enumerated() {
				try [0, 5].forEach { aqs in
					doc.design.additionalQuietZonePixels = UInt(aqs)
					doc.logoTemplate = item.element
					let image = try doc.cgImage(dimension: dimension)
					let content = try image.representation.png()
					let filename = "logo-\(item.offset)-aqs\(aqs).png"
					let link = try imageStore.store(content, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a>"
				}
				markdownText += "|"
			}
			markdownText += "\n"

			markdownText += "| svg |"
			for item in items.enumerated() {
				try [0, 5].forEach { aqs in
					doc.design.additionalQuietZonePixels = UInt(aqs)
					doc.logoTemplate = item.element
					let svgcontent = try doc.svg(dimension: dimension)
					let filename = "logo-\(item.offset)-aqs\(aqs).svg"
					let link = try imageStore.store(svgcontent, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a>"
				}
				markdownText += "|"
			}
			markdownText += "\n"

			markdownText += " pdf |"

			for item in items.enumerated() {
				try [0, 5].forEach { aqs in
					doc.design.additionalQuietZonePixels = UInt(aqs)
					doc.logoTemplate = item.element
					let image = try doc.pdfData(dimension: dimension)
					let filename = "logo-\(item.offset)-aqs\(aqs).pdf"
					let link = try imageStore.store(image, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a>"
				}
				markdownText += "|"
			}
		}
		markdownText += "\n"
	}

	func testBackgroundCornerRadius() throws {
		markdownText += "## Corner radius\n\n"

		let doc = try QRCode.Document(utf8String: "Corner radius checking", errorCorrection: .high)
		doc.design.additionalQuietZonePixels = 4

		let c1 = QRCode.FillStyle.Solid(1, 0, 0)
		let c2 = QRCode.FillStyle.LinearGradient(
			try DSFGradient(pins: [
				DSFGradient.Pin(CGColor.RGBA(0.8, 0.8, 1, 1), 0),
				DSFGradient.Pin(CGColor.RGBA(0.8, 0.8, 0.4, 1), 0.4),
				DSFGradient.Pin(CGColor.RGBA(0.016, 0.198, 1, 1), 1),
			])
		)
		let c3 = QRCode.FillStyle.RadialGradient(
			try DSFGradient(pins: [
				DSFGradient.Pin(CGColor.RGBA(0.8, 0.8, 1, 1), 0),
				DSFGradient.Pin(CGColor.RGBA(0.8, 0.8, 0.4, 1), 0.4),
				DSFGradient.Pin(CGColor.RGBA(0.016, 0.198, 1, 1), 1),
			])
		)

		let fillImage = try c3.makeImage(dimension: 500)
		XCTAssertEqual(500, fillImage.width)
		XCTAssertEqual(500, fillImage.height)

		let logoImage3 = try resourceImage(for: "lego", extension: "jpeg")
		let c4 = QRCode.FillStyle.Image(logoImage3)
		let bgs: [QRCodeFillStyleGenerator] = [c1, c2, c3, c4]

		do {
			var count = 0
			try bgs.forEach { bgs in
				count += 1
				doc.design.style.background = bgs
				doc.design.foregroundColor(.commonWhite)

				markdownText += "|  Type  |    0    |    2    |    4    |    6    |\n"
				markdownText += "|:-------|:------:|:------:|:------:|:------:|\n"

				markdownText += "| PNG |"
				try [0, 2, 4, 6].forEach { cr in
					doc.design.style.backgroundFractionalCornerRadius = cr
					let content = try doc.imageData(.png(), dimension: 300)
					let filename = "corner-radius-solid-\(cr)-\(count).png"
					let link = try imageStore.store(content, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a><br/>|"
				}
				markdownText += "\n"
				markdownText += "| SVG |"
				try [0, 2, 4, 6].forEach { cr in
					doc.design.style.backgroundFractionalCornerRadius = cr
					let content = try doc.imageData(.svg, dimension: 300)
					let filename = "corner-radius-solid-\(cr)-\(count).svg"
					let link = try imageStore.store(content, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a><br/>|"
				}
				markdownText += "\n\n"
			}
			markdownText += "\n"
		}

		markdownText += "\n\n"
	}

	func testComponentGeneration() throws {
		markdownText += "## Component paths\n\n"

		markdownText += "|        | all | on pixels | off pixels | eye background | eye outer | eye pupil |\n"
		markdownText += "|:------:|:------:|:------:|:------:|:------:|:------:|:------:|\n"

		let doc = try QRCode.Document(
			utf8String: "QR Code generation test with a lot of content to display!",
			errorCorrection: .high
		)

		let items = [
			(QRCode.Components.onPixels, "onPixels", CGColor.createWithHue(0.6, saturation: 1, brightness: 1, alpha: 1)),
			(QRCode.Components.offPixels, "offPixels", CGColor.createWithHue(0.8, saturation: 1, brightness: 1, alpha: 1)),
			(QRCode.Components.eyeBackground, "eyeBackground", CGColor.createWithHue(0, saturation: 1, brightness: 0, alpha: 1)),
			(QRCode.Components.eyeOuter, "eyeOuter", CGColor.createWithHue(0.0, saturation: 1, brightness: 1, alpha: 1)),
			(QRCode.Components.eyePupil, "eyePupil", CGColor.createWithHue(0.4, saturation: 1, brightness: 1, alpha: 1)),
		]

		let rect = CGRect(origin: .zero, size: .init(width: dimension, height: dimension))

		let logoTemplate = QRCode.LogoTemplate(
			image: try resourceImage(for: "apple", extension: "png"),
			path: CGPath(rect: CGRect(x: 0.40, y: 0.365, width: 0.55, height: 0.25), transform: nil),
			inset: 32
		)
		let logoImageC = try resourceImage(for: "instagram-icon", extension: "png")
		let logoTemplate2 = QRCode.LogoTemplate.CircleCenter(image: logoImageC)

		try [
			("nologo", nil),
			("logo-1", logoTemplate),
			("logo-2", logoTemplate2)
		].forEach { template in

			doc.logoTemplate = template.1
			let filenameaddition = template.0

			markdownText += "| \(filenameaddition) "

			// Do all first

			do {
				let image = try CGImage.Create(size: rect.size, flipped: true) { ctx in
					ctx.saveGState()
					ctx.setFillColor(CGColor.gray(0, 0.05))
					ctx.fill([rect])
					ctx.setStrokeColor(CGColor.gray(0, 0.8))
					ctx.setLineWidth(0.5)
					ctx.stroke(rect)
					ctx.restoreGState()

					for item in items {
						let path = doc.path(dimension: self.dimension, components: item.0)
						ctx.addPath(path)
						ctx.setFillColor(item.2)
						ctx.fillPath()
					}
				}//.flipping(.horizontally)

				let content = try image.representation.png()
				let filename = "components-all-\(filenameaddition).png"
				let link = try imageStore.store(content, filename: filename)
				markdownText += "|<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a><br/>"
			}

			// Now each individually

			for item in items.enumerated() {
				let path = doc.path(dimension: dimension, components: item.element.0)
				let image = try CGImage.Create(size: rect.size, flipped: true) { ctx in
					ctx.saveGState()
					ctx.setFillColor(CGColor.gray(0, 0.05))
					ctx.fill([rect])
					ctx.setStrokeColor(CGColor.gray(0, 0.8))
					ctx.setLineWidth(0.5)
					ctx.stroke(rect)
					ctx.restoreGState()

					ctx.addPath(path)
					ctx.setFillColor(item.element.2)
					ctx.fillPath()
				}

				let content = try image.representation.png()
				let filename = "components-\(item.offset)-\(filenameaddition).png"
				let link = try imageStore.store(content, filename: filename)
				markdownText += "|<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a>"
			}
			markdownText += "|\n"
		}

		markdownText += "\n"
	}

	func testOnPathOffPath() throws {
		let doc = try QRCode.Document(utf8String: "Checking on/off paths", errorCorrection: .low)

		markdownText += "## On path/Off Path\n\n"

		markdownText += "|       |  on/off  |  on  |  off  |\n"
		markdownText += "|:-----:|:-----:|:-----:|:-----:|\n"

		let items = [
			("on/off", [QRCode.Components.onPixels, QRCode.Components.offPixels]),
			("on", QRCode.Components.onPixels),
			("on", QRCode.Components.offPixels),
		]

		let rect = CGRect(origin: .zero, size: CGSize(dimension: dimension))
		let names = QRCodePixelShapeFactory.shared.availableGeneratorNames.sorted()
		for name in names {

			let generator = try QRCodePixelShapeFactory.shared.named(name, settings: commonsettings)
			doc.design.shape.onPixels = generator
			doc.design.shape.offPixels = generator

			markdownText += "|\(name)|"

			for item in items.enumerated() {
				let image = try CGImage.Create(size: rect.size, flipped: true) { ctx in
					ctx.saveGState()
					ctx.setFillColor(CGColor.gray(0, 0.05))
					ctx.fill([rect])
					ctx.setStrokeColor(CGColor.gray(0, 0.8))
					ctx.setLineWidth(0.5)
					ctx.stroke(rect)
					ctx.restoreGState()

					if item.element.1.contains(QRCode.Components.onPixels) {
						ctx.saveGState()
						let path = doc.path(dimension: dimension, components: .onPixels)
						ctx.addPath(path)
						ctx.setFillColor(CGColor.RGBA(0.8, 0, 0, 1))
						ctx.fillPath()
						ctx.restoreGState()
					}

					if item.element.1.contains(QRCode.Components.offPixels) {
						ctx.saveGState()
						let path = doc.path(dimension: dimension, components: .offPixels)
						ctx.addPath(path)
						ctx.setFillColor(CGColor.RGBA(0, 0, 0.8, 1))
						ctx.fillPath()
						ctx.restoreGState()
					}

					ctx.saveGState()
					let path = doc.path(dimension: dimension, components: .eyeAll)
					ctx.addPath(path)
					ctx.setFillColor(CGColor.RGBA(0.0, 0.0, 0.0, 0.1))
					ctx.fillPath()
					ctx.restoreGState()
				}//.flipping(.horizontally)

				let content = try image.representation.png()
				let filename = "onpathcheck-\(name)-\(item.offset).png"
				let link = try imageStore.store(content, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a>|"
			}
			markdownText += "\n"
		}
		markdownText += "\n"
	}

	func testUsePixelShapeChecks() throws {

		markdownText += "## Use Pixel shape checks \n\n"

		let doc = try QRCode.Document(utf8String: "This is a test")
		doc.design.shape.eye = QRCode.EyeShape.UsePixelShape()
		doc.design.shape.pupil = QRCode.PupilShape.UsePixelShape()

		let names = QRCodePixelShapeFactory.shared.availableGeneratorNames
		for name in names {
			let g = try QRCodePixelShapeFactory.shared.named(name)
			_ = g.setSettingValue(0.1, forKey: QRCode.SettingsKey.insetFraction)
			_ = g.setSettingValue(1, forKey: QRCode.SettingsKey.cornerRadiusFraction)
			doc.design.shape.onPixels = g

			let image = try doc.imageData(.jpg(dpi: 72, compression: 0.5), dimension: 500)
			let filename = "usePixelShape-\(name).jpg"
			let link = try imageStore.store(image, filename: filename)
			markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a>"
		}

		markdownText += "\n"
	}

	func testStyleExportEquivalenceChecks() throws {
		markdownText += "## Style export equivalence checks \n\n"
		let exporters: [QRCode.Document.ExportType] = [.png(), .pdf(), .svg]
		let sampleDocs: [(String, QRCode.Document)] = [
			try {
				let doc = try QRCode.Document(utf8String: "QRCode stylish design - Blue wavy", errorCorrection: .medium)
				doc.design.shape.eye = QRCode.EyeShape.RoundedRect()
				doc.design.shape.onPixels = QRCode.PixelShape.RoundedPath(cornerRadiusFraction: 1, hasInnerCorners: true)
				doc.design.style.onPixels = QRCode.FillStyle.LinearGradient(
					try DSFGradient(pins: [
						DSFGradient.Pin(CGColor.RGBA(0, 0.589, 1, 1), 0),
						DSFGradient.Pin(CGColor.RGBA(0.016, 0.198, 1, 1), 1),
					])
				)
				doc.design.shape.offPixels = QRCode.PixelShape.Circle(insetFraction: 0.1)
				doc.design.style.offPixels = QRCode.FillStyle.Solid(0, 0, 0, alpha: 0.1)
				return ("design-funky-blue", doc)
			}(),
			// -------------------
			try {
				let doc = try QRCode.Document(utf8String: "QRCode stylish design - Speck highlights", errorCorrection: .quantize)
				doc.design.style.background = QRCode.FillStyle.Solid(0.937, 0.714, 0.502)
				doc.design.shape.eye = QRCode.EyeShape.RoundedOuter()
				doc.design.style.eyeBackground = CGColor.commonWhite
				doc.design.shape.onPixels = QRCode.PixelShape.Square(insetFraction: 0.3)
				doc.design.style.onPixels = QRCode.FillStyle.Solid(gray: 0.0)
				doc.design.style.onPixelsBackground = CGColor.gray(0, 0.2)
				doc.design.shape.offPixels = QRCode.PixelShape.Square(insetFraction: 0.75)
				doc.design.style.offPixels = QRCode.FillStyle.Solid(gray: 1.0)
				doc.design.style.offPixelsBackground = CGColor.gray(1, 0.1)
				return ("design-speck", doc)
			}(),
			// -------------------
			try {
				let url = URL(string: "https://github.com/dagronf/QRCode")!
				let doc = try QRCode.Document(.link(url), errorCorrection: .quantize)
				doc.design.style.background = QRCode.FillStyle.Solid(.commonClear)
				doc.design.shape.onPixels = QRCode.PixelShape.RoundedRect(cornerRadiusFraction: 0.5, insetFraction: 0.1)
				doc.design.shape.eye = QRCode.EyeShape.RoundedRect()
				doc.design.style.setForegroundStyle(
					QRCode.FillStyle.LinearGradient(
						try DSFGradient(pins: [
							DSFGradient.Pin(CGColor.RGBA(0.556, 0.979, 0, 1), 0),
							DSFGradient.Pin(CGColor.RGBA(0.016, 0.444, 0.018, 1), 1),
						]),
						startPoint: CGPoint(x: 0, y: 0),
						endPoint: CGPoint(x: 0.5, y: 1)
					)
				)
				doc.design.style.eye = QRCode.FillStyle.Solid(0.116, 0.544, 0.118)
				doc.design.style.pupil = QRCode.FillStyle.Solid(0.556, 0.979, 0)
				return ("design-github", doc)
			}(),
			// -------------------
			try {
				let doc = try QRCode.Document(utf8String: "QRCode stylish design - landscape", errorCorrection: .quantize)
				doc.design.shape.onPixels = QRCode.PixelShape.Vertical(insetFraction: 0.1, cornerRadiusFraction: 1)
				doc.design.style.setForegroundStyle(
					QRCode.FillStyle.LinearGradient(
						try DSFGradient(pins: [
							DSFGradient.Pin(CGColor.RGBA(0.004, 0.096, 0.574, 1), 0),
							DSFGradient.Pin(CGColor.RGBA(0, 0.903, 0.997, 1), 0.55),
							DSFGradient.Pin(CGColor.RGBA(0, 0.154, 0, 1), 0.556),
							DSFGradient.Pin(CGColor.RGBA(0, 0.586, 0, 1), 1),
						]),
						startPoint: CGPoint(x: 0, y: 0),
						endPoint: CGPoint(x: 0, y: 1)
					)
				)
				doc.design.shape.offPixels = QRCode.PixelShape.Vertical(insetFraction: 0.8, cornerRadiusFraction: 1)
				doc.design.style.offPixels = QRCode.FillStyle.Solid(gray: 0, alpha: 0.1)
				return ("design-landscape", doc)
			}(),

			// -------------------
			try {
				let doc = try QRCode.build
					.text("CRT-Style")
					.errorCorrection(.high)
					.onPixels.shape(QRCode.PixelShape.CRT(insetFraction: 0.1, rotationFraction: 0.1))
					.onPixels.style(QRCode.FillStyle.Solid(0, 0, 1))
					.offPixels.shape(QRCode.PixelShape.CRT(insetFraction: 0.4, rotationFraction: 0.3, useRandomRotation: true))
					.offPixels.style(QRCode.FillStyle.Solid(gray: 0, alpha: 0.1))
					.eye.shape(QRCode.EyeShape.CRT())
					.document

				return ("crt-style-shapes", doc)
			}(),

			// -------------------
			try {
				let doc = try QRCode.Document(utf8String: "Blobby pixel style", errorCorrection: .medium)
				doc.design.shape.eye = QRCode.EyeShape.RoundedRect()
				doc.design.shape.onPixels = QRCode.PixelShape.Blob()
				doc.design.style.onPixels = QRCode.FillStyle.LinearGradient(
					try DSFGradient(pins: [
						DSFGradient.Pin(CGColor.RGBA(1, 0.589, 0, 1), 0),
						DSFGradient.Pin(CGColor.RGBA(1, 0, 0.3, 1), 1),
					]),
					startPoint: CGPoint(x: 0, y: 1),
					endPoint: CGPoint(x: 0, y: 0)
				)
				doc.design.shape.offPixels = QRCode.PixelShape.Circle(insetFraction: 0.3)
				doc.design.style.offPixels = QRCode.FillStyle.Solid(0, 0, 0, alpha: 0.1)
				return ("blobby-pixel-style", doc)
			}(),

			// -------------------
			try {
				let doc = try QRCode.Document(utf8String: "QRCode stylish design with quiet space - landscape", errorCorrection: .quantize)
				doc.design.additionalQuietZonePixels = 6
				doc.design.shape.onPixels = QRCode.PixelShape.Vertical(insetFraction: 0.1, cornerRadiusFraction: 1)
				doc.design.style.setForegroundStyle(
					QRCode.FillStyle.LinearGradient(
						try DSFGradient(pins: [
							DSFGradient.Pin(CGColor.RGBA(0.004, 0.096, 0.574, 1), 0),
							DSFGradient.Pin(CGColor.RGBA(0, 0.903, 0.997, 1), 0.55),
							DSFGradient.Pin(CGColor.RGBA(0, 0.154, 0, 1), 0.556),
							DSFGradient.Pin(CGColor.RGBA(0, 0.586, 0, 1), 1),
						]),
						startPoint: CGPoint(x: 0, y: 0),
						endPoint: CGPoint(x: 0, y: 1)
					)
				)
				doc.design.shape.offPixels = QRCode.PixelShape.Vertical(insetFraction: 0.8, cornerRadiusFraction: 1)
				doc.design.style.offPixels = QRCode.FillStyle.Solid(gray: 0, alpha: 0.1)
				return ("design-landscape-quiet-space", doc)
			}(),
			// -------------------
			try {
				let doc = try QRCode.Document(utf8String: "QRCode stylish design - radial sepia", errorCorrection: .medium)
				doc.design.foregroundStyle(QRCode.FillStyle.Solid(CGColor.RGBA(0.356, 0.209, 0.014, 1)))
				doc.design.shape.onPixels = QRCode.PixelShape.Square(insetFraction: 0.05)
				doc.design.shape.eye = QRCode.EyeShape.RoundedPointingIn()
				doc.design.style.background = .radialGradient(
					try DSFGradient(pins: [
						DSFGradient.Pin(CGColor.RGBA(0.999, 1, 1, 1), 0),
						DSFGradient.Pin(CGColor.RGBA(0.907, 0.765, 0.428, 1), 1),
					])
				)
				return ("design-radialsepia", doc)
			}(),
			// -------------------
			try {
				let doc = try QRCode.Document(utf8String: "QRCode stylish design - bottom right corner masking", errorCorrection: .high)
				let logoImage = try resourceImage(for: "corner-heart", extension: "png")

				doc.design.backgroundColor(.commonBlack)
				doc.design.foregroundStyle(
					QRCode.FillStyle.LinearGradient(
						try DSFGradient(pins: [
							DSFGradient.Pin(CGColor.RGBA(1, 0.149, 0, 1), 0),
							DSFGradient.Pin(CGColor.RGBA(1, 0.578, 0, 1), 0.2),
							DSFGradient.Pin(CGColor.RGBA(0.999, 0.985, 0, 1), 0.4),
							DSFGradient.Pin(CGColor.RGBA(0, 0.976, 0, 1), 0.6),
							DSFGradient.Pin(CGColor.RGBA(0.016, 0.198, 1, 1), 0.8),
							DSFGradient.Pin(CGColor.RGBA(0.581, 0.215, 1, 1), 1),
						]),
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
				doc.logoTemplate = QRCode.LogoTemplate(image: logoImage, path: path, inset: 0)
				return ("design-bottomright-masked", doc)
			}(),
			// -------------------
			try {
				let doc = try QRCode.Document(utf8String: "QRCode stylish design - bottom right corner masking with quiet space", errorCorrection: .high)
				doc.design.additionalQuietZonePixels = 3

				let logoImage = try resourceImage(for: "corner-heart", extension: "png")

				doc.design.backgroundColor(.commonBlack)
				doc.design.foregroundStyle(
					QRCode.FillStyle.LinearGradient(
						try DSFGradient(pins: [
							DSFGradient.Pin(CGColor.RGBA(1, 0.149, 0, 1), 0),
							DSFGradient.Pin(CGColor.RGBA(1, 0.578, 0, 1), 0.2),
							DSFGradient.Pin(CGColor.RGBA(0.999, 0.985, 0, 1), 0.4),
							DSFGradient.Pin(CGColor.RGBA(0, 0.976, 0, 1), 0.6),
							DSFGradient.Pin(CGColor.RGBA(0.016, 0.198, 1, 1), 0.8),
							DSFGradient.Pin(CGColor.RGBA(0.581, 0.215, 1, 1), 1),
						]),
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
				doc.logoTemplate = QRCode.LogoTemplate(image: logoImage, path: path, inset: 0)
				return ("design-bottomright-masked-quiet-space", doc)
			}(),
			// -------------------
			try {
				let doc = try QRCode.Document(utf8String: "Adding a logo to a QR code using an image's transparency", errorCorrection: .high)
				doc.design.style.background = QRCode.FillStyle.Solid(255.0/255.0, 255.0/255.0, 158.0/255.0)
				let logoImage = try resourceImage(for: "logo", extension: "png")
				doc.logoTemplate = QRCode.LogoTemplate(image: logoImage)
				return ("design-logo-masking-using-transparency", doc)
			}(),
			// -------------------
			try {
				let doc = try QRCode.Document(utf8String: "Adding a logo to a QR code using an image's transparency with quiet space", errorCorrection: .high)
				doc.design.style.background = QRCode.FillStyle.Solid(255.0/255.0, 255.0/255.0, 158.0/255.0)
				doc.design.additionalQuietZonePixels = 6
				let logoImage = try resourceImage(for: "logo", extension: "png")
				doc.logoTemplate = QRCode.LogoTemplate(image: logoImage)
				return ("design-logo-masking-using-transparency-and-quiet-space", doc)
			}(),
			// -------------------
			try {
				let doc = try QRCode.Document(utf8String: "Adding a logo to a QR code (without masking) with quiet space", errorCorrection: .high)
				doc.design.style.background = QRCode.FillStyle.Solid(255.0/255.0, 255.0/255.0, 158.0/255.0)
				doc.design.additionalQuietZonePixels = 3
				let logoImage = try resourceImage(for: "logo", extension: "png")
				doc.logoTemplate = QRCode.LogoTemplate(image: logoImage, masksQRCodePixels: false)
				return ("design-logo-masking-using-transparency-without-masking-and-quiet-space", doc)
			}(),
			// -------------------
			try {
				let doc = try QRCode.Document(utf8String: "Adding a logo to a QR code using an image and a masking image", errorCorrection: .high)
				doc.design.style.background = QRCode.FillStyle.Solid(255.0/255.0, 255.0/255.0, 158.0/255.0)
				let logoImage = try resourceImage(for: "logo", extension: "png")
				let logoMaskImage = try resourceImage(for: "logo-mask", extension: "png")
				doc.logoTemplate = QRCode.LogoTemplate(image: logoImage, maskImage: logoMaskImage)
				return ("design-logo-masking", doc)
			}(),
			// -------------------
			try {
				let doc = try QRCode.Document(utf8String: "Adding a logo to a QR code using an image and a masking image with quiet space", errorCorrection: .high)
				doc.design.additionalQuietZonePixels = 6
				doc.design.style.background = QRCode.FillStyle.Solid(255.0/255.0, 255.0/255.0, 158.0/255.0)
				let logoImage = try resourceImage(for: "logo", extension: "png")
				let logoMaskImage = try resourceImage(for: "logo-mask", extension: "png")
				doc.logoTemplate = QRCode.LogoTemplate(image: logoImage, maskImage: logoMaskImage)
				return ("design-logo-masking-quiet-space", doc)
			}(),
			// -------------------
			try {
				let doc = try QRCode.Document(utf8String: "QRCode drawing only the 'off' pixels of the qr code", errorCorrection: .high)
				doc.design.shape.onPixels = QRCode.PixelShape.Circle(insetFraction: 0.05)
				doc.design.shape.negatedOnPixelsOnly = true
				doc.design.style.background = QRCode.FillStyle.Solid(gray: 0)
				doc.design.foregroundStyle(QRCode.FillStyle.Solid(gray: 1))
				return ("design-negated", doc)
			}(),
			// -------------------
			try {
				let doc = try QRCode.Document(utf8String: "QRCode drawing only the 'off' pixels of the qr code with quiet space", errorCorrection: .high)
				doc.design.additionalQuietZonePixels = 6
				doc.design.shape.onPixels = QRCode.PixelShape.Circle(insetFraction: 0.05)
				doc.design.shape.negatedOnPixelsOnly = true
				doc.design.style.background = QRCode.FillStyle.Solid(gray: 0)
				doc.design.foregroundStyle(QRCode.FillStyle.Solid(gray: 1))
				return ("design-negated-quiet-space", doc)
			}(),
			// -------------------
			try {
				let logoImage = try resourceImage(for: "instagram-icon", extension: "png")
				let doc = try QRCode.Document(utf8String: "QRCode drawing only the 'off' pixels of the qr code using fancy path", errorCorrection: .high)
				doc.design.shape.onPixels = QRCode.PixelShape.CurvePixel(cornerRadiusFraction: 0.8)
				doc.design.shape.negatedOnPixelsOnly = true
				doc.design.style.background = QRCode.FillStyle.Solid(0.999, 0.988, 0.472, alpha:1)
				doc.design.foregroundStyle(QRCode.FillStyle.Solid(0.087, 0.015, 0.356, alpha:1))
				doc.logoTemplate = QRCode.LogoTemplate(
					image: logoImage,
					path: CGPath(ellipseIn: CGRect(x: 0.7, y: 0.7, width: 0.28, height: 0.28), transform: nil)
				)
				return ("design-negated-with-path", doc)
			}(),
			// -------------------
			try {
				let logoImage = try resourceImage(for: "instagram-icon", extension: "png")		
				let doc = try QRCode.Document(utf8String: "QRCode drawing only the 'off' pixels of the qr code using fancy path and quiet space", errorCorrection: .high)
				doc.design.additionalQuietZonePixels = 6
				doc.design.shape.onPixels = QRCode.PixelShape.CurvePixel(cornerRadiusFraction: 0.8)
				doc.design.shape.negatedOnPixelsOnly = true
				doc.design.style.background = QRCode.FillStyle.Solid(0.999, 0.988, 0.472, alpha:1)
				doc.design.foregroundStyle(QRCode.FillStyle.Solid(0.087, 0.015, 0.356, alpha:1))
				doc.logoTemplate = QRCode.LogoTemplate(
					image: logoImage,
					path: CGPath(ellipseIn: CGRect(x: 0.7, y: 0.7, width: 0.28, height: 0.28), transform: nil)
				)
				return ("design-negated-with-path-quiet-space", doc)
			}()
		]

		markdownText += "\n\n"
		for doc in sampleDocs {
			markdownText += "### \(doc.1.utf8String ?? "<none>") \n\n"
			markdownText += "|  png  |  pdf  |  svg  |\n"
			markdownText += "|:-----:|:-----:|:-----:|\n"

			for item in exporters {
				let data = try doc.1.imageData(item, dimension: dimension)
				let filename = "\(doc.0).\(item.fileExtension)"
				let link = try imageStore.store(data, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a> |"
			}
			markdownText += "\n\n"
		}
	}

	func testEquivalenceQuietSpaceBackgroundColors() throws {
		markdownText += "## Quiet Space, background colors\n"

		try [0, 20].forEach { aqs in
			let exporters: [QRCode.Document.ExportType] = [.png(), .pdf(), .svg]
			let doc = QRCode.Document()
			doc.utf8String = "https://www.swift.org"

			doc.design.additionalQuietZonePixels = UInt(aqs)
			doc.design.backgroundColor(CGColor.sRGBA(0, 0.6, 0, 1))

			doc.design.style.eye = QRCode.FillStyle.Solid(gray: 1)
			doc.design.style.eyeBackground = CGColor.gray(0, 0.2)

			doc.design.shape.onPixels = QRCode.PixelShape.Square(insetFraction: 0.7)
			doc.design.style.onPixels = QRCode.FillStyle.Solid(gray: 1)
			doc.design.style.onPixelsBackground = CGColor.sRGBA(1, 1, 1, 0.2)

			doc.design.shape.offPixels = QRCode.PixelShape.Square(insetFraction: 0.7)
			doc.design.style.offPixels = QRCode.FillStyle.Solid(gray: 0)
			doc.design.style.offPixelsBackground = CGColor.sRGBA(0, 0, 0, 0.2)

			markdownText += "\n\n"
			markdownText += "### Exporting with pixel background colors"
			if aqs > 0 { markdownText += " with quiet space" }
			markdownText += "\n\n"
			markdownText += "|  png  |  pdf  |  svg  |\n"
			markdownText += "|:-----:|:-----:|:-----:|\n"

			for item in exporters {
				let data = try doc.imageData(item, dimension: dimension)
				let filename = "pixel-background-colors\(aqs > 0 ? "-quietspace" : "").\(item.fileExtension)"
				let link = try imageStore.store(data, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a> |"
			}
			markdownText += "\n\n"
		}
	}

	func testEquivalienceImageBackgroundStyles() throws {
		markdownText += "## Image and background equivalence\n"

		let exporters: [QRCode.Document.ExportType] = [.png(), .pdf(), .svg]

		try [0, 4].forEach { (aqs: UInt) in
			do {
				let doc = try QRCode.Document(utf8String: "This is a test", engine: QRCodeEngineExternal())
				doc.design.additionalQuietZonePixels = aqs

				doc.design.backgroundColor(CGColor.gray(0, 1))
				doc.design.shape.onPixels = QRCode.PixelShape.RoundedPath(cornerRadiusFraction: 0.7, hasInnerCorners: true)

				let logoImage = try resourceImage(for: "colored-fill", extension: "jpg")
				let fillImage = QRCode.FillStyle.Image(logoImage)
				doc.design.style.onPixels = fillImage

				let logoImage2 = try resourceImage(for: "colored-fill-invert", extension: "jpg")
				let eyeImage = QRCode.FillStyle.Image(logoImage2)
				doc.design.style.eye = eyeImage
				doc.design.shape.eye = QRCode.EyeShape.Squircle()

				let logoImage3 = try resourceImage(for: "colored-fill-bw", extension: "jpg")
				let pupilImage = QRCode.FillStyle.Image(logoImage3)
				doc.design.style.pupil = pupilImage
				doc.design.shape.pupil = QRCode.PupilShape.BarsHorizontal()

				markdownText += "\n\n"
				markdownText += "### Exporting with image background colors"
				if aqs > 0 { markdownText += " with quiet space" }
				markdownText += "\n\n"
				markdownText += "|  png  |  pdf  |  svg  |\n"
				markdownText += "|:-----:|:-----:|:-----:|\n"

				for item in exporters {
					let data = try doc.imageData(item, dimension: self.dimension)
					let filename = "fillstyle-image-components\(aqs > 0 ? "-quietspace" : "").\(item.fileExtension)"
					let link = try imageStore.store(data, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a> |"
				}
				markdownText += "\n"
			}

			do {
				let logoImage = try resourceImage(for: "swift-logo", extension: "png")
				let backgroundImage = QRCode.FillStyle.Image(logoImage)

				let doc = try QRCode.Document(utf8String: "https://www.swift.org/about/", engine: QRCodeEngineExternal())
				doc.design.additionalQuietZonePixels = UInt(aqs)
				doc.design.style.background = backgroundImage

				for item in exporters {
					let data = try doc.imageData(item, dimension: self.dimension)
					let filename = "fillstyle-image-background\(aqs > 0 ? "-quietspace" : "").\(item.fileExtension)"
					let link = try imageStore.store(data, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a> |"
				}
				markdownText += "\n"
			}

			do {
				let gradient = try DSFGradient(
					pins: [
						DSFGradient.Pin(CGColor.RGBA(1, 0, 0, 1.000), 0),
						DSFGradient.Pin(CGColor.RGBA(0, 0, 1, 1.000), 1),
					]
				)
				let background = QRCode.FillStyle.LinearGradient(
					gradient,
					startPoint: CGPoint(x: 0, y: 1),
					endPoint: CGPoint(x: 1, y: 1)
				)

				let doc = try QRCode.Document(utf8String: "Gradient Background")
				doc.design.additionalQuietZonePixels = UInt(aqs)
				doc.design.style.background = background
				doc.design.foregroundColor(.commonWhite)

				for item in exporters {
					let data = try doc.imageData(item, dimension: self.dimension)
					let filename = "fillstyle-lineargradient-background\(aqs > 0 ? "-quietspace" : "").\(item.fileExtension)"
					let link = try imageStore.store(data, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a> |"
				}
				markdownText += "\n"
			}

			do {
				let gradient = try DSFGradient(
					pins: [
						DSFGradient.Pin(CGColor.RGBA(1, 0, 0, 1.000), 0),
						DSFGradient.Pin(CGColor.RGBA(0, 0, 1, 1.000), 1),
					]
				)
				let background = QRCode.FillStyle.RadialGradient(gradient)

				let doc = try QRCode.Document(utf8String: "Radial Background")
				doc.design.additionalQuietZonePixels = UInt(aqs)
				doc.design.style.background = background
				doc.design.foregroundColor(.commonWhite)

				for item in exporters {
					let data = try doc.imageData(item, dimension: self.dimension)
					let filename = "fillstyle-radialgradient-background\(aqs > 0 ? "-quietspace" : "").\(item.fileExtension)"
					let link = try imageStore.store(data, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a> |"
				}
				markdownText += "\n"
			}

			markdownText += "\n\n"
		}
	}

	func testExternalGeneratorTextOptimizations() throws {
		markdownText += "## External generator text optimizations \n\n"

		let externalColor = CGColor.sRGBA(0.3, 0.4, 0.8, 1)

		do {
			markdownText += "### Basic alphanum optimisation \n\n"

			let r1 = "THIS IS A TEST"
			markdownText += "Message is: `\(r1)`\n\n"

			markdownText += "| Core Image | External <br/> (no optimization) | External |\n"
			markdownText += "|:----------:|:--------:|:------------:|\n"
			markdownText += "| "

			do {
				let doc1 = try QRCode.Document(utf8String: r1)
				let image = try doc1.imageData(.jpg(), dimension: 250)
				let filename = "generator-basictext-default.jpg"
				let link = try imageStore.store(image, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a> <br/> size=\(doc1.boolMatrix.dimension)"
			}

			markdownText += " | "

			do {
				let data = r1.data(using: .ascii)!
				let doc1 = try QRCode.Document(data: data, engine: QRCodeEngineExternal())
				doc1.design.foregroundColor(externalColor)
				let image = try doc1.imageData(.jpg(), dimension: 250)
				let filename = "generator-basictext-external-noopt.jpg"
				let link = try imageStore.store(image, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a> <br/> size=\(doc1.boolMatrix.dimension)"
			}

			markdownText += " | "

			do {
				let doc1 = try QRCode.Document(utf8String: r1, engine: QRCodeEngineExternal())
				doc1.design.foregroundColor(externalColor)
				let image = try doc1.imageData(.jpg(), dimension: 250)
				let filename = "generator-basictext-external.jpg"
				let link = try imageStore.store(image, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a> <br/> size=\(doc1.boolMatrix.dimension)"
			}
			markdownText += " | "
		}

		markdownText += "\n\n"


		do {
			markdownText += "### Basic numeric optimisation \n\n"

			let r1 = "0123456789012345678901234567890123456789"
			markdownText += "Message is: `\(r1)`\n\n"

			markdownText += "| Core Image | External <br/> (no optimization) | External |\n"
			markdownText += "|:----------:|:--------:|:------------:|\n"
			markdownText += "| "

			do {
				let doc1 = try QRCode.Document(utf8String: r1)
				let image = try doc1.imageData(.jpg(), dimension: 250)
				let filename = "generator-numerics-default.jpg"
				let link = try imageStore.store(image, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a> <br/> size=\(doc1.boolMatrix.dimension)"
			}

			markdownText += " | "

			do {
				let data = r1.data(using: .ascii)!
				let doc1 = try QRCode.Document(data: data, engine: QRCodeEngineExternal())
				doc1.design.foregroundColor(externalColor)
				let image = try doc1.imageData(.jpg(), dimension: 250)
				let filename = "generator-numerics-external-noopt.jpg"
				let link = try imageStore.store(image, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a> <br/> size=\(doc1.boolMatrix.dimension)"
			}

			markdownText += " | "

			do {
				let doc1 = try QRCode.Document(utf8String: r1, engine: QRCodeEngineExternal())
				doc1.design.foregroundColor(externalColor)
				let image = try doc1.imageData(.jpg(), dimension: 250)
				let filename = "generator-numerics-external.jpg"
				let link = try imageStore.store(image, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a> <br/> size=\(doc1.boolMatrix.dimension)"
			}

			markdownText += " | "
		}

		markdownText += "\n"

		do {
			markdownText += "### Basic alphanum optimisation \n\n"

			let r1 = "0123456789ABCDEFGHIJKLMNOP 0123456789ABCDEFGHIJKLMNOP"
			markdownText += "Message is: `\(r1)`\n\n"

			markdownText += "| Core Image | External <br/> (no optimization) | External |\n"
			markdownText += "|:----------:|:--------:|:------------:|\n"
			markdownText += "| "

			do {
				let doc1 = try QRCode.Document(utf8String: r1)
				let image = try doc1.imageData(.jpg(), dimension: 250)
				let filename = "generator-alphanum-default.jpg"
				let link = try imageStore.store(image, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a> <br/> size=\(doc1.boolMatrix.dimension)"
			}

			markdownText += " | "

			do {
				let data = r1.data(using: .ascii)!
				let doc1 = try QRCode.Document(data: data, engine: QRCodeEngineExternal())
				doc1.design.foregroundColor(externalColor)
				let image = try doc1.imageData(.jpg(), dimension: 250)
				let filename = "generator-alphanum-external-noopt.jpg"
				let link = try imageStore.store(image, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a> <br/> size=\(doc1.boolMatrix.dimension)"
			}

			markdownText += " | "

			do {
				let doc1 = try QRCode.Document(utf8String: r1, engine: QRCodeEngineExternal())
				doc1.design.foregroundColor(externalColor)
				let image = try doc1.imageData(.jpg(), dimension: 250)
				let filename = "generator-alphanum-external.jpg"
				let link = try imageStore.store(image, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a> <br/> size=\(doc1.boolMatrix.dimension)"
			}

			markdownText += " | "

			markdownText += "\n"
		}

		do {
			markdownText += "### Unable to optimize \n\n"

			let r1 = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYz $%*+-./:"
			markdownText += "Message is: `\(r1)`\n\n"
			markdownText += "(external generator is unable to optimize this due to lower-case z)\n\n"

			markdownText += "| Core Image | External <br/> (no optimization) | External |\n"
			markdownText += "|:----------:|:--------:|:------------:|\n"
			markdownText += "| "

			do {
				let doc1 = try QRCode.Document(utf8String: r1)
				let image = try doc1.imageData(.jpg(), dimension: 250)
				let filename = "generator-alphanum-default.jpg"
				let link = try imageStore.store(image, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a> <br/> size=\(doc1.boolMatrix.dimension)"
			}

			markdownText += " | "

			do {
				let data = r1.data(using: .ascii)!
				let doc1 = try QRCode.Document(data: data, engine: QRCodeEngineExternal())
				doc1.design.foregroundColor(externalColor)
				let image = try doc1.imageData(.jpg(), dimension: 250)
				let filename = "generator-alphanum-external-noopt.jpg"
				let link = try imageStore.store(image, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a> <br/> size=\(doc1.boolMatrix.dimension)"
			}

			markdownText += " | "

			do {
				let doc1 = try QRCode.Document(utf8String: r1, engine: QRCodeEngineExternal())
				doc1.design.foregroundColor(externalColor)
				let image = try doc1.imageData(.jpg(), dimension: 250)
				let filename = "generator-alphanum-external.jpg"
				let link = try imageStore.store(image, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"125\" /></a> <br/> size=\(doc1.boolMatrix.dimension)"
			}

			markdownText += " | "
		}
		markdownText += "\n\n"
	}

	func testBackgroundStyles() throws {
		markdownText += "## Background styles \n\n"
		let exporters: [QRCode.Document.ExportType] = [.png(), .pdf(), .svg]

		do {
			markdownText += "### Linear \n\n"

			markdownText += "|  png  |  pdf  |  svg  |\n"
			markdownText += "|:-----:|:-----:|:-----:|\n"

			let gradient = try DSFGradient(
				pins: [
					DSFGradient.Pin(CGColor.RGBA(1, 1, 0.9, 1.0), 0.1),
					DSFGradient.Pin(CGColor.RGBA(0.778, 0.635, 0.492, 1.0), 0.9),
				]
			)

			let radial = QRCode.FillStyle.LinearGradient(gradient)
			let doc = try QRCode.Document(utf8String: "QR Code with a linear background")
			doc.design.style.background = radial
			doc.design.shape.eye = QRCode.EyeShape.Edges()

			for item in exporters {
				let image = try doc.imageData(item, dimension: dimension)
				let filename = "background-fill-linear.\(item.fileExtension)"
				let link = try imageStore.store(image, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a> | "
			}
		}
		markdownText += "\n\n"

		do {
			markdownText += "### Radial \n\n"

			markdownText += "|  png  |  pdf  |  svg  |\n"
			markdownText += "|:-----:|:-----:|:-----:|\n"

			let gradient = try DSFGradient(
				pins: [
					DSFGradient.Pin(CGColor.RGBA(1, 1, 0.9, 1.0), 0.1),
					DSFGradient.Pin(CGColor.RGBA(0.778, 0.635, 0.492, 1.0), 0.9),
				]
			)

			let radial = QRCode.FillStyle.RadialGradient(gradient)
			let doc = try QRCode.Document(utf8String: "QR Code with a radial background")
			doc.design.style.background = radial

			for item in exporters {
				let image = try doc.imageData(item, dimension: dimension)
				let filename = "background-fill-radial.\(item.fileExtension)"
				let link = try imageStore.store(image, filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a> | "
			}
		}
		markdownText += "\n\n"

		do {
			markdownText += "### Image \n\n"

			let logoImage = try resourceImage(for: "photo-logo", extension: "jpg")

			markdownText += "|  png  |  pdf  |  svg  |\n"
			markdownText += "|:-----:|:-----:|:-----:|\n"

			let doc = try QRCode.Document(utf8String: "QR Code with a radial background")
			doc.design.style.background = QRCode.FillStyle.Image(logoImage)
			doc.design.foregroundColor(.gray(1, 0.6))

			markdownText += "| "
			for item in exporters {
				try [0, 8, 16].forEach { aqs in
					doc.design.additionalQuietZonePixels = UInt(aqs)
					let image = try doc.imageData(item, dimension: dimension)
					let filename = "background-fill-image-quietspace-\(aqs).\(item.fileExtension)"
					let link = try imageStore.store(image, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"150\" /></a> "
				}
				markdownText += " | "
			}
		}
		markdownText += "\n\n"
	}

	func testCheckEyeBackgroundPath() throws {

		// Verify that the eye background path is drawn correctly

		markdownText += "## Verify eye background exclusion zone drawing\n\n"

		let doc = try QRCode.Document(utf8String: "Validate QR Eye background")

		doc.design.style.background = QRCode.FillStyle.Solid(1, 0, 0)

		markdownText += "|  eye  | flipped |   0   |   2   |   4   |\n"
		markdownText += "|:------|:-------:|:-----:|:-----:|:-----:|\n"

		try QRCodeEyeShapeFactory.shared.all().sorted(by: { $0.name < $1.name }).forEach { generator in
			doc.design.shape.eye = generator
			doc.design.style.eyeBackground = .commonWhite

			let flipped = generator.supportsSettingValue(forKey: QRCode.SettingsKey.isFlipped) ? [false, true] : [false]

			try flipped.forEach { isFlipped in

				markdownText += "|\(generator.name)|\(isFlipped)"

				try [0, 2, 4].forEach { (quietZone: UInt) in

					markdownText += "|"

					_ = doc.design.shape.eye.setSettingValue(isFlipped, forKey: QRCode.SettingsKey.isFlipped)

					doc.design.additionalQuietZonePixels = quietZone

					let image = try doc.imageData(.png(), dimension: dimension)
					let filename = "eye-background-exclusion-zone-\(generator.name)-\(quietZone)-\(isFlipped).png"
					let link = try imageStore.store(image, filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"150\" /></a> "
				}
				markdownText += "|\n"
			}
		}
		markdownText += "\n\n"
	}
}
