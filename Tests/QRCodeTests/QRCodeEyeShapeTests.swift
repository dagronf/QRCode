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
		markdown += "# Eye shape configuration\n\n"
	}

	override func tearDownWithError() throws {
		// Write out the markdown
		try markdown.write()
	}

	func testGenerateEyeShapeOptions() throws {
		
		markdown += "|  Eye Shape  |  Options  |\n"
		markdown += "|:-----------:|-----------|\n"

		let images = try QRCodeEyeShapeFactory.shared.generateSampleImages(
			dimension: 200,
			foregroundColor: CGColor.commonBlack,
			backgroundColor: CGColor.commonWhite
		)

		for shape in images {
			let imageData = try shape.image.imageData(for: .png())
			let link = try markdown.add(filename: shape.name + ".png", imageData: imageData)

			markdown += "| <a href=\"\(link)\"><img src=\"\(link)\" width=\"75\" /></a><br/>\(shape.name) | "

			let generator = try QRCodeEyeShapeFactory.shared.named(shape.name)

			var settings: String = ""

			if generator.supportsSettingValue(forKey: QRCode.SettingsKey.cornerRadiusFraction) {
				settings += "• __Corner radius__<br/>"
			}
			if generator.supportsSettingValue(forKey: QRCode.SettingsKey.hasInnerCorners) {
				settings += "• __Optional Inner corners__<br/>"
			}
			if generator.supportsSettingValue(forKey: QRCode.SettingsKey.corners) {
				settings += "• __Configurable corners__<br/>"
			}
			if generator.supportsSettingValue(forKey: QRCode.SettingsKey.isFlipped) {
				settings += "• __Flippable__<br/>"
			}
			if generator.supportsSettingValue(forKey: QRCode.SettingsKey.eyeInnerStyle) {
				settings += "• __Configurable inner corners__<br/>"
			}

			if settings.count > 0 {
				markdown += settings
			}
			else {
				markdown += "_none_"
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

	func testGeneratePixelShapeOptions() throws {

		markdown += "|  Pixel Shape  |  Options  |\n"
		markdown += "|:-------------:|-----------|\n"

		let images = try QRCodePixelShapeFactory.shared.generateSampleImages(
			dimension: 200,
			foregroundColor: CGColor.commonBlack,
			backgroundColor: CGColor.commonWhite
		)

		for shape in images {
			let imageData = try shape.image.imageData(for: .png())
			let link = try markdown.add(filename: shape.name + ".png", imageData: imageData)

			markdown += "| <a href=\"\(link)\"><img src=\"\(link)\" width=\"75\" /></a><br/>__\(shape.name)__ | "

			let generator = try QRCodePixelShapeFactory.shared.named(shape.name)

			var settings: String = ""

			if generator.supportsSettingValue(forKey: QRCode.SettingsKey.cornerRadiusFraction) {
				settings += "• __Corner radius__<br/>"
			}
			if generator.supportsSettingValue(forKey: QRCode.SettingsKey.hasInnerCorners) {
				settings += "• __Optional Inner corners__<br/>"
			}
			if generator.supportsSettingValue(forKey: QRCode.SettingsKey.corners) {
				settings += "• __Configurable corners__<br/>"
			}
			if generator.supportsSettingValue(forKey: QRCode.SettingsKey.isFlipped) {
				settings += "• __Flippable__<br/>"
			}
			if generator.supportsSettingValue(forKey: QRCode.SettingsKey.rotationFraction) {
				settings += "• __Pixel rotation__<br/>"
			}
			if generator.supportsSettingValue(forKey: QRCode.SettingsKey.rotationGeneratorName) {
				settings += "&nbsp;&nbsp;- Supports pixel rotation generator<br/>"
			}

			if generator.supportsSettingValue(forKey: QRCode.SettingsKey.insetFraction) {
				settings += "• __Pixel inset__<br/>"
			}
			if generator.supportsSettingValue(forKey: QRCode.SettingsKey.insetGeneratorName) {
				settings += "&nbsp;&nbsp;- Supports pixel inset generator<br/>"
			}

			if settings.count > 0 {
				markdown += settings
			}
			else {
				markdown += "_none_"
			}

			markdown += " |\n"
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

		markdown += "|  Pupil Shape  |  Options  |\n"
		markdown += "|:-------------:|-----------|\n"

		let images = try QRCodePupilShapeFactory.shared.generateSampleImages(
			dimension: 100,
			foregroundColor: CGColor.commonBlack,
			backgroundColor: CGColor.commonWhite
		)

		for shape in images {
			let imageData = try shape.image.imageData(for: .png())
			let link = try markdown.add(filename: shape.name + ".png", imageData: imageData)

			markdown += "| <a href=\"\(link)\"><img src=\"\(link)\" width=\"50\" /></a><br/>__\(shape.name)__ | "

			let generator = try QRCodePupilShapeFactory.shared.named(shape.name)

			var settings: String = ""

			if generator.supportsSettingValue(forKey: QRCode.SettingsKey.cornerRadiusFraction) {
				settings += "• __Corner radius__<br/>"
			}
			if generator.supportsSettingValue(forKey: QRCode.SettingsKey.hasInnerCorners) {
				settings += "• __Optional Inner corners__<br/>"
			}
			if generator.supportsSettingValue(forKey: QRCode.SettingsKey.corners) {
				settings += "• __Configurable corners__<br/>"
			}
			if generator.supportsSettingValue(forKey: QRCode.SettingsKey.isFlipped) {
				settings += "• __Flippable__<br/>"
			}

			if settings.count > 0 {
				markdown += settings
			}
			else {
				markdown += "_none_"
			}

			markdown += " |\n"
		}
	}
}
