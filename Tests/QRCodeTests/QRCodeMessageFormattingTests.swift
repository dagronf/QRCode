import XCTest
import QRCode

final class QRCodeMessageFormattingTests: XCTestCase {

	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testMessageFormatter1() throws {
		let url = URL(string: "https://www.apple.com/mac-studio/")!
		let code = try QRCode.Document(.link(url))
		let outputImage = try code.cgImage(dimension: 150)

		#if !os(watchOS)
		try XCTValidateSingleQRCode(outputImage, expectedText: "https://www.apple.com/mac-studio/")
		#endif
	}

	func testMessageFormatter2() throws {
		let message = "बिलार आ कुकुर आ मछरी आ चिरई-चुरुंग के"
		let code = try QRCode.Document(.text(message))

		let outputImage = try code.cgImage(dimension: 150)
		try XCTValidateSingleQRCode(outputImage, expectedText: message)
	}

	func testBasicQRCode() throws {

		let url = URL(string: "https://www.apple.com.au/")!
		let doc = try QRCode.Document(.link(url), errorCorrection: .high, engine: __testEngine)

		let boomat = doc.boolMatrix
		XCTAssertEqual(35, boomat.dimension)
	}

	func testEvent() throws {
		let components = DateComponents(
			calendar: Calendar.current,
			timeZone: TimeZone(identifier: "America/Los_Angeles"), 
			year: 2024,
			month: 6,
			day: 10,
			hour: 10,
			minute: 0,
			second: 0
		)
		let startDate = try XCTUnwrap(components.date)

		let doc = try QRCode.Document(
			.event(
				summary: "WWDC Keynote 2024",
				location: "Apple Spaceship",
				start: startDate,
				end: startDate.addingTimeInterval(3600 * 2)
			)
		)

		let image = try doc.cgImage(dimension: 300)

		// VEVENT expects \r\n

		let expected = """
			BEGIN:VEVENT\r
			SUMMARY:WWDC Keynote 2024\r
			LOCATION:Apple Spaceship\r
			DTSTART:20240610T170000Z\r
			DTEND:20240610T190000Z\r
			END:VEVENT
			"""

		try XCTValidateSingleQRCode(image, expectedText: expected)
	}
}
