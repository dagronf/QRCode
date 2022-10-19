//
//  QRCodePixelShape.swift
//
//  Created by Darren Ford on 17/11/21.
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

// MARK: - Data shape

internal let PixelShapeTypeName_ = "type"
internal let PixelShapeSettingsName_ = "settings"

public extension QRCode {
	/// The shape of the data within the qr code.
	@objc(QRCodePixelShape) class PixelShape: NSObject {}
}

/// A protocol for wrapping generating the data shape for a path
@objc public protocol QRCodePixelShapeGenerator {
	@objc static var Name: String { get }
	@objc static func Create(_ settings: [String: Any]?) -> QRCodePixelShapeGenerator

	/// Make a copy of the shape object
	@objc func copyShape() -> QRCodePixelShapeGenerator

	/// Generate a path representing the 'on' _data_ pixels within the specified QRCode data (ie. no eyes etc)
	/// - Parameters:
	///   - size: The dimensions of the path to generate
	///   - data: The data to represent
	///   - isTemplate: If true, ignores eyes and any other QRCode concepts (purely for displaying raw data)
	/// - Returns: A path representing the specified QRCode data
	func onPath(size: CGSize, data: QRCode, isTemplate: Bool) -> CGPath

	/// Generate a path representing the 'off' _data_ pixels within the specified QRCode data (ie. no eyes etc)
	/// - Parameters:
	///   - size: The dimensions of the path to generate
	///   - data: The data to represent
	///   - isTemplate: If true, ignores eyes and any other QRCode concepts (purely for displaying raw data)
	/// - Returns: A path representing the specified QRCode data
	func offPath(size: CGSize, data: QRCode, isTemplate: Bool) -> CGPath

	/// Returns a storable representation of the shape handler
	func settings() -> [String: Any]

	/// Set a configuration value for a particular setting string
	func setSettingValue(_ value: Any?, forKey key: String) -> Bool

	/// Does the shape generator support setting values for a particular key?
	func supportsSettingValue(forKey key: String) -> Bool
}

public extension QRCodePixelShapeGenerator {
	var name: String { return Self.Name }

	internal func coreSettings() -> [String: Any] {
		var core: [String: Any] = [PixelShapeTypeName_: self.name]
		core[PixelShapeSettingsName_] = self.settings()
		return core
	}
}
