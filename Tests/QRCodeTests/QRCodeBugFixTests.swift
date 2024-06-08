import XCTest
@testable import QRCode

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

final class BugFixTests: XCTestCase {

	let outputFolder = try! testResultsContainer.subfolder(with: "BugFixTests")

	func testExternalOptimizationIssue() throws {
		let unoptim = "this is a test to encode a bunch of data in the qr codethis is a test to encode a bunch of data in the qr codethis is a test to encode a bunch of data in the qr codethis is a test to encode a bunch of data in the qr codethis is a test to encode a bunch of data in the qr codethis is a test to encode a bunch of data in the qr codethis is a test to encode a bunch of data in the qr codethis is a test to encode a bunch of data in the qr codethis is a test to encode a bunch of data in the qr codethis is a test to encode a bunch of data in the qr code"
		let optim = "THIS IS A TEST TO ENCODE A BUNCH OF DATA IN THE QR CODETHIS IS A TEST TO ENCODE A BUNCH OF DATA IN THE QR CODETHIS IS A TEST TO ENCODE A BUNCH OF DATA IN THE QR CODETHIS IS A TEST TO ENCODE A BUNCH OF DATA IN THE QR CODETHIS IS A TEST TO ENCODE A BUNCH OF DATA IN THE QR CODETHIS IS A TEST TO ENCODE A BUNCH OF DATA IN THE QR CODETHIS IS A TEST TO ENCODE A BUNCH OF DATA IN THE QR CODETHIS IS A TEST TO ENCODE A BUNCH OF DATA IN THE QR CODETHIS IS A TEST TO ENCODE A BUNCH OF DATA IN THE QR CODETHIS IS A TEST TO ENCODE A BUNCH OF DATA IN THE QR CODE"

		let ud = try QRCode.Document(utf8String: unoptim, engine: QRCodeEngineExternal())
		let od = try QRCode.Document(utf8String: optim, engine: QRCodeEngineExternal())

		XCTAssertEqual(107, ud.boolMatrix.dimension)
		XCTAssertEqual(91, od.boolMatrix.dimension)
	}

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
	func testVerticalHorizontalDefaults() throws {
		let od = try QRCode.Document(utf8String: "This is a test")
		let pi = QRCode.PixelShape.Vertical()
		od.design.shape.onPixels = pi

		let generatedImage1 = try XCTUnwrap(od.nsImage(dimension: 300, dpi: 216))
		Swift.print(generatedImage1)
		pi.insetFraction = 0.1
		pi.cornerRadiusFraction = 1.0

		let generatedImage2 = try XCTUnwrap(od.nsImage(dimension: 300, dpi: 216))
		Swift.print(generatedImage2)
	}
#endif

#if canImport(UIKit)
	func testBlurryUIImageRegression() throws {
		let optim = "THIS IS A TEST TO ENCODE A BUNCH OF DATA IN THE QR CODE - THIS IS A TEST TO ENCODE A BUNCH OF DATA IN THE QR CODE"
		let od = try QRCode.Document(utf8String: optim, engine: QRCodeEngineExternal())
		XCTAssertEqual(47, od.boolMatrix.dimension)

		// New API.
		let generatedImage1 = try XCTUnwrap(od.uiImage(dimension: 300, dpi: 216))
		// 'Old' API using scale
		let generatedImage2 = try XCTUnwrap(od.uiImage(dimension: 300, scale: 3))

		// Check that the scale is 3, and that both images are the same scale
		XCTAssertEqual(3, generatedImage1.scale)
		XCTAssertEqual(3, generatedImage2.scale)

		// Check the width and height
		XCTAssertEqual(generatedImage1.size.width * generatedImage1.scale, 900)
		XCTAssertEqual(generatedImage1.size.height * generatedImage1.scale, 900)

		// Heights and widths of the two image should be equal
		XCTAssertEqual(generatedImage1.size.width,  generatedImage2.size.width)
		XCTAssertEqual(generatedImage1.size.height, generatedImage2.size.height)

		// The files on disk should have 3x scale
		let o1 = try XCTUnwrap(generatedImage1.jpegData(compressionQuality: 0.5))
		try outputFolder.write(o1, to: "uiimage_generation_dpi_x3.jpg")
		let o2 = try XCTUnwrap(generatedImage2.jpegData(compressionQuality: 0.5))
		try outputFolder.write(o2, to: "uiimage_generation_scale_x3.jpg")
		let op1 = try XCTUnwrap(generatedImage1.pngData())
		try outputFolder.write(op1, to: "uiimage_generation_dpi_x3.png")
		let op2 = try XCTUnwrap(generatedImage2.pngData())
		try outputFolder.write(op2, to: "uiimage_generation_scale_x3.png")
	}
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
	func testNSImageDPI() throws {
		let optim = "THIS IS A TEST TO ENCODE A BUNCH OF DATA IN THE QR CODETHIS IS A TEST TO ENCODE A BUNCH OF DATA IN THE QR CODETHIS IS A TEST TO ENCODE A BUNCH OF DATA IN THE QR CODETHIS IS A TEST TO ENCODE A BUNCH OF DATA IN THE QR CODETHIS IS A TEST TO ENCODE A BUNCH OF DATA IN THE QR CODETHIS IS A TEST TO ENCODE A BUNCH OF DATA IN THE QR CODETHIS IS A TEST TO ENCODE A BUNCH OF DATA IN THE QR CODETHIS IS A TEST TO ENCODE A BUNCH OF DATA IN THE QR CODETHIS IS A TEST TO ENCODE A BUNCH OF DATA IN THE QR CODETHIS IS A TEST TO ENCODE A BUNCH OF DATA IN THE QR CODE"
		let od = try QRCode.Document(utf8String: optim, engine: QRCodeEngineExternal())
		XCTAssertEqual(91, od.boolMatrix.dimension)

		// New API.
		let generatedImage1 = try XCTUnwrap(od.nsImage(dimension: 300, dpi: 216))
		XCTAssertEqual(CGSize(dimension: 100), generatedImage1.size)
		// Check that the scale is 3, and that both images are the same scale
		XCTAssertEqual(1, generatedImage1.representations.count)

		// The dimension of the final image is 100 x 100 (300 pixels at 216 dpi = 300 / 3 == 100)
		XCTAssertEqual(CGSize(dimension: 100), generatedImage1.representations[0].size)

		// There should be 300 x 300 pixels in the image
		let cg1 = try XCTUnwrap(generatedImage1.cgImage())
		XCTAssertEqual(300, cg1.width)
		XCTAssertEqual(300, cg1.height)

		let outputFolder = try outputFolder.subfolder(with: "testNSImageDPI")

		// The files on disk should have 3x scale
		let o1 = try generatedImage1.representation.jpeg(compression: 0.5)
		try outputFolder.write(o1, to: "nsimage_generation_dpi_x3.jpg")
		let op1 = try generatedImage1.representation.png()
		try outputFolder.write(op1, to: "nsimage_generation_dpi_x3.png")
	}
#endif
}
