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

	func testEventYearFormatterCheck() throws {
		// This is a check to make sure our YEAR formatting in the event formatter is correct.
		// Accidentally using YYYY in the date formatter has unexpected results
		// See: https://dev.to/shane/yyyy-vs-yyyy-the-day-the-java-date-formatter-hurt-my-brain-4527

		let components = DateComponents(
			calendar: .current,
			timeZone: TimeZone(identifier: "UTC"),
			year: 2019,
			month: 12,
			day: 31,
			hour: 10,
			minute: 0,
			second: 0
		)
		let d1 = try XCTUnwrap(components.date)

		let df = DateFormatter()
		df.timeZone = TimeZone(abbreviation: "UTC")

		do {
			// lowercase 'y' represents the YEAR
			df.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
			let d1s = df.string(from: d1)
			XCTAssertEqual("20191231T100000Z", d1s)
		}

		do {
			// uppercase 'Y' represents the YEAR in "Week of Year" based calendars
			// This is NOT what we expect for the event formatter
			df.dateFormat = "YYYYMMdd'T'HHmmss'Z'"
			let d2s = df.string(from: d1)

			// A week of year based year should have the year in 2020 for this date
			XCTAssertNotEqual("20191231T100000Z", d2s)
			// This week is technically the START of the new year (2020)
			XCTAssertEqual("20201231T100000Z", d2s)
		}

		do {
			let event = try QRCode.Message.Event(
				summary: "Checking dates",
				location: "Some dumb computer",
				start: d1,
				end: d1.addingTimeInterval(3600)
			)
			let formatted = try XCTUnwrap(event.text)
			XCTAssertTrue(formatted.contains("DTSTART:20191231T100000Z"))
			XCTAssertTrue(formatted.contains("DTEND:20191231T110000Z"))
		}
	}
}
