import XCTest
@testable import QRCode
@testable import QRCodeExternal

#if os(watchOS)

final class QRCodeWatchOSTests: XCTestCase {
	func testBasic() throws {
		do {
			let doc = QRCode.Document(
				utf8String: "Hi there from external generator (watchOS)",
				errorCorrection: .high,
				generator: QRCodeGenerator_External()
			)

			let svg = doc.svg(dimension: 800)

			XCTAssertEqual(3, svg.termCount("fill=\"#000000\""))

			try svg.writeToTempFile(named: "BasicCreateWatchImage.svg")

			let image = doc.uiImage(dimension: 800)!
			let data = image.pngRepresentation()!
			try data.writeToTempFile(named: "BasicCreateWatchImage.png")	
		}
	}
}

#endif
