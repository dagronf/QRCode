//
//  QRCodePixelShapeFactory.swift
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

import CoreGraphics
import Foundation

/// A data shape factory
@objc public final class QRCodePixelShapeFactory: NSObject, Sendable {
	/// Shared data shape factory
	@objc public static let shared = QRCodePixelShapeFactory()

	/// Create
	@objc override public init() {
		super.init()
	}

	/// The available pixel shape generator names
	@objc public var availableGeneratorNames: [String] {
		self.registeredTypes.map { $0.Name }
	}

	/// Return all of the pixel generators (with default settings) in name sorted order
	@objc public func all() -> [any QRCodePixelShapeGenerator] {
		self.registeredTypes.map { $0.Create(nil) }
	}

	/// Return a new instance of the data shape generator with the specified name and optional settings
	@objc public func named(_ name: String, settings: [String: Any]? = nil) throws -> (any QRCodePixelShapeGenerator) {
		guard let f = self.registeredTypes.first(where: { $0.Name == name }) else {
			throw QRCodeError.unsupportedGeneratorName
		}
		return f.Create(settings)
	}

	/// Create a data shape generator from the specified shape settings
	@objc public func create(settings: [String: Any]) throws -> (any QRCodePixelShapeGenerator) {
		guard let type = settings[PixelShapeTypeName_] as? String else {
			throw QRCodeError.cannotCreateGenerator
		}
		let settings = settings[PixelShapeSettingsName_] as? [String: Any]
		return try self.named(type, settings: settings)
	}

	// Private

	// The registered pixel shapes in name sorted order
	private let registeredTypes: [any QRCodePixelShapeGenerator.Type] = [
		QRCode.PixelShape.Square.self,
		QRCode.PixelShape.Circle.self,
		QRCode.PixelShape.RoundedRect.self,
		QRCode.PixelShape.Squircle.self,
		QRCode.PixelShape.Vertical.self,
		QRCode.PixelShape.Flower.self,
		QRCode.PixelShape.Horizontal.self,
		QRCode.PixelShape.Pointy.self,
		QRCode.PixelShape.CurvePixel.self,
		QRCode.PixelShape.Razor.self,
		QRCode.PixelShape.RoundedEndIndent.self,
		QRCode.PixelShape.RoundedPath.self,
		QRCode.PixelShape.Sharp.self,
		QRCode.PixelShape.Star.self,
		QRCode.PixelShape.Shiny.self,
	].sorted(by: { a, b in a.Title < b.Title })

	/// The default matrix to use when generating pixel sample images
	private static let defaultMatrix = BoolMatrix(dimension: 7, rawFlattenedInt: [
		0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 1, 1, 0, 0,
		0, 0, 0, 0, 1, 0, 0,
		0, 1, 0, 1, 1, 1, 0,
		0, 1, 1, 1, 1, 0, 0,
		0, 0, 0, 1, 0, 1, 0,
		0, 0, 0, 0, 0, 0, 0,
	])
}

public extension QRCodePixelShapeFactory {
	/// Generate an image of the data represented by a specific data generator for a fixed 5x5 data pixel representation
	/// - Parameters:
	///   - pixelGenerator: The pixel generator to use
	///   - dimension: The dimension of the image to output
	///   - foregroundColor: The foreground color
	///   - backgroundColor: The background color (optional)
	///   - samplePixelMatrix: The matrix of pixels to draw in the result
	///   - isOn: If true, draws the 'on' pixels in the qrcode, else draws the 'off' pixels
	/// - Returns: A CGImage representation of the data
	@objc func image(
		pixelGenerator: any QRCodePixelShapeGenerator,
		dimension: CGFloat,
		foregroundColor: CGColor,
		backgroundColor: CGColor? = nil,
		samplePixelMatrix: BoolMatrix? = nil,
		isOn: Bool = true
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

		// Draw the qr with the required styles
		let qr = QRCode()
		qr.current = samplePixelMatrix ?? Self.defaultMatrix

		let path = CGMutablePath()
		let p2: CGPath = {
			if isOn {
				return pixelGenerator.generatePath(from: qr.current, size: CGSize(dimension: dimension))
			}
			else {
				let inverted = qr.current.inverted()
				return pixelGenerator.generatePath(from: inverted, size: CGSize(dimension: dimension))
			}
		}()
		path.addPath(p2)
		context.addPath(path)
		context.setFillColor(foregroundColor)
		context.fillPath()

		guard let im = context.makeImage() else {
			throw QRCodeError.cannotGenerateImage
		}
		return im
	}
}

public extension QRCodePixelShapeFactory {
	/// Generate an array of <generator_name>:<sample_image> pairs of the pixel representation for each of the generators
	/// - Parameters:
	///   - dimension: The dimension of the sample images to generate
	///   - foregroundColor: The foreground color
	///   - backgroundColor: The background color (optional)
	///   - isOn: If true, draws the 'on' pixels in the qrcode, else draws the 'off' pixels
	///   - samplePixelMatrix: The matrix of pixels to draw in the result
	///   - commonSettings: QRCode settings to apply to each generator
	/// - Returns: A CGImage representation of the data
	func generateSampleImages(
		dimension: CGFloat,
		foregroundColor: CGColor,
		backgroundColor: CGColor? = nil,
		isOn: Bool = true,
		samplePixelMatrix: BoolMatrix? = nil,
		commonSettings: [String: Any]? = nil
	) throws -> [(name: String, image: CGImage)] {
		try QRCodePixelShapeFactory.shared.all()
			.map {
				let pixelImage = try QRCodePixelShapeFactory.shared.image(
					pixelGenerator: $0,
					dimension: dimension,
					foregroundColor: foregroundColor,
					backgroundColor: backgroundColor,
					samplePixelMatrix: samplePixelMatrix
				)
				return (name: $0.name, image: pixelImage)
			}
	}
}
