//
//  QRCode+SVG.swift
//
//  Copyright © 2023 Darren Ford. All rights reserved.
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

import Foundation
import CoreGraphics
import ImageIO

// QRCode SVG representation

public extension QRCode {
	/// Returns a string of SVG code for an image depicting this QR Code, with the given number of border modules.
	/// - Parameters:
	///   - dimension: The dimension of the output svg
	///   - design: The design for the QR Code
	///   - logoTemplate: The logo template to use when generating the svg data
	/// - Returns: An SVG representation of the QR code
	///
	/// The string always uses Unix newlines (\n), regardless of the platform.
	@objc func svg(
		dimension: Int,
		design: QRCode.Design,
		logoTemplate: QRCode.LogoTemplate? = nil
	) -> String {
		//let totalSize = CGSize(dimension: dimension)
		var svg = ""

		/// The size of each pixel in the output
		let additionalQuietSpacePixels = CGFloat(design.additionalQuietZonePixels)
		let dx: CGFloat = CGFloat(dimension) / (CGFloat(self.cellDimension) + (2.0 * additionalQuietSpacePixels))
		let additionalQuietSpace = dx * additionalQuietSpacePixels

		// SVG Header
		svg += "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" version=\"1.1\" height=\"\(dimension)\" width=\"\(dimension)\">\n"

		// This is the final position for the generated qr code, inset within the final image
		let rect = CGRect(origin: .zero, size: CGSize(dimension: dimension))
		let finalRect = rect.insetBy(dx: additionalQuietSpace, dy: additionalQuietSpace)

		var pathDefinitions: [String] = []

		// The background color for the qr code

		if let background = design.style.background,
			let backgroundFill = background.svgRepresentation(styleIdentifier: "background")
		{
			svg += "   <rect \(backgroundFill.styleAttribute) x=\"0\" y=\"0\" width=\"\(dimension)\" height=\"\(dimension)\""
			let cornerRadius = design.style.backgroundFractionalCornerRadius
			if cornerRadius > 0 {
				let computedRadius = Int(dx * CGFloat(cornerRadius))
				svg += " rx=\"\(computedRadius)px\" ry=\"\(computedRadius)px\""
			}
			svg += " />\n"

			if let def = backgroundFill.styleDefinition {
				pathDefinitions.append(def)
			}
		}

		// If negatedOnPixelsOnly, superceed all other styles and display settings
		if design.shape.negatedOnPixelsOnly {
			var negatedMatrix = self.boolMatrix.inverted()
			if let logoTemplate = logoTemplate {
				negatedMatrix = logoTemplate.applyingMask(matrix: negatedMatrix, dimension: CGFloat(dimension))
			}

			let negatedPath = self.path(
				finalRect.size,
				components: .negative,
				shape: design.shape,
				additionalQuietSpace: additionalQuietSpace
			)
			if let onPixels = design.style.onPixels.svgRepresentation(styleIdentifier: "on-pixels") {
				svg += "   <path \(onPixels.styleAttribute) d=\"\(negatedPath.svgDataPath())\" />\n"
				if let def = onPixels.styleDefinition {
					pathDefinitions.append(def)
				}
			}
		}
		else {

			// Eye background color

			if let eyeBackgroundColor = design.style.eyeBackground,
				let hexEyeBackgroundColor = design.style.eyeBackground?.hexRGBCode()
			{
				let eyeBackgroundPath = self.path(finalRect.size, components: .eyeBackground, shape: design.shape, additionalQuietSpace: additionalQuietSpace)
				let alphaStr = _SVGF(eyeBackgroundColor.alpha)
				svg += "   <path fill=\"\(hexEyeBackgroundColor)\" fill-opacity=\"\(alphaStr)\" d=\"\(eyeBackgroundPath.svgDataPath()))\" />\n"
			}

			// Pupil

			do {
				let eyePupilPath = self.path(finalRect.size, components: .eyePupil, shape: design.shape, additionalQuietSpace: additionalQuietSpace)
				if let pupilFill = design.style.actualPupilStyle.svgRepresentation(styleIdentifier: "pupil-fill") {
					svg += "   <path \(pupilFill.styleAttribute) d=\"\(eyePupilPath.svgDataPath())\" />\n"
					if let def = pupilFill.styleDefinition {
						pathDefinitions.append(def)
					}
				}
			}

			// Eye

			do {
				let eyeOuterPath = self.path(finalRect.size, components: .eyeOuter, shape: design.shape, additionalQuietSpace: additionalQuietSpace)
				if let eyeOuterFill = design.style.actualEyeStyle.svgRepresentation(styleIdentifier: "eye-outer-fill") {
					svg += "   <path \(eyeOuterFill.styleAttribute) d=\"\(eyeOuterPath.svgDataPath())\" />\n"
					if let def = eyeOuterFill.styleDefinition {
						pathDefinitions.append(def)
					}
				}
			}

			// The background for the off pixels (if set)
			
			do {
				if let color = design.style.offPixelsBackground,
					let offPixelsBackground = QRCode.FillStyle.Solid(color).svgRepresentation(styleIdentifier: "off-pixels-background-color")
				{
					let offPixelsBackgroundPath = self.path(finalRect.size, components: .offPixelsBackground, shape: design.shape, logoTemplate: logoTemplate, additionalQuietSpace: additionalQuietSpace)
					svg += "   <path \(offPixelsBackground.styleAttribute) d=\"\(offPixelsBackgroundPath.svgDataPath())\" />\n"
				}
			}

			// Off pixels

			do {
				if let _ = design.shape.offPixels {
					let offPixelsPath = self.path(finalRect.size, components: .offPixels, shape: design.shape, logoTemplate: logoTemplate, additionalQuietSpace: additionalQuietSpace)
					if let offPixels = design.style.offPixels?.svgRepresentation(styleIdentifier: "off-pixels") {
						svg += "   <path \(offPixels.styleAttribute) d=\"\(offPixelsPath.svgDataPath())\" />\n"
						if let def = offPixels.styleDefinition {
							pathDefinitions.append(def)
						}
					}
				}
			}

			// The background for the on pixels (if set)

			do {
				if let color = design.style.onPixelsBackground,
					let onPixelsBackground = QRCode.FillStyle.Solid(color).svgRepresentation(styleIdentifier: "on-pixels-background-color")
				{
					let onPixelsBackgroundPath = self.path(finalRect.size, components: .onPixelsBackground, shape: design.shape, logoTemplate: logoTemplate, additionalQuietSpace: additionalQuietSpace)
					svg += "   <path \(onPixelsBackground.styleAttribute) d=\"\(onPixelsBackgroundPath.svgDataPath())\" />\n"
				}
			}

			// On pixels

			do {
				let onPixelsPath = self.path(finalRect.size, components: .onPixels, shape: design.shape, logoTemplate: logoTemplate, additionalQuietSpace: additionalQuietSpace)
				if let onPixels = design.style.onPixels.svgRepresentation(styleIdentifier: "on-pixels") {
					svg += "   <path \(onPixels.styleAttribute) d=\"\(onPixelsPath.svgDataPath())\" />\n"
					if let def = onPixels.styleDefinition {
						pathDefinitions.append(def)
					}
				}
			}
		}

		if let logoTemplate = logoTemplate,
			let pngData = try? logoTemplate.image.representation.png()
		{
			// Store the image in the SVG as a base64 string

			let abspath = logoTemplate.absolutePathForMaskPath(dimension: finalRect.width)
			let bounds = abspath.boundingBoxOfPath.insetBy(
				dx: logoTemplate.inset,
				dy: logoTemplate.inset
			).offsetBy(dx: additionalQuietSpace, dy: additionalQuietSpace)

//			do {
//				let xPos   = _SVGF(bounds.origin.x)
//				let yPos   = _SVGF(bounds.origin.y)
//				let width  = _SVGF(bounds.size.width)
//				let height = _SVGF(bounds.size.height)
//				svg += " <rect x=\"\(xPos)\" y=\"\(yPos)\" width=\"\(width)\" height=\"\(height)\" stroke=\"black\" fill=\"transparent\" stroke-width=\"5\"/>\n "
//			}

			let imageb64d = pngData.base64EncodedData(options: [.lineLength64Characters, .endLineWithLineFeed])
			let strImage = String(data: imageb64d, encoding: .ascii)!

			let dp = abspath.svgDataPath()
			var clipPath = "   <clipPath id=\"logo-mask\">\n"
			clipPath += "      <path d=\"\(dp)\" />\n"
			clipPath += "   </clipPath>\n"
			pathDefinitions.append(clipPath)

			let xPos   = _SVGF(bounds.origin.x)  // - design.additionalQuietSpace)
			let yPos   = _SVGF(bounds.origin.y)  // - design.additionalQuietSpace)
			let width  = _SVGF(bounds.size.width)
			let height = _SVGF(bounds.size.height)
			

			//svg += " <image clip-path=\"url(#logo-mask)\" x=\"\(xPos)\" y=\"\(yPos)\" width=\"\(width)\" height=\"\(height)\" "
			svg += " <image x=\"\(xPos)\" y=\"\(yPos)\" width=\"\(width)\" height=\"\(height)\" "

			svg += " preserveAspectRatio=\"none\" "

			svg += "xlink:href=\"data:image/png;base64,"
			svg += strImage
			svg += "\" />"
		}

		if pathDefinitions.count > 0 {
			svg += "<defs>\n"
			for def in pathDefinitions {
				svg.append(def)
			}
			svg += "</defs>\n"
		}

		svg += "</svg>\n"

		return svg
	}

	/// Returns utf8-encoded SVG data for this qr code
	/// - Parameters:
	///   - dimension: The dimension of the output svg
	///   - design: The design for the QR Code
	///   - logoTemplate: The logo template to use when generating the svg data
	/// - Returns: An SVG representation of the QR code
	///
	/// The string always uses Unix newlines (\n), regardless of the platform.
	@objc func svgData(
		dimension: Int,
		design: QRCode.Design,
		logoTemplate: QRCode.LogoTemplate? = nil
	) -> Data? {
		let str = self.svg(dimension: dimension, design: design, logoTemplate: logoTemplate)
		return str.data(using: .utf8, allowLossyConversion: false)
	}
}
