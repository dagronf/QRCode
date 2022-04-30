//
//  QRCodeDataShape.swift
//
//  Created by Darren Ford on 17/11/21.
//  Copyright © 2021 Darren Ford. All rights reserved.
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

// MARK: - Data shape

public extension QRCode {
	/// The shape of the data within the qr code.
	@objc(QRCodeDataShape) class DataShape: NSObject {}
}

/// A protocol for wrapping generating the data shape for a path
@objc public protocol QRCodeDataShapeGenerator {
	static var Name: String { get }
	static func Create(_ settings: [String: Any]) -> QRCodeDataShapeGenerator

	/// Make a copy of the shape object
	func copyShape() -> QRCodeDataShapeGenerator

	/// Generate a path (within 'size')

	/// Generate a path representing the 'on' _data_ pixels within the specified QRCode data (ie. no eyes etc)
	/// - Parameters:
	///   - size: The bounds of the path to generate
	///   - data: The data to represent
	///   - isTemplate: If true, ignores eyes and any other QRCode concepts (purely for displaying raw data)
	/// - Returns: A path representing the specified QRCode data
	func onPath(size: CGSize, data: QRCode, isTemplate: Bool) -> CGPath

	/// Generate a path representing the 'off' _data_ pixels within the specified QRCode data (ie. no eyes etc)
	/// - Parameters:
	///   - size: The bounds of the path to generate
	///   - data: The data to represent
	///   - isTemplate: If true, ignores eyes and any other QRCode concepts (purely for displaying raw data)
	/// - Returns: A path representing the specified QRCode data
	func offPath(size: CGSize, data: QRCode, isTemplate: Bool) -> CGPath

	/// Returns a storable representation of the shape handler
	func settings() -> [String: Any]
}

private let DataShapeTypeName = "type"
private let DataShapeSettingsName = "settings"

public extension QRCodeDataShapeGenerator {
	var name: String { return Self.Name }

	internal func coreSettings() -> [String: Any] {
		var core: [String: Any] = [DataShapeTypeName: self.name]
		core[DataShapeSettingsName] = self.settings()
		return core
	}
}

public class QRCodeDataShapeFactory {
	public static var registeredTypes: [QRCodeDataShapeGenerator.Type] = [
		QRCode.DataShape.Vertical.self,
		QRCode.DataShape.Horizontal.self,
		QRCode.DataShape.Pixel.self,
		QRCode.DataShape.RoundedPath.self,
		QRCode.DataShape.Pointy.self,
	]

	@objc public func create(settings: [String: Any]) -> QRCodeDataShapeGenerator? {
		guard let type = settings[DataShapeTypeName] as? String else { return nil }
		guard let set = settings[DataShapeSettingsName] as? [String: Any] else { return nil }
		guard let f = QRCodeDataShapeFactory.registeredTypes.first(where: { $0.Name == type }) else {
			return nil
		}
		return f.Create(set)
	}
}

public let DataShapeFactory = QRCodeDataShapeFactory()

public extension QRCodeDataShapeFactory {
	func image(
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
