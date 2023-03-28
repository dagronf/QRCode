//
//  QRCodePixelShape.swift
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

// MARK: - Data shape

internal let PixelShapeTypeName_ = "type"
internal let PixelShapeSettingsName_ = "settings"

public extension QRCode {
	/// The shape of the data within the qr code.
	@objc(QRCodePixelShape) class PixelShape: NSObject {
		private override init() { fatalError() }
	}
}

/// A protocol for wrapping generating the data shape for a path
@objc public protocol QRCodePixelShapeGenerator {
	/// The unique name for identifying the pixel shape
	@objc static var Name: String { get }
	/// The user-facing title for the generator
	@objc static var Title: String { get }

	/// Create a pixel shape generator using the provided settings
	@objc static func Create(_ settings: [String: Any]?) -> QRCodePixelShapeGenerator

	/// Make a copy of the shape object
	@objc func copyShape() -> QRCodePixelShapeGenerator

	/// Generate a path representing the 'on' pixels within the specified matrix
	/// - Parameters:
	///   - matrix: The matrix
	///   - size: The dimensions of the path to generate
	/// - Returns: A path representing the specified matrix data
	@objc func generatePath(from matrix: BoolMatrix, size: CGSize) -> CGPath

	/// Returns a storable representation of the shape handler
	func settings() -> [String: Any]

	/// Set a configuration value for a particular setting string
	func setSettingValue(_ value: Any?, forKey key: String) -> Bool

	/// Does the shape generator support setting values for a particular key?
	func supportsSettingValue(forKey key: String) -> Bool
}

public extension QRCodePixelShapeGenerator {
	var name: String { return Self.Name }
	var title: String { return Self.Title }

	internal func coreSettings() -> [String: Any] {
		var core: [String: Any] = [PixelShapeTypeName_: self.name]
		core[PixelShapeSettingsName_] = self.settings()
		return core
	}
}
