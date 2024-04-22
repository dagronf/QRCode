import XCTest
@testable import QRCode

final class QRCodeMaskingTests: XCTestCase {

	let outputFolder = try! testResultsContainer.subfolder(with: "QRCodeMaskingTests")

	func testBasicMask() throws {
		let code = QRCode.Document(
			utf8String: "https://www.apple.com/au/mac-studio/",
			errorCorrection: .high,
			generator: __testGenerator
		)

		let image = try resourceImage(for: "colored-fill", extension: "jpg")

		do {
			let p = CGPath(ellipseIn: CGRect(x: 0.30, y: 0.30, width: 0.40, height: 0.40), transform: nil)
			let t = QRCode.LogoTemplate(image: image, path: p)
			code.logoTemplate = t

			let svg = code.svg(dimension: 600)
			try outputFolder.write(svg, to: "testBasicMask1.svg")

			let image = code.platformImage(dimension: 300, dpi: 144)!
			let data = image.pngRepresentation()!
			try outputFolder.write(data, to: "testBasicMask1.png")
		}

		do {
			let p = CGPath(rect: CGRect(x: 0.35, y: 0.35, width: 0.30, height: 0.30), transform: nil)
			let t = QRCode.LogoTemplate(image: image, path: p)
			code.logoTemplate = t

			let svg = code.svg(dimension: 600)
			try outputFolder.write(svg, to: "testBasicMask2.svg")

			let image = code.platformImage(dimension: 300, dpi: 144)!
			let data = image.pngRepresentation()!
			try outputFolder.write(data, to: "testBasicMask2.png")
		}
	}

	func testAbsolutePositioningMask() throws {
		let code = QRCode.Document(
			utf8String: "https://www.apple.com/au/mac-studio/",
			errorCorrection: .high,
			generator: __testGenerator
		)

		let image2 = try resourceImage(for: "colored-fill", extension: "jpg")

		let p = CGPath(rect: CGRect(x: 0.35, y: 0.35, width: 0.30, height: 0.30), transform: nil)
		let t = QRCode.LogoTemplate(image: image2, path: p)

		code.logoTemplate = t
		#if os(macOS)
		let image = try XCTUnwrap(code.nsImage(dimension: 300))
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
				image: logoImage.cgImage()!,
				path: CGPath(ellipseIn: CGRect(x: 0.65, y: 0.65, width: 0.30, height: 0.30), transform: nil),
				inset: 8
			)

			let logoQRCode = try XCTUnwrap(code.platformImage(dimension: 300))
			let data = try XCTUnwrap(logoQRCode.pngRepresentation())
			try outputFolder.write(data, to: "logo-lower-right-logo-small.png")

			let logoQRCode2 = try XCTUnwrap(code.platformImage(dimension: 512))
			let data2 = try XCTUnwrap(logoQRCode2.pngRepresentation())
			try outputFolder.write(data2, to: "logo-lower-right-logo-larger.png")

			let str = code.svg(dimension: 512)
			try outputFolder.write(str, to: "logo-lower-right-logo-larger.svg")
		}

		do {
			// Centered square logo
			let logoImage = try resourceImage(for: "square-logo", extension: "png")

			let logo = QRCode.LogoTemplate(
				image: logoImage,
				path: CGPath(rect: CGRect(x: 0.35, y: 0.35, width: 0.30, height: 0.30), transform: nil),
				inset: 8
			)
			code.logoTemplate = logo

			let logoQRCode = try XCTUnwrap(code.platformImage(dimension: 600))
			let data = try XCTUnwrap(logoQRCode.pngRepresentation())
			try outputFolder.write(data, to: "logo-center-square-logo.png")
		}

		do {
			// rectangular, non-centered
			let logoImage = try resourceImage(for: "apple", extension: "png")

			let logo = QRCode.LogoTemplate(
				image: logoImage,
				path: CGPath(rect: CGRect(x: 0.40, y: 0.365, width: 0.55, height: 0.25), transform: nil),
				inset: 8
			)
			code.logoTemplate = logo

			let logoQRCode = try XCTUnwrap(code.platformImage(dimension: 512))
			let data = try XCTUnwrap(logoQRCode.pngRepresentation())
			try outputFolder.write(data, to: "logo-rectangular-non-centered.png")

			let logo2 = QRCode.LogoTemplate(
				image: logoImage,
				path: CGPath(rect: CGRect(x: 0.40, y: 0.365, width: 0.55, height: 0.25), transform: nil),
				inset: 32
			)
			code.logoTemplate = logo2

			let logoQRCode2 = try XCTUnwrap(code.platformImage(dimension: 3000))
			let data2 = try XCTUnwrap(logoQRCode2.pngRepresentation())
			try outputFolder.write(data2, to: "logo-rectangular-non-centered-large.png")

			let str = code.svg(dimension: 3000)
			try outputFolder.write(str, to: "logo-rectangular-non-centered-large.svg")
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

			code.logoTemplate = .CircleCenter(image: logoImage.cgImage()!)

			let logo1 = try XCTUnwrap(code.platformImage(dimension: 300))
			let data2 = try XCTUnwrap(logo1.pngRepresentation())
			try outputFolder.write(data2, to: "fixed-template-circle-center.png")
		}

		do {
			let logoURL = try XCTUnwrap(Bundle.module.url(forResource: "instagram-icon", withExtension: "png"))
			let logoImage = try XCTUnwrap(CommonImage(contentsOfFile: logoURL.path))

			code.logoTemplate = QRCode.LogoTemplate.CircleBottomRight(image: logoImage.cgImage()!)

			let logo1 = try XCTUnwrap(code.platformImage(dimension: 300))
			let data2 = try XCTUnwrap(logo1.pngRepresentation())
			try outputFolder.write(data2, to: "fixed-template-circle-bottom-right.png")
		}

		do {
			let logoURL = try XCTUnwrap(Bundle.module.url(forResource: "square-logo", withExtension: "png"))
			let logoImage = try XCTUnwrap(CommonImage(contentsOfFile: logoURL.path))

			code.logoTemplate = QRCode.LogoTemplate.SquareCenter(image: logoImage.cgImage()!)

			let logo1 = try XCTUnwrap(code.platformImage(dimension: 300))
			let data2 = try XCTUnwrap(logo1.pngRepresentation())
			try outputFolder.write(data2, to: "fixed-template-square-center.png")
		}

		do {
			let logoURL = try XCTUnwrap(Bundle.module.url(forResource: "square-logo", withExtension: "png"))
			let logoImage = try XCTUnwrap(CommonImage(contentsOfFile: logoURL.path))

			code.logoTemplate = QRCode.LogoTemplate.SquareBottomRight(image: logoImage.cgImage()!)

			let logo1 = try XCTUnwrap(code.platformImage(dimension: 300))
			let data2 = try XCTUnwrap(logo1.pngRepresentation())
			try outputFolder.write(data2, to: "fixed-template-square-bottom-right.png")
		}
	}

	func testLogoImageMasking() throws {
		let doc = QRCode.Document(
			utf8String: "Verifying logo image masking works",
			errorCorrection: .high,
			generator: __testGenerator
		)

		let image = try resourceImage(for: "logo", extension: "png")

		do {
			doc.logoTemplate = QRCode.LogoTemplate(image: image)

			let logo1 = try XCTUnwrap(doc.platformImage(dimension: 300))
			let data2 = try XCTUnwrap(logo1.pngRepresentation())
			try outputFolder.write(data2, to: "logotemplate-image-transparency-mask.png")
		}

		do {
			let imageMask = try resourceImage(for: "logo-mask", extension: "png")
			doc.logoTemplate = QRCode.LogoTemplate(image: image, maskImage: imageMask)

			let logo1 = try XCTUnwrap(doc.platformImage(dimension: 300))
			let data2 = try XCTUnwrap(logo1.pngRepresentation())
			try outputFolder.write(data2, to: "logotemplate-image-using-imagemask.png")
		}
	}

	func testLogoQRMasking() throws {
		let doc = QRCode.Document(
			utf8String: "Verifying logo image masking works",
			errorCorrection: .high
		)

		let path = CGPath(rect: CGRect(x: 0.3, y: 0.3, width: 0.4, height: 0.4), transform: nil)
		let transf = CGMutablePath()
		transf.addPath(path, transform: CGAffineTransform(scaleX: 10, y: 10))

		let outputFolder = try outputFolder.subfolder(with: "logotemplate-qrmasking")

		do {
			// Checking whether the logotemplate style of 'use path' correctly masks the qr accordingly
			let image = try resourceImage(for: "square-logo", extension: "png")
			let imageDestination = CGPath(rect: CGRect(x: 0.3, y: 0.3, width: 0.4, height: 0.4), transform: nil)
			do {
				doc.logoTemplate = QRCode.LogoTemplate(image: image, path: imageDestination)
				try outputFolder.write(try XCTUnwrap(doc.pngData(dimension: 300)), to: "logotemplate-imagepath-qrmasked.png")
				try outputFolder.write(try XCTUnwrap(doc.svgData(dimension: 300)), to: "logotemplate-imagepath-qrmasked.svg")
			}
			do {
				doc.logoTemplate = QRCode.LogoTemplate(image: image, path: imageDestination, masksQRCodePixels: false)
				try outputFolder.write(try XCTUnwrap(doc.pngData(dimension: 300)), to: "logotemplate-imagepath-qrnotmasked.png")
				try outputFolder.write(try XCTUnwrap(doc.svgData(dimension: 300)), to: "logotemplate-imagepath-qrnotmasked.svg")
			}
		}

		do {
			// Checking whether the logotemplate style of 'use images transparency' correctly masks the qr accordingly
			let image = try resourceImage(for: "logo", extension: "png")
			do {
				doc.logoTemplate = QRCode.LogoTemplate(image: image)
				try outputFolder.write(try XCTUnwrap(doc.pngData(dimension: 300)), to: "logotemplate-transparency-qrmasked.png")
				try outputFolder.write(try XCTUnwrap(doc.svgData(dimension: 300)), to: "logotemplate-transparency-qrmasked.svg")
			}
			do {
				doc.logoTemplate = QRCode.LogoTemplate(image: image, masksQRCodePixels: false)
				try outputFolder.write(try XCTUnwrap(doc.pngData(dimension: 300)), to: "logotemplate-transparency-qrnotmasked.png")
				try outputFolder.write(try XCTUnwrap(doc.svgData(dimension: 300)), to: "logotemplate-transparency-qrnotmasked.svg")
			}
		}

		do {
			// Checking whether the logotemplate style of 'use images transparency' correctly masks the qr accordingly
			let image = try resourceImage(for: "logo", extension: "png")
			let imagemask = try resourceImage(for: "logo-mask", extension: "png")
			do {
				doc.logoTemplate = QRCode.LogoTemplate(image: image, maskImage: imagemask)
				try outputFolder.write(try XCTUnwrap(doc.pngData(dimension: 300)), to: "logotemplate-maskimage-qrmasked.png")
				try outputFolder.write(try XCTUnwrap(doc.svgData(dimension: 300)), to: "logotemplate-maskimage-qrmasked.svg")
			}
			do {
				doc.logoTemplate = QRCode.LogoTemplate(image: image, maskImage: imagemask, masksQRCodePixels: false)
				try outputFolder.write(try XCTUnwrap(doc.pngData(dimension: 300)), to: "logotemplate-maskimage-qrnotmasked.png")
				try outputFolder.write(try XCTUnwrap(doc.svgData(dimension: 300)), to: "logotemplate-maskimage-qrnotmasked.svg")
			}
		}
	}
}
