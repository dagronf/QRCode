//
//  QRCodeEyeShape.swift
//
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

// MARK: - Eye shape

internal let EyeShapeTypeName_ = "type"
internal let EyeShapeSettingsName_ = "settings"

public extension QRCode {
	/// The shape of an 'eye' within the qr code
	@objc(QRCodeEyeShape) class EyeShape: NSObject {}
}

/// A protocol for wrapping generating the eye shapes for a path
@objc public protocol QRCodeEyeShapeGenerator {
	@objc static var Name: String { get }
	@objc static func Create(_ settings: [String: Any]?) -> QRCodeEyeShapeGenerator
	@objc func settings() -> [String: Any]
	@objc func copyShape() -> QRCodeEyeShapeGenerator
	@objc func eyePath() -> CGPath

	@objc func defaultPupil() -> QRCodePupilShapeGenerator
}

public extension QRCodeEyeShapeGenerator {
	var name: String { return Self.Name }

	internal func coreSettings() -> [String: Any] {
		var core: [String: Any] = [EyeShapeTypeName_: self.name]
		core[EyeShapeSettingsName_] = self.settings()
		return core
	}
}

internal let PupilShapeTypeName_ = "type"
internal let PupilShapeSettingsName_ = "settings"

public extension QRCode {
	/// The shape of an 'eye' within the qr code
	@objc(QRCodePupilShape) class PupilShape: NSObject {}
}

@objc public protocol QRCodePupilShapeGenerator {
	@objc static var Name: String { get }
	@objc static func Create(_ settings: [String: Any]?) -> QRCodePupilShapeGenerator
	@objc func settings() -> [String: Any]
	@objc func copyShape() -> QRCodePupilShapeGenerator
	@objc func pupilPath() -> CGPath
}

public extension QRCodePupilShapeGenerator {
	var name: String { return Self.Name }

	internal func coreSettings() -> [String: Any] {
		var core: [String: Any] = [PupilShapeTypeName_: self.name]
		core[PupilShapeSettingsName_] = self.settings()
		return core
	}
}
