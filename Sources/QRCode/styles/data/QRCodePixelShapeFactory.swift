//
//  QRCodePixelShapeFactory.swift
//
//  Created by Darren Ford on 3/5/22.
//  Copyright © 2022 Darren Ford. All rights reserved.
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
@objc public class QRCodePixelShapeFactory: NSObject {
	/// Shared data shape factory
	@objc public static let shared = QRCodePixelShapeFactory()

	/// Create
	@objc override public init() {
		self.registeredTypes = [
			QRCode.PixelShape.Square.self,
			QRCode.PixelShape.Circle.self,
			QRCode.PixelShape.RoundedRect.self,
			QRCode.PixelShape.Squircle.self,
			QRCode.PixelShape.Vertical.self,
			QRCode.PixelShape.Horizontal.self,
			QRCode.PixelShape.RoundedPath.self,
			QRCode.PixelShape.Pointy.self,
		]
		super.init()
	}

	/// The available pixel shape generator names
	@objc public var availableGeneratorNames: [String] {
		self.registeredTypes.map { $0.Name }.sorted()
	}

	/// Return a new instance of the data shape generator with the specified name and optional settings
	@objc public func named(_ name: String, settings: [String: Any]? = nil) -> QRCodePixelShapeGenerator? {
		guard let f = self.registeredTypes.first(where: { $0.Name == name }) else {
			return nil
		}
		return f.Create(settings)
	}

	/// Create a data shape generator from the specified shape settings
	@objc public func create(settings: [String: Any]) -> QRCodePixelShapeGenerator? {
		guard let type = settings[PixelShapeTypeName_] as? String else { return nil }
		let settings = settings[PixelShapeSettingsName_] as? [String: Any]
		return self.named(type, settings: settings)
	}

	// Private

	internal var registeredTypes: [QRCodePixelShapeGenerator.Type]
}

public extension QRCodePixelShapeFactory {
	/// Generate an image of the data represented by a specific data generator for a fixed 5x5 data pixel representation
	/// - Parameters:
	///   - pixelShape: The pixel generator to use
	///   - isOn: If true, draws the 'on' pixels in the qrcode, else draws the 'off' pixels
	///   - dimension: The dimension of the image to output
	///   - foregroundColor: The foreground color
	///   - backgroundColor: The background color (optional)
	/// - Returns: A CGImage representation of the data
	@objc func image(
		pixelShape: QRCodePixelShapeGenerator,
		isOn: Bool = true,
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

		let qr = QRCode()
		qr.current = BoolMatrix(dimension: 7, rawFlattenedInt: [
			0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 1, 1, 0, 0,
			0, 0, 0, 0, 1, 0, 0,
			0, 1, 0, 1, 1, 1, 0,
			0, 1, 1, 1, 1, 0, 0,
			0, 0, 0, 1, 0, 1, 0,
			0, 0, 0, 0, 0, 0, 0,
		])

		let path = CGMutablePath()
		let p2: CGPath = {
			if isOn {
				return pixelShape.onPath(size: CGSize(width: dimension, height: dimension), data: qr, isTemplate: true)
			}
			else {
				return pixelShape.offPath(size: CGSize(width: dimension, height: dimension), data: qr, isTemplate: true)
			}
		}()
		path.addPath(p2)
		context.addPath(path)
		context.setFillColor(foregroundColor)
		context.fillPath()

		let im = context.makeImage()
		return im
	}
}

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public extension QRCodePixelShapeFactory {
#if os(macOS)
	/// Create an NSImage representation of a pixel shape
	func nsImage(
		pixelShape: QRCodePixelShapeGenerator,
		dimension: CGFloat,
		foregroundColor: NSColor
	) -> NSImage? {
		if let cgi = image(pixelShape: pixelShape, dimension: dimension, foregroundColor: foregroundColor.cgColor) {
			return NSImage(cgImage: cgi, size: .zero)
		}
		return nil
	}
#endif
}
