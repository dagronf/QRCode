//
//  QRCodePupilShapeFactory.swift
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

import Foundation
import CoreGraphics

/// An eye shape factory
@objc public final class QRCodePupilShapeFactory: NSObject, Sendable {
	/// A shared eye shape factory
	@objc public static let shared = QRCodePupilShapeFactory()

	/// Create
	@objc override public init() {
		super.init()
	}

	/// The available pupil shape generator names
	@objc public var availableGeneratorNames: [String] {
		self.registeredTypes.map { $0.Name }
	}

	/// Return all of the pupil generators (with default settings) in name sorted order
	@objc public func all() -> [any QRCodePupilShapeGenerator] {
		self.registeredTypes.map { $0.Create(nil) }
	}

	/// Return a new instance of an eye shape generator with the specified name and optional settings
	@objc public func named(_ name: String, settings: [String: Any]? = nil) throws -> (any QRCodePupilShapeGenerator) {
		guard let f = self.registeredTypes.first(where: { $0.Name == name }) else {
			throw QRCodeError.unsupportedGeneratorName
		}
		return f.Create(settings)
	}

	/// Create an eye shape generator from the specified shape settings
	@objc public func create(settings: [String: Any]) throws -> (any QRCodePupilShapeGenerator) {
		guard let type = settings[PupilShapeTypeName_] as? String else {
			throw QRCodeError.cannotCreateGenerator
		}
		let settings = settings[PupilShapeSettingsName_] as? [String: Any] ?? [:]
		return try self.named(type, settings: settings)
	}

	// Private

	// The registered pupil shapes in name sorted order
	private let registeredTypes: [any QRCodePupilShapeGenerator.Type] = [
			QRCode.PupilShape.Circle.self,
			QRCode.PupilShape.CorneredPixels.self,
			QRCode.PupilShape.Cross.self,
			QRCode.PupilShape.CrossCurved.self,
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
			QRCode.PupilShape.UsePixelShape.self,
			QRCode.PupilShape.HexagonLeaf.self,
			QRCode.PupilShape.Seal.self,
			QRCode.PupilShape.Blobby.self,
			QRCode.PupilShape.Teardrop.self,
			QRCode.PupilShape.UFO.self,
			QRCode.PupilShape.Pinch.self,
			QRCode.PupilShape.SquareBarsHorizontal.self,
			QRCode.PupilShape.SquareBarsVertical.self,
	].sorted(by: { a, b in a.Title < b.Title })
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
		pupilGenerator: any QRCodePupilShapeGenerator,
		dimension: CGFloat,
		foregroundColor: CGColor,
		backgroundColor: CGColor? = nil
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

		if let g = pupilGenerator as? QRCode.PupilShape.UsePixelShape {
			path.addPath(g.previewPath(), transform: scaleTransform)
		}
		else {
			path.addPath(pupilGenerator.pupilPath(), transform: scaleTransform)
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
	) throws -> [(name: String, image: CGImage)] {
		try QRCodePupilShapeFactory.shared.all()
			.map {
				let pupilImage = try QRCodePupilShapeFactory.shared.image(
					pupilGenerator: $0,
					dimension: dimension,
					foregroundColor: foregroundColor,
					backgroundColor: backgroundColor
				)
				return (name: $0.name, image: pupilImage)
			}
	}
}
