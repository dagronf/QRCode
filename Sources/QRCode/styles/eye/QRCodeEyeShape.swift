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
	var name: String { get }
	func copyShape() -> QRCodeEyeShapeHandler
	func eyePath() -> CGPath
	func pupilPath() -> CGPath
}

public class QRCodeEyeShapeFactory {
	public private(set) var eyeShapes: [QRCodeEyeShapeHandler] = []
	init() {
		self.register()
	}

	func register() {
		self.eyeShapes = [
			QRCode.EyeShape.Circle(),
			QRCode.EyeShape.Leaf(),
			QRCode.EyeShape.RoundedOuter(),
			QRCode.EyeShape.RoundedPointingIn(),
			QRCode.EyeShape.RoundedRect(),
			QRCode.EyeShape.Square(),
		]
	}

	public var knownTypes: [String] {
		self.eyeShapes.map { $0.name }
	}

	public func named(_ name: String) -> QRCodeEyeShapeHandler? {
		return self.eyeShapes.first { h in h.name == name }
	}
}

public let EyeShapeFactory = QRCodeEyeShapeFactory()
