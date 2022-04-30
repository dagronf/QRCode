//
//  File.swift
//
//
//  Created by Darren Ford on 19/11/21.
//

import CoreGraphics
import Foundation

// MARK: - Data shape

public extension QRCode {
	/// The shape of the data within the qr code.
	@objc(QRCodeDataShape) class DataShape: NSObject {}
}

/// A protocol for wrapping generating the data shape for a path
@objc public protocol QRCodeDataShapeHandler {
	static var Name: String { get }
	static func Create(_ settings: [String: Any]) -> QRCodeDataShapeHandler

	/// Make a copy of the shape object
	func copyShape() -> QRCodeDataShapeHandler

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

public extension QRCodeDataShapeHandler {
	var name: String { return Self.Name }
}

private let DataShapeTypeName = "type"
private let DataShapeSettingsName = "settings"

public class QRCodeDataShapeFactory {
	public static var registeredTypes: [QRCodeDataShapeHandler.Type] = [
		QRCode.DataShape.Vertical.self,
		QRCode.DataShape.Horizontal.self,
		QRCode.DataShape.Pixel.self,
		QRCode.DataShape.RoundedPath.self,
		QRCode.DataShape.Pointy.self,
	]

	@objc public func create(settings: [String: Any]) -> QRCodeDataShapeHandler? {
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
		dataShape: QRCodeDataShapeHandler,
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
