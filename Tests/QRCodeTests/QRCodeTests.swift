import XCTest
@testable import QRCode

import SwiftImageReadWrite
internal let testResultsContainer = try! TestFilesContainer(named: "QRCodeTests")

final class QRCodeTests: XCTestCase {

	let outputFolder = try! testResultsContainer.subfolder(with: "QRCodeTests")

	func testBasicQRCode() throws {
		let doc = try QRCode(engine: __testEngine)
		let url = URL(string: "https://www.apple.com.au/")!
		try doc.update(message: try QRCode.Message.Link(url), errorCorrection: .high)

		let boomat = doc.boolMatrix
		XCTAssertEqual(35, boomat.dimension)
	}

	func testGenerateBasicQRCode() throws {

		#if os(watchOS)
		let engines: [QRCodeEngine] = [QRCodeEngineExternal()]
		#else
		let engines: [QRCodeEngine] = [QRCodeEngineCoreImage(), QRCodeEngineExternal()]
		#endif
		try engines.forEach { engine in

			let qrcode = try QRCode(utf8String: "This is a test", engine: engine)

			// Generate png
			do {
				let image = try qrcode.cgImage(dimension: 300)
				let data = try image.representation.png()
				let _ = try outputFolder.write(data, to: "basic-generation-\(engine.name).png")
			}

			// Generate pdf
			do {
				let pdfData = try qrcode.pdfData(dimension: 300)
				let _ = try outputFolder.write(pdfData, to: "basic-generation-\(engine.name).pdf")
			}

			// Generate svg
			do {
				let svgData = try qrcode.svgData(dimension: 300)
				let _ = try outputFolder.write(svgData, to: "basic-generation-\(engine.name).svg")
			}

			// Generate path
			do {
				let path = qrcode.path(dimension: 300)
				let image = try CGImage.Create(dimension: 300, flipped: true) { ctx in
					ctx.addPath(path)
					ctx.setFillColor(CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1))
					ctx.fillPath()
				}
				let data = try image.representation.png()
				let _ = try outputFolder.write(data, to: "basic-generation-path-\(engine.name).png")
			}
		}
	}

	func testAsciiGenerationWorks() throws {
		let doc = try QRCode.Document(engine: __testEngine)
		doc.errorCorrection = .low
		doc.data = "testing".data(using: .utf8)!
		let ascii = doc.asciiRepresentation
		Swift.print(ascii)

		let doc2 = try QRCode.Document(engine: __testEngine)
		doc2.errorCorrection = .low
		doc2.data = "testing".data(using: .utf8)!
		let ascii2 = doc2.smallAsciiRepresentation
		Swift.print(ascii2)
	}

	func testBasicEncodeDecode() throws {
		do {
			let doc1 = try QRCode.Document(engine: __testEngine)
			doc1.data = "this is a test".data(using: .utf8)!

			let s = doc1.settings()
			let doc11 = try QRCode.Document.Create(settings: s, engine: __testEngine)
			XCTAssertNotNil(doc11)

			let data = try doc1.jsonData()
			let dataStr = try doc1.jsonStringFormatted()

			let doc111 = try QRCode.Document.Create(jsonData: data, engine: __testEngine)
			XCTAssertNotNil(doc111)
			let data111Str = try doc111.jsonStringFormatted()
			XCTAssertEqual(dataStr, data111Str)
		}
		catch {
			fatalError("Caught exception")
		}
	}

	func testBasicEncodeDecodeWithCustomPupil() throws {
		do {
			let doc1 = try QRCode.Document(engine: __testEngine)
			doc1.data = "this is a test".data(using: .utf8)!
			doc1.design.shape.pupil = QRCode.PupilShape.Circle()

			let s = doc1.settings()
			let doc11 = try QRCode.Document.Create(settings: s, engine: __testEngine)
			XCTAssertNotNil(doc11)

			let data = try doc1.jsonData()
			let dataStr = try doc1.jsonStringFormatted()

			let doc111 = try QRCode.Document.Create(jsonData: data, engine: __testEngine)
			XCTAssertNotNil(doc111)
			let data111Str = try doc111.jsonStringFormatted()
			XCTAssertEqual(dataStr, data111Str)

			// Check that the eye shape matches that which we encoded
			let e1 = try XCTUnwrap(doc111.design.shape.eye.name)
			XCTAssertEqual(e1, QRCode.EyeShape.Square.Name)

			// Check that the custom pupil shape make it across the encoding
			let o1 = try XCTUnwrap(doc111.design.shape.pupil?.name)
			let r1 = try XCTUnwrap(doc111.design.shape.pupil?.name)
			XCTAssertEqual(o1, r1)
		}
	}

	func testBasicCreate() throws {
		do {
			let doc = try QRCode.Document(utf8String: "Hi there!", errorCorrection: .high, engine: __testEngine)
			doc.design.backgroundColor(CGColor.commonClear)
			doc.design.foregroundColor(CGColor.commonWhite)
			let image = try doc.cgImage(CGSize(width: 800, height: 600))
			XCTAssertEqual(800, image.width)
			XCTAssertEqual(600, image.height)

			try XCTValidateSingleQRCode(image, expectedText: "Hi there!")
		}
	}

	func testNewGeneratePath() throws {
		let g = QRCode.PixelShape.RoundedPath(cornerRadiusFraction: 0.7, hasInnerCorners: true)
		let image = try QRCodePixelShapeFactory.shared.image(
			pixelGenerator: g,
			dimension: 300,
			foregroundColor: CGColor.commonBlack
		)
		XCTAssertEqual(CGSize(width: 300, height: 300), image.size)

		let doc = try QRCode.Document(utf8String: "Hi there!", errorCorrection: .high, engine: __testEngine)
		doc.design.shape.onPixels = QRCode.PixelShape.RoundedPath(cornerRadiusFraction: 0.7, hasInnerCorners: true)

		doc.design.shape.offPixels = QRCode.PixelShape.CurvePixel(cornerRadiusFraction: 1)
		doc.design.style.offPixels = QRCode.FillStyle.Solid(gray: 0.9)

		let cgi = try doc.cgImage(dimension: 600)
		try XCTValidateSingleQRCode(cgi, expectedText: "Hi there!")
	}

	#if canImport(CoreImage)
	func testDiff() throws {
		let g1 = try QRCode.Document(utf8String: "This is a test", errorCorrection: .high)
		let i1 = try g1.cgImage(.init(width: 300, height: 300))
		try XCTValidateSingleQRCode(i1, expectedText: "This is a test")

		let g2 = try QRCode.Document(utf8String: "This is a test", errorCorrection: .quantize)
		let i2 = try g2.cgImage(.init(width: 300, height: 300))
		try XCTValidateSingleQRCode(i2, expectedText: "This is a test")

		let g3 = try QRCode.Document(utf8String: "This is a test", errorCorrection: .quantize)
		g3.design.backgroundColor(CGColor.gray(1, 0.9))
		let i3 = try g3.cgImage(.init(width: 300, height: 300))
		try XCTValidateSingleQRCode(i3, expectedText: "This is a test")

		do {
			// Check exact match
			let diff = try CGImage.diff(i1, i1)
			XCTAssertEqual(0.0, diff, accuracy: 0.000001)
		}

		do {
			// Check big difference
			let diff = try CGImage.diff(i1, i2)
			XCTAssertEqual(1.0, diff, accuracy: 0.000001)
		}

		do {
			// Check minor difference
			let diff = try CGImage.diff(i2, i3)
			XCTAssertEqual(0.1, diff, accuracy: 0.01)
		}
	}
	#endif

	func testGenerateImagesAtDifferentResolutions() throws {
		let doc = try QRCode.Document(utf8String: "Generate content QR", errorCorrection: .high, engine: __testEngine)
		doc.design.shape.onPixels = QRCode.PixelShape.Circle()

		let dpis = [(300, 72.0, "", 300), (600, 144.0, "@2x", 300), (900, 216.0, "@3x", 300)]
#if os(macOS)
		do {
			for dpi in dpis {
				let data = try doc.pngData(dimension: dpi.0, dpi: dpi.1)
				let url = try outputFolder.write(data, to: "dpi-test-output\(dpi.2).png")
				let im = try XCTUnwrap(NSImage(contentsOf: url))
				XCTAssertEqual(CGSize(dimension: dpi.3), im.size)
				XCTAssertEqual(dpi.0, im.representations[0].pixelsWide)
				XCTAssertEqual(dpi.0, im.representations[0].pixelsHigh)
			}
		}

		do {
			for dpi in dpis {
				let data = try doc.tiffData(dimension: dpi.0, dpi: dpi.1)
				let url = try outputFolder.write(data, to: "dpi-test-output\(dpi.2).tiff")
				let im = try XCTUnwrap(NSImage(contentsOf: url))
				XCTAssertEqual(CGSize(dimension: dpi.3), im.size)
				XCTAssertEqual(dpi.0, im.representations[0].pixelsWide)
				XCTAssertEqual(dpi.0, im.representations[0].pixelsHigh)
			}
		}

		do {
			for dpi in dpis {
				let data = try doc.jpegData(dimension: dpi.0, dpi: dpi.1, compression: 0.4)
				let url = try outputFolder.write(data, to: "dpi-test-output\(dpi.2).jpg")
				let im = try XCTUnwrap(NSImage(contentsOf: url))
				XCTAssertEqual(CGSize(dimension: dpi.3), im.size)
				XCTAssertEqual(dpi.0, im.representations[0].pixelsWide)
				XCTAssertEqual(dpi.0, im.representations[0].pixelsHigh)
			}
		}
#else
		do {
			for dpi in dpis {
				let data = try doc.pngData(dimension: dpi.0, dpi: dpi.1)
				let url = try outputFolder.write(data, to: "dpi-test-output\(dpi.2).png")
				let im = try XCTUnwrap(UIImage(contentsOfFile: url.path))
				XCTAssertEqual(CGSize(dimension: dpi.3), im.size)
			}
		}

		do {
			for dpi in dpis {
				let data = try doc.tiffData(dimension: dpi.0, dpi: dpi.1)
				let url = try outputFolder.write(data, to: "dpi-test-output\(dpi.2).tiff")
				let im = try XCTUnwrap(UIImage(contentsOfFile: url.path))
				XCTAssertEqual(CGSize(dimension: dpi.3), im.size)
			}
		}

#endif

		do {
			let data = try doc.pdfData(dimension: 300)
			try outputFolder.write(data, to: "dpi-test-output.pdf")
		}

		do {
			let data = try doc.svgData(dimension: 300)
			try outputFolder.write(data, to: "dpi-test-output.svg")
		}
	}

	func testQuietSpace() throws {

		do {
			let doc = try QRCode.Document(utf8String: "Hi there!", errorCorrection: .high, engine: __testEngine)
			doc.design.shape.onPixels = QRCode.PixelShape.Circle(insetFraction: 0.4)
			doc.design.style.onPixelsBackground = CGColor.commonBlack

			// radial fill
			let c = QRCode.FillStyle.RadialGradient(
				DSFGradient(
					pins: [
						DSFGradient.Pin(CGColor.sRGBA(1, 0, 0, 1), 0),
						DSFGradient.Pin(CGColor.sRGBA(0, 1, 0, 1), 0.5),
						DSFGradient.Pin(CGColor.sRGBA(0, 0, 1, 1), 1.0),
					]
				)!,
				centerPoint: CGPoint(x: 0.5, y: 0.5)
			)

			let fillImage = try c.makeImage(dimension: 500)
			XCTAssertEqual(500, fillImage.width)
			XCTAssertEqual(500, fillImage.height)

			doc.design.style.onPixels = c
			doc.design.style.eyeBackground = CGColor.RGBA(0, 1, 1, 1)
			doc.design.shape.offPixels = QRCode.PixelShape.Flower(insetFraction: 0.2)
			doc.design.style.offPixels = QRCode.FillStyle.Solid(0, 1, 0)

			let gradient = DSFGradient(
				pins: [
					DSFGradient.Pin(CGColor.RGBA(1, 1, 0, 1), 0),
					DSFGradient.Pin(CGColor.RGBA(0, 1, 1, 1), 1),
				]
			)!
			doc.design.style.offPixels = QRCode.FillStyle.LinearGradient(
				gradient,
				startPoint: CGPoint(x: 0, y: 1),
				endPoint: CGPoint(x: 1, y: 1)
			)

			doc.design.style.offPixelsBackground = CGColor.commonWhite

			let logoImage = try resourceImage(for: "photo-logo", extension: "jpg")
			doc.design.style.background = QRCode.FillStyle.Image(logoImage)

			doc.design.additionalQuietZonePixels = 8

			let image = try doc.cgImage(dimension: 800)
			XCTAssertEqual(image.width, 800)
			XCTAssertEqual(image.height, 800)

			try XCTValidateSingleQRCode(image, expectedText: "Hi there!")
		}

		do {
			let doc = try QRCode.Document(utf8String: "Hi there!", errorCorrection: .high, engine: __testEngine)

			let logoImage = try resourceImage(for: "photo-logo", extension: "jpg")
			doc.design.style.onPixels = QRCode.FillStyle.Image(logoImage)

			let image = try doc.cgImage(dimension: 800)
			XCTAssertEqual(image.width, 800)
			XCTAssertEqual(image.height, 800)

			try XCTValidateSingleQRCode(image, expectedText: "Hi there!")
		}
	}

	func testCustomPixelMatrixDefault() throws {
		// Default
		let im = try QRCodePixelShapeFactory.shared.image(
			pixelGenerator: QRCode.PixelShape.RoundedPath(cornerRadiusFraction: 0.5, hasInnerCorners: true),
			dimension: 36,
			foregroundColor: CGColor.RGBA(1, 0, 0, 0.5)
		)

		let o1 = try im.representation.png()
		try outputFolder.write(o1, to: "custom-pixelssample-default-36x36@1x.png")
	}

	func testCustomPixelMatrix3() throws {
		let d3 = BoolMatrix(
			dimension: 3,
			rawFlattenedInt: [
				1, 0, 0,
				0, 1, 1,
				0, 1 ,0
			])

		let im = try QRCodePixelShapeFactory.shared.image(
			pixelGenerator: QRCode.PixelShape.RoundedPath(cornerRadiusFraction: 1, hasInnerCorners: true),
			dimension: 96,
			foregroundColor: CGColor.commonBlack,
			samplePixelMatrix: d3
		)
		let o1 = try im.representation.jpeg(dpi: 144.0, compression: 0.75)
		try outputFolder.write(o1, to: "custom-pixelssample-3x3-48x48@2x.jpg")
	}

	func testCustomMatrixAlignment() throws {

		var markdownText = "# Pixel alignment checks\n\n"

		let matrices: [BoolMatrix] = [
			BoolMatrix(
				dimension: 3,
				rawFlattenedInt: [
					1, 1, 1,
					1, 0, 1,
					1, 1, 1,
				]
			),
			BoolMatrix(
				dimension: 3,
				rawFlattenedInt: [
					1, 0, 1,
					0, 1, 0,
					1, 0, 1,
				]
			),
			BoolMatrix(
				dimension: 3,
				rawFlattenedInt: [
					1, 0, 0,
					1, 1, 1,
					0, 0, 1,
				]
			),
			BoolMatrix(
				dimension: 3,
				rawFlattenedInt: [
					1, 0, 1,
					1, 0, 1,
					1, 0, 1,
				]
			),
			BoolMatrix(
				dimension: 4,
				rawFlattenedInt: [
					1, 1, 1, 0,
					0, 0, 1, 1,
					1, 0, 1, 1,
					1, 1, 0, 1,
				]
			),
			BoolMatrix(
				dimension: 5,
				rawFlattenedInt: [
					1, 1, 1, 1, 1,
					1, 1, 1, 1, 1,
					1, 1, 1, 1, 1,
					1, 1, 1, 1, 1,
					1, 1, 1, 1, 1,
				]
			)
		]

		let outputFolder = try outputFolder.subfolder(with: "pixel-alignment")

		try matrices.enumerated().forEach { matrix in

			markdownText += "## Matrix check\n\n"

			let allImages = try QRCodePixelShapeFactory.shared.generateSampleImages(
				dimension: 300,
				foregroundColor: .commonBlack,
				backgroundColor: CGColor.sRGBA(1, 0, 0, 1),
				isOn: true,
				samplePixelMatrix: matrix.element
			)

			try allImages.forEach { item in
				let n = "pixel-alignment-check-\(matrix.offset)-\(item.name).jpg"
				let image = try item.image.representation.jpeg(scale: 2, compression: 0.5)
				try outputFolder.write(image, to: n)
				markdownText += "<img src=\"./\(n)\" width=\"150\" /> &nbsp;"
			}
			markdownText += "\n\n"
		}

		// Write out a markdown file for easy presentation of the results
		try outputFolder.write(markdownText, to: "_pixel-alignment.md", encoding: .utf8)
	}

	func testCustomPixelMatrix4() throws {
		let d3 = BoolMatrix(
			dimension: 4,
			rawFlattenedInt: [
				1, 1, 0, 1,
				0, 1, 1, 0,
				1, 0, 1, 0,
				0, 1, 1, 1,
			])

		let im = try QRCodePixelShapeFactory.shared.image(
			pixelGenerator: QRCode.PixelShape.CurvePixel(cornerRadiusFraction: 1),
			dimension: 72,
			foregroundColor: CGColor.commonBlack,
			samplePixelMatrix: d3
		)

		let o1 = try im.representation.png(dpi: 144.0)
		try outputFolder.write(o1, to: "custom-pixelssample-4x4-36x36@2x.png")

		#if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
		
		// Convert to a @2x UIImage
		let uii = try XCTUnwrap(UIImage(cgImage: im, scale: 2, orientation: .up))
		XCTAssertEqual(CGSize(dimension: 36), uii.size)
		XCTAssertEqual(2, uii.scale)

		#elseif os(macOS)
		// Convert to a @2x NSImage

		// For some reason, this creator fails on GitHub actions, but runs fine locally
		//		let nsi = try XCTUnwrap(NSImage(cgImage: im4, size: CGSize(dimension: 36)))
		let nsi = NSImage(size: NSSize(dimension: 36))
		nsi.addRepresentation(NSBitmapImageRep(cgImage: im))

		XCTAssertEqual(CGSize(dimension: 36), nsi.size)
		XCTAssertEqual(nsi.representations.count, 1)
		XCTAssertEqual(nsi.representations[0].pixelsWide, 72)
		XCTAssertEqual(nsi.representations[0].pixelsHigh, 72)
		
		#endif
	}

	#if !os(watchOS)
	func testCGImageQuickGen() throws {
		do {
			let image = try CGImage.qrCode("This is a test!!!", dimension: 300)
			XCTAssertEqual(image.width, 300)
			XCTAssertEqual(image.height, 300)
			XCTAssertEqual(image.detectQRCodeStrings(), ["This is a test!!!"])

			try XCTValidateSingleQRCode(image, expectedText: "This is a test!!!")
		}

		do {
			let path = try CGPath.qrCode("This is a test!!!", dimension: 300)

			let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
			let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
			let ctx = try XCTUnwrap(CGContext(
					data: nil,
					width: 300,
					height: 300,
					bitsPerComponent: 8,
					bytesPerRow: 300 * 4,
					space: colorSpace,
					bitmapInfo: bitmapInfo.rawValue
				)
			)

			ctx.scaleBy(x: 1, y: -1)
			ctx.translateBy(x: 0, y: -300)

			ctx.setFillColor(.commonWhite)
			ctx.fill([CGRect(x: 0, y: 0, width: 300, height: 300)])

			ctx.addPath(path)
			ctx.setFillColor(.commonBlack)
			ctx.fillPath()

			let image = try XCTUnwrap(ctx.makeImage())
			XCTAssertEqual(image.detectQRCodeStrings(), ["This is a test!!!"])
		}
	}
	#endif

	func testBasicGeneration() throws {
		let code = try QRCode.Document(utf8String: "https://wildcaretas.org.au/tasmanian-nature-conservation-fund-grants/")
		let png = try code.cgImage(dimension: 300).representation.png(scale: 2)
		try outputFolder.write(png, to: "basic-qrcode-no-styling.png")
	}

	func testFormattedInitialiser() throws {
		let urlcontent = "https://wildcaretas.org.au/tasmanian-nature-conservation-fund-grants/"
		let url = URL(string: urlcontent)!
		let code = try QRCode.Document(.link(url))
		let image = try code.cgImage(dimension: 300)
		let png = try image.representation.png(scale: 2)
		try outputFolder.write(png, to: "basic-qrcode-formatted-input.png")

		try XCTValidateSingleQRCode(image, expectedText: urlcontent)
	}

	func testEncoding() throws {
		struct S1: Codable {
			let text: String
			let content: QRCode.Content
		}

		do {
			let d1 = S1(text: "hi there", content: .data(Data([0, 1, 2, 3])))
			let enc1 = try JSONEncoder().encode(d1)

//			let enc1s = String(data: enc1, encoding: .utf8)
//			Swift.print(enc1s)

			let d2 = try JSONDecoder().decode(S1.self, from: enc1)
			if case let .data(ddd) = d2.content {
				XCTAssertEqual(Data([0, 1, 2, 3]), ddd)
			}
		}

		do {
			let d1 = S1(text: "hi there", content: .text("Wheee"))
			let enc1 = try JSONEncoder().encode(d1)
			let d2 = try JSONDecoder().decode(S1.self, from: enc1)
			if case let .text(ddd) = d2.content {
				XCTAssertEqual("Wheee", ddd)
			}
		}
	}
}
