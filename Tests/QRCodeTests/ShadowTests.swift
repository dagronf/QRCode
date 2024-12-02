import XCTest
@testable import QRCode

private var markdownText = ""
private let outputFolder = try! testResultsContainer.subfolder(with: "shadow-tests")
private let imagesFolder = try! outputFolder.subfolder(with: "images")
private let imageStore = ImageOutput(imagesFolder)

private let shadowTypes = [QRCode.ShadowType.dropShadow, QRCode.ShadowType.innerShadow]

final class ShadowTests: XCTestCase {

	override func setUpWithError() throws {
	}

	override func tearDownWithError() throws {
		try! outputFolder.write(markdownText, to: "index-\(osstring).md", encoding: .utf8)
	}

	func testSolidImageShadows() throws {

		markdownText += "# Shadows - solid fill 1\n\n"

		let doc = try QRCode.Document(utf8String: "shadow-basic", errorCorrection: .high)

		try shadowTypes.forEach { shadowType in

			markdownText += "## \(shadowType.name)\n\n"

			let s1 = QRCode.Shadow(shadowType, dx: 0.2, dy: -0.2, blur: 3, color: CGColor.sRGBA(1, 0, 1))
			let s2 = QRCode.Shadow(shadowType, dx: 0, dy: 0, blur: 8, color: CGColor.sRGBA(0, 0, 1))
			let s3 = QRCode.Shadow(shadowType, dx: -0.2, dy: 0.2, blur: 8, color: CGColor.sRGBA(0, 1, 0))

			markdownText += "| shadow  |   png   |   svg   |   pdf   |\n"
			markdownText += "|---------|---------|---------|---------|\n"

			try [nil, s1, s2, s3].enumerated().forEach { item in
				doc.design.style.shadow = item.element

				if let s = item.element {
					markdownText += "| \(s.offset.width) x \(s.offset.height) : \(s.blur) "
				}
				else {
					markdownText += "| no shadow "
				}

				markdownText += " | "
				do {
					let imd = try doc.imageData(.png(), dimension: 600)
					let link = try imageStore.store(imd, filename: "basic-all-shadow-\(shadowType.name)-\(item.offset).png")
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"150\" /></a> "
				}
				markdownText += " | "
				do {
					let imd = try doc.imageData(.svg, dimension: 600)
					let link = try imageStore.store(imd, filename: "basic-all-shadow-\(shadowType.name)-\(item.offset).svg")
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"150\" /></a> "
				}
				markdownText += " | "
				do {
					let imd = try doc.imageData(.pdf(), dimension: 600)
					let link = try imageStore.store(imd, filename: "basic-all-shadow-\(shadowType.name)-\(item.offset).pdf")
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"150\" /></a> "
				}
				markdownText += " |\n"
			}

			markdownText += "\n\n"
		}
	}

	func testFancyLinearGradient() throws {

		markdownText += "# Shadows - linear fill 1\n\n"

		let doc = try QRCode.build
			.text("https://www.apple.com/au/")
			.errorCorrection(.medium)
			.eye.shape(.crt())
			.onPixels.shape(QRCode.PixelShape.Blob())
			.onPixels.style(
				QRCode.FillStyle.LinearGradient(
					try DSFGradient(pins: [
						DSFGradient.Pin(CGColor.RGBA(1, 0.589, 0, 1), 0),
						DSFGradient.Pin(CGColor.RGBA(1, 0, 0.3, 1), 1),
					]),
					startPoint: CGPoint(x: 0, y: 1),
					endPoint: CGPoint(x: 0, y: 0)
				)
			)
			.offPixels.shape(QRCode.PixelShape.Circle(insetFraction: 0.3))
			.offPixels.style(QRCode.FillStyle.Solid(0, 0, 0, alpha: 0.1))
			.document

		try shadowTypes.forEach { shadowType in

			markdownText += "## \(shadowType.name)\n\n"

			let s1 = QRCode.Shadow(shadowType, offset: CGSize(width: 0.2, height: -0.2), blur: 3, color: CGColor(red: 0, green: 0, blue: 0, alpha: 1))
			let s2 = QRCode.Shadow(shadowType, offset: CGSize(width: 0, height: 0), blur: 10, color: CGColor(red: 0, green: 0, blue: 0, alpha: 1))
			let s3 = QRCode.Shadow(shadowType, offset: CGSize(width: 0.25, height: -0.25), blur: 0, color: CGColor(red: 0, green: 0, blue: 1, alpha: 1))

			markdownText += "|  shadow |   png   |   svg   |   pdf   |\n"
			markdownText += "|---------|---------|---------|---------|\n"

			try [nil, s1, s2, s3].enumerated().forEach { shadow in
				doc.design.style.shadow = shadow.element

				if let s = shadow.element {
					markdownText += "| \(s.offset.width) x \(s.offset.height) : \(s.blur) "
				}
				else {
					markdownText += "| no shadow "
				}

				markdownText += " | "
				do {
					let imd = try doc.imageData(.png(), dimension: 600)
					let link = try imageStore.store(imd, filename: "styled-shadow-\(shadowType.name)-\(shadow.offset).png")
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"150\" /></a> "
				}
				markdownText += " | "
				do {
					let imd = try doc.imageData(.svg, dimension: 600)
					let link = try imageStore.store(imd, filename: "styled-shadow-\(shadowType.name)-\(shadow.offset).svg")
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"150\" /></a> "
				}
				markdownText += " | "
				do {
					let imd = try doc.imageData(.pdf(), dimension: 600)
					let link = try imageStore.store(imd, filename: "styled-shadow-\(shadowType.name)-\(shadow.offset).pdf")
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"150\" /></a> "
				}

				markdownText += "|\n"
			}
			markdownText += "\n\n"
		}
	}

	func testFancyLinearGradient2() throws {

		markdownText += "# Drop shadow - linear fill 2\n\n"

		let doc = try QRCode.Document(utf8String: "Rainbow linear gradient", errorCorrection: .high)
		doc.design.additionalQuietZonePixels = 3
		doc.design.shape.onPixels = QRCode.PixelShape.RoundedPath(cornerRadiusFraction: 1)
		doc.design.shape.negatedOnPixelsOnly = true
		doc.design.backgroundColor(.commonBlack)
		doc.design.foregroundStyle(
			QRCode.FillStyle.LinearGradient(
				try DSFGradient(pins: [
					DSFGradient.Pin(CGColor.RGBA(1, 0.149, 0, 1), 0),
					DSFGradient.Pin(CGColor.RGBA(1, 0.578, 0, 1), 0.2),
					DSFGradient.Pin(CGColor.RGBA(0.999, 0.985, 0, 1), 0.4),
					DSFGradient.Pin(CGColor.RGBA(0, 0.976, 0, 1), 0.6),
					DSFGradient.Pin(CGColor.RGBA(0.016, 0.198, 1, 1), 0.8),
					DSFGradient.Pin(CGColor.RGBA(0.581, 0.215, 1, 1), 1),
				]),
				startPoint: CGPoint(x: 0, y: 0),
				endPoint: CGPoint(x: 1, y: 0)
			)
		)

		let s1 = QRCode.Shadow(.dropShadow, dx: 0.1, dy: -0.1, blur: 2, color: CGColor(gray: 1, alpha: 1))
		let s2 = QRCode.Shadow(.innerShadow, dx: 0.2, dy: -0.2, blur: 4, color: CGColor(gray: 1, alpha: 1))

		try [s1, s2].enumerated().forEach { shadow in

			markdownText += "## \(shadow.element.type.name)\n\n"

			markdownText += "|   png   |   svg   |   pdf   |\n"
			markdownText += "|---------|---------|---------|\n"

			doc.design.style.shadow = shadow.element

			do {
				let imd = try doc.imageData(.png(), dimension: 600)
				let link = try imageStore.store(imd, filename: "rainbow-shadow-\(shadow.offset).png")
				markdownText += "| <a href=\"\(link)\"><img src=\"\(link)\" width=\"100\" /></a> | "
			}
			do {
				let imd = try doc.imageData(.svg, dimension: 600)
				let link = try imageStore.store(imd, filename: "rainbow-shadow-\(shadow.offset).svg")
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"100\" /></a> | "
			}
			do {
				let imd = try doc.imageData(.pdf(), dimension: 600)
				let link = try imageStore.store(imd, filename: "rainbow-shadow-\(shadow.offset).pdf")
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"100\" /></a> | "
			}

			markdownText += "\n\n"
		}

		markdownText += "\n\n"
	}

	func testRadialGradient1() throws {

		markdownText += "# Shadows - radial fill 1\n\n"

		let gr = try DSFGradient(pins: [
			DSFGradient.Pin(CGColor.RGBA(0.03, 0.3, 0.1, 1), 0),
			DSFGradient.Pin(CGColor.RGBA(0, 1, 0.2, 1), 1.0),
		])

		let rfill = QRCode.FillStyle.RadialGradient(gr, centerPoint: CGPoint(x: 0.5, y: 0.75))

		let doc = try QRCode.Document(utf8String: "Radial gradient", errorCorrection: .high)
		doc.design.style.onPixels = rfill
		doc.design.shape.eye = QRCode.EyeShape.RoundedRect(cornerRadiusFraction: 0.8)

		try shadowTypes.forEach { shadowType in

			markdownText += "## \(shadowType.name)\n\n"

			let s1 = QRCode.Shadow(shadowType, dx: 0.2, dy: -0.2, blur: 3, color: CGColor.sRGBA(0, 0, 0))
			let s2 = QRCode.Shadow(shadowType, dx: 0, dy: 0, blur: 10, color: CGColor.sRGBA(0, 0, 0))
			let s3 = QRCode.Shadow(shadowType, dx: 0.25, dy: 0.25, blur: 0, color: CGColor.sRGBA(0, 0, 0))

			markdownText += "|  shadow |   png   |   svg   |   pdf   |\n"
			markdownText += "|---------|---------|---------|---------|\n"

			try [nil, s1, s2, s3].enumerated().forEach { shadow in
				doc.design.style.shadow = shadow.element

				if let s = shadow.element {
					markdownText += "| \(s.offset.width) x \(s.offset.height) : \(s.blur) "
				}
				else {
					markdownText += "| no shadow "
				}

				markdownText += " | "
				do {
					let imd = try doc.imageData(.png(), dimension: 600)
					let link = try imageStore.store(imd, filename: "radial-\(shadowType.name)-\(shadow.offset).png")
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"150\" /></a> "
				}
				markdownText += " | "
				do {
					let imd = try doc.imageData(.svg, dimension: 600)
					let link = try imageStore.store(imd, filename: "radial-\(shadowType.name)-\(shadow.offset).svg")
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"150\" /></a> "
				}
				markdownText += " | "
				do {
					let imd = try doc.imageData(.pdf(), dimension: 600)
					let link = try imageStore.store(imd, filename: "radial-\(shadowType.name)-\(shadow.offset).pdf")
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"150\" /></a> "
				}
				markdownText += "|\n"
			}

			markdownText += "\n\n"
		}
	}

	func testImageShadowFill() throws {

		markdownText += "# Shadows - image fill\n\n"

		let doc = try QRCode.Document(utf8String: "Peacock feathers style, with bubbles style on pixels")

		doc.design.shape.eye = QRCode.EyeShape.Peacock()

		doc.design.shape.onPixels = QRCode.PixelShape.Circle(
			insetGenerator: QRCode.PixelInset.Random(),
			insetFraction: 0.4
		)

		let image = try resourceCommonImage(for: "beach-square", extension: "jpg")
		doc.design.style.onPixels = QRCode.FillStyle.Image(image: image)

		try shadowTypes.forEach { shadowType in

			markdownText += "## \(shadowType.name)\n\n"

			let s1 = QRCode.Shadow(shadowType, offset: CGSize(width: 0.1, height: -0.1), blur: 3, color: CGColor(red: 0, green: 0, blue: 0, alpha: 1))
			let s2 = QRCode.Shadow(shadowType, offset: CGSize(width: 0, height: 0), blur: 10, color: CGColor(red: 0, green: 0, blue: 0, alpha: 1))
			let s3 = QRCode.Shadow(shadowType, offset: CGSize(width: 0.1, height: 0.1), blur: 0, color: CGColor(red: 0, green: 0, blue: 1, alpha: 1))

			markdownText += "| shadow |   png   |   svg   |   pdf   |\n"
			markdownText += "|--------|---------|---------|---------|\n"

			try [nil, s1, s2, s3].enumerated().forEach { shadow in
				let s = shadow.element
				doc.design.style.shadow = s
				if let s = s {
					markdownText += "| \(s.offset.width) x \(s.offset.height) : \(s.blur) "
				}
				else {
					markdownText += "| no shadow "
				}

				markdownText += " | "
				do {
					let imd = try doc.imageData(.png(), dimension: 600)
					let link = try imageStore.store(imd, filename: "image-shadow-\(shadowType.name)-\(shadow.offset).png")
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"150\" /></a> "
				}
				markdownText += " | "
				do {
					let imd = try doc.imageData(.svg, dimension: 600)
					let link = try imageStore.store(imd, filename: "image-shadow-\(shadowType.name)-\(shadow.offset).svg")
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"150\" /></a> "
				}
				markdownText += " | "
				do {
					let imd = try doc.imageData(.pdf(), dimension: 600)
					let link = try imageStore.store(imd, filename: "image-shadow-\(shadowType.name)-\(shadow.offset).pdf")
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"150\" /></a> "
				}
				markdownText += "|\n"
			}

			markdownText += "\n\n"
		}
	}

	func testBasicSolidShadowFill() throws {

		markdownText += "# Shadows - solid fill 2\n\n"

		let doc = try QRCode.Document(utf8String: "Basic shadow")
		doc.design.additionalQuietZonePixels = 2
		doc.design.style.backgroundFractionalCornerRadius = 2
		doc.design.style.background = QRCode.FillStyle.Solid(0, 0, 0.4)
		doc.design.style.onPixels = QRCode.FillStyle.Solid(1, 1, 0)

		try shadowTypes.forEach { shadowType in

			markdownText += "## \(shadowType.name)\n\n"

			let gray = (shadowType == .dropShadow) ? 1.0 : 0.0

			let s1 = QRCode.Shadow(shadowType, dx: 0.25, dy: -0.25, blur: 8, color: CGColor(gray: gray, alpha: 1))
			let s2 = QRCode.Shadow(shadowType, dx: 0, dy: 0, blur: 8, color: CGColor(gray: gray, alpha: 1))

			markdownText += "| shadow |   png   |   svg   |   pdf   |\n"
			markdownText += "|--------|---------|---------|---------|\n"

			try [nil, s1, s2].enumerated().forEach { shadow in
				doc.design.style.shadow = shadow.element

				if let s = shadow.element {
					markdownText += "| \(s.offset.width) x \(s.offset.height) : \(s.blur) "
				}
				else {
					markdownText += "| no shadow "
				}

				markdownText += " | "
				do {
					let imd = try doc.imageData(.png(), dimension: 600)
					let link = try imageStore.store(imd, filename: "solid-fill-with-shadow-\(shadowType.name)-\(shadow.offset).png")
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"150\" /></a> "
				}
				markdownText += " | "
				do {

					let imd = try doc.imageData(.svg, dimension: 600)
					let link = try imageStore.store(imd, filename: "solid-fill-with-shadow-\(shadowType.name)-\(shadow.offset).svg")
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"150\" /></a> "
				}
				markdownText += " | "
				do {
					let imd = try doc.imageData(.pdf(), dimension: 600)
					let link = try imageStore.store(imd, filename: "solid-fill-with-shadow-\(shadowType.name)-\(shadow.offset).pdf")
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"150\" /></a> "
				}
				markdownText += " |\n"
			}

			markdownText += "\n\n"
		}
		markdownText += "\n\n"
	}

	//	func testShadowMatrix() throws {
	//
	//		markdownText += "# Drop shadow - matrix\n\n"
	//
	//		let doc = try QRCode.Document(utf8String: "Matrix qr code with shadow")
	//		doc.errorCorrection = .high
	//		doc.design.backgroundColor(CGColor.sRGBA(1, 1, 0.4))
	//
	//		let places = [-0.2, -0.1, 0.0, 0.1, 0.2]
	//
	//		let exportTypes: [QRCode.Document.ExportType] = [.png(), .svg]
	//
	//		try exportTypes.forEach { exportType in
	//
	//			markdownText += "## Export - \(exportType.fileExtension)\n\n"
	//
	//			markdownText += "|     |     |     |     |     |\n"
	//			markdownText += "|-----|-----|-----|-----|-----|\n"
	//
	//			for y in places.reversed() {
	//				markdownText += "| "
	//				for x in places {
	//					let s1 = QRCode.Shadow(dx: x, dy: y, blur: 16, color: CGColor.sRGBA(1, 0, 0))
	//					doc.design.style.shadow = s1
	//
	//					let imd = try doc.imageData(exportType, dimension: 600)
	//					let link = try imageStore.store(imd, filename: "matrix(\(x),\(y)).\(exportType.fileExtension)")
	//					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"100\" /></a> |"
	//				}
	//				markdownText += "\n"
	//			}
	//			markdownText += "\n\n"
	//		}
	//	}
}
