import XCTest
@testable import QRCode

private var markdownText = ""
private let outputFolder = try! testResultsContainer.subfolder(with: "eyeshapes")
private let imagesFolder = try! outputFolder.subfolder(with: "images")
private let imageStore = ImageOutput(imagesFolder)

private let formatter3: NumberFormatter = {
	let n = NumberFormatter()
	n.minimumFractionDigits = 3
	n.maximumFractionDigits = 3
	return n
}()

final class QRCodeEyeShapeTests: XCTestCase {

	override func setUpWithError() throws {
		markdownText += "# Eye tests\n\n"
	}

	override func tearDownWithError() throws {
		// Write out the markdown
		try! outputFolder.write(markdownText, to: "eye-shapes-\(OSString()).md", encoding: .utf8)
	}

	func testRoundedPointingOut() throws {

		markdownText += "## RoundedPointingOut check (\(OSString()))\n\n"

		markdownText += "## Eye shape\n\n"

		markdownText += "|  roundedPointingOut  |   roundedPointingIn   |   roundedPointingIn (flipped)   |\n"
		markdownText += "|-------------|-------------|-------------|\n"

		do {
			let doc = try QRCode.build
				.text("roundedPointingOut")
				.eye.shape(QRCode.EyeShape.RoundedPointingOut())
				.document

			let image = try doc.pngData(dimension: 200)
			let filename = "eye-roundedPointingOut-check1.png"
			let link = try imageStore.store(image, filename: filename)

			markdownText += "| <a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a> "
		}

		do {
			let doc = try QRCode.build
				.text("roundedPointingIn")
				.eye.shape(QRCode.EyeShape.RoundedPointingIn())
				.document

			let image = try doc.pngData(dimension: 200)
			let filename = "eye-roundedPointingIn-check1.png"
			let link = try imageStore.store(image, filename: filename)

			markdownText += "| <a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a> "
		}

		do {
			let doc = try QRCode.build
				.text("roundedPointingInFlip ")
				.eye.shape(QRCode.EyeShape.RoundedPointingIn(flip: .both))
				.document

			let image = try doc.pngData(dimension: 200)
			let filename = "eye-roundedPointingIn-flip.png"
			let link = try imageStore.store(image, filename: filename)

			markdownText += "| <a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a> |\n\n"
		}

		markdownText += " |\n\n"

		markdownText += "## Pupil shape\n\n"

		markdownText += "|  roundedPointingOut  |   roundedPointingIn   |   roundedPointingIn (flipped)   |\n"
		markdownText += "|-------------|-------------|-------------|\n"

		do {
			let doc = try QRCode.build
				.text("roundedPointingOut")
				.pupil.shape(QRCode.PupilShape.RoundedPointingOut())
				.document

			let image = try doc.pngData(dimension: 200)
			let filename = "pupil-roundedPointingOut-check1.png"
			let link = try imageStore.store(image, filename: filename)

			markdownText += "| <a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a> "
		}

		do {
			let doc = try QRCode.build
				.text("roundedPointingIn")
				.pupil.shape(QRCode.PupilShape.RoundedPointingIn())
				.document

			let image = try doc.pngData(dimension: 200)
			let filename = "pupil-roundedPointingIn-check1.png"
			let link = try imageStore.store(image, filename: filename)

			markdownText += "| <a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a> "
		}

		do {
			let doc = try QRCode.build
				.text("roundedPointingInFlip ")
				.pupil.shape(QRCode.PupilShape.RoundedPointingIn(flip: .both))
				.document

			let image = try doc.pngData(dimension: 200)
			let filename = "pupil-roundedPointingIn-flip.png"
			let link = try imageStore.store(image, filename: filename)

			markdownText += "| <a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a> |\n\n"
		}

		markdownText += " |\n\n"
	}

	func testEyeCornerRadius() throws {
		markdownText += "## Rounded Rect eye radius configuration (\(OSString()))\n\n"

		markdownText += "|  radius  |   png   |   svg   |  quiet  |\n"
		markdownText += "|:---------|:-------:|:-------:|:-------:|\n"

		var steps = [QRCode.EyeShape.RoundedRect.DefaultRadius]  // Make
		steps.append(contentsOf: stride(from: 0, through: 1, by: 0.2).map { $0 })
		try steps.forEach { cornerRadius in

			markdownText += "| \(formatter3.string(for: cornerRadius)!)"

			let doc = try QRCode.build
				.text("Eye corner radius")
				.backgroundColor(CGColor(red: 0, green: 0, blue: 1, alpha: 0.3))
				.eye.shape(QRCode.EyeShape.RoundedRect(cornerRadiusFraction: cornerRadius))
				.eye.backgroundColor(CGColor(red: 1, green: 0, blue: 0, alpha: 1))
				.document

			let image = try doc.pngData(dimension: 400)
			let filename = "eye-rounded-rect-radius-\(cornerRadius).png"
			let link = try imageStore.store(image, filename: filename)

			markdownText += "| <a href=\"\(link)\"><img src=\"\(link)\" width=\"250\" /></a> "

			let svgImage = try doc.svgData(dimension: 400)
			let filename2 = "eye-rounded-rect-radius-\(cornerRadius).svg"
			let link2 = try imageStore.store(svgImage, filename: filename2)
			markdownText += "| <a href=\"\(link2)\"><img src=\"\(link2)\" width=\"250\" /></a> "

			doc.design.additionalQuietZonePixels = 6
			let image3 = try doc.pngData(dimension: 400)
			let filename3 = "eye-rounded-rect-radius-\(cornerRadius)-qs.png"
			let link3 = try imageStore.store(image3, filename: filename3)
			markdownText += "| <a href=\"\(link3)\"><img src=\"\(link3)\" width=\"250\" /></a> "

			markdownText += "|\n"
		}
		markdownText += "\n\n"
	}
}

final class QRCodeEyeShapeConfigurationTests: XCTestCase {

	let markdown = MarkdownContainer(testName: "eye-configuration-options")

	override func setUpWithError() throws {
		markdown += "# Eye shape options\n\n"
	}

	override func tearDownWithError() throws {
		// Write out the markdown
		try markdown.write()
	}

	func testGenerateEyeShapeOptions() throws {
		
		markdown += "|  Preview  |  Name  | Class |  Options  | \n"
		markdown += "|:-------------:|-----------|---------|---------|\n"

		QRCodeEyeShapeFactory.shared.all().sorted(by: { a, b in a.name < b.name }).forEach { g in
			let link = "../../Art/images/eye_\(g.name).png"

			markdown += "| <a href=\"\(link)\"><img src=\"\(link)\" width=\"75\" /></a> "
			markdown += "| __\(g.name)__ "
			let typename = "\(type(of: g))"
			markdown += "| `QRCode.EyeShape.\(typename)` "
			markdown += "| "

			do {
				var settings: String = ""

				if g.supportsSettingValue(forKey: QRCode.SettingsKey.cornerRadiusFraction) {
					settings += "• __Corner radius__<br/>"
				}
				if g.supportsSettingValue(forKey: QRCode.SettingsKey.hasInnerCorners) {
					settings += "• __Optional Inner corners__<br/>"
				}
				if g.supportsSettingValue(forKey: QRCode.SettingsKey.corners) {
					settings += "• __Configurable corners__<br/>"
				}
				if g.supportsSettingValue(forKey: QRCode.SettingsKey.flip) {
					settings += "• __Flippable__<br/>"
				}
				if g.supportsSettingValue(forKey: QRCode.SettingsKey.rotationFraction) {
					settings += "• __Pixel rotation__<br/>"
				}
				if g.supportsSettingValue(forKey: QRCode.SettingsKey.rotationGeneratorName) {
					settings += "&nbsp;&nbsp;- Supports pixel rotation generator<br/>"
				}

				if g.supportsSettingValue(forKey: QRCode.SettingsKey.insetFraction) {
					settings += "• __Pixel inset__<br/>"
				}
				if g.supportsSettingValue(forKey: QRCode.SettingsKey.insetGeneratorName) {
					settings += "&nbsp;&nbsp;- Supports pixel inset generator<br/>"
				}
				if g.supportsSettingValue(forKey: QRCode.SettingsKey.eyeInnerStyle) {
					settings += "• __Configurable eye corners__<br/>"
				}

				markdown += (settings.count > 0) ? settings : "_none_"
			}

			markdown += " |\n"
		}
	}
}


final class QRCodePixelShapeConfigurationTests: XCTestCase {

	let markdown = MarkdownContainer(testName: "pixel-configuration-options")

	override func setUpWithError() throws {
		markdown += "# Pixel shape options\n\n"
	}

	override func tearDownWithError() throws {
		// Write out the markdown
		try markdown.write()
	}

	func testGeneratePixelShapes() throws {

		markdown += "|  Preview  |  Name  | Class |  Options  | \n"
		markdown += "|:-------------:|-----------|---------|---------|\n"

		QRCodePixelShapeFactory.shared.all().sorted(by: { a, b in a.name < b.name }).forEach { g in
			let link = "../../Art/images/data_\(g.name).png"

			markdown += "| <a href=\"\(link)\"><img src=\"\(link)\" width=\"75\" /></a> "
			markdown += "| __\(g.name)__ "
			let typename = "\(type(of: g))"
			markdown += "| `QRCode.PixelShape.\(typename)` "
			markdown += "| "

			do {
				var settings: String = ""

				if g.supportsSettingValue(forKey: QRCode.SettingsKey.cornerRadiusFraction) {
					settings += "• __Corner radius__<br/>"
				}
				if g.supportsSettingValue(forKey: QRCode.SettingsKey.hasInnerCorners) {
					settings += "• __Optional Inner corners__<br/>"
				}
				if g.supportsSettingValue(forKey: QRCode.SettingsKey.corners) {
					settings += "• __Configurable corners__<br/>"
				}
				if g.supportsSettingValue(forKey: QRCode.SettingsKey.flip) {
					settings += "• __Flippable__<br/>"
				}
				if g.supportsSettingValue(forKey: QRCode.SettingsKey.rotationFraction) {
					settings += "• __Pixel rotation__<br/>"
				}
				if g.supportsSettingValue(forKey: QRCode.SettingsKey.rotationGeneratorName) {
					settings += "&nbsp;&nbsp;- Supports pixel rotation generator<br/>"
				}

				if g.supportsSettingValue(forKey: QRCode.SettingsKey.insetFraction) {
					settings += "• __Pixel inset__<br/>"
				}
				if g.supportsSettingValue(forKey: QRCode.SettingsKey.insetGeneratorName) {
					settings += "&nbsp;&nbsp;- Supports pixel inset generator<br/>"
				}

				markdown += (settings.count > 0) ? settings : "_none_"
				markdown += " |\n"
			}
		}
	}
}

final class QRCodePupilShapeConfigurationTests: XCTestCase {

	let markdown = MarkdownContainer(testName: "pupil-configuration-options")

	override func setUpWithError() throws {
		markdown += "# Pupil shape options\n\n"
	}

	override func tearDownWithError() throws {
		// Write out the markdown
		try markdown.write()
	}

	func testGeneratePupilShapeOptions() throws {

		markdown += "|  Preview  |  Name  | Class |  Options  | \n"
		markdown += "|:-------------:|-----------|---------|---------|\n"

		QRCodePupilShapeFactory.shared.all().sorted(by: { a, b in a.name < b.name }).forEach { g in
			let link = "../../Art/images/pupil_\(g.name).png"

			markdown += "| <a href=\"\(link)\"><img src=\"\(link)\" width=\"75\" /></a> "
			markdown += "| __\(g.name)__ "
			let typename = "\(type(of: g))"
			markdown += "| `QRCode.PixelShape.\(typename)` "
			markdown += "| "

			do {
				var settings: String = ""

				if g.supportsSettingValue(forKey: QRCode.SettingsKey.cornerRadiusFraction) {
					settings += "• __Corner radius__<br/>"
				}
				if g.supportsSettingValue(forKey: QRCode.SettingsKey.hasInnerCorners) {
					settings += "• __Optional Inner corners__<br/>"
				}
				if g.supportsSettingValue(forKey: QRCode.SettingsKey.corners) {
					settings += "• __Configurable corners__<br/>"
				}
				if g.supportsSettingValue(forKey: QRCode.SettingsKey.flip) {
					settings += "• __Flippable__<br/>"
				}
				if g.supportsSettingValue(forKey: QRCode.SettingsKey.rotationFraction) {
					settings += "• __Pixel rotation__<br/>"
				}
				if g.supportsSettingValue(forKey: QRCode.SettingsKey.rotationGeneratorName) {
					settings += "&nbsp;&nbsp;- Supports pixel rotation generator<br/>"
				}

				if g.supportsSettingValue(forKey: QRCode.SettingsKey.insetFraction) {
					settings += "• __Pixel inset__<br/>"
				}
				if g.supportsSettingValue(forKey: QRCode.SettingsKey.insetGeneratorName) {
					settings += "&nbsp;&nbsp;- Supports pixel inset generator<br/>"
				}

				markdown += (settings.count > 0) ? settings : "_none_"
				markdown += " |\n"
			}
		}
	}
}


final class InlineDocumentationGenerations: XCTestCase {

	let markdown = MarkdownContainer(testName: "inline-documentation-image-lists.md")

	override func tearDownWithError() throws {
		// Write out the markdown
		try markdown.write()
	}

	func testGenerateInlineEyeImagesForDocumentation() throws {
		markdown += "## Main doco inline pixel shape markdown\n\n"
		QRCodePixelShapeFactory.shared.all().sorted(by: { a, b in a.name < b.name }).forEach { g in
			markdown += "<img src=\"./Art/images/data_\(g.name).png\" width=\"60\" title=\"\(g.title)\" /> "
		}
		markdown += "\n\n"

		markdown += "## Main doco inline eye shape markdown\n\n"
		QRCodeEyeShapeFactory.shared.all().sorted(by: { a, b in a.name < b.name }).forEach { g in
			markdown += "<img src=\"./Art/images/eye_\(g.name).png\" width=\"60\" title=\"\(g.title)\" /> "
		}
		markdown += "\n\n"

		markdown += "## Main doco inline pupil shape markdown\n\n"
		QRCodePupilShapeFactory.shared.all().sorted(by: { a, b in a.name < b.name }).forEach { g in
			markdown += "<img src=\"./Art/images/pupil_\(g.name).png\" width=\"30\" title=\"\(g.title)\" /> "
		}
		markdown += "\n\n"
	}
}


final class EyeMirroringGenerationTests: XCTestCase {

	let markdown = MarkdownContainer(testName: "eye-mirroring.md")

	override func tearDownWithError() throws {
		// Write out the markdown
		try markdown.write()
	}

	func testGenerateInlineEyeImagesForDocumentation() throws {
		markdown += "## Eye mirroring\n\n"

		let doc = try QRCode.Document(utf8String: "Eye mirroring tests")

		markdown += "| name | png-mirror-true | svg-mirror-true | png-mirror-false | svg-mirror-false|\n"
		markdown += "|------|------|------|------|------|\n"

		try QRCodeEyeShapeFactory.shared.all().sorted(by: { a, b in a.name < b.name }).forEach { g in
			doc.design.shape.eye = g
			doc.design.style.eye = QRCode.FillStyle.Solid(1, 0, 0)
			doc.design.style.eyeBackground = .RGBA(0, 1, 0)

			markdown += "| \(g.name) "

			doc.design.shape.mirrorEyePathsAroundQRCodeCenter = true
			let png = try doc.pngData(dimension: 300)
			let orig = try markdown.add(filename: "eye-mirror-true-\(g.name).png", imageData: png)
			markdown += "| <a href=\"\(orig)\"><img src=\"\(orig)\" width=\"200\" /></a> "

			doc.design.shape.mirrorEyePathsAroundQRCodeCenter = true
			let svg1 = try doc.svgData(dimension: 300)
			let orig3 = try markdown.add(filename: "eye-mirror-true-\(g.name).svg", imageData: svg1)
			markdown += "| <a href=\"\(orig3)\"><img src=\"\(orig3)\" width=\"200\" /></a> "

			doc.design.shape.mirrorEyePathsAroundQRCodeCenter = false
			let png2 = try doc.pngData(dimension: 300)
			let orig2 = try markdown.add(filename: "eye-mirror-false-\(g.name).png", imageData: png2)
			markdown += "| <a href=\"\(orig2)\"><img src=\"\(orig2)\" width=\"200\" /></a> "

			doc.design.shape.mirrorEyePathsAroundQRCodeCenter = false
			let svg2 = try doc.svgData(dimension: 300)
			let orig4 = try markdown.add(filename: "eye-mirror-false-\(g.name).svg", imageData: svg2)
			markdown += "| <a href=\"\(orig4)\"><img src=\"\(orig4)\" width=\"200\" /></a> "

			markdown += "|\n"
		}

		markdown += "\n\n"

		do {
			let doc = try QRCode.Document(utf8String: "Pupil mirroring tests")

			markdown += "| name | png-mirror-true | svg-mirror-true | png-mirror-false | svg-mirror-false|\n"
			markdown += "|------|------|------|------|------|\n"

			try QRCodePupilShapeFactory.shared.all().sorted(by: { a, b in a.name < b.name }).forEach { g in
				doc.design.shape.pupil = g
				doc.design.style.pupil = QRCode.FillStyle.Solid(1, 0, 0)

				markdown += "| \(g.name) "

				doc.design.shape.mirrorEyePathsAroundQRCodeCenter = true
				let png = try doc.pngData(dimension: 300)
				let orig = try markdown.add(filename: "pupil-mirror-true-\(g.name).png", imageData: png)
				markdown += "| <a href=\"\(orig)\"><img src=\"\(orig)\" width=\"200\" /></a> "

				doc.design.shape.mirrorEyePathsAroundQRCodeCenter = true
				let svg1 = try doc.svgData(dimension: 300)
				let orig3 = try markdown.add(filename: "pupil-mirror-true-\(g.name).svg", imageData: svg1)
				markdown += "| <a href=\"\(orig3)\"><img src=\"\(orig3)\" width=\"200\" /></a> "

				doc.design.shape.mirrorEyePathsAroundQRCodeCenter = false
				let png2 = try doc.pngData(dimension: 300)
				let orig2 = try markdown.add(filename: "pupil-mirror-false-\(g.name).png", imageData: png2)
				markdown += "| <a href=\"\(orig2)\"><img src=\"\(orig2)\" width=\"200\" /></a> "

				doc.design.shape.mirrorEyePathsAroundQRCodeCenter = false
				let svg2 = try doc.svgData(dimension: 300)
				let orig4 = try markdown.add(filename: "pupil-mirror-false-\(g.name).svg", imageData: svg2)
				markdown += "| <a href=\"\(orig4)\"><img src=\"\(orig4)\" width=\"200\" /></a> "

				markdown += "|\n"
			}
		}
	}
}
