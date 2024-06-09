import XCTest

#if !os(watchOS)

@testable import QRCode

final class QRCodeDetectionTests: XCTestCase {
	//let _msg = "DENSO WAVE serves as a leader in developing and manufacturing automatic data capture devices for barcodes, QR codes, and RFID, etc. and industrial robots (FA equipment), etc."

	// Japanese test: "Achieves the lightest weight in its class, about 128g, which is kind to everyone who works in the field. With a lightweight and compact body, it is highly portable and reduces the burden of long hours of work on site."
	let _msg = "現場で働くすべての人にやさしい、クラス最軽量の約128gを実現。軽量・コンパクトなボディで、携帯性が高く、現場での長時間作業の負担も軽減します。"

	func test3rdPartyGenerator() throws {

		// Make sure the third party generator can generate a qr code
		let doc = try QRCode.Document(engine: QRCodeEngineExternal())

		doc.utf8String = "This is a test"

		var matr = doc.boolMatrix
		doc.errorCorrection = .low
		XCTAssertEqual(matr.dimension, 27)

		doc.utf8String = "This is higher quality"
		doc.errorCorrection = .high
		matr = doc.boolMatrix
		XCTAssertEqual(matr.dimension, 31)

		// Create a QR code from the doc, then detect it back in and check that
		// the strings match
		doc.utf8String = _msg
		let imaged = try doc.cgImage(CGSize(width: 600, height: 600))

		// ... now attempt to detect the text from the generated image

		let features = QRCode.DetectQRCodes(imaged)
		XCTAssertEqual(1, features.count)

		let first = features[0]
		XCTAssertEqual(_msg, first.messageString)
	}

	func testSimpleGeneratorDetect() throws {

		// Make sure the default generator can generate a qr code that we can read back
		let doc = QRCode.Document()
		doc.utf8String = "This is a test"

		var matr = doc.boolMatrix
		doc.errorCorrection = .low
		XCTAssertEqual(matr.dimension, 27)

		doc.utf8String = "This is higher quality"
		doc.errorCorrection = .high
		matr = doc.boolMatrix
		XCTAssertEqual(matr.dimension, 31)

		// Create a QR code from the doc, then detect it back in and check that the strings match.
		doc.utf8String = _msg

		// Generate a basic QR code image
		let imaged = try doc.cgImage(CGSize(width: 600, height: 600))

		// ... now attempt to detect the text from the generated image

		let features = QRCode.DetectQRCodes(imaged)
		XCTAssertEqual(1, features.count)

		let first = features[0]
		XCTAssertEqual(_msg, first.messageString)
	}

	func testDetectFromImage() throws {
		do {
			let image = try resourceCommonImage(for: "qrcodes-image", extension: "jpg")

			let results = QRCode.DetectQRCodes(in: image)
			XCTAssertEqual(5, results.count)
			for i in 0..<5 {
				XCTAssertEqual("http://www.qrstuff.com", results[i].messageString)
			}
		}

		do {
			let image = try resourceCommonImage(for: "nsw-health", extension: "jpg")
			let results = QRCode.DetectQRCodes(in: image)
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
			let image = try resourceCommonImage(for: "example-com", extension: "jpg")
			let results = QRCode.DetectQRCodes(in: image)
			XCTAssertEqual(1, results.count)
			XCTAssertEqual("www.example.com", results[0].messageString)

			let br = results[0].bounds
			XCTAssertEqual(256, br.origin.x, accuracy: 1)
			XCTAssertEqual(195, br.origin.y, accuracy: 1)
			XCTAssertEqual(63, br.size.width, accuracy: 1)
			XCTAssertEqual(65, br.size.height, accuracy: 1)
		}
	}

	func testBasicDetection() throws {

		let qrCode = try QRCode(engine: __testEngine)
		try qrCode.update(text: "https://www.apple.com.au/", errorCorrection: .high)

		// Convert to image and detect qr codes
		do {
			let imaged = try qrCode.cgImage(CGSize(width: 600, height: 600))
			let features = QRCode.DetectQRCodes(imaged)
			let first = features[0]
			XCTAssertEqual("https://www.apple.com.au/", first.messageString)
		}

		let design = QRCode.Design()
		design.shape.onPixels = QRCode.PixelShape.Squircle()
		design.shape.eye = QRCode.EyeShape.RoundedPointingIn()

		do {
			let img = try qrCode.cgImage(CGSize(width: 500, height: 500), design: design)
			let features = QRCode.DetectQRCodes(img)
			let first = features[0]
			XCTAssertEqual("https://www.apple.com.au/", first.messageString)
		}
	}

	func testMaskedDetection() throws {
		let text = "https://www.qrcode.com/en/howto/generate.html"
		let doc = try QRCode.Document(utf8String: text, errorCorrection: .high)
		let image = try resourceImage(for: "colored-fill", extension: "jpg")

		do {
			let p = CGPath(ellipseIn: CGRect(x: 0.30, y: 0.30, width: 0.40, height: 0.40), transform: nil)
			let t = QRCode.LogoTemplate(image: image, path: p)
			doc.logoTemplate = t

			let image = try doc.cgImage(dimension: 300)
#if os(macOS)
			let nsImage = NSImage(cgImage: image, size: .zero)
			XCTAssertNotNil(nsImage)
#endif

			let features = QRCode.DetectQRCodes(image)
			XCTAssertEqual(1, features.count)
			let first = features[0]
			XCTAssertEqual(text, first.messageString)
		}

		do {
			let logoImage = try resourceImage(for: "colored-fill", extension: "jpg")

			// This mask image is too big, and will fail detection using the built-in CIDetector
			let p = CGPath(ellipseIn: CGRect(x: 0.20, y: 0.20, width: 0.60, height: 0.60), transform: nil)
			let t = QRCode.LogoTemplate(image: logoImage, path: p)
			doc.logoTemplate = t

			let image = try doc.cgImage(dimension: 300)
#if os(macOS)
			let nsImage = NSImage(cgImage: image, size: .zero)
			XCTAssertNotNil(nsImage)
#endif

			let features = QRCode.DetectQRCodes(image)
			XCTAssertEqual(0, features.count)
		}
	}
}

#endif
