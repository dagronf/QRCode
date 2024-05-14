import XCTest
@testable import QRCode

#if os(watchOS)

final class QRCodeWatchOSTests: XCTestCase {

	let outputFolder = try! testResultsContainer.subfolder(with: "QRCodeWatchOSTests")

	func testBasic() throws {
		do {
			let doc = try QRCode.Document(
				"Hi there from external generator (watchOS)",
				errorCorrection: .high,
				engine: QRCodeEngine_External()
			)

			let svg = try doc.svg(dimension: 800)

			XCTAssertEqual(3, svg.termCount("fill=\"#000000\""))

			try outputFolder.write(svg, to: "BasicCreateWatchImage.svg")

			let data = try XCTUnwrap(doc.uiImage(dimension: 800).pngData())
			try outputFolder.write(data, to: "BasicCreateWatchImage.png")
		}
	}
}

#endif
