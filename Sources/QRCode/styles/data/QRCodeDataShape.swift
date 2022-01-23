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
	static var name: String { get }
	static func Create(_ settings: [String: Any]) -> QRCodeDataShapeHandler

	func copyShape() -> QRCodeDataShapeHandler
	func onPath(size: CGSize, data: QRCode) -> CGPath
	func offPath(size: CGSize, data: QRCode) -> CGPath

	func settings() -> [String: Any]

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
		guard let f = QRCodeDataShapeFactory.registeredTypes.first(where: { $0.name == type }) else {
			return nil
		}
		return f.Create(settings)
	}
}

public let DataShapeFactory = QRCodeDataShapeFactory()
