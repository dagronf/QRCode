import XCTest
@testable import QRCode
@testable import QRCodeExternal

final class QRCodeMaskingTests: XCTestCase {
	func testBasicMask() throws {
		let code = QRCode.Document(
			utf8String: "https://www.apple.com/au/mac-studio/",
			errorCorrection: .high,
			generator: __testGenerator
		)

		do {
			let p = CGPath(ellipseIn: CGRect(x: 0.30, y: 0.30, width: 0.40, height: 0.40), transform: nil)
			let t = QRCode.LogoTemplate(path: p)
			code.logoTemplate = t

			let svg = code.svg(dimension: 600)
			try svg.writeToTempFile(named: "testBasicMask1.svg")

			let image = code.platformImage(dimension: 300, scale: 2)!
			let data = image.pngRepresentation()!
			try data.writeToTempFile(named: "testBasicMask1.png")
		}

		do {
			let p = CGPath(rect: CGRect(x: 0.35, y: 0.35, width: 0.30, height: 0.30), transform: nil)
			let t = QRCode.LogoTemplate(path: p)
			code.logoTemplate = t

			let svg = code.svg(dimension: 600)
			try svg.writeToTempFile(named: "testBasicMask2.svg")

			let image = code.platformImage(dimension: 300, scale: 2)!
			let data = image.pngRepresentation()!
			try data.writeToTempFile(named: "testBasicMask2.png")
		}
	}

	func testAbsolutePositioningMask() throws {
		let code = QRCode.Document(
			utf8String: "https://www.apple.com/au/mac-studio/",
			errorCorrection: .high,
			generator: __testGenerator
		)

		let p = CGPath(rect: CGRect(x: 0.35, y: 0.35, width: 0.30, height: 0.30), transform: nil)
		let t = QRCode.LogoTemplate(path: p)

		code.logoTemplate = t
		#if os(macOS)
		let image = try XCTUnwrap(code.nsImage(dimension: 300, scale: 1))
		_ = image
		#endif

		/// absolute mask for a 100 px dimension should just be the same as the mask
		let absMask = t.absolutePathForMaskPath(dimension: 1)
		XCTAssertEqual(p, absMask)

		/// absolute mask for a 200 px dimension should be 200x the size of the mask
		let absMask2 = t.absolutePathForMaskPath(dimension: 200)
		let scaled: CGPath = {
			let x = CGMutablePath()
			x.addPath(p, transform: CGAffineTransform(scaleX: 200, y: 200))
			return x
		}()
		XCTAssertEqual(absMask2, scaled)

		// TODO: Need more tests here
	}

	func testOverlayImage() throws {

		let code = QRCode.Document(
			utf8String: "https://www.apple.com/au/mac-studio/",
			errorCorrection: .high,
			generator: __testGenerator
		)

		code.design.shape.onPixels = QRCode.PixelShape.CurvePixel(cornerRadiusFraction: 0.9)

		do {
			// Lower right logo
			let logoURL = try XCTUnwrap(Bundle.module.url(forResource: "instagram-icon", withExtension: "png"))
			let logoImage = try XCTUnwrap(CommonImage(contentsOfFile: logoURL.path))
			code.logoTemplate = QRCode.LogoTemplate(
				path: CGPath(ellipseIn: CGRect(x: 0.65, y: 0.65, width: 0.30, height: 0.30), transform: nil),
				inset: 8,
				image: logoImage.cgImage()
			)

			let logoQRCode = try XCTUnwrap(code.platformImage(dimension: 300))
			let data = try XCTUnwrap(logoQRCode.pngRepresentation())
			try data.writeToTempFile(named: "logo-lower-right-logo-small.png")

			let logoQRCode2 = try XCTUnwrap(code.platformImage(dimension: 512))
			let data2 = try XCTUnwrap(logoQRCode2.pngRepresentation())
			try data2.writeToTempFile(named: "logo-lower-right-logo-larger.png")

			let str = code.svg(dimension: 512)
			try str.writeToTempFile(named: "logo-lower-right-logo-larger.svg")
		}

		do {
			// Centered square logo
			let logoURL = try XCTUnwrap(Bundle.module.url(forResource: "square-logo", withExtension: "png"))
			let logoImage = try XCTUnwrap(CommonImage(contentsOfFile: logoURL.path))

			let logo = QRCode.LogoTemplate(
				path: CGPath(rect: CGRect(x: 0.35, y: 0.35, width: 0.30, height: 0.30), transform: nil),
				inset: 8,
				image: logoImage.cgImage()
			)
			code.logoTemplate = logo

			let logoQRCode = try XCTUnwrap(code.platformImage(dimension: 600))
			let data = try XCTUnwrap(logoQRCode.pngRepresentation())
			try data.writeToTempFile(named: "logo-center-square-logo.png")
		}

		do {
			// rectangular, non-centered
			let logoURL = try XCTUnwrap(Bundle.module.url(forResource: "apple", withExtension: "png"))
			let logoImage = try XCTUnwrap(CommonImage(contentsOfFile: logoURL.path))

			let logo = QRCode.LogoTemplate(
				path: CGPath(rect: CGRect(x: 0.40, y: 0.365, width: 0.55, height: 0.25), transform: nil),
				inset: 8,
				image: logoImage.cgImage()
			)
			code.logoTemplate = logo

			let logoQRCode = try XCTUnwrap(code.platformImage(dimension: 512))
			let data = try XCTUnwrap(logoQRCode.pngRepresentation())
			try data.writeToTempFile(named: "logo-rectangular-non-centered.png")

			let logo2 = QRCode.LogoTemplate(
				path: CGPath(rect: CGRect(x: 0.40, y: 0.365, width: 0.55, height: 0.25), transform: nil),
				inset: 32,
				image: logoImage.cgImage()
			)
			code.logoTemplate = logo2

			let logoQRCode2 = try XCTUnwrap(code.platformImage(dimension: 3000))
			let data2 = try XCTUnwrap(logoQRCode2.pngRepresentation())
			try data2.writeToTempFile(named: "logo-rectangular-non-centered-large.png")

			let str = code.svg(dimension: 3000)
			try str.writeToTempFile(named: "logo-rectangular-non-centered-large.svg")
		}
	}

	func testFixedTemplates() throws {
		let code = QRCode.Document(
			utf8String: "Verifying that pre-built logo templates work as expected",
			errorCorrection: .high,
			generator: __testGenerator
		)

		do {
			let logoURL = try XCTUnwrap(Bundle.module.url(forResource: "instagram-icon", withExtension: "png"))
			let logoImage = try XCTUnwrap(CommonImage(contentsOfFile: logoURL.path))

			code.logoTemplate = QRCode.LogoTemplate.CircleCenter(image: logoImage.cgImage()!)

			let logo1 = try XCTUnwrap(code.platformImage(dimension: 300))
			let data2 = try XCTUnwrap(logo1.pngRepresentation())
			try data2.writeToTempFile(named: "fixed-template-circle-center.png")
		}

		do {
			let logoURL = try XCTUnwrap(Bundle.module.url(forResource: "instagram-icon", withExtension: "png"))
			let logoImage = try XCTUnwrap(CommonImage(contentsOfFile: logoURL.path))

			code.logoTemplate = QRCode.LogoTemplate.CircleBottomRight(image: logoImage.cgImage()!)

			let logo1 = try XCTUnwrap(code.platformImage(dimension: 300))
			let data2 = try XCTUnwrap(logo1.pngRepresentation())
			try data2.writeToTempFile(named: "fixed-template-circle-bottom-right.png")
		}

		do {
			let logoURL = try XCTUnwrap(Bundle.module.url(forResource: "square-logo", withExtension: "png"))
			let logoImage = try XCTUnwrap(CommonImage(contentsOfFile: logoURL.path))

			code.logoTemplate = QRCode.LogoTemplate.SquareCenter(image: logoImage.cgImage()!)

			let logo1 = try XCTUnwrap(code.platformImage(dimension: 300))
			let data2 = try XCTUnwrap(logo1.pngRepresentation())
			try data2.writeToTempFile(named: "fixed-template-square-center.png")
		}

		do {
			let logoURL = try XCTUnwrap(Bundle.module.url(forResource: "square-logo", withExtension: "png"))
			let logoImage = try XCTUnwrap(CommonImage(contentsOfFile: logoURL.path))

			code.logoTemplate = QRCode.LogoTemplate.SquareBottomRight(image: logoImage.cgImage()!)

			let logo1 = try XCTUnwrap(code.platformImage(dimension: 300))
			let data2 = try XCTUnwrap(logo1.pngRepresentation())
			try data2.writeToTempFile(named: "fixed-template-square-bottom-right.png")
		}
	}
}

