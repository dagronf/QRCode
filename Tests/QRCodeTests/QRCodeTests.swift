import XCTest
@testable import QRCode
@testable import QRCode3rdPartyGenerator

final class QRCodeTests: XCTestCase {

	private func performTest(closure: () throws -> Void) {
		do {
			try closure()
		}
		catch {
			XCTFail("Unexpected error thrown: \(error)")
		}
	}


    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        //XCTAssertEqual(QRCodeView().text, "Hello, World!")

//		 let q = QRCode.Message.Mail(mailTo: "poodlebox@pobox.eu",
//											  subject: "This is a test!",
//											  body: "Groovy and wonderful bits")

		 let doc = QRCode.Document()
		 doc.errorCorrection = .low
		 doc.data = "testing".data(using: .utf8)!
		 let ascii = doc.asciiRepresentation
		 Swift.print(ascii)

		 let doc2 = QRCode.Document()
		 doc2.errorCorrection = .low
		 doc2.data = "testing".data(using: .utf8)!
		 let ascii2 = doc2.smallAsciiRepresentation
		 Swift.print(ascii2)
    }

	func testDSFGradient() {
		let gps1 = [
			DSFGradient.Pin(CGColor.white, 1.0),
			DSFGradient.Pin(CGColor.black, 0.0),
			DSFGradient.Pin(CGColor(red: 1, green: 1, blue: 0, alpha: 1.0), 0.2),
		]
		let g1 = DSFGradient(pins: gps1)
		let arc = try! XCTUnwrap(g1?.asRGBAGradientString())
		let g11 = try! XCTUnwrap(DSFGradient.FromRGBAGradientString(arc))

		XCTAssertEqual(g11.pins[0].position, 0.0)
		XCTAssertEqual(g11.pins[1].position, 0.2)
		XCTAssertEqual(g11.pins[2].position, 1.0)

		let g11c = g11.copyGradient()
		XCTAssertEqual(g11c.pins[0].position, 0.0)
		XCTAssertEqual(g11c.pins[1].position, 0.2)
		XCTAssertEqual(g11c.pins[2].position, 1.0)
	}


	func testBasicEncodeDecode() throws {
		do {
			let doc1 = QRCode.Document()
			doc1.data = "this is a test".data(using: .utf8)!

			let s = doc1.settings()
			let doc11 = try QRCode.Document.Create(settings: s)
			XCTAssertNotNil(doc11)

			let data = try XCTUnwrap(doc1.jsonData())
			let dataStr = try XCTUnwrap(doc1.jsonStringFormatted())

			let doc111 = try XCTUnwrap(QRCode.Document.Create(jsonData: data))
			XCTAssertNotNil(doc111)
			let data111Str = try XCTUnwrap(doc111.jsonStringFormatted())
			XCTAssertEqual(dataStr, data111Str)
		}
		catch {
			fatalError("Caught exception")
		}
	}
}
