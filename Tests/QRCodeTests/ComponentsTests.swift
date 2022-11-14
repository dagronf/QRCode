import XCTest
@testable import QRCode

final class ComponentsTests: XCTestCase {


	func testCore() throws {
		XCTAssertEqual(2, "catdogcat".termCount("cat"))
		XCTAssertEqual(2, "dogcatcat".termCount("cat"))
		XCTAssertEqual(1, "dogcAtcat".termCount("cat"))
		XCTAssertEqual(1, "caterpillar".termCount("cat"))
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
