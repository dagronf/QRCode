import XCTest
@testable import QRCode

final class QRCodeLoadSaveTests: XCTestCase {

	let outputFolder = try! testResultsContainer.subfolder(with: "QRCodeLoadSaveTests")

	func testBasic() throws {
		let doc1 = QRCode.Document(generator: __testGenerator)
		doc1.data = "this is a test".data(using: .utf8)!

		let data = try XCTUnwrap(doc1.jsonData())

		let doc2 = try QRCode.Document.Create(jsonData: data, generator: __testGenerator)

		// Data should be the same
		XCTAssertEqual(doc2.data, doc1.data)

		// Should default to square pixels
		_ = try XCTUnwrap(doc2.design.shape.onPixels as? QRCode.PixelShape.Square)
	}

	func testBasicPixelEncodeDecode() throws {

		do {
			let doc = QRCode.Document(generator: __testGenerator)
			doc.data = "this is a test".data(using: .utf8)!
			doc.design.shape.onPixels = QRCode.PixelShape.Circle(insetFraction: 0.2)
			doc.design.shape.eye = QRCode.EyeShape.Leaf()

			let data = try XCTUnwrap(doc.jsonData())

			let doc2 = try QRCode.Document.Create(jsonData: data, generator: __testGenerator)

			// Make sure the data shape comes back out
			let shape = try XCTUnwrap(doc2.design.shape.onPixels as? QRCode.PixelShape.Circle)
			XCTAssertEqual(shape.insetFraction, 0.2)

			// Make sure the eye shape comes back out
			let _ = try XCTUnwrap(doc2.design.shape.eye as? QRCode.EyeShape.Leaf)
		}

		do {
			let doc = QRCode.Document(generator: __testGenerator)
			doc.data = "this is a test".data(using: .utf8)!
			doc.design.shape.onPixels = QRCode.PixelShape.RoundedRect(cornerRadiusFraction: 0.8, insetFraction: 0.2)
			let data = try XCTUnwrap(doc.jsonData())
			let doc2 = try QRCode.Document.Create(jsonData: data, generator: __testGenerator)
			let shape = try XCTUnwrap(doc2.design.shape.onPixels as? QRCode.PixelShape.RoundedRect)
			XCTAssertEqual(shape.insetFraction, 0.2, accuracy: 0.0001)
			XCTAssertEqual(shape.cornerRadiusFraction, 0.8, accuracy: 0.0001)
		}

		do {
			let doc = QRCode.Document(generator: __testGenerator)
			doc.data = "this is a test and fishes like squircles".data(using: .utf8)!
			doc.design.shape.onPixels = QRCode.PixelShape.Squircle(insetFraction: 0.6)
			let data = try XCTUnwrap(doc.jsonData())
			let doc2 = try QRCode.Document.Create(jsonData: data, generator: __testGenerator)
			let shape = try XCTUnwrap(doc2.design.shape.onPixels as? QRCode.PixelShape.Squircle)
			XCTAssertEqual(shape.insetFraction, 0.6, accuracy: 0.0001)
		}
	}

	func testBasicJSON() throws {
		let json = """
		{
			"correction": "H",
			"data": "dGhpcyBpcyBhIHRlc3Q=",
		}
		"""

		let data = json.data(using: .utf8)!
		let doc = try QRCode.Document.Create(jsonData: data, generator: __testGenerator)

		let msg = try XCTUnwrap(String(data: try XCTUnwrap(doc.data), encoding: .utf8))
		XCTAssertEqual("this is a test", msg)
		XCTAssertEqual(doc.errorCorrection, .high)
		XCTAssertNotEqual(doc.errorCorrection, .low)
	}

	func testSimpleFillStyleEncoding() throws {

		let doc1 = QRCode.Document(generator: __testGenerator)
		doc1.data = "simple colors".data(using: .utf8)!
		doc1.errorCorrection = .quantize

		doc1.design.style.onPixels = QRCode.FillStyle.Solid(CGColor(red: 1, green: 0, blue: 0, alpha: 1))
		doc1.design.style.offPixels = QRCode.FillStyle.Solid(CGColor(red: 0, green: 1, blue: 0, alpha: 0.1))
		doc1.design.style.background = QRCode.FillStyle.Solid(CGColor(red: 0, green: 0, blue: 1, alpha: 0.5))

		doc1.design.style.eye = QRCode.FillStyle.LinearGradient(
			DSFGradient(pins: [
				DSFGradient.Pin(CGColor(gray: 0.5, alpha: 0.5), 0),
				DSFGradient.Pin(CGColor(gray: 1.0, alpha: 0.1), 1)
				]
			)!
		)

		let data = try XCTUnwrap(doc1.jsonData())

		let doc2 = try QRCode.Document.Create(jsonData: data, generator: __testGenerator)
		XCTAssertEqual(doc1.data, doc2.data)
		XCTAssertEqual(doc1.errorCorrection, doc2.errorCorrection)
	}

	func testSolidFillLoadSave() throws {
		let c = QRCode.FillStyle.Solid(CGColor(red: 0.5, green: 0.5, blue: 1, alpha: 0.8))
		let ctc = try XCTUnwrap(c.color.sRGBAComponents())
		let core = c.coreSettings()

		let st: QRCode.FillStyle.Solid = try XCTUnwrap(FillStyleFactory.Create(settings: core) as? QRCode.FillStyle.Solid)
		XCTAssertEqual(st.color.alpha, c.color.alpha)
		let stc = try XCTUnwrap(st.color.sRGBAComponents())

		// Make sure we loaded the color back correctly
		XCTAssertEqual(ctc.r, stc.r)
		XCTAssertEqual(ctc.g, stc.g)
		XCTAssertEqual(ctc.b, stc.b)
		XCTAssertEqual(ctc.a, stc.a)
	}

	func testRadialGradientLoadSave() throws {
		let c = QRCode.FillStyle.RadialGradient(
			DSFGradient(pins: [
				DSFGradient.Pin(CGColor.black, 0),
				DSFGradient.Pin(CGColor(gray: 0.5, alpha: 0.5), 0.5),
				DSFGradient.Pin(CGColor.white, 1)
				]
			)!,
			centerPoint: CGPoint(x: 0.2, y: 0.8))

		let core = c.coreSettings()

		let st: QRCode.FillStyle.RadialGradient = try XCTUnwrap(FillStyleFactory.Create(settings: core) as? QRCode.FillStyle.RadialGradient)
		XCTAssertEqual(0.2, st.centerPoint.x, accuracy: 0.0001)
		XCTAssertEqual(0.8, st.centerPoint.y, accuracy: 0.0001)
		XCTAssertEqual(c.gradient.pins.count, st.gradient.pins.count)
		XCTAssertEqual(c.gradient.pins.map { $0.position }, st.gradient.pins.map { $0.position })
	}

	func testLoadSaveNegatedOnPixelsOnly() throws {
		#if os(watchOS)
		let generator = QRCodeGenerator_External()
		#else
		let generator: QRCodeEngine? = nil
		#endif

		let doc = QRCode.Document(utf8String: "checking negative value set", generator: generator)
		doc.design.shape.negatedOnPixelsOnly = true

		let settings = doc.settings()

		let doc2 = try QRCode.Document(dictionary: settings, generator: generator)
		XCTAssertEqual(true, doc2.design.shape.negatedOnPixelsOnly)
		let data1 = try XCTUnwrap(doc2.imageData(.jpg(compression: 0.2), dimension: 300))
		try outputFolder.write(data1, to: "NegatedQRCodeTestFile-on.jpg")

		doc2.design.shape.negatedOnPixelsOnly = false
		let settings3 = doc2.settings()
		let doc3 = try QRCode.Document(dictionary: settings3, generator: generator)
		XCTAssertEqual(false, doc3.design.shape.negatedOnPixelsOnly)

		let data2 = try XCTUnwrap(doc3.imageData(.jpg(compression: 0.5), dimension: 300))
		try outputFolder.write(data2, to: "NegatedQRCodeTestFile-off.jpg")
	}

	func testEncodeDecodeShield() throws {
		do {
			let doc = QRCode.Document(utf8String: "This is testing of shield encoding/decoding")
			doc.design.shape.eye = QRCode.EyeShape.Shield()

			let d1 = try doc.jsonData()
			let recon = try QRCode.Document.Create(jsonData: d1)

			let eye = try XCTUnwrap(recon.design.shape.eye as? QRCode.EyeShape.Shield)
			XCTAssertEqual(eye.corners, .all)

			let pupil = try XCTUnwrap(recon.design.shape.actualPupilShape as? QRCode.PupilShape.Shield)
			XCTAssertEqual(pupil.corners, .all)
		}

		do {
			let doc = QRCode.Document(utf8String: "This is testing of shield encoding/decoding")
			doc.design.shape.eye = QRCode.EyeShape.Shield(corners: [.tr, .bl])

			let d1 = try doc.jsonData()
			let recon = try QRCode.Document.Create(jsonData: d1)

			let eye = try XCTUnwrap(recon.design.shape.eye as? QRCode.EyeShape.Shield)
			XCTAssertEqual(eye.corners, [.tr, .bl])

			// Pupil corners should match the eye corners

			let pupil = try XCTUnwrap(recon.design.shape.actualPupilShape as? QRCode.PupilShape.Shield)
			XCTAssertEqual(pupil.corners, [.tr, .bl])
		}

		do {
			let doc = QRCode.Document(utf8String: "This is testing of shield encoding/decoding")
			doc.design.shape.eye = QRCode.EyeShape.Shield(corners: [.tl, .br])
			doc.design.shape.pupil = QRCode.PupilShape.Shield(corners: [.bl])

			let d1 = try doc.jsonData()
			let recon = try QRCode.Document.Create(jsonData: d1)

			let eye = try XCTUnwrap(recon.design.shape.eye as? QRCode.EyeShape.Shield)
			XCTAssertEqual(eye.corners, [.tl, .br])

			let pupil = try XCTUnwrap(recon.design.shape.actualPupilShape as? QRCode.PupilShape.Shield)
			XCTAssertEqual(pupil.corners, [.bl])
		}
	}

}
