import XCTest

@testable import QRCode

final class QRCodeImageFillTests: XCTestCase {

	let outputFolder = try! testResultsContainer.subfolder(with: "QRCodeImageFillTests")

	func testBasic() throws {
		let doc = try QRCode.Document(utf8String: "This is a test", engine: QRCodeEngineExternal())

		let logoImage = try resourceImage(for: "swift-logo", extension: "png")

		let backgroundImage = QRCode.FillStyle.Image(logoImage)

		let fillImage = try backgroundImage.makeImage(dimension: 500)
		XCTAssertEqual(500, fillImage.width)
		XCTAssertEqual(500, fillImage.height)

		doc.design.style.background = backgroundImage

		let im1 = try doc.platformImage(dimension: 600)
		Swift.print(im1)

		// Write out json data -- the image should be encoded as base64 PNG
		let rawData = try doc.jsonData()
		let svgData = try doc.svg(dimension: 300)
		try outputFolder.write(svgData, to: "svgdata-orig.svg")

		let svgDataSuperLarge = try doc.svg(dimension: 3000)
		try outputFolder.write(svgDataSuperLarge, to: "svgdata-superlarge.svg")

		let doc2 = try QRCode.Document(jsonData: rawData, engine: QRCodeEngineExternal())
		let fillStyle = try XCTUnwrap(doc2.design.style.background as? QRCode.FillStyle.Image)
		XCTAssertNotNil(fillStyle.image)
		XCTAssertEqual(fillStyle.image?.width, logoImage.width)
		XCTAssertEqual(fillStyle.image?.height, logoImage.height)

		let im2 = try doc2.platformImage(dimension: 600)
		Swift.print(im2)

		let svgData2 = try doc2.svg(dimension: 300)
		try outputFolder.write(svgData2, to: "svgdata-recon.svg")

		XCTAssertEqual(svgData, svgData2)
	}

	func testBasic2() throws {
		let doc = try QRCode.Document(utf8String: "This is a test", engine: QRCodeEngineExternal())

		doc.design.backgroundColor(.commonBlack)
		doc.design.shape.onPixels = QRCode.PixelShape.RoundedPath(cornerRadiusFraction: 0.7, hasInnerCorners: true)

		let logoImage = try resourceImage(for: "colored-fill", extension: "jpg")
		let fillImage = QRCode.FillStyle.Image(logoImage)
		doc.design.style.onPixels = fillImage

		let logoImage2 = try resourceImage(for: "colored-fill-invert", extension: "jpg")
		let eyeImage = QRCode.FillStyle.Image(logoImage2)
		doc.design.style.eye = eyeImage
		doc.design.shape.eye = QRCode.EyeShape.Squircle()

		let logoImage3 = try resourceImage(for: "colored-fill-bw", extension: "jpg")
		let pupilImage = QRCode.FillStyle.Image(logoImage3)

		do {
			let fillImage = try pupilImage.makeImage(dimension: 500)
			XCTAssertEqual(500, fillImage.width)
			XCTAssertEqual(500, fillImage.height)
		}

		doc.design.style.pupil = pupilImage
		doc.design.shape.pupil = QRCode.PupilShape.BarsHorizontal()

		let im1 = try doc.platformImage(dimension: 600)
		Swift.print(im1)

		let encoded = try doc.jsonData()
		let doc2 = try QRCode.Document(jsonData: encoded, engine: QRCodeEngineExternal())
		let im2 = try doc2.platformImage(dimension: 600)
		Swift.print(im2)
	}
}
