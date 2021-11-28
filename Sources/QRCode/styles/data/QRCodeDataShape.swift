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
	var name: String { get }
	func copyShape() -> QRCodeDataShapeHandler
	func onPath(size: CGSize, data: QRCode) -> CGPath
	func offPath(size: CGSize, data: QRCode) -> CGPath
}

public class QRCodeDataShapeFactory {
	public var knownTypes: [String] {
		["square", "circle", "roundedrect", "horizontal", "vertical", "roundedpath"]
	}

	public func named(_ name: String, inset: CGFloat, cornerRadiusFraction: CGFloat) -> QRCodeDataShapeHandler? {
		if name == "square" {
			return QRCode.DataShape.Square(inset: inset)
		}
		else if name == "circle" {
			return QRCode.DataShape.Circle(inset: inset)
		}
		else if name == "roundedrect" {
			return QRCode.DataShape.RoundedRect(inset: inset, cornerRadiusFraction: cornerRadiusFraction)
		}
		else if name == "horizontal" {
			return QRCode.DataShape.Horizontal(inset: inset, cornerRadiusFraction: cornerRadiusFraction)
		}
		else if name == "vertical" {
			return QRCode.DataShape.Vertical(inset: inset, cornerRadiusFraction: cornerRadiusFraction)
		}
		else if name == "roundedpath" {
			return QRCode.DataShape.RoundedPath()
		}
		return nil
	}
}

public let DataShapeFactory = QRCodeDataShapeFactory()
