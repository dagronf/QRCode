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
			DSFGradient.Pin(CGColor.RGBA(1, 1, 0, 1), 0.2),
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

	func testCGPathApplyWithBlockLegacy() throws {

		// Basic verification that the 'legacy' applyWithBlock wrapper returns the same results.

		do {
			let pth = CGPath(roundedRect: CGRect(x: 0, y: 0, width: 200, height: 300), cornerWidth: 20, cornerHeight: 30, transform: nil)
			var msg1 = ""
			pth.applyWithBlock { item in
				let element = item.pointee
				switch element.type {
				case .moveToPoint:          msg1 += "moveToPoint"
				case .addLineToPoint:       msg1 += "addLineToPoint"
				case .addQuadCurveToPoint:  msg1 += "addQuadCurveToPoint"
				case .addCurveToPoint:      msg1 += "addCurveToPoint"
				case .closeSubpath:         msg1 += "closeSubpath"
				default:
					msg1 += "<ERROR>"
				}
				msg1 += ":"
			}

			var msg2 = ""
			pth.applyWithBlockLegacy { item in
				let element = item.pointee
				switch element.type {
				case .moveToPoint:          msg2 += "moveToPoint"
				case .addLineToPoint:       msg2 += "addLineToPoint"
				case .addQuadCurveToPoint:  msg2 += "addQuadCurveToPoint"
				case .addCurveToPoint:      msg2 += "addCurveToPoint"
				case .closeSubpath:         msg2 += "closeSubpath"
				default:
					msg2 += "<ERROR>"
				}
				msg2 += ":"
			}

			XCTAssertEqual(msg1, msg2)
		}

		do {

			let pth = CGPath.make { path in
				path.move(to: CGPoint(x: 10, y: 10))
				path.addLine(to: CGPoint(x: 30, y: 30))
				path.addQuadCurve(to: CGPoint(x: 200, y: 200), control: CGPoint(x: 100, y: 100))
				path.addCurve(to: CGPoint(x: 20, y: 400), control1: CGPoint(x: 150, y: 120), control2: CGPoint(x: 100, y: 350))
				path.closeSubpath()
				path.move(to: CGPoint(x: 200, y: 200))
				path.addLine(to: CGPoint(x: 230, y: 230))
				path.addLine(to: CGPoint(x: 260, y: 210))
				path.closeSubpath()
			}

			var msg1 = ""
			pth.applyWithBlock { item in
				let element = item.pointee
				switch element.type {
				case .moveToPoint:          msg1 += "moveToPoint"
				case .addLineToPoint:       msg1 += "addLineToPoint"
				case .addQuadCurveToPoint:  msg1 += "addQuadCurveToPoint"
				case .addCurveToPoint:      msg1 += "addCurveToPoint"
				case .closeSubpath:         msg1 += "closeSubpath"
				default:
					msg1 += "<ERROR>"
				}
				msg1 += ":"
			}

			var msg2 = ""
			pth.applyWithBlockLegacy { item in
				let element = item.pointee
				switch element.type {
				case .moveToPoint:          msg2 += "moveToPoint"
				case .addLineToPoint:       msg2 += "addLineToPoint"
				case .addQuadCurveToPoint:  msg2 += "addQuadCurveToPoint"
				case .addCurveToPoint:      msg2 += "addCurveToPoint"
				case .closeSubpath:         msg2 += "closeSubpath"
				default:
					msg2 += "<ERROR>"
				}
				msg2 += ":"
			}

			XCTAssertEqual(msg1, msg2)
		}
	}

}
