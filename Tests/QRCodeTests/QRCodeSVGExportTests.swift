@testable import QRCode

import XCTest

final class QRCodeSVGTests: XCTestCase {

	let outputFolder = try! testResultsContainer.subfolder(with: "QRCodeSVGTests")

	func testBasicSVG() throws {
		let doc = QRCode.Document(
			utf8String: "This is a test This is a test This is a test This is a test",
			errorCorrection: .high,
			generator: __testGenerator
		)

		do {
			let image = try loadImageResource("colored-fill", withExtension: "jpg")

			doc.design.foregroundColor(CGColor.RGBA(1, 0, 0, 1))
			doc.logoTemplate = QRCode.LogoTemplate(
				image: image,
				path: CGPath(ellipseIn: CGRect(x: 0.35, y: 0.35, width: 0.3, height: 0.3), transform: nil)
			)
			let svg = doc.svg(dimension: 800)
			XCTAssertGreaterThan(svg.count, 0)

			try outputFolder.write(svg, to: "basicSVG1-mask-no-image.svg")
		}

		do {
			doc.design.foregroundColor(CGColor.RGBA(0, 0.3, 0, 1))
			let svg = doc.svg(dimension: 512)
			XCTAssertGreaterThan(svg.count, 0)
			try outputFolder.write(svg, to: "basicSVG2-mask-no-image.svg")
		}
	}

	func testExportSVGWithSolidFill() throws {
		let code = QRCode.Document(
			utf8String: "https://www.apple.com/au/mac-studio/",
			errorCorrection: .high,
			generator: __testGenerator
		)
		code.design.shape.onPixels = QRCode.PixelShape.CurvePixel(cornerRadiusFraction: 0.8)

		do {
			// Flat color
			code.design.style.onPixels = QRCode.FillStyle.Solid(CGColor.sRGBA(1, 0, 1, 1))

			let svg1 = code.svg(dimension: 600)

			XCTAssertTrue(svg1.contains("fill=\"#ff00ff\""))
			try outputFolder.write(svg1, to: "solidFillGeneration.svg")

			let image = code.platformImage(dimension: 300, dpi: 144)!
			let data = image.pngRepresentation()!
			try outputFolder.write(data, to: "solidFillGeneration.png")
		}
	}

	func testExportSVGWithLinearFill() throws {
		let code = QRCode.Document(
			utf8String: "https://www.apple.com/au/mac-studio/",
			errorCorrection: .high,
			generator: __testGenerator
		)

		// Draw without a background
		code.design.style.background = nil

		code.design.shape.eye = QRCode.EyeShape.RoundedPointingIn()
		code.design.style.eye = QRCode.FillStyle.LinearGradient(
			DSFGradient(
				pins: [
					DSFGradient.Pin(CGColor.sRGBA(0.6, 0.6, 0, 1), 0),
					DSFGradient.Pin(CGColor.sRGBA(0.0, 0.4, 0, 1), 1),
				]
			)!,
			startPoint: CGPoint(x: 0, y: 1),
			endPoint: CGPoint(x: 1, y: 1)
		)

		// linear color
		code.design.style.onPixels = QRCode.FillStyle.LinearGradient(
			DSFGradient(
				pins: [
					DSFGradient.Pin(CGColor.sRGBA(1, 0, 0, 1), 0),
					DSFGradient.Pin(CGColor.sRGBA(0, 0, 1, 1), 1),
				]
			)!
		)
		let svg1 = code.svg(dimension: 600)
		try outputFolder.write(svg1, to: "svgExportLinearFill.svg")

		let image = code.platformImage(dimension: 300, dpi: 144)!
		let data = image.pngRepresentation()!
		try outputFolder.write(data, to: "svgExportLinearFill.png")
	}

	func testExportSVGWithRadialFill() throws {
		let code = QRCode.Document(
			utf8String: "https://www.apple.com/au/mac-studio/",
			errorCorrection: .high,
			generator: __testGenerator
		)
		code.design.shape.onPixels = QRCode.PixelShape.CurvePixel(cornerRadiusFraction: 0.8)

		code.design.shape.eye = QRCode.EyeShape.Circle()
		code.design.shape.pupil = QRCode.PupilShape.BarsHorizontal()

		code.design.style.background = QRCode.FillStyle.Solid(1, 1.0, 0.8)
		code.design.style.eyeBackground = CGColor.white

		// radial fill
		let c = QRCode.FillStyle.RadialGradient(
			DSFGradient(
				pins: [
					DSFGradient.Pin(CGColor.sRGBA(1, 0, 0, 1), 0),
					DSFGradient.Pin(CGColor.sRGBA(0, 1, 0, 1), 0.5),
					DSFGradient.Pin(CGColor.sRGBA(0, 0, 1, 1), 1.0),
				]
			)!,
			centerPoint: CGPoint(x: 0.5, y: 0.5)
		)

		code.design.style.onPixels = c
		let svg1 = code.svg(dimension: 600)
		try outputFolder.write(svg1, to: "svgExportRadialFill.svg")

		let image = code.platformImage(dimension: 300, dpi: 144)!
		let data = image.pngRepresentation()!
		try outputFolder.write(data, to: "svgExportRadialFill.png")
	}

	func testExportSVGWithBackgroundPixelColors() throws {

		let d = QRCode.Document(generator: QRCodeGenerator_External())
		d.utf8String = "https://www.swift.org"

		d.design.backgroundColor(CGColor.sRGBA(0, 0.6, 0, 1))

		d.design.style.eye = QRCode.FillStyle.Solid(gray: 1)
		d.design.style.eyeBackground = CGColor.gray(0, 0.2)

		d.design.shape.onPixels = QRCode.PixelShape.Square(insetFraction: 0.7)
		d.design.style.onPixels = QRCode.FillStyle.Solid(gray: 1)
		d.design.style.onPixelsBackground = CGColor.sRGBA(1, 1, 1, 0.2)

		d.design.shape.offPixels = QRCode.PixelShape.Square(insetFraction: 0.7)
		d.design.style.offPixels = QRCode.FillStyle.Solid(gray: 0)
		d.design.style.offPixelsBackground = CGColor.sRGBA(0, 0, 0, 0.2)

		let svg1 = d.svg(dimension: 600)
		try outputFolder.write(svg1, to: "svgExportPixelBackgroundColors.svg")
	}

	func testSVGFormatter() throws {
		// SVG Formatting should _always_ use '.' as the decimal separator
		XCTAssertEqual(_SVGF(0.33), "0.33")
		XCTAssertEqual(_SVGF(1), "1")
		XCTAssertEqual(_SVGF(1.4), "1.4")
		XCTAssertEqual(_SVGF(1024.56), "1024.56")
		XCTAssertEqual(_SVGF(123456789.789), "123456789.789")
	}

	#if os(macOS)
	func testIssue19ExportSVGIssue() throws {
		
		// You can test this by changing the text locale to French
		
		// See [Issue 19](https://github.com/dagronf/QRCode/issues/19)
		
		let d = QRCode.Document(utf8String: "Test")
		d.errorCorrection = .low
		d.design.shape.eye = QRCode.EyeShape.RoundedOuter()
		d.design.shape.onPixels = QRCode.PixelShape.Circle()
		let str = d.svg(dimension: 989)
		
		//		try str.write(
		//			to: URL(fileURLWithPath: "/tmp/qrcode19.svg"),
		//			atomically: true,
		//			encoding: .utf8
		//		)
		
		let url = try XCTUnwrap(Bundle.module.url(forResource: "Issue19Generated", withExtension: "svg"))
		let existing = try String(contentsOf: url)
		XCTAssertEqual(str, existing)
	}
	#endif

}
