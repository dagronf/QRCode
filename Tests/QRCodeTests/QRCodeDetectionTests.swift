import XCTest

#if !os(watchOS)

@testable import QRCode
@testable import QRCodeExternal

#if os(macOS)
typealias CommonImage = NSImage
#else
typealias CommonImage = UIImage
#endif

final class QRCodeDetectionTests: XCTestCase {
	//let _msg = "DENSO WAVE serves as a leader in developing and manufacturing automatic data capture devices for barcodes, QR codes, and RFID, etc. and industrial robots (FA equipment), etc."

	// Japanese test: "Achieves the lightest weight in its class, about 128g, which is kind to everyone who works in the field. With a lightweight and compact body, it is highly portable and reduces the burden of long hours of work on site."
	let _msg = "現場で働くすべての人にやさしい、クラス最軽量の約128gを実現。軽量・コンパクトなボディで、携帯性が高く、現場での長時間作業の負担も軽減します。"

	func test3rdPartyGenerator() throws {

		// Make sure the third party generator can generate a qr code
		let doc = QRCode.Document(generator: QRCodeGenerator_External())

		_ = doc.setString("This is a test")

		var matr = doc.boolMatrix
		doc.errorCorrection = .low
		XCTAssertEqual(matr.dimension, 27)

		_ = doc.setString("This is higher quality")
		doc.errorCorrection = .high
		matr = doc.boolMatrix
		XCTAssertEqual(matr.dimension, 31)

		// Create a QR code from the doc, then detect it back in and check that
		// the strings match
		_ = doc.setString(_msg)
		let imaged = try XCTUnwrap(doc.cgImage(CGSize(width: 600, height: 600)))

		// ... now attempt to detect the text from the generated image

		let features = QRCode.DetectQRCodes(imaged)
		XCTAssertEqual(1, features.count)

		let first = features[0]
		XCTAssertEqual(_msg, first.messageString)
	}

	func testSimpleGeneratorDetect() throws {

		// Make sure the default generator can generate a qr code that we can read back
		let doc = QRCode.Document()

		_ = doc.setString("This is a test")

		var matr = doc.boolMatrix
		doc.errorCorrection = .low
		XCTAssertEqual(matr.dimension, 27)

		_ = doc.setString("This is higher quality")
		doc.errorCorrection = .high
		matr = doc.boolMatrix
		XCTAssertEqual(matr.dimension, 31)

		// Create a QR code from the doc, then detect it back in and check that the strings match.
		_ = doc.setString(_msg)

		// Generate a basic QR code image
		let imaged = try XCTUnwrap(doc.cgImage(CGSize(width: 600, height: 600)))

		// ... now attempt to detect the text from the generated image

		let features = QRCode.DetectQRCodes(imaged)
		XCTAssertEqual(1, features.count)

		let first = features[0]
		XCTAssertEqual(_msg, first.messageString)
	}

	func testDetectFromImage() throws {
		do {
			let imageURL = try XCTUnwrap(Bundle.module.url(forResource: "qrcodes-image", withExtension: "jpg"))
			let image = try XCTUnwrap(CommonImage(contentsOfFile: imageURL.path))

			let results = try XCTUnwrap(QRCode.DetectQRCodes(in: image))
			XCTAssertEqual(5, results.count)
			for i in 0..<5 {
				XCTAssertEqual("http://www.qrstuff.com", results[i].messageString)
			}
		}

		do {
			let imageURL = try XCTUnwrap(Bundle.module.url(forResource: "nsw-health", withExtension: "jpg"))
			let image = try XCTUnwrap(CommonImage(contentsOfFile: imageURL.path))

			let results = try XCTUnwrap(QRCode.DetectQRCodes(in: image))
			XCTAssertEqual(1, results.count)
			let msg = try XCTUnwrap(results[0].messageString)
			XCTAssertTrue(msg.starts(with: "https://www.service.nsw.gov.au/campaign"))

			let br = results[0].bounds
			XCTAssertEqual(329, br.origin.x, accuracy: 1)
			XCTAssertEqual(121, br.origin.y, accuracy: 1)
			XCTAssertEqual(195, br.size.width, accuracy: 1)
			XCTAssertEqual(188, br.size.height, accuracy: 1)
		}

		do {
			let imageURL = try XCTUnwrap(Bundle.module.url(forResource: "example-com", withExtension: "jpg"))
			let image = try XCTUnwrap(CommonImage(contentsOfFile: imageURL.path))

			let results = try XCTUnwrap(QRCode.DetectQRCodes(in: image))
			XCTAssertEqual(1, results.count)
			XCTAssertEqual("www.example.com", results[0].messageString)

			let br = results[0].bounds
			XCTAssertEqual(256, br.origin.x, accuracy: 1)
			XCTAssertEqual(195, br.origin.y, accuracy: 1)
			XCTAssertEqual(63, br.size.width, accuracy: 1)
			XCTAssertEqual(65, br.size.height, accuracy: 1)
		}
	}
}

#endif
