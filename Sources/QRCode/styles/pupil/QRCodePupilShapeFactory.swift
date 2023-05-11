//
//  QRCodePupilShapeFactory.swift
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

/// An eye shape factory
@objc public class QRCodePupilShapeFactory: NSObject {
	/// A shared eye shape factory
	@objc public static let shared = QRCodePupilShapeFactory()

	/// Create
	@objc override public init() {
		self.registeredTypes = [
			QRCode.PupilShape.Circle.self,
			QRCode.PupilShape.CorneredPixels.self,
			QRCode.PupilShape.Edges.self,
			QRCode.PupilShape.RoundedRect.self,
			QRCode.PupilShape.RoundedPointingIn.self,
			QRCode.PupilShape.Squircle.self,
			QRCode.PupilShape.RoundedOuter.self,
			QRCode.PupilShape.Square.self,
			QRCode.PupilShape.Pixels.self,
			QRCode.PupilShape.Leaf.self,
			QRCode.PupilShape.BarsVertical.self,
			QRCode.PupilShape.BarsHorizontal.self,
			QRCode.PupilShape.RoundedPointingOut.self,
			QRCode.PupilShape.Shield.self,
		]
		super.init()
	}

	@objc public var availableGeneratorNames: [String] {
		self.registeredTypes.map { $0.Name }.sorted()
	}

	/// Return a new instance of an eye shape generator with the specified name and optional settings
	@objc public func named(_ name: String, settings: [String: Any]? = nil) -> QRCodePupilShapeGenerator? {
		guard let f = self.registeredTypes.first(where: { $0.Name == name }) else {
			return nil
		}
		return f.Create(settings)
	}

	/// Create an eye shape generator from the specified shape settings
	@objc public func create(settings: [String: Any]) -> QRCodePupilShapeGenerator? {
		guard let type = settings[PupilShapeTypeName_] as? String else { return nil }
		let settings = settings[PupilShapeSettingsName_] as? [String: Any] ?? [:]
		return self.named(type, settings: settings)
	}

	// Private

	internal var registeredTypes: [QRCodePupilShapeGenerator.Type]
}

public extension QRCodePupilShapeFactory {
	/// Generate an image of the data represented by a specific data generator for a fixed 5x5 data pixel representation
	/// - Parameters:
	///   - pixelShape: The pixel generator to use
	///   - dimension: The dimension of the image to output
	///   - foregroundColor: The foreground color
	///   - backgroundColor: The background color (optional)
	/// - Returns: A CGImage representation of the data
	func image(
		pupilGenerator: QRCodePupilShapeGenerator,
		dimension: CGFloat,
		foregroundColor: CGColor,
		backgroundColor: CGColor? = nil
	) -> CGImage? {
		let width = Int(dimension)
		let height = Int(dimension)
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		guard let context = CGContext(
			data: nil,
			width: width,
			height: height,
			bitsPerComponent: 8,
			bytesPerRow: 0,
			space: colorSpace,
			bitmapInfo: bitmapInfo.rawValue
		)
		else {
			return nil
		}

		// fill the background color
		context.usingGState { ctx in
			ctx.setFillColor(backgroundColor ?? .clear)
			ctx.fill(CGRect(origin: .zero, size: CGSize(width: width, height: height)))
		}

		context.scaleBy(x: 1, y: -1)
		context.translateBy(x: 0, y: -dimension)

		// Scale the context drawing so that the default size (90px) fits into the drawing
		let fitScale = dimension / 90
		context.scaleBy(x: fitScale, y: fitScale)

		// Transform to move and scale the pupil to fit the full 90x90 range
		var scaleTransform = CGAffineTransform.identity

		// Scale the pupil to 90x90
		scaleTransform = scaleTransform.scaledBy(x: 2, y: 2)

		// Move the pupil back to origin
		scaleTransform = scaleTransform.translatedBy(x: -22, y: -22)

		// Draw the qr with the required styles
		let path = CGMutablePath()
		path.addPath(pupilGenerator.pupilPath(), transform: scaleTransform)

		context.addPath(path)
		context.setFillColor(foregroundColor)
		context.fillPath()

		let im = context.makeImage()
		return im
	}
}

public extension QRCodePupilShapeFactory {
	/// Generate an array of <generator_name>:<sample_image> pairs for each of the pupil generators
	/// - Parameters:
	///   - dimension: The dimension of the sample images to generate
	///   - foregroundColor: The foreground color
	///   - backgroundColor: The background color (optional)
	///   - isOn: If true, draws the 'on' pixels in the qrcode, else draws the 'off' pixels
	/// - Returns: A CGImage representation of the data
	func generateSampleImages(
		dimension: CGFloat,
		foregroundColor: CGColor,
		backgroundColor: CGColor? = nil
	) -> [(name: String, image: CGImage)] {
		QRCodePupilShapeFactory.shared.availableGeneratorNames
			.sorted()
			.compactMap { name in
				guard
					let pupilGenerator = QRCodePupilShapeFactory.shared.named(name),
					let pupilImage = QRCodePupilShapeFactory.shared.image(
						pupilGenerator: pupilGenerator,
						dimension: dimension,
						foregroundColor: foregroundColor,
						backgroundColor: backgroundColor
					)
				else {
					return nil
				}
				return (name: name, image: pupilImage)
			}
	}
}
