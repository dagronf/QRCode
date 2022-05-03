//
//  QRCodeDataShapeFactory.swift
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
@objc public class QRCodeDataShapeFactory: NSObject {
	/// Shared data shape factory
	@objc public static let shared = QRCodeDataShapeFactory()

	/// Create
	@objc override public init() {
		self.registeredTypes = [
			QRCode.DataShape.Square.self,
			QRCode.DataShape.Circle.self,
			QRCode.DataShape.RoundedRect.self,
			QRCode.DataShape.Squircle.self,
			QRCode.DataShape.Vertical.self,
			QRCode.DataShape.Horizontal.self,
			QRCode.DataShape.RoundedPath.self,
			QRCode.DataShape.Pointy.self,
		]
		super.init()
	}

	@objc public var availableGeneratorNames: [String] {
		self.registeredTypes.map { $0.Name }
	}

	/// Return a new instance of the data shape generator with the specified name and optional settings
	@objc public func named(_ name: String, settings: [String: Any]? = nil) -> QRCodeDataShapeGenerator? {
		guard let f = self.registeredTypes.first(where: { $0.Name == name }) else {
			return nil
		}
		return f.Create(settings)
	}

	/// Create a data shape generator from the specified shape settings
	@objc public func create(settings: [String: Any]) -> QRCodeDataShapeGenerator? {
		guard let type = settings[DataShapeTypeName_] as? String else { return nil }
		let settings = settings[DataShapeSettingsName_] as? [String: Any]
		return self.named(type, settings: settings)
	}

	// Private

	internal var registeredTypes: [QRCodeDataShapeGenerator.Type]
}

public extension QRCodeDataShapeFactory {
	/// Return an image representing the shape generator as a 5x5 data pixel grouping
	@objc func image(
		dataShape: QRCodeDataShapeGenerator,
		isOn: Bool = true,
		dimension: CGFloat,
		foregroundColor: CGColor
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

		context.scaleBy(x: 1, y: -1)
		context.translateBy(x: 0, y: -dimension)

		let fitScale = dimension / 90
		var scaleTransform = CGAffineTransform.identity
		scaleTransform = scaleTransform.scaledBy(x: fitScale, y: fitScale)

		// Draw the qr with the required styles

		let qr = QRCode()
		qr.current = BoolMatrix(dimension: 5, rawFlattenedInt: [
			0, 0, 1, 1, 0,
			0, 0, 0, 1, 0,
			1, 0, 1, 1, 1,
			1, 1, 1, 1, 0,
			0, 0, 1, 0, 1,
		])

		let path = CGMutablePath()
		let p2: CGPath = {
			if isOn {
				return dataShape.onPath(size: CGSize(width: dimension, height: dimension), data: qr, isTemplate: true)
			}
			else {
				return dataShape.offPath(size: CGSize(width: dimension, height: dimension), data: qr, isTemplate: true)
			}
		}()
		path.addPath(p2) // , transform: scaleTransform)
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

public extension QRCodeDataShapeFactory {
#if os(macOS)
	func nsImage(dataShape: QRCodeDataShapeGenerator, dimension: CGFloat, foregroundColor: NSColor) -> NSImage? {
		if let cgi = image(dataShape: dataShape, dimension: dimension, foregroundColor: foregroundColor.cgColor) {
			return NSImage(cgImage: cgi, size: .zero)
		}
		return nil
	}
#endif
}
