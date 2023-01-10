import XCTest

@testable import QRCode
@testable import QRCodeExternal

func resourceImage(for resource: String, extension extn: String) -> CGImage {
	let url = Bundle.module.url(forResource: resource, withExtension: extn)!
	return CommonImage(contentsOfFile: url.path)!.cgImage()!
}

final class QRCodeImageFillTests: XCTestCase {

	func testBasic() throws {
		let doc = QRCode.Document(utf8String: "This is a test", generator: QRCodeGenerator_External())

		let logoURL = try XCTUnwrap(Bundle.module.url(forResource: "swift-logo", withExtension: "png"))
		let logoImage = try XCTUnwrap(CommonImage(contentsOfFile: logoURL.path)).cgImage()!

		let backgroundImage = QRCode.FillStyle.Image(logoImage)

		doc.design.style.background = backgroundImage

		let im1 = try XCTUnwrap(doc.platformImage(dimension: 600))
		Swift.print(im1)

		// Write out json data -- the image should be encoded as base64 PNG
		let rawData = try doc.jsonData()
		let svgData = doc.svg(dimension: 300)
		try svgData.writeToTempFile(named: "svgdata.svg")

		let svgDataSuperLarge = doc.svg(dimension: 3000)
		try svgDataSuperLarge.writeToTempFile(named: "svgdata-superlarge.svg")


		let doc2 = try XCTUnwrap(QRCode.Document.init(jsonData: rawData, generator: QRCodeGenerator_External()))
		let fillStyle = try XCTUnwrap(doc2.design.style.background as? QRCode.FillStyle.Image)
		XCTAssertNotNil(fillStyle.image)
		XCTAssertEqual(fillStyle.image?.width, logoImage.width)
		XCTAssertEqual(fillStyle.image?.height, logoImage.height)

		let im2 = try XCTUnwrap(doc2.platformImage(dimension: 600))

		let svgData2 = doc2.svg(dimension: 300)
		XCTAssertEqual(svgData, svgData2)
	}

	func testBasic2() throws {
		let doc = QRCode.Document(utf8String: "This is a test", generator: QRCodeGenerator_External())

		doc.design.backgroundColor(CGColor(gray: 0, alpha: 1))
		doc.design.shape.onPixels = QRCode.PixelShape.RoundedPath(cornerRadiusFraction: 0.7, hasInnerCorners: true)

		let logoImage =  resourceImage(for: "colored-fill", extension: "jpg")
		let fillImage = QRCode.FillStyle.Image(logoImage)
		doc.design.style.onPixels = fillImage

		let logoImage2 = resourceImage(for: "colored-fill-invert", extension: "jpg")
		let eyeImage = QRCode.FillStyle.Image(logoImage2)
		doc.design.style.eye = eyeImage
		doc.design.shape.eye = QRCode.EyeShape.Squircle()

		let logoImage3 = resourceImage(for: "colored-fill-bw", extension: "jpg")
		let pupilImage = QRCode.FillStyle.Image(logoImage3)
		doc.design.style.pupil = pupilImage
		doc.design.shape.pupil = QRCode.PupilShape.BarsHorizontal()

		let im1 = try XCTUnwrap(doc.platformImage(dimension: 600))
		Swift.print(im1)

		let encoded = try doc.jsonData()
		let doc2 = try XCTUnwrap(QRCode.Document.init(jsonData: encoded, generator: QRCodeGenerator_External()))
		let im2 = try XCTUnwrap(doc2.platformImage(dimension: 600))
		Swift.print(im2)
	}
}
