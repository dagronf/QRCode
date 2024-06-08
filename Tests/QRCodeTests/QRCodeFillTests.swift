import XCTest
@testable import QRCode

// Tests generating fills

final class QRCodeFillTests: XCTestCase {

	let outputFolder = try! testResultsContainer.subfolder(with: "QRCodeFillTests")

	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testSolidFill() throws {
		let fillImage1 = try QRCode.FillStyle.Solid(srgbRed: 1, green: 0, blue: 0).makeImage(dimension: 500)
		let data1 = try fillImage1.representation.jpeg()
		try outputFolder.write(data1, to: "solid-fill-1.jpg")
		let fillImage2 = try QRCode.FillStyle.Solid(srgbRed: 0, green: 0, blue: 1, alpha: 0.2).makeImage(dimension: 128)
		let data2 = try fillImage2.representation.png()
		try outputFolder.write(data2, to: "solid-fill-2.png")
	}

	func testLinearGradientFill() throws {
		// Linear fill
		let gradient = try! DSFGradient.build([
			(0.30, CGColor(srgbRed: 0.005, green: 0.101, blue: 0.395, alpha: 1)),
			(0.55, CGColor(srgbRed: 0, green: 0.021, blue: 0.137, alpha: 1)),
			(0.655, CGColor(srgbRed: 0, green: 0.978, blue: 0.354, alpha: 1)),
			(0.66, CGColor(srgbRed: 1, green: 0.248, blue:0, alpha: 1)),
			(1.00, CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)),
		])

		let linear = QRCode.FillStyle.LinearGradient(
			gradient,
			startPoint: CGPoint(x: 0.2, y: 0),
			endPoint: CGPoint(x: 1, y: 1)
		)
		do {
			let fillImage = try linear.makeImage(dimension: 300)
			XCTAssertEqual(300, fillImage.width)
			XCTAssertEqual(300, fillImage.height)
			let data = try fillImage.representation.jpeg()
			try outputFolder.write(data, to: "linear-fill.jpg")
		}
		do {
			let fillImage = try linear.makeImage(dimension: 300, isFlipped: true)
			XCTAssertEqual(300, fillImage.width)
			XCTAssertEqual(300, fillImage.height)
			let data = try fillImage.representation.jpeg()
			try outputFolder.write(data, to: "linear-fill-flipped.jpg")
		}
	}

	func testRadialGradientFill() throws {
		// Radial
		let gradient = try! DSFGradient.build([
			(0.30, CGColor(srgbRed: 0.005, green: 0.101, blue: 0.395, alpha: 1)),
			(0.55, CGColor(srgbRed: 0, green: 0.021, blue: 0.137, alpha: 1)),
			(0.655, CGColor(srgbRed: 0, green: 0.978, blue: 0.354, alpha: 1)),
			(0.66, CGColor(srgbRed: 1, green: 0.248, blue:0, alpha: 1)),
			(1.00, CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)),
		])

		let radial = QRCode.FillStyle.RadialGradient(gradient, centerPoint: CGPoint(x: 0.5, y: 0.5))
		do {
			let fillImage = try radial.makeImage(dimension: 512, isFlipped: true)
			XCTAssertEqual(512, fillImage.width)
			XCTAssertEqual(512, fillImage.height)
			let data = try fillImage.representation.jpeg()
			try outputFolder.write(data, to: "radial-fill.jpg")
		}

		do {
			let fillImage = try radial.makeImage(width: 480, height: 640, isFlipped: true)
			XCTAssertEqual(480, fillImage.width)
			XCTAssertEqual(640, fillImage.height)
			let data = try fillImage.representation.jpeg()
			try outputFolder.write(data, to: "radial-fill-non-square.jpg")
		}
	}

	func testImageFill() throws {

		do {
			// Image fill
			let logoImage = try resourceImage(for: "square-logo", extension: "png")
			let fill = QRCode.FillStyle.Image(logoImage)
			let fillImage = try fill.makeImage(dimension: 500)
			XCTAssertEqual(500, fillImage.width)
			XCTAssertEqual(500, fillImage.height)
			let data = try fillImage.representation.jpeg()
			try outputFolder.write(data, to: "image-fill.jpg")
		}

		do {
			// Image fill
			let logoImage = try resourceImage(for: "square-logo", extension: "png")
			let fill = QRCode.FillStyle.Image(logoImage)
			let fillImage = try fill.makeImage(width: 640, height: 480, isFlipped: true)
			XCTAssertEqual(640, fillImage.width)
			XCTAssertEqual(480, fillImage.height)
			let data = try fillImage.representation.jpeg()
			try outputFolder.write(data, to: "image-fill-flipped.jpg")
		}
	}
}
