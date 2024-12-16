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
				if g.supportsSettingValue(forKey: QRCode.SettingsKey.isFlipped)
						|| g.supportsSettingValue(forKey: QRCode.SettingsKey.flip) {
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
				if g.supportsSettingValue(forKey: QRCode.SettingsKey.isFlipped)
						|| g.supportsSettingValue(forKey: QRCode.SettingsKey.flip) {
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
				if g.supportsSettingValue(forKey: QRCode.SettingsKey.isFlipped)
						|| g.supportsSettingValue(forKey: QRCode.SettingsKey.flip) {
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
