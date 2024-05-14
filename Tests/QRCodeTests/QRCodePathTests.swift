import XCTest
@testable import QRCode

import SwiftImageReadWrite

//private let trc = try! TestFilesContainer(named: "QRCodePathTests")
private let outputFolder = try! testResultsContainer.subfolder(with: "QRCodePathTests")
private let imagesFolder = try! outputFolder.subfolder(with: "images")
private let imageStore = ImageOutput(imagesFolder)

private var markdown = ""

// Testing the 'path' call generates the expected outcomes


final class QRCodePathTests: XCTestCase {

	override class func setUp() {
		markdown += "# Path Generation tests\n\n"
	}

	// Called when the test _class_ completes
	override class func tearDown() {
		// Write out the markdown
		try! outputFolder.write(markdown, to: "path-tests.md", encoding: .utf8)
	}

	func testBasicQRCode() throws {

		markdown += "## Basic path\n\n"

		let doc = QRCode.Document()
		let url = URL(string: "https://www.apple.com.au/")!
		try doc.update(message: try QRCode.Message.Link(url), errorCorrection: .high)

		let cs: [(QRCode.Components, String)] = [
			(.all, "all"),
			(.eyeOuter, "eye-outer"),
			(.eyePupil, "eye-pupil"),
			(.eyeAll, "eye-all"),
			(.onPixels, "on-pixels"),
			(.offPixels, "off-pixels"),
			(.eyeBackground, "eye-background"),
			(.onPixelsBackground, "on-pixels-background"),
			(.offPixelsBackground, "off-pixels-background"),
			(.negative, "negative"),
		]

		try QRCodePixelShapeFactory.shared.all().forEach { generator in

			markdown += "## \(generator.title)\n\n"

			markdown += "| Name |   0   |   4   |   8   |  12  |\n"
			markdown += "|------|-------|-------|-------|------|\n"

			doc.design.shape.onPixels = generator
			doc.design.shape.offPixels = generator

			try cs.forEach { comp in

				markdown += "| \(comp.1) "

				try [0, 4, 8, 12].forEach { quietSpace in

					markdown += "| "

					doc.design.additionalQuietZonePixels = UInt(quietSpace)

					let path = doc.path(.init(dimension: 300), components: comp.0)
					//let ppp = NSBezierPath(cgPath: path)

					let b1 = try CreateBitmap(dimension: 300) { ctx in
						ctx.usingGState { c in
							c.setFillColor(CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1))
							c.fill(CGRect(origin: .zero, size: CGSize(width: ctx.width, height: ctx.height)))
						}

						ctx.addPath(path)
						ctx.setFillColor(.commonBlack)
						ctx.fillPath()
					}

					let filename = "basic-path-\(generator.name)-\(comp.1)-qs\(quietSpace).png"
					let png = try XCTUnwrap(b1.representation.png())
					let link = try imageStore.store(png, filename: filename)
					markdown += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a> &nbsp;"
				}
				markdown += " |\n"
			}

			markdown += "\n\n"
		}

		markdown += "\n\n"
	}

	func testOffOnRegistration() throws {

		markdown += "## Path registration\n\n"

		let doc = QRCode.Document()
		let url = URL(string: "https://www.apple.com.au/")!
		try doc.update(message: try QRCode.Message.Link(url), errorCorrection: .high)

		markdown += "| on/off pixels registration | on/off background registration |\n"
		markdown += "|------|-------|\n"
		markdown += "| "

		do {
			let onPixels = doc.path(.init(dimension: 1024), components: [.onPixels])
			let offPixels = doc.path(.init(dimension: 1024), components: [.offPixels])

			let b1 = try CreateBitmap(dimension: 1024) { ctx in
				ctx.usingGState { c in
					c.setFillColor(.commonWhite)
					c.fill(CGRect(origin: .zero, size: CGSize(width: ctx.width, height: ctx.height)))
				}

				ctx.addPath(onPixels)
				ctx.setFillColor(CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 0.5))
				ctx.fillPath()

				ctx.addPath(offPixels)
				ctx.setFillColor(CGColor(srgbRed: 0, green: 0, blue: 1, alpha: 0.5))
				ctx.fillPath()
			}

			let filename = "path-registration.png"
			let png = try XCTUnwrap(b1.representation.png())
			let link = try imageStore.store(png, filename: filename)

			markdown += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"300\" /></a> |"

		}

		do {
			let onPixels = doc.path(.init(dimension: 1024), components: [.onPixelsBackground])
			let offPixels = doc.path(.init(dimension: 1024), components: [.offPixelsBackground])

			let b1 = try CreateBitmap(dimension: 1024) { ctx in
				ctx.usingGState { c in
					c.setFillColor(.commonWhite)
					c.fill(CGRect(origin: .zero, size: CGSize(width: ctx.width, height: ctx.height)))
				}

				ctx.addPath(onPixels)
				ctx.setFillColor(CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 0.5))
				ctx.fillPath()

				ctx.addPath(offPixels)
				ctx.setFillColor(CGColor(srgbRed: 0, green: 0, blue: 1, alpha: 0.5))
				ctx.fillPath()
			}

			let filename = "path-registration-background.png"
			let png = try XCTUnwrap(b1.representation.png())
			let link = try imageStore.store(png, filename: filename)

			markdown += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"300\" /></a> &nbsp;"
		}

		markdown += "\n\n"
	}

	func testEyeBackground() throws {
		let doc = QRCode.Document()
		let url = URL(string: "https://www.apple.com.au/")!
		try doc.update(message: try QRCode.Message.Link(url), errorCorrection: .high)

		try QRCodeEyeShapeFactory.shared.all().forEach { generator in
			doc.design.shape.eye = generator

			let bg = doc.path(.init(dimension: 300), components: [.eyeBackground])
			let be = doc.path(.init(dimension: 300), components: [.eyeAll])


			let b1 = try CreateBitmap(dimension: 300) { ctx in
				ctx.usingGState { c in
					c.setFillColor(.commonBlack)
					c.fill(CGRect(origin: .zero, size: CGSize(width: ctx.width, height: ctx.height)))
				}

				ctx.addPath(bg)
				ctx.setFillColor(CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1))
				ctx.fillPath()

				ctx.addPath(be)
				ctx.setFillColor(CGColor(srgbRed: 0, green: 0, blue: 1, alpha: 1))
				ctx.fillPath()
			}

			let filename = "eye-background-(\(generator.name)).png"
			let png = try XCTUnwrap(b1.representation.png())
			let link = try imageStore.store(png, filename: filename)

			markdown += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"200\" /></a> &nbsp;"
		}
	}
}
