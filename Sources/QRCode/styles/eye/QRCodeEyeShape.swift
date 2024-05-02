//
//  QRCodeEyeShape.swift
//
//  Copyright © 2024 Darren Ford. All rights reserved.
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
	@objc(QRCodeEyeShape) class EyeShape: NSObject {
		private override init() { super.init() }
	}
}

/// A protocol for wrapping generating the eye shapes for a path
@objc public protocol QRCodeEyeShapeGenerator {
	/// The unique string identifier for the eye shape generator
	@objc static var Name: String { get }
	/// The user-facing title for the eye shape generator
	@objc static var Title: String { get }
	@objc static func Create(_ settings: [String: Any]?) -> any QRCodeEyeShapeGenerator
	@objc func copyShape() -> any QRCodeEyeShapeGenerator
	@objc func eyePath() -> CGPath
	@objc func eyeBackgroundPath() -> CGPath
	@objc func defaultPupil() -> any QRCodePupilShapeGenerator

	/// Returns a storable representation of the shape handler
	@objc func settings() -> [String: Any]
	/// Does the shape generator support setting values for a particular key?
	@objc func supportsSettingValue(forKey key: String) -> Bool
	/// Set a configuration value for a particular setting string
	@objc func setSettingValue(_ value: Any?, forKey key: String) -> Bool
}

public extension QRCodeEyeShapeGenerator {
	var name: String { return Self.Name }
	var title: String { return Self.Title }

	internal func coreSettings() -> [String: Any] {
		var core: [String: Any] = [EyeShapeTypeName_: self.name]
		core[EyeShapeSettingsName_] = self.settings()
		return core
	}

	/// Return a value from the settings
	func settingsValue<T>(forKey key: String) -> T? { settings()[key] as? T }
}
