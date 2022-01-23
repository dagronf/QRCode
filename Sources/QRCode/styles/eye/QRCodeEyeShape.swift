//
//  QRCodeEyeStyleCircle.swift
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

import Foundation
import CoreGraphics

// MARK: - Eye shape

public extension QRCode {
	/// The shape of an 'eye' within the qr code
	@objc(QRCodeEyeShape) class EyeShape: NSObject {}
}

/// A protocol for wrapping generating the eye shapes for a path
@objc public protocol QRCodeEyeShapeHandler {
	@objc static var name: String { get }
	@objc static func Create(_ settings: [String: Any]) -> QRCodeEyeShapeHandler
	@objc func settings() -> [String: Any]
	@objc func copyShape() -> QRCodeEyeShapeHandler
	@objc func eyePath() -> CGPath
	@objc func pupilPath() -> CGPath
}

public class QRCodeEyeShapeFactory {

	static public var registeredTypes: [QRCodeEyeShapeHandler.Type] = [
		QRCode.EyeShape.Circle.self,
		QRCode.EyeShape.RoundedRect.self,
		QRCode.EyeShape.RoundedPointingIn.self,
		QRCode.EyeShape.Squircle.self,
		QRCode.EyeShape.RoundedOuter.self,
		QRCode.EyeShape.Square.self,
		QRCode.EyeShape.Leaf.self
	]

	@objc public var knownTypes: [String] {
		QRCodeEyeShapeFactory.registeredTypes.map { $0.name }
	}

	@objc public func Create(settings: [String: Any]) -> QRCodeEyeShapeHandler? {
		guard let type = settings["type"] as? String else { return nil }
		guard let f = QRCodeEyeShapeFactory.registeredTypes.first(where: { $0.name == type }) else {
			return nil
		}
		return f.Create(settings)
	}
}

public let EyeShapeFactory = QRCodeEyeShapeFactory()
