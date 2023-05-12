import XCTest
@testable import QRCode
final class QRCodeTests: XCTestCase {
	func testBasicQRCode() throws {
		let doc = QRCode(generator: __testGenerator)
		let url = URL(string: "https://www.apple.com.au/")!
		doc.update(message: QRCode.Message.Link(url), errorCorrection: .high)

		let boomat = doc.boolMatrix
		XCTAssertEqual(35, boomat.dimension)
	}

	func testAsciiGenerationWorks() throws {
		let doc = QRCode.Document(generator: __testGenerator)
		doc.errorCorrection = .low
		doc.data = "testing".data(using: .utf8)!
		let ascii = doc.asciiRepresentation
		Swift.print(ascii)

		let doc2 = QRCode.Document(generator: __testGenerator)
		doc2.errorCorrection = .low
		doc2.data = "testing".data(using: .utf8)!
		let ascii2 = doc2.smallAsciiRepresentation
		Swift.print(ascii2)
	}

	func testBasicEncodeDecode() throws {
		do {
			let doc1 = QRCode.Document(generator: __testGenerator)
			doc1.data = "this is a test".data(using: .utf8)!

			let s = doc1.settings()
			let doc11 = try QRCode.Document.Create(settings: s, generator: __testGenerator)
			XCTAssertNotNil(doc11)

			let data = try XCTUnwrap(doc1.jsonData())
			let dataStr = try XCTUnwrap(doc1.jsonStringFormatted())

			let doc111 = try XCTUnwrap(QRCode.Document.Create(jsonData: data, generator: __testGenerator))
			XCTAssertNotNil(doc111)
			let data111Str = try XCTUnwrap(doc111.jsonStringFormatted())
			XCTAssertEqual(dataStr, data111Str)
		}
		catch {
			fatalError("Caught exception")
		}
	}

	func testBasicEncodeDecodeWithCustomPupil() throws {
		do {
			let doc1 = QRCode.Document(generator: __testGenerator)
			doc1.data = "this is a test".data(using: .utf8)!
			doc1.design.shape.pupil = QRCode.PupilShape.Circle()

			let s = doc1.settings()
			let doc11 = try QRCode.Document.Create(settings: s, generator: __testGenerator)
			XCTAssertNotNil(doc11)

			let data = try XCTUnwrap(doc1.jsonData())
			let dataStr = try XCTUnwrap(doc1.jsonStringFormatted())

			let doc111 = try XCTUnwrap(QRCode.Document.Create(jsonData: data, generator: __testGenerator))
			XCTAssertNotNil(doc111)
			let data111Str = try XCTUnwrap(doc111.jsonStringFormatted())
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
			let doc = QRCode.Document(utf8String: "Hi there!", errorCorrection: .high, generator: __testGenerator)
			doc.design.backgroundColor(CGColor.clear)
			doc.design.foregroundColor(CGColor.white)
			let image = doc.cgImage(CGSize(width: 800, height: 800))
			let _ = try XCTUnwrap(image)
		}
	}

	func testNewGeneratePath() throws {
		let g = QRCode.PixelShape.RoundedPath(cornerRadiusFraction: 0.7, hasInnerCorners: true)
		let image = QRCodePixelShapeFactory.shared.image(
			pixelGenerator: g,
			dimension: 300,
			foregroundColor: CGColor.black
		)
		XCTAssertNotNil(image)

		let doc = QRCode.Document(utf8String: "Hi there!", errorCorrection: .high, generator: __testGenerator)
		doc.design.shape.onPixels = QRCode.PixelShape.RoundedPath(cornerRadiusFraction: 0.7, hasInnerCorners: true)

		doc.design.shape.offPixels = QRCode.PixelShape.CurvePixel(cornerRadiusFraction: 1)
		doc.design.style.offPixels = QRCode.FillStyle.Solid(gray: 0.9)

		let cgi = doc.cgImage(dimension: 600)!
		Swift.print(cgi)
		#if os(macOS)
		let nsi = NSImage(cgImage: cgi, size: CGSize(dimension: 300))
		Swift.print(nsi)
		#endif
	}

	func testGenerateImagesAtDifferentResolutions() throws {
		let doc = QRCode.Document(utf8String: "Generate content QR", errorCorrection: .high, generator: __testGenerator)
		doc.design.shape.onPixels = QRCode.PixelShape.Circle()

		let dpis = [(300, 72.0, "", 300), (600, 144.0, "@2x", 300), (900, 216.0, "@3x", 300)]
#if os(macOS)
		do {
			for dpi in dpis {
				let data = try XCTUnwrap(doc.pngData(dimension: dpi.0, dpi: dpi.1))
				let url = try data.writeToTempFile(named: "dpi-test-output\(dpi.2).png")
				let im = try XCTUnwrap(NSImage(contentsOf: url))
				XCTAssertEqual(CGSize(dimension: dpi.3), im.size)
				XCTAssertEqual(dpi.0, im.representations[0].pixelsWide)
				XCTAssertEqual(dpi.0, im.representations[0].pixelsHigh)
			}
		}

		do {
			for dpi in dpis {
				let data = try XCTUnwrap(doc.tiffData(dimension: dpi.0, dpi: dpi.1))
				let url = try data.writeToTempFile(named: "dpi-test-output\(dpi.2).tiff")
				let im = try XCTUnwrap(NSImage(contentsOf: url))
				XCTAssertEqual(CGSize(dimension: dpi.3), im.size)
				XCTAssertEqual(dpi.0, im.representations[0].pixelsWide)
				XCTAssertEqual(dpi.0, im.representations[0].pixelsHigh)
			}
		}

		do {
			for dpi in dpis {
				let data = try XCTUnwrap(doc.jpegData(dimension: dpi.0, dpi: dpi.1, compression: 0.4))
				let url = try data.writeToTempFile(named: "dpi-test-output\(dpi.2).jpg")
				let im = try XCTUnwrap(NSImage(contentsOf: url))
				XCTAssertEqual(CGSize(dimension: dpi.3), im.size)
				XCTAssertEqual(dpi.0, im.representations[0].pixelsWide)
				XCTAssertEqual(dpi.0, im.representations[0].pixelsHigh)
			}
		}
#else
		do {
			for dpi in dpis {
				let data = try XCTUnwrap(doc.pngData(dimension: dpi.0, dpi: dpi.1))
				let url = try data.writeToTempFile(named: "dpi-test-output\(dpi.2).png")
				let im = try XCTUnwrap(UIImage(contentsOfFile: url.path))
				XCTAssertEqual(CGSize(dimension: dpi.3), im.size)
			}
		}

		do {
			for dpi in dpis {
				let data = try XCTUnwrap(doc.tiffData(dimension: dpi.0, dpi: dpi.1))
				let url = try data.writeToTempFile(named: "dpi-test-output\(dpi.2).tiff")
				let im = try XCTUnwrap(UIImage(contentsOfFile: url.path))
				XCTAssertEqual(CGSize(dimension: dpi.3), im.size)
			}
		}

#endif

		do {
			let data = try XCTUnwrap(doc.pdfData(dimension: 300))
			try data.writeToTempFile(named: "dpi-test-output.pdf")
		}

		do {
			let data = try XCTUnwrap(doc.svgData(dimension: 300))
			try data.writeToTempFile(named: "dpi-test-output.svg")
		}
	}

	func testQuietSpace() throws {

		do {
			let doc = QRCode.Document(utf8String: "Hi there!", errorCorrection: .high, generator: __testGenerator)
			doc.design.shape.onPixels = QRCode.PixelShape.Circle(insetFraction: 0.4)
			//doc.design.style.onPixels = QRCode.FillStyle.Solid(1, 0, 0)
			doc.design.style.onPixelsBackground = CGColor.black

			// radial fill
			let c = QRCode.FillStyle.RadialGradient(
				DSFGradient(
					pins: [
						DSFGradient.Pin(CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1), 0),
						DSFGradient.Pin(CGColor(srgbRed: 0, green: 1, blue: 0, alpha: 1), 0.5),
						DSFGradient.Pin(CGColor(srgbRed: 0, green: 0, blue: 1, alpha: 1), 1.0),
					]
				)!,
				centerPoint: CGPoint(x: 0.5, y: 0.5)
			)
			doc.design.style.onPixels = c


			doc.design.style.eyeBackground = CGColor(red: 0, green: 1, blue: 1, alpha: 1)

			doc.design.shape.offPixels = QRCode.PixelShape.Flower(insetFraction: 0.2)
			doc.design.style.offPixels = QRCode.FillStyle.Solid(0, 1, 0)

			let gradient = DSFGradient(
				pins: [
					DSFGradient.Pin(CGColor(red: 1, green: 1, blue: 0, alpha: 1.000), 0),
					DSFGradient.Pin(CGColor(red: 0, green: 1, blue: 1, alpha: 1.000), 1),
				]
			)!
			doc.design.style.offPixels = QRCode.FillStyle.LinearGradient(
				gradient,
				startPoint: CGPoint(x: 0, y: 1),
				endPoint: CGPoint(x: 1, y: 1)
			)

			doc.design.style.offPixelsBackground = CGColor.white

			let logoURL = try XCTUnwrap(Bundle.module.url(forResource: "photo-logo", withExtension: "jpg"))
			let logoImage = try XCTUnwrap(CommonImage(contentsOfFile: logoURL.path)?.cgImage())
			doc.design.style.background = QRCode.FillStyle.Image(logoImage)

			doc.design.additionalQuietZonePixels = 8

			let image = try XCTUnwrap(doc.cgImage(dimension: 800))
			XCTAssertEqual(image.width, 800)
			XCTAssertEqual(image.height, 800)
		}

		do {
			let doc = QRCode.Document(utf8String: "Hi there!", errorCorrection: .high, generator: __testGenerator)
			//doc.design.additionalQuietSpace = 100

			let logoURL = try XCTUnwrap(Bundle.module.url(forResource: "photo-logo", withExtension: "jpg"))
			let logoImage = try XCTUnwrap(CommonImage(contentsOfFile: logoURL.path)?.cgImage())
			doc.design.style.onPixels = QRCode.FillStyle.Image(logoImage)

			let image = try XCTUnwrap(doc.cgImage(dimension: 800))
			XCTAssertEqual(image.width, 800)
			XCTAssertEqual(image.height, 800)
		}
	}
}
