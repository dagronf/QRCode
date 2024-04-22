//
//  QRCodeEncodeDecodeTests.swift
//  
//
//  Created by Darren Ford on 6/4/2023.
//

import XCTest

@testable import QRCode

final class QRCodeEncodeDecodeTests: XCTestCase {

	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testLogoTemplateEncoding() throws {

		let image = try resourceImage(for: "colored-fill", extension: "jpg")
		let sz = CGSize(width: image.width, height: image.height)
		let maskImage = try resourceImage(for: "apple", extension: "png")
		let szMask = CGSize(width: maskImage.width, height: maskImage.height)

		do {
			let lt = QRCode.LogoTemplate(
				image: image,
				path: CGPath(rect: CGRect(x: 0.4, y: 0.4, width: 0.2, height: 0.2), transform: nil),
				inset: 0.8
			)
			XCTAssertEqual(false, lt.useImageMasking)

			let lt2 = try roundTripEncodeDecode(lt)

			XCTAssertEqual(lt.inset, lt2.object.inset)
			XCTAssertEqual(lt.useImageMasking, lt2.object.useImageMasking)

			// Not ideal - check that the dimensions of the image is the same
			let im2 = lt2.object.image
			XCTAssertEqual(sz, CGSize(width: im2.width, height: im2.height))
		}

		do {
			let lt = QRCode.LogoTemplate(
				image: image,
				maskImage: maskImage
			)
			XCTAssertEqual(true, lt.useImageMasking)

			let lt2 = try roundTripEncodeDecode(lt)
			
			XCTAssertEqual(lt.inset, lt2.object.inset)
			XCTAssertEqual(lt.useImageMasking, lt2.object.useImageMasking)

			// Not ideal - check that the dimensions of the image is the same
			let im2 = lt2.object.image
			XCTAssertEqual(sz, CGSize(width: im2.width, height: im2.height))

			// check the mask image
			let imm2 = try XCTUnwrap(lt2.object.maskImage)
			XCTAssertEqual(szMask, CGSize(width: imm2.width, height: imm2.height))
		}
	}
}
