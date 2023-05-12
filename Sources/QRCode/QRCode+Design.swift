//
//  QRCode+Design.swift
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
	/// The design for the qr code output.
	///
	/// This combines :-
	/// * a 'shape' (the outline shape of the component of the qr code), and
	/// * a 'style' (the fill styles for each component of the qr code)
	@objc(QRCodeDesign) class Design: NSObject {

		/// Convenience initializer for objc
		@objc public static func create() -> Design { return Design() }

		/// The drawing shape for the qr code.
		@objc public var shape = QRCode.Shape()
		
		/// The display style for the qr code.
		@objc public var style = QRCode.Style()

		/// Any additional quiet zone beyond the scope of the QR code
		@objc public var additionalQuietZonePixels: UInt = 0

		/// Basic initializer for the default style
		@objc public override init() {
			super.init()
		}

		/// Convenience creator for a simple background and foreground color
		/// - Parameters:
		///   - foregroundColor: The color to use for the foreground
		///   - backgroundColor: (Optional) The color to use for the background.
		@objc public init(foregroundColor: CGColor, backgroundColor: CGColor? = nil) {
			super.init()
			self.foregroundColor(foregroundColor)
				.backgroundColor(backgroundColor)
		}

		/// Copy the design
		public func copyDesign() -> Design {
			let c = Design()
			c.shape = self.shape.copyShape()
			c.style = self.style.copyStyle()
			c.additionalQuietZonePixels = self.additionalQuietZonePixels
			return c
		}
	}
}

// MARK: Save and restore

public extension QRCode.Design {
	@objc func settings() -> [String: Any] {
		var result: [String: Any] = [
			"shape": shape.settings(),
			"style": style.settings()
		]
		if additionalQuietZonePixels > 0 {
			result["additionalQuietZonePixels"] = self.additionalQuietZonePixels
		}
		return result
	}

	/// Generate a JSON string representation of the document.
	@objc func jsonData() throws -> Data {
		let dict = self.settings()
		return try JSONSerialization.data(withJSONObject: dict)
	}

	@objc static func Create(settings: [String: Any]) -> QRCode.Design? {
		let design = QRCode.Design()

		if let sh = settings["shape"] as? [String: Any],
			let shape = QRCode.Shape.Create(settings: sh) {
			design.shape = shape
		}

		if let sh = settings["style"] as? [String: Any],
			let style = QRCode.Style.Create(settings: sh) {
			design.style = style
		}

		design.additionalQuietZonePixels = UIntValue(settings[QRCode.SettingsKey.additionalQuietZonePixels, default: 0]) ?? 0

		return design
	}

	/// Create a QRCode document from the provided json formatted data
	@objc static func Create(jsonData: Data) -> QRCode.Design? {
		guard
			let s = try? JSONSerialization.jsonObject(with: jsonData, options: []),
			let settings = s as? [String: Any]
		else {
			return nil
		}
		return QRCode.Design.Create(settings: settings)
	}
}


// MARK: Some conveniences on the design object

public extension QRCode.Design {
	/// Set the foreground color for the design
	/// - Parameter color: The color to set
	/// - Returns: This design object
	@discardableResult
	@objc func foregroundColor(_ color: CGColor) -> QRCode.Design {
		self.style.setForegroundStyle(QRCode.FillStyle.Solid(color))
		return self
	}

	/// Set the foreground style for the design
	/// - Parameter fillStyle: The fill style generator
	/// - Returns: This design object
	@discardableResult
	@objc func foregroundStyle(_ fillStyle: QRCodeFillStyleGenerator) -> QRCode.Design {
		self.style.setForegroundStyle(fillStyle)
		return self
	}

	/// Set the background color for the design
	/// - Parameter color: The color to set. If nil, the background color is set to clear
	/// - Returns: This design object
	@discardableResult
	@objc func backgroundColor(_ color: CGColor?) -> QRCode.Design {
		self.style.background = color.unwrapping { QRCode.FillStyle.Solid($0) } ?? QRCode.FillStyle.Solid(.clear)
		return self
	}
}
