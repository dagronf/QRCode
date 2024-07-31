import XCTest
@testable import QRCode

// Tests for the QRCode builder

final class QRCodeBuilderTests: XCTestCase {
	let outputFolder = try! testResultsContainer.subfolder(with: "QRCodeBuilderTests")

	func testBuilder() throws {
		let doc = try QRCode.build
			.text("Testing the qrcode builder")
		try outputFolder.write(
			try doc.generate.image(dimension: 300, representation: .png(scale: 2)),
			to: "builder-basic-black-white.png"
		)
	}

	func testBuilder2() throws {
		let doc = try QRCode.build
			.text("Testing the qrcode builder")
			.errorCorrection(.high)
			.quietZonePixelCount(4)
			.foregroundColor(CGColor(red: 1, green: 0, blue: 0, alpha: 1))

		try outputFolder.write(
			try doc.generate.image(dimension: 300, representation: .png(scale: 2)),
			to: "builder-test1.png"
		)
	}

	func testBuilderForeBackColors() throws {
		let doc = try QRCode.build
			.text("Testing the qrcode builder")
			.foregroundColor(CGColor(srgbRed: 1, green: 1, blue: 0, alpha: 1))
			.backgroundColor(CGColor(srgbRed: 0.3, green: 0, blue: 0.3, alpha: 1))
		try outputFolder.write(
			try doc.generate.image(dimension: 1000, representation: .png(scale: 2)),
			to: "builder-basic-foreground-background.png"
		)
	}

	func testBuilderBasicLogo() throws {
		do {
			let image = try resourceImage(for: "wwf", extension: "jpeg")
			let im2 = try QRCode.build
				.text("Fish and chips")
				.backgroundColor(CGColor(srgbRed: 1, green: 1, blue: 0.6, alpha: 1))
				.logo(image, position: .circleCenter(inset: 5))
				.generate.image(dimension: 500)

			try outputFolder.write(
				try im2.imageData(for: .png()),
				to: "builder-logo-basic-circle-center.png"
			)
		}

		do {
			let image = try resourceImage(for: "wwf", extension: "jpeg")
			let im2 = try QRCode.build
				.text("World Wildlife Foundation")
				.background.style(CGColor(srgbRed: 1, green: 1, blue: 0.6, alpha: 1))
				.logo(image, position: .squareBottomRight(inset: 0))
				.generate.image(dimension: 500)

			try outputFolder.write(
				try im2.imageData(for: .png()),
				to: "builder-logo-basic-square-bottom-right.png"
			)
		}

		do {
			let image = try resourceImage(for: "logo-scan", extension: "png")
			let im2 = try QRCode.build
				.text("https://www.worldwildlife.org/about")
				.background.style(.sRGBA(1, 1, 0.6, 1))
				.background.cornerRadius(2)
				.onPixels.shape(.curvePixel())
				.offPixels.shape(.flower())
				.offPixels.style(CGColor(srgbRed: 0, green: 1, blue: 0, alpha: 0.3))
				.logo(
					image: image,
					unitRect: CGRect(x: 0.3, y: 0.72, width: 0.45, height: 0.22),
					inset: 10
				)
				.generate.image(dimension: 500)

			try outputFolder.write(
				try im2.imageData(for: .png()),
				to: "builder-logo-basic-rect-positioning.png"
			)
		}
	}

	func testBuilderBasicUrl() throws {
		let doc = try QRCode.build
			.url(URL(string: "https://www.worldwildlife.org/about")!)
			.document

		let ii = try doc.cgImage(dimension: 758)
		try outputFolder.write(
			try ii.imageData(for: .png()),
			to: "builder-plain.png"
		)
	}

	func testBuilderStylish1() throws {
		let image = try QRCode.build
			.text("https://www.worldwildlife.org/about")
			.quietZonePixelCount(3)
			.foregroundColor(CGColor(srgbRed: 1, green: 0, blue: 0.6, alpha: 1))
			.backgroundColor(CGColor(srgbRed: 0, green: 0, blue: 0.2, alpha: 1))
			.background.cornerRadius(3)
			.onPixels.shape(.curvePixel())
			.eye.shape(.teardrop())
			.generate.image(dimension: 600, representation: .png())
		try outputFolder.write(image, to: "builder-example-doco.png")
	}

	func testBuilderLogoMasking() throws {
		let logoImage = try resourceImage(for: "logo", extension: "png")
		let logoMaskImage = try resourceImage(for: "logo-mask", extension: "png")

		let builder = try QRCode.build
			.text("Adding a logo to a QR code using an image and a mask image")
			.logo(image: logoImage, maskImage: logoMaskImage)

		let image = try builder.generate.image(dimension: 400, representation: .png())
		try outputFolder.write(image, to: "builder-masked-logo.png")

		builder.logo(image: logoImage)
		let image2 = try builder.generate.image(dimension: 400, representation: .png())
		try outputFolder.write(image2, to: "builder-logo.png")
	}
}
