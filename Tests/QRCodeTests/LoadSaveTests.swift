import XCTest
@testable import QRCode

final class QRCodeLoadSaveTests: XCTestCase {
	func testBasic() throws {
		let doc1 = QRCode.Document()
		doc1.data = "this is a test".data(using: .utf8)!

		let data = try XCTUnwrap(doc1.jsonData())

		let doc2 = try QRCode.Document.Create(jsonData: data)

		// Data should be the same
		XCTAssertEqual(doc2.data, doc1.data)

		// Should default to square pixels
		_ = try XCTUnwrap(doc2.design.shape.data as? QRCode.DataShape.Square)
	}

	func testBasicPixelEncodeDecode() throws {

		do {
			let doc = QRCode.Document()
			doc.data = "this is a test".data(using: .utf8)!
			doc.design.shape.data = QRCode.DataShape.Circle(inset: 2)
			doc.design.shape.eye = QRCode.EyeShape.Leaf()

			let data = try XCTUnwrap(doc.jsonData())

			let doc2 = try QRCode.Document.Create(jsonData: data)

			// Make sure the data shape comes back out
			let shape = try XCTUnwrap(doc2.design.shape.data as? QRCode.DataShape.Circle)
			XCTAssertEqual(shape.inset, 2)

			// Make sure the eye shape comes back out
			let _ = try XCTUnwrap(doc2.design.shape.eye as? QRCode.EyeShape.Leaf)
		}

		do {
			let doc = QRCode.Document()
			doc.data = "this is a test".data(using: .utf8)!
			doc.design.shape.data = QRCode.DataShape.RoundedRect(inset: 1.1, cornerRadiusFraction: 0.8)
			let data = try XCTUnwrap(doc.jsonData())
			let doc2 = try QRCode.Document.Create(jsonData: data)
			let shape = try XCTUnwrap(doc2.design.shape.data as? QRCode.DataShape.RoundedRect)
			XCTAssertEqual(shape.inset, 1.1, accuracy: 0.0001)
			XCTAssertEqual(shape.cornerRadiusFraction, 0.8, accuracy: 0.0001)
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
		let doc = try QRCode.Document.Create(jsonData: data)

		let msg = try XCTUnwrap(String(data: doc.data, encoding: .utf8))
		XCTAssertEqual("this is a test", msg)
		XCTAssertEqual(doc.errorCorrection, .high)
		XCTAssertNotEqual(doc.errorCorrection, .low)
	}

	func testSimpleFillStyleEncoding() throws {

		let doc1 = QRCode.Document()
		doc1.data = "simple colors".data(using: .utf8)!
		doc1.errorCorrection = .quantize

		doc1.design.style.data = QRCode.FillStyle.Solid(CGColor(red: 1, green: 0, blue: 0, alpha: 1))
		doc1.design.style.dataInverted = QRCode.FillStyle.Solid(CGColor(red: 0, green: 1, blue: 0, alpha: 0.1))
		doc1.design.style.background = QRCode.FillStyle.Solid(CGColor(red: 0, green: 0, blue: 1, alpha: 0.5))

		doc1.design.style.eye = QRCode.FillStyle.LinearGradient(
			DSFGradient(pins: [
				DSFGradient.Pin(CGColor(gray: 0.5, alpha: 0.5), 0),
				DSFGradient.Pin(CGColor(gray: 1.0, alpha: 0.1), 1)
				]
			)!
		)

		let data = try XCTUnwrap(doc1.jsonData())

		let doc2 = try QRCode.Document.Create(jsonData: data)
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
}
