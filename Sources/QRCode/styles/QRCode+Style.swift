//
//  QRCode+Style.swift
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
	/// Represents the style when drawing the qr code
	@objc(QRCodeStyle) class Style: NSObject {

		/// Convenience initializer for objc
		@objc public static func create() -> Style { return Style() }

		/// Set the foreground color for all the components of the qr code
		@inlinable @objc public func setForegroundStyle(_ style: QRCodeFillStyleGenerator) {
			onPixels = style
			eye = nil
			pupil = nil
		}

		/// The style for the data component for the QR code. Defaults to black
		@objc public var onPixels: QRCodeFillStyleGenerator = QRCode.FillStyle.Solid(CGColor(gray: 0.0, alpha: 1.0))

		/// The background color for the 'on' pixels
		@objc public var onPixelsBackground: CGColor?
		
		/// The style for drawing the non-drawn sections for the qr code.
		@objc public var offPixels: QRCodeFillStyleGenerator?

		/// The background color for the 'off' pixels
		@objc public var offPixelsBackground: CGColor?

		/// The border around the eye. By default, this is the same color as the data
		@objc public var eye: QRCodeFillStyleGenerator?
		/// The pupil of the eye. By default, this is the same color as the eye, and failing that the data
		@objc public var pupil: QRCodeFillStyleGenerator?

		/// The background style for the QR code. If nil, no background is drawn. Defaults to white
		@objc public var background: QRCodeFillStyleGenerator? = QRCode.FillStyle.Solid(CGColor(gray: 1.0, alpha: 1.0))

		/// A corner radius (in qr pixels) to apply to the background fill
		@objc public var backgroundFractionalCornerRadius: CGFloat = 0

		/// The background color behind the eyes.
		///
		/// Setting a solid background color (eg. white) behind the eyes can make the QR code more readable
		@objc public var eyeBackground: CGColor? = nil

		/// Copy the style
		public func copyStyle() -> Style {
			let c = Style()
			c.onPixels = self.onPixels.copyStyle()
			c.onPixelsBackground = self.onPixelsBackground?.copy()
			c.offPixels = self.offPixels?.copyStyle()
			c.offPixelsBackground = self.offPixelsBackground?.copy()
			c.background = self.background?.copyStyle()
			c.backgroundFractionalCornerRadius = self.backgroundFractionalCornerRadius
			c.eye = self.eye?.copyStyle()
			c.eyeBackground = self.eyeBackground?.copy()
			c.pupil = self.pupil?.copyStyle()
			return c
		}
	}
}

public extension QRCode.Style {
	/// Returns the eye style that will be used when drawing. Handles the case where the eye style is nil
	@objc var actualEyeStyle: QRCodeFillStyleGenerator {
		return self.eye ?? self.onPixels
	}

	/// Returns the pupil style that will be used when drawing. Handles the case where the pupil style is nil
	@objc var actualPupilStyle: QRCodeFillStyleGenerator {
		return self.pupil ?? self.eye ?? self.onPixels
	}
}

public extension QRCode.Style {
	@objc func settings() -> [String: Any] {
		var result: [String: Any] = [ "onPixels": onPixels.coreSettings() ]
		if let e = eye?.coreSettings() {
			result["eye"] = e
		}
		if let p = pupil?.coreSettings() {
			result["pupil"] = p
		}
		if let b = background?.coreSettings() {
			result["background"] = b
		}

		if backgroundFractionalCornerRadius > 0.1 {
			result["backgroundFractionalCornerRadius"] = Double(backgroundFractionalCornerRadius)
		}

		if let di = offPixels?.coreSettings() {
			result["offPixels"] = di
		}

		// The eye background

		if let e = self.eyeBackground, let eb = e.archiveSRGBA() {
			result["eyeBackground"] = ["color": eb]
		}

		// the backgrounds for the pixels

		if let e = self.onPixelsBackground, let eb = e.archiveSRGBA() {
			result["onPixelsBackground"] = ["color": eb]
		}
		if let e = self.offPixelsBackground, let eb = e.archiveSRGBA() {
			result["offPixelsBackground"] = ["color": eb]
		}
		return result
	}

	@objc static func Create(settings: [String: Any]) -> QRCode.Style? {
		let style = QRCode.Style()

		if let d = settings["onPixels"] as? [String: Any],
			let pixelShape = FillStyleFactory.Create(settings: d) {
			style.onPixels = pixelShape
		}

		if let e = settings["eye"] as? [String: Any],
			let eye = FillStyleFactory.Create(settings: e) {
			style.eye = eye
		}

		if let e = settings["pupil"] as? [String: Any],
			let pupil = FillStyleFactory.Create(settings: e) {
			style.pupil = pupil
		}

		if let e = settings["background"] as? [String: Any],
			let background = FillStyleFactory.Create(settings: e) {
			style.background = background
		}
		else {
			style.background = nil
		}

		if let e = settings["backgroundFractionalCornerRadius"] as? Double {
			style.backgroundFractionalCornerRadius = max(0, e)
		}

		if let e = settings["offPixels"] as? [String: Any],
			let offPixels = FillStyleFactory.Create(settings: e) {
			style.offPixels = offPixels
		}

		// The eye background

		if let eb = settings["eyeBackground"] as? [String: Any],
			let ebs = eb["color"] as? String,
			let ec = CGColor.UnarchiveSRGBA(ebs)
		{
			style.eyeBackground = ec
		}

		// the backgrounds for the pixels

		if let eb = settings["onPixelsBackground"] as? [String: Any],
			let ebs = eb["color"] as? String,
			let ec = CGColor.UnarchiveSRGBA(ebs)
		{
			style.onPixelsBackground = ec
		}

		if let eb = settings["offPixelsBackground"] as? [String: Any],
			let ebs = eb["color"] as? String,
			let ec = CGColor.UnarchiveSRGBA(ebs)
		{
			style.offPixelsBackground = ec
		}

		return style
	}
}
