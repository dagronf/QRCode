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

private let outputFolder = try! testResultsContainer.subfolder(with: "pixel-rotation-doco")
private let imagesFolder = try! outputFolder.subfolder(with: "images")
private let imageStore = ImageOutput(imagesFolder)
private var markdown = ""

final class QRCodePixelRotationDocumentTests: XCTestCase {

	override func setUpWithError() throws {
		markdown += "# Pixel rotation generator examples\n\n"
	}

	override func tearDownWithError() throws {
		// Write out the markdown
		try! outputFolder.write(markdown, to: "pixel-rotation-tests.md", encoding: .utf8)
	}

	func testExample() throws {
		markdown += "| Name |  0.0  |  0.125  |  0.25  |  0.375  |  0.5  |\n"
		markdown += "|------|-------|-------|-------|-------|-------|\n"

		try QRCode.PixelRotation.generators.forEach { generator in

			let g = generator.Create()

			markdown += "| \(g.name) "

			try [0.0, 0.125, 0.25, 0.375, 0.5].forEach { (inset: CGFloat) in
				let pngData = try QRCode.build
					.text("Pixel rotation tests")
					.errorCorrection(.high)
					.onPixels.shape(
						.heart(
							rotationGenerator: g,
							rotationFraction: inset
						)
					)
					.generate.image(dimension: 400, representation: .png())

				let filename = "rotation-\(g.name)-\(inset).png"
				let link = try imageStore.store(pngData, filename: filename)

				markdown += "| <a href=\"\(link)\"><img src=\"\(link)\" width=\"120\" /></a> &nbsp;"
			}

			markdown += " |\n"
		}
	}
}
