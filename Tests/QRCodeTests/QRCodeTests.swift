import XCTest
@testable import QRCode

final class QRCodeTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        //XCTAssertEqual(QRCodeView().text, "Hello, World!")

//		 let q = QRCode.Message.Mail(mailTo: "poodlebox@pobox.eu",
//											  subject: "This is a test!",
//											  body: "Groovy and wonderful bits")

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
}
