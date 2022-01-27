//
//  File.swift
//  
//
//  Created by Darren Ford on 19/11/21.
//

import Foundation
import CoreGraphics

// MARK: - Data shape

public extension QRCode {
	/// The shape of the data within the qr code.
	@objc(QRCodeDataShape) class DataShape: NSObject {}
}

/// A protocol for wrapping generating the data shape for a path
@objc public protocol QRCodeDataShapeHandler {
	static var Name: String { get }
	static func Create(_ settings: [String: Any]) -> QRCodeDataShapeHandler

	func copyShape() -> QRCodeDataShapeHandler
	func onPath(size: CGSize, data: QRCode, isTemplate: Bool) -> CGPath
	func offPath(size: CGSize, data: QRCode, isTemplate: Bool) -> CGPath

	func settings() -> [String: Any]
}
public extension QRCodeDataShapeHandler {
	var name: String { return Self.Name }
}


public class QRCodeDataShapeFactory {

	static public var registeredTypes: [QRCodeDataShapeHandler.Type] = [
		QRCode.DataShape.Vertical.self,
		QRCode.DataShape.Horizontal.self,
		QRCode.DataShape.Pixel.self,
		QRCode.DataShape.RoundedPath.self,
		QRCode.DataShape.Pointy.self
	]

	@objc public func create(settings: [String: Any]) -> QRCodeDataShapeHandler? {
		guard let type = settings["type"] as? String else { return nil }
		guard let f = QRCodeDataShapeFactory.registeredTypes.first(where: { $0.Name == type }) else {
			return nil
		}
		return f.Create(settings)
	}
}

public let DataShapeFactory = QRCodeDataShapeFactory()

extension QRCodeDataShapeFactory {
	public func image(
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
		) else {
			return nil
		}

		context.scaleBy(x: 1, y: -1)
		context.translateBy(x: 0, y: -dimension)

		let fitScale = dimension / 90
		var scaleTransform = CGAffineTransform.identity
		scaleTransform = scaleTransform.scaledBy(x: fitScale, y: fitScale)

		// Draw the qr with the required styles

		let qr = QRCode()
		qr.current = BoolMatrix(dimension: 5, flattened: [
			false, false, true, true, false,
			false, false, false, true, false,
			true, false, true, true, true,
			true, true, true, true, false,
			false, false, true, false, true,
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
		path.addPath(p2) //, transform: scaleTransform)
		context.addPath(path)
		context.setFillColor(foregroundColor)
		context.fillPath()

		let im = context.makeImage()
		return im
	}
}
