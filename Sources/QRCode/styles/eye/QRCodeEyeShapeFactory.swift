//
//  Copyright © 2025 Darren Ford. All rights reserved.
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
@objc public final class QRCodeEyeShapeFactory: NSObject {
	/// A shared eye shape factory
	@objc public static let shared = QRCodeEyeShapeFactory()

	/// Create
	@objc override public init() {
		super.init()
	}

	/// The available eye shape generator names
	@objc public var availableGeneratorNames: [String] {
		self.registeredTypes.map { $0.Name }
	}

	/// Return all of the eye generators (with default settings) in name sorted order
	@objc public func all() -> [any QRCodeEyeShapeGenerator] {
		self.registeredTypes
			.map { $0.Create(nil) }
			.sorted(by: { a, b in a.name < b.name })
	}

	/// Return a new instance of an eye shape generator with the specified name and optional settings
	@objc public func named(_ name: String, settings: [String: Any]? = nil) throws -> (any QRCodeEyeShapeGenerator) {
		guard let f = self.registeredTypes.first(where: { $0.Name == name }) else {
			throw QRCodeError.unsupportedGeneratorName
		}
		return f.Create(settings)
	}

	/// Create an eye shape generator from the specified shape settings
	@objc public func create(settings: [String: Any]) throws -> (any QRCodeEyeShapeGenerator) {
		guard let type = settings[EyeShapeTypeName_] as? String else {
			throw QRCodeError.cannotCreateGenerator
		}
		let settings = settings[EyeShapeSettingsName_] as? [String: Any] ?? [:]
		return try self.named(type, settings: settings)
	}

	// Private

	// The registered eye shapes in name sorted order
	private let registeredTypes: [any QRCodeEyeShapeGenerator.Type] = [
		QRCode.EyeShape.Circle.self,
		QRCode.EyeShape.Edges.self,
		QRCode.EyeShape.RoundedRect.self,
		QRCode.EyeShape.Squircle.self,
		QRCode.EyeShape.RoundedOuter.self,
		QRCode.EyeShape.Square.self,
		QRCode.EyeShape.Leaf.self,
		QRCode.EyeShape.BarsVertical.self,
		QRCode.EyeShape.BarsHorizontal.self,
		QRCode.EyeShape.Pixels.self,
		QRCode.EyeShape.CorneredPixels.self,
		QRCode.EyeShape.RoundedPointingIn.self,
		QRCode.EyeShape.RoundedPointingOut.self,
		QRCode.EyeShape.Shield.self,
		QRCode.EyeShape.UsePixelShape.self,
		QRCode.EyeShape.Teardrop.self,
		QRCode.EyeShape.Fireball.self,
		QRCode.EyeShape.Peacock.self,
		QRCode.EyeShape.UFO.self,
		QRCode.EyeShape.UFORounded.self,
		QRCode.EyeShape.Pinch.self,
		QRCode.EyeShape.CRT.self,
		QRCode.EyeShape.SquarePeg.self,
		QRCode.EyeShape.Eye.self,
		QRCode.EyeShape.SpikyCircle.self,
		QRCode.EyeShape.Explode.self,
		QRCode.EyeShape.DotDragHorizontal.self,
		QRCode.EyeShape.DotDragVertical.self,
		QRCode.EyeShape.Headlight.self,
		QRCode.EyeShape.SurroundingBars.self,
		QRCode.EyeShape.Cloud.self,
		QRCode.EyeShape.FabricScissors.self,
		QRCode.EyeShape.DiagonalStripes.self,
		QRCode.EyeShape.Flame.self,
		QRCode.EyeShape.CloudCircle.self,
		QRCode.EyeShape.HolePunch.self,
	].sorted(by: { a, b in a.Title < b.Title })
}

public extension QRCodeEyeShapeFactory {
	/// Generate an image of the eye represented by a specific eye generator
	/// - Parameters:
	///   - eyeGenerator: The eye generator to use
	///   - pupilGenerator: The pupil generator to use. If nil, uses the default eye pupil
	///   - dimension: The dimension of the image to output
	///   - foregroundColor: The foreground color
	///   - backgroundColor: The background color (optional)
	///   - eyeBackgroundColor: The eye background color (optional)
	/// - Returns: A CGImage representation of the eye
	func image(
		eyeGenerator: any QRCodeEyeShapeGenerator,
		pupilGenerator: (any QRCodePupilShapeGenerator)? = nil,
		dimension: CGFloat,
		foregroundColor: CGColor,
		backgroundColor: CGColor? = nil,
		eyeBackgroundColor: CGColor? = nil
	) throws -> CGImage {
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
			throw QRCodeError.cannotGenerateImage
		}

		// fill the background color
		context.usingGState { ctx in
			ctx.setFillColor(backgroundColor ?? .commonClear)
			ctx.fill(CGRect(origin: .zero, size: CGSize(width: width, height: height)))
		}

		context.scaleBy(x: 1, y: -1)
		context.translateBy(x: 0, y: -dimension)

		let fitScale = dimension / 90
		var scaleTransform = CGAffineTransform.identity
		scaleTransform = scaleTransform.scaledBy(x: fitScale, y: fitScale)

		if let eyeBackgroundColor = eyeBackgroundColor {
			let p = CGMutablePath()
			let eb = eyeGenerator.eyeBackgroundPath()
				.applyingTransform(CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -90))
			p.addPath(eb, transform: scaleTransform)
			context.usingGState { ctx in
				ctx.addPath(p)
				ctx.setFillColor(eyeBackgroundColor)
				ctx.fillPath()
			}
		}

		// Draw the qr with the required styles
		let path = CGMutablePath()
		if let g = eyeGenerator as? QRCode.EyeShape.UsePixelShape {
			path.addPath(g.previewPath(), transform: scaleTransform)
		}
		else {
			path.addPath(eyeGenerator.eyePath(), transform: scaleTransform)
		}

		if let g = pupilGenerator as? QRCode.PupilShape.UsePixelShape {
			path.addPath(g.previewPath(), transform: scaleTransform)
		}
		else {
			let pupil = pupilGenerator ?? eyeGenerator.defaultPupil()
			path.addPath(pupil.pupilPath(), transform: scaleTransform)
		}

		context.addPath(path)
		context.setFillColor(foregroundColor)
		context.fillPath()

		guard let im = context.makeImage() else {
			throw QRCodeError.cannotGenerateImage
		}
		return im
	}
}

public extension QRCodeEyeShapeFactory {
	/// Generate an array of <generator_name>:<sample_image> pairs for each of the eye generators
	/// - Parameters:
	///   - dimension: The dimension of the sample images to generate
	///   - foregroundColor: The foreground color
	///   - backgroundColor: The background color (optional)
	///   - eyebackgroundColor: The eye background color (optional)
	/// - Returns: A CGImage representation of the data
	func generateSampleImages(
		dimension: CGFloat,
		foregroundColor: CGColor,
		backgroundColor: CGColor? = nil,
		eyeBackgroundColor: CGColor? = nil
	) throws -> [(name: String, image: CGImage)] {
		try QRCodeEyeShapeFactory.shared.all()
			.map {
				let eyeImage = try QRCodeEyeShapeFactory.shared.image(
					eyeGenerator: $0,
					dimension: dimension,
					foregroundColor: foregroundColor,
					backgroundColor: backgroundColor,
					eyeBackgroundColor: eyeBackgroundColor
				)
				return (name: $0.name, image: eyeImage)
			}
	}
}
