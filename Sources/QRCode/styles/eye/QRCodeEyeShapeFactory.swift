//
//  QRCodeEyeShapeFactory.swift
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

import CoreGraphics
import Foundation

/// An eye shape factory
@objc public class QRCodeEyeShapeFactory: NSObject {
	/// A shared eye shape factory
	@objc public static let shared = QRCodeEyeShapeFactory()

	/// Create
	@objc override public init() {
		self.registeredTypes = [
			QRCode.EyeShape.Circle.self,
			QRCode.EyeShape.Edges.self,
			QRCode.EyeShape.RoundedRect.self,
			QRCode.EyeShape.RoundedPointingIn.self,
			QRCode.EyeShape.Squircle.self,
			QRCode.EyeShape.RoundedOuter.self,
			QRCode.EyeShape.Square.self,
			QRCode.EyeShape.Leaf.self,
			QRCode.EyeShape.BarsVertical.self,
			QRCode.EyeShape.BarsHorizontal.self,
			QRCode.EyeShape.Pixels.self,
			QRCode.EyeShape.CorneredPixels.self,
			QRCode.EyeShape.RoundedPointingOut.self,
			QRCode.EyeShape.Shield.self
		]
		super.init()
	}

	@objc public var availableGeneratorNames: [String] {
		self.registeredTypes.map { $0.Name }.sorted()
	}

	/// Return a new instance of an eye shape generator with the specified name and optional settings
	@objc public func named(_ name: String, settings: [String: Any]? = nil) -> QRCodeEyeShapeGenerator? {
		guard let f = self.registeredTypes.first(where: { $0.Name == name }) else {
			return nil
		}
		return f.Create(settings)
	}

	/// Create an eye shape generator from the specified shape settings
	@objc public func create(settings: [String: Any]) -> QRCodeEyeShapeGenerator? {
		guard let type = settings[EyeShapeTypeName_] as? String else { return nil }
		let settings = settings[EyeShapeSettingsName_] as? [String: Any] ?? [:]
		return self.named(type, settings: settings)
	}

	// Private

	internal var registeredTypes: [QRCodeEyeShapeGenerator.Type]
}

public extension QRCodeEyeShapeFactory {
	/// Generate an image of the eye represented by a specific eye generator
	/// - Parameters:
	///   - eyeGenerator: The eye generator to use
	///   - pupilGenerator: The pupil generator to use. If nil, uses the default eye pupil
	///   - dimension: The dimension of the image to output
	///   - foregroundColor: The foreground color
	///   - backgroundColor: The background color (optional)
	/// - Returns: A CGImage representation of the eye
	func image(
		eyeGenerator: QRCodeEyeShapeGenerator,
		pupilGenerator: QRCodePupilShapeGenerator? = nil,
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

		let fitScale = dimension / 90
		var scaleTransform = CGAffineTransform.identity
		scaleTransform = scaleTransform.scaledBy(x: fitScale, y: fitScale)

		// Draw the qr with the required styles
		let path = CGMutablePath()
		path.addPath(eyeGenerator.eyePath(), transform: scaleTransform)

		let pupil = pupilGenerator ?? eyeGenerator.defaultPupil()
		path.addPath(pupil.pupilPath(), transform: scaleTransform)

		context.addPath(path)
		context.setFillColor(foregroundColor)
		context.fillPath()

		let im = context.makeImage()
		return im
	}
}

public extension QRCodeEyeShapeFactory {
	/// Generate an array of <generator_name>:<sample_image> pairs for each of the eye generators
	/// - Parameters:
	///   - dimension: The dimension of the sample images to generate
	///   - foregroundColor: The foreground color
	///   - backgroundColor: The background color (optional)
	///   - isOn: If true, draws the 'on' pixels in the qrcode, else draws the 'off' pixels
	/// - Returns: A CGImage representation of the data
	func generateSampleImages(
		dimension: CGFloat,
		foregroundColor: CGColor,
		backgroundColor: CGColor? = nil,
		isOn: Bool = true
	) -> [(name: String, image: CGImage)] {
		QRCodeEyeShapeFactory.shared.availableGeneratorNames
			.sorted()
			.compactMap { name in
				guard
					let eyeGenerator = QRCodeEyeShapeFactory.shared.named(name),
					let eyeImage = QRCodeEyeShapeFactory.shared.image(
						eyeGenerator: eyeGenerator,
						dimension: dimension,
						foregroundColor: foregroundColor,
						backgroundColor: backgroundColor
					)
				else {
					return nil
				}
				return (name: name, image: eyeImage)
			}
	}
}
