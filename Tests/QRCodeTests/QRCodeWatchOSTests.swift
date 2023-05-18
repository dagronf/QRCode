import XCTest
@testable import QRCode

#if os(watchOS)

final class QRCodeWatchOSTests: XCTestCase {

	let outputFolder = try! testResultsContainer.subfolder(with: "QRCodeWatchOSTests")

	func testBasic() throws {
		do {
			let doc = QRCode.Document(
				utf8String: "Hi there from external generator (watchOS)",
				errorCorrection: .high,
				generator: QRCodeGenerator_External()
			)

			let svg = doc.svg(dimension: 800)

			XCTAssertEqual(3, svg.termCount("fill=\"#000000\""))

			try outputFolder.write(svg, to: "BasicCreateWatchImage.svg")

			let image = doc.uiImage(dimension: 800)!
			let data = image.pngRepresentation()!
			try outputFolder.write(data, to: "BasicCreateWatchImage.png")
		}
	}
}

#endif
