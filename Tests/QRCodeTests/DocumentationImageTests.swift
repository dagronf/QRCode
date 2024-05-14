//
//  DocumentationImageTests.swift
//
//  Copyright © 2024 Darren Ford. All rights reserved.
//
//  MIT license
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial
//  portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
//  OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import XCTest
import SwiftImageReadWrite

@testable import QRCode

// Generate all the images for the markdown documentation

private let systemBlue = CGColor.sRGBA(0.040, 0.519, 1.000, 1.0)
private let systemGreen = CGColor.sRGBA(0.203, 0.842, 0.293, 1.0)
private let systemBrown = CGColor.sRGBA(0.676, 0.558, 0.409, 1.0)

final class DocumentationImageTests: XCTestCase {

	let outputFolder = try! testResultsContainer.subfolder(with: "documentation-images")

	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testQuietSpace() throws {
		let doc = QRCode.Document(utf8String: "https://www.swift.org/about/")
		doc.design.style.background = QRCode.FillStyle.Solid(0.410, 1.000, 0.375)

		try [0, 5, 10, 15].forEach { aqs in
			doc.design.additionalQuietZonePixels = UInt(aqs)
			let cg1 = try XCTUnwrap(doc.cgImage(CGSize(width: 300, height: 300)))
			let data = try XCTUnwrap(cg1.representation.png(dpi: 144))
			try outputFolder.write(data, to: "quiet-space-\(aqs).png")
		}

		do {
			let image = try resourceImage(for: "swift-logo", extension: "png")
			doc.design.style.background = QRCode.FillStyle.Image(image)
			doc.design.additionalQuietZonePixels = 4
			let cg1 = try XCTUnwrap(doc.cgImage(CGSize(width: 300, height: 300)))
			let data = try XCTUnwrap(cg1.representation.png(dpi: 144))
			try outputFolder.write(data, to: "quiet-space-background-image.png")
		}
	}

	func testCornerRadius() throws {
		do {
			let doc = QRCode.Document(utf8String: "Corner radius checking", errorCorrection: .high)
			doc.design.style.background = QRCode.FillStyle.Solid(1, 0, 0)
			doc.design.foregroundStyle(QRCode.FillStyle.Solid(1, 1, 1))
			doc.design.additionalQuietZonePixels = 4
			try [0, 2, 4, 6].forEach { cr in
				doc.design.style.backgroundFractionalCornerRadius = cr
				let cg1 = try XCTUnwrap(doc.cgImage(CGSize(width: 300, height: 300)))
				let data = try XCTUnwrap(cg1.representation.png(dpi: 144))
				try outputFolder.write(data, to: "corner-radius-\(Int(cr)).png")
			}
		}

		do {
			let doc = QRCode.Document(utf8String: "Corner radius checking")
			doc.design.style.background = QRCode.FillStyle.Solid(0, 0, 0.7)
			doc.design.foregroundStyle(QRCode.FillStyle.Solid(1, 1, 1))
			doc.design.shape.eye = QRCode.EyeShape.RoundedOuter()
			doc.design.additionalQuietZonePixels = 2
			doc.design.style.backgroundFractionalCornerRadius = 3.0

			let cg1 = try XCTUnwrap(doc.cgImage(CGSize(width: 300, height: 300)))
			let data = try XCTUnwrap(cg1.representation.png(dpi: 144))
			try outputFolder.write(data, to: "corner-radius-example.png")
		}
	}

	let imageSize: Double = 120

	func testGenerateEyeShapeDocumentationImages() throws {
		// Eye sample images
		let eyeShapes = try QRCodeEyeShapeFactory.shared.generateSampleImages(
			dimension: imageSize * 2,
			foregroundColor: .commonBlack,
			backgroundColor: CGColor.gray(0.9)
		)

		try eyeShapes.forEach { sample in
			let data = try XCTUnwrap(sample.image.representation.png())
			try outputFolder.write(data, to: "eye_\(sample.name).png")
		}
	}

	func testGeneratePixelShapeDocumentationImages() throws {
		// Pixels sample images
		let commonPixelSettings: [String: Any] = [
			QRCode.SettingsKey.insetFraction: 0.1,
			QRCode.SettingsKey.cornerRadiusFraction: 0.75
		]
		let pixelShapes = try QRCodePixelShapeFactory.shared.generateSampleImages(
			dimension: imageSize * 2,
			foregroundColor: .commonBlack,
			backgroundColor: CGColor.gray(0.9),
			commonSettings: commonPixelSettings
		)

		try pixelShapes.forEach { sample in
			let data = try XCTUnwrap(sample.image.representation.png())
			try outputFolder.write(data, to: "data_\(sample.name).png")
		}
	}

	func testGeneratePupilShapeDocumentationImages() throws {
		// Pupil sample images
		let pupilShapes = try QRCodePupilShapeFactory.shared.generateSampleImages(
			dimension: imageSize * 2,
			foregroundColor: .commonBlack,
			backgroundColor: CGColor.gray(0.9)
		)

		try pupilShapes.forEach { sample in
			let data = try XCTUnwrap(sample.image.representation.png())
			try outputFolder.write(data, to: "pupil_\(sample.name).png")
		}
	}

	func testOffPixelImageGeneration() throws {
		let doc1 = QRCode.Document(utf8String: "Testing off-pixels")
		doc1.design.backgroundColor(.commonWhite)
		doc1.design.shape.eye = QRCode.EyeShape.RoundedOuter()
		doc1.design.shape.onPixels = QRCode.PixelShape.Circle()
		doc1.design.style.onPixels = QRCode.FillStyle.Solid(systemGreen)
		doc1.design.shape.offPixels = QRCode.PixelShape.Horizontal(insetFraction: 0.4, cornerRadiusFraction: 1) //inset: 4)
		doc1.design.style.offPixels = QRCode.FillStyle.Solid(systemGreen.copy(alpha: 0.4)!)

		let cg1 = try XCTUnwrap(doc1.cgImage(CGSize(width: 300, height: 300)))
		let data = try XCTUnwrap(cg1.representation.png(dpi: 144))
		try outputFolder.write(data, to: "offPixels.png")
	}

	func testEyeColorStyles() throws {
		let doc2 = QRCode.Document(utf8String: "Github example for colors")
		doc2.design.backgroundColor(.commonWhite)
		doc2.design.shape.eye = QRCode.EyeShape.Leaf()
		doc2.design.style.eye = QRCode.FillStyle.Solid(systemGreen)
		doc2.design.style.pupil = QRCode.FillStyle.Solid(systemBlue)

		doc2.design.shape.onPixels = QRCode.PixelShape.RoundedPath()
		doc2.design.style.onPixels = QRCode.FillStyle.Solid(systemBrown)

		let cg1 = try XCTUnwrap(doc2.cgImage(CGSize(width: 300, height: 300)))
		let data = try XCTUnwrap(cg1.representation.png(dpi: 144))
		try outputFolder.write(data, to: "eye_colorstyles.png")
	}

	func testRadialFillStyle() throws {
		// Set the background color to a solid white
		let doc3 = QRCode.Document(utf8String: "Github example for colors")
		doc3.design.style.background = QRCode.FillStyle.Solid(.commonWhite)

		// Set the fill color for the data to radial gradient
		let radial = QRCode.FillStyle.RadialGradient(
			DSFGradient(pins: [
				DSFGradient.Pin(CGColor.RGBA(0.8, 0, 0, 1), 0),
				DSFGradient.Pin(CGColor.RGBA(0.1, 0, 0, 1), 1)
			])!,
			centerPoint: CGPoint(x: 0.5, y: 0.5)
		)
		doc3.design.style.onPixels = radial

		let cg1 = try XCTUnwrap(doc3.cgImage(CGSize(width: 300, height: 300)))
		let data = try XCTUnwrap(cg1.representation.png(dpi: 144))
		try outputFolder.write(data, to: "fillstyles.png")
	}

	func testCustomPupilUsage() throws {
		let doc = QRCode.Document(utf8String: "Custom pupil")
		doc.design.style.background = QRCode.FillStyle.Solid(.commonWhite)
		doc.design.shape.eye = QRCode.EyeShape.Squircle()
		doc.design.style.eye = QRCode.FillStyle.Solid(0.149, 0.137, 0.208)
		doc.design.shape.pupil = QRCode.PupilShape.BarsHorizontal()
		doc.design.style.pupil = QRCode.FillStyle.Solid(0.314, 0.235, 0.322)
		doc.design.style.onPixels = QRCode.FillStyle.Solid(0.624, 0.424, 0.400)

		let cg1 = try XCTUnwrap(doc.cgImage(CGSize(width: 300, height: 300)))
		let data = try XCTUnwrap(cg1.representation.png(dpi: 144))
		try outputFolder.write(data, to: "custompupil.png")
	}

	func testLogoUsage() throws {
		do {
			let doc = QRCode.Document(utf8String: "QR Code with overlaid logo", errorCorrection: .high)
			doc.design.backgroundColor(CGColor.sRGBA(0.149, 0.137, 0.208))
			doc.design.shape.onPixels = QRCode.PixelShape.CurvePixel(cornerRadiusFraction: 0.8)
			doc.design.style.onPixels = QRCode.FillStyle.Solid(1.000, 0.733, 0.424, alpha: 1.000)

			doc.design.style.eye   = QRCode.FillStyle.Solid(0.831, 0.537, 0.416, alpha: 1.000)
			doc.design.style.pupil = QRCode.FillStyle.Solid(0.624, 0.424, 0.400, alpha: 1.000)

			doc.design.shape.eye = QRCode.EyeShape.RoundedPointingIn()

			let image = try resourceImage(for: "square-logo", extension: "png")

			// Centered square logo
			doc.logoTemplate = QRCode.LogoTemplate(
				image: image,
				path: CGPath(rect: CGRect(x: 0.35, y: 0.35, width: 0.30, height: 0.30), transform: nil),
				inset: 2
			)

			let cg1 = try XCTUnwrap(doc.cgImage(CGSize(width: 300, height: 300)))
			let data = try XCTUnwrap(cg1.representation.png(dpi: 144))
			try outputFolder.write(data, to: "qrcode-with-logo.png")

			let pdfData = try XCTUnwrap(doc.pdfData(dimension: 300))
			try outputFolder.write(pdfData, to: "qrcode-with-logo.pdf")
		}

		do {
			let doc = QRCode.Document(utf8String: "QR Code with overlaid logo center square", errorCorrection: .high)
			let image = try resourceImage(for: "square-logo", extension: "png")

			// Create a logo 'template'
			doc.logoTemplate = QRCode.LogoTemplate(
				image: image,
				path: CGPath(rect: CGRect(x: 0.35, y: 0.35, width: 0.30, height: 0.30), transform: nil),
				inset: 3
			)

			let cg1 = try XCTUnwrap(doc.cgImage(CGSize(width: 300, height: 300)))
			let data = try XCTUnwrap(cg1.representation.png(dpi: 144))
			try outputFolder.write(data, to: "qrcode-with-logo-example.png")
		}

		do {
			let doc = QRCode.Document(utf8String: "QR Code with overlaid logo bottom right circular", errorCorrection: .high)
			let image = try resourceImage(for: "instagram-icon", extension: "png")

			// Create a logo 'template'
			doc.logoTemplate = QRCode.LogoTemplate(
				image: image,
				path: CGPath(ellipseIn: CGRect(x: 0.7, y: 0.7, width: 0.30, height: 0.30), transform: nil),
				inset: 8
			)

			let cg1 = try XCTUnwrap(doc.cgImage(CGSize(width: 300, height: 300)))
			let data = try XCTUnwrap(cg1.representation.png(dpi: 144))
			try outputFolder.write(data, to: "qrcode-with-logo-example-bottom-right.png")
		}
	}

	func testGenerateOffPixels() throws {
		do {
			let doc = QRCode.Document(utf8String: "QRCode drawing only the 'off' pixels of the qr code", errorCorrection: .high)
			doc.design.shape.onPixels = QRCode.PixelShape.Circle(insetFraction: 0.05)
			doc.design.shape.negatedOnPixelsOnly = true
			doc.design.style.background = QRCode.FillStyle.Solid(gray: 0)
			doc.design.foregroundStyle(QRCode.FillStyle.Solid(gray: 1))

			let cg1 = try XCTUnwrap(doc.cgImage(dimension: 600))
			let data = try XCTUnwrap(cg1.representation.png(dpi: 144))
			try outputFolder.write(data, to: "qrcode-with-negated.png")

			let pdfData = try XCTUnwrap(doc.pdfData(dimension: 600))
			try outputFolder.write(pdfData, to: "qrcode-with-negated.pdf")
		}
	}

	func testSampleQRCodeImages() throws {

		do {
			let doc = QRCode.Document(utf8String: "This is an image background")
			let image = try resourceImage(for: "photo-logo", extension: "jpg")

			doc.design.style.background = QRCode.FillStyle.Image(image)
			doc.design.style.onPixels = QRCode.FillStyle.Solid(gray: 1, alpha: 0.5)

			let cg1 = try XCTUnwrap(doc.cgImage(dimension: 400))
			let data = try XCTUnwrap(cg1.representation.jpeg(compression: 0.65))
			try outputFolder.write(data, to: "demo-simple-image-background.jpg")
		}

		do {
			let doc = QRCode.Document(utf8String: "https://en.wikipedia.org/wiki/The_Wombles")
			let image = try resourceImage(for: "wombles", extension: "jpeg")

			let pixelFill = QRCode.FillStyle.LinearGradient(
				DSFGradient(pins: [
					DSFGradient.Pin(CGColor.RGBA(0, 0, 1), 0),
					DSFGradient.Pin(CGColor.RGBA(1, 0, 0), 1),
				])!,
				startPoint: CGPoint(x: 0, y: 0),
				endPoint: CGPoint(x: 0, y: 1)
			)

			let fillImage = try XCTUnwrap(pixelFill.makeImage(dimension: 500))
			XCTAssertEqual(500, fillImage.width)
			XCTAssertEqual(500, fillImage.height)

			doc.design.style.onPixels = pixelFill
			doc.design.shape.onPixels = QRCode.PixelShape.RoundedEndIndent(cornerRadiusFraction: 1, hasInnerCorners: true)

			doc.design.shape.eye = QRCode.EyeShape.Shield(topLeft: false, topRight: true, bottomLeft: true, bottomRight: false)

			let logo = QRCode.LogoTemplate(image: image)
			logo.path = CGPath(rect: CGRect(x: 0.65, y: 0.375, width: 0.25, height: 0.25), transform: nil)
			doc.logoTemplate = logo

			let cg1 = try XCTUnwrap(doc.cgImage(dimension: 400))
			let data = try XCTUnwrap(cg1.representation.jpeg(compression: 0.8))
			try outputFolder.write(data, to: "demo-wombles.jpg")
		}

		do {
			let doc = QRCode.Document(
				utf8String: "QRCode drawing only the 'off' pixels of the qr code with quiet space",
				errorCorrection: .high
			)
			doc.design.additionalQuietZonePixels = 6
			doc.design.style.backgroundFractionalCornerRadius = 4
			doc.design.shape.onPixels = QRCode.PixelShape.Circle(insetFraction: 0.05)
			doc.design.shape.negatedOnPixelsOnly = true

			// Black background
			doc.design.style.background = QRCode.FillStyle.Solid(gray: 0)
			// White foreground
			doc.design.foregroundStyle(QRCode.FillStyle.Solid(gray: 1))

			let cg1 = try XCTUnwrap(doc.cgImage(dimension: 600))
			let data = try XCTUnwrap(cg1.representation.png())
			try outputFolder.write(data, to: "design-negated-quiet-space.png")
		}

		do {
			let d = QRCode.Document(engine: QRCodeEngine_External())
			d.utf8String = "https://www.swift.org"

			d.design.backgroundColor(CGColor.sRGBA(0, 0.6, 0))

			d.design.style.eye = QRCode.FillStyle.Solid(gray: 1)
			d.design.style.eyeBackground = CGColor.gray(0, 0.2)

			d.design.shape.onPixels = QRCode.PixelShape.Square(insetFraction: 0.7)
			d.design.style.onPixels = QRCode.FillStyle.Solid(gray: 1)
			d.design.style.onPixelsBackground = CGColor.sRGBA(1, 1, 1, 0.2)

			d.design.shape.offPixels = QRCode.PixelShape.Square(insetFraction: 0.7)
			d.design.style.offPixels = QRCode.FillStyle.Solid(gray: 0)
			d.design.style.offPixelsBackground = CGColor.sRGBA(0, 0, 0, 0.2)

			let svg = try d.svg(dimension: 600)
			try outputFolder.write(svg, to: "svgExportPixelBackgroundColors.svg")
		}

		do {
			let doc = QRCode.Document(
				utf8String: "http://www.bom.gov.au/products/IDR022.loop.shtml",
				errorCorrection: .high
			)

			// Set the background image
			let backgroundImage = try resourceImage(for: "b-image", extension: "jpg")
			doc.design.style.background = QRCode.FillStyle.Image(backgroundImage)

			// The red component color
			let red_color = CGColor.sRGBA(1, 0, 0)

			// Use Squircle for the eye
			doc.design.shape.eye = QRCode.EyeShape.Squircle()
			// We need to set the color of the eye background, or else the background image shows
			// through the eye (which is bad for recognition)
			doc.design.style.eyeBackground = red_color

			// Make the 'on' pixels white
			doc.design.style.onPixels = QRCode.FillStyle.Solid(1, 1, 1)
			doc.design.shape.onPixels = QRCode.PixelShape.Square(insetFraction: 0.5)

			// Make the 'off' pixels red
			doc.design.style.offPixels = QRCode.FillStyle.Solid(red_color)
			doc.design.shape.offPixels = QRCode.PixelShape.Square(insetFraction: 0.5)

			// Generate the image
			let cg1 = try XCTUnwrap(doc.cgImage(dimension: 400))
			let data = try XCTUnwrap(cg1.representation.jpeg(dpi: 144, compression: 0.65))
			try outputFolder.write(data, to: "qrcode-off-pixels.jpg")
		}

		do {
			let doc = QRCode.Document(utf8String: "https://www.worldwildlife.org")

			let backgroundImage = try resourceImage(for: "wwf", extension: "jpeg")
			doc.design.style.background = QRCode.FillStyle.Image(backgroundImage)

			doc.design.style.eyeBackground = .commonWhite

			doc.design.shape.onPixels = QRCode.PixelShape.Star(insetFraction: 0.4)
			doc.design.style.onPixels = QRCode.FillStyle.Solid(.commonBlack)

			doc.design.shape.offPixels = QRCode.PixelShape.Star(insetFraction: 0.4)
			doc.design.style.offPixels = QRCode.FillStyle.Solid(.commonWhite)

			doc.design.shape.eye = QRCode.EyeShape.Leaf()
			doc.design.shape.pupil = QRCode.PupilShape.BarsHorizontal()

			// Generate the image
			let svg = try doc.svg(dimension: 300)
			try outputFolder.write(svg, to: "wwf.svg")
		}

		do {
			let doc = QRCode.Document(utf8String: "https://developer.apple.com/swift/")

			let gradient = try! DSFGradient.build([
				(0.3 , CGColor.sRGBA(0.005, 0.101, 0.395, 1)),
				(0.55, CGColor.sRGBA(0, 0.021, 0.137, 1)),
				(0.65, CGColor.sRGBA(0, 0.978, 0.354, 1)),
				(0.66, CGColor.sRGBA(1, 0.248, 0, 1)),
				(1.0 , CGColor.sRGBA(0, 0, 0, 1)),
			])

			let linear = QRCode.FillStyle.LinearGradient(
				gradient,
				startPoint: CGPoint(x: 0.3, y: 0),
				endPoint: CGPoint(x: 0.9, y: 1)
			)

			doc.design.style.background = linear
			doc.design.additionalQuietZonePixels = 1
			doc.design.style.backgroundFractionalCornerRadius = 3

			doc.design.shape.eye = QRCode.EyeShape.RoundedPointingIn()

			doc.design.style.onPixels = QRCode.FillStyle.Solid(gray: 1)
			doc.design.shape.onPixels = QRCode.PixelShape.Vertical(insetFraction: 0.05, cornerRadiusFraction: 1)

			doc.design.style.offPixels = QRCode.FillStyle.Solid(gray: 1, alpha: 0.1)
			doc.design.shape.offPixels = QRCode.PixelShape.Vertical(insetFraction: 0.05, cornerRadiusFraction: 1)

			let imageData = try XCTUnwrap(doc.pngData(dimension: 400))
			try outputFolder.write(imageData, to: "linear-background.png")
		}

		do {
			let doc = QRCode.Document(utf8String: "https://www.qrcode.com/en/history/", errorCorrection: .high)

			doc.design.shape.eye = QRCode.EyeShape.Squircle()
			doc.design.style.eye = QRCode.FillStyle.Solid(108.0 / 255.0, 76.0 / 255.0, 191.0 / 255.0)
			doc.design.style.pupil = QRCode.FillStyle.Solid(168.0 / 255.0, 33.0 / 255.0, 107.0 / 255.0)

			doc.design.shape.onPixels = QRCode.PixelShape.Squircle(insetFraction: 0.1)

			let c = QRCode.FillStyle.RadialGradient(
				DSFGradient(pins: [
					DSFGradient.Pin(CGColor.RGBA(1, 1, 0.75, 1), 1),
					DSFGradient.Pin(CGColor.RGBA(1, 1, 0.95, 1), 0),
					]
				)!,
				centerPoint: CGPoint(x: 0.5, y: 0.5))

			doc.design.style.background = c

			// Create a logo 'template'
			let image = try resourceImage(for: "logo-scan", extension: "png")

			doc.logoTemplate = QRCode.LogoTemplate(
				image: image,
				path: CGPath(rect: CGRect(x: 0.49, y: 0.4, width: 0.45, height: 0.22), transform: nil),
				inset: 4
			)

			let svg = try doc.svg(dimension: 200)
			try outputFolder.write(svg, to: "qrcode-with-basic-logo.svg")

			let pdfData = try doc.pdfData(dimension: 200)
			try outputFolder.write(pdfData, to: "qrcode-with-basic-logo.pdf")
		}
	}

	func testPeacockBeach() throws {
		let doc = QRCode.Document(utf8String: "Peacock feathers style, with bubbles style on pixels")

		let background = CGColor(srgbRed: 0.018, green:0.086, blue:0.15, alpha:1)
		doc.design.backgroundColor(background)

		doc.design.shape.eye = QRCode.EyeShape.Peacock()

		doc.design.shape.onPixels = QRCode.PixelShape.Circle(insetFraction: 0.4, useRandomInset: true)

		let image = try resourceCommonImage(for: "beach-square", extension: "jpg")
		doc.design.style.onPixels = QRCode.FillStyle.Image(image: image)

		let cg1 = try XCTUnwrap(doc.cgImage(CGSize(width: 300, height: 300)))
		let data = try XCTUnwrap(cg1.representation.jpeg(dpi: 144, compression: 0.65))
		try outputFolder.write(data, to: "beach-peacock.jpg")

		let pdfData = try doc.pdfData(dimension: 300)
		try outputFolder.write(pdfData, to: "beach-peacock.pdf")

		let svgData = try doc.svgData(dimension: 300)
		try outputFolder.write(svgData, to: "beach-peacock.svg")
	}
}
