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
		let shape = try XCTUnwrap(doc2.design.shape.data as? QRCode.DataShape.Pixel)
		XCTAssertEqual(shape.pixelType, .square)
	}

	func testBasicPixelEncodeDecode() throws {
		let doc1 = QRCode.Document()
		doc1.data = "this is a test".data(using: .utf8)!
		doc1.design.shape.data = QRCode.DataShape.Pixel(pixelType: .circle)
		doc1.design.shape.eye = QRCode.EyeShape.Leaf()

		let data = try XCTUnwrap(doc1.jsonData())

		let doc2 = try QRCode.Document.Create(jsonData: data)

		let shape = try XCTUnwrap(doc2.design.shape.data as? QRCode.DataShape.Pixel)
		XCTAssertEqual(QRCode.DataShape.Pixel.Name, doc2.design.shape.data.name)
		let _ = try XCTUnwrap(doc2.design.shape.data as? QRCode.DataShape.Pixel)
		XCTAssertEqual(shape.pixelType, .circle)

		XCTAssertEqual(doc2.design.shape.eye.name, QRCode.EyeShape.Leaf.Name)
		let _ = try XCTUnwrap(doc2.design.shape.eye as? QRCode.EyeShape.Leaf)
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
		let msg2 = try XCTUnwrap(String(data: doc2.data, encoding: .utf8))
		XCTAssertEqual(msg2, "simple colors")


//		let msg = try XCTUnwrap(String(data: doc.data, encoding: .utf8))
//		XCTAssertEqual("this is a test", msg)
//		XCTAssertEqual(doc.errorCorrection, .high)
//		XCTAssertNotEqual(doc.errorCorrection, .low)
	}
}
