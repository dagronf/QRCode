//
//  QRCodePupilShape.swift
//
//  Copyright © 2023 Darren Ford. All rights reserved.
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

public extension QRCode {
	/// The shape of an 'eye' within the qr code
	@objc(QRCodePupilShape) class PupilShape: NSObject {
		private override init() { fatalError() }
	}
}

internal let PupilShapeTypeName_ = "type"
internal let PupilShapeSettingsName_ = "settings"

@objc public protocol QRCodePupilShapeGenerator {
	/// The unique name for identifying the pupil shape
	@objc static var Name: String { get }
	/// The user-facing title for the generator
	@objc static var Title: String { get }
	/// Create a pupil shape generator using the provided settings
	@objc static func Create(_ settings: [String: Any]?) -> QRCodePupilShapeGenerator
	@objc func copyShape() -> QRCodePupilShapeGenerator
	@objc func pupilPath() -> CGPath

	@objc func settings() -> [String: Any]
	/// Does the shape generator support setting values for a particular key?
	@objc func supportsSettingValue(forKey key: String) -> Bool
	/// Set a configuration value for a particular setting string
	@objc func setSettingValue(_ value: Any?, forKey key: String) -> Bool
}

public extension QRCodePupilShapeGenerator {
	@inlinable var name: String { return Self.Name }
	@inlinable var title: String { return Self.Title }

	internal func coreSettings() -> [String: Any] {
		var core: [String: Any] = [PupilShapeTypeName_: self.name]
		core[PupilShapeSettingsName_] = self.settings()
		return core
	}
}
