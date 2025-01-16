//
//  Copyright © 2025 Darren Ford. All rights reserved.
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

// A basic SwiftUI view that doesn't require a document

import Foundation
import SwiftUI

/// A SwiftUI qrcode view with just the basics
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6, *)
public struct QRCodeViewUI: View {
	private let content: QRCode.Document
	private let isValid: Bool

	/// Generate a QRCode view
	/// - Parameters:
	///   - content: The text content to display in the code
	///   - errorCorrection: The error correction
	///   - foregroundColor: Foreground color
	///   - backgroundColor: Background color
	///   - additionalQuietZonePixels: The number of additional quiet zone pixels to apply
	///   - backgroundFractionalCornerRadius: The corner radius of the background, in fractions of a module size
	///   - onPixelShape: The 'on pixels' shape
	///   - onPixelStyle: The 'on pixels' fill style
	///   - onPixelBackgroundColor: The 'on pixels' background color
	///   - eyeShape: The eye shape
	///   - eyeStyle: The eye fill style
	///   - eyeBackgroundColor: The color to draw behind the eye
	///   - pupilShape: The pupil shape
	///   - pupilStyle: The pu[il fill style
	///   - offPixelShape: The 'off pixels' shape
	///   - offPixelStyle: The 'off pixels' fill style
	///   - offPixelBackgroundColor: The 'off pixels' background color
	///   - logoTemplate: The logo to display on the code
	///   - negatedOnPixelsOnly: Invert the on and off pixels
	///   - shadow: The shadow to apply to the foreground elements
	///   - engine: The qr generator engine
	///   - generatedDocument: A binding to the generated document for later access
	public init(
		content: String,
		errorCorrection: QRCode.ErrorCorrection = .high,

		foregroundColor: CGColor = CGColor(gray: 0, alpha: 1),
		backgroundColor: CGColor = CGColor(gray: 1, alpha: 1),

		additionalQuietZonePixels: UInt = 0,
		backgroundFractionalCornerRadius: CGFloat = 0,

		onPixelShape: (any QRCodePixelShapeGenerator)? = nil,
		onPixelStyle: (any QRCodeFillStyleGenerator)? = nil,
		onPixelBackgroundColor: CGColor? = nil,

		eyeShape: (any QRCodeEyeShapeGenerator)? = nil,
		eyeStyle: (any QRCodeFillStyleGenerator)? = nil,
		eyeBackgroundColor: CGColor? = nil,

		pupilShape: (any QRCodePupilShapeGenerator)? = nil,
		pupilStyle: (any QRCodeFillStyleGenerator)? = nil,

		offPixelShape: (any QRCodePixelShapeGenerator)? = nil,
		offPixelStyle: (any QRCodeFillStyleGenerator)? = nil,
		offPixelBackgroundColor: CGColor? = nil,

		logoTemplate: QRCode.LogoTemplate? = nil,
		negatedOnPixelsOnly: Bool = false,
		shadow: QRCode.Shadow? = nil,

		engine: (any QRCodeEngine)? = nil,
		generatedDocument: Binding<QRCode.Document?>? = nil
	) {
		do {
			self.content = try QRCode.Document(
				utf8String: content,
				errorCorrection: errorCorrection,
				engine: engine ?? QRCode.DefaultEngine()
			)
			self.content.design.foregroundColor(foregroundColor)
			self.content.design.backgroundColor(backgroundColor)

			self.content.design.additionalQuietZonePixels = additionalQuietZonePixels
			self.content.design.style.backgroundFractionalCornerRadius = backgroundFractionalCornerRadius
			self.content.design.shape.negatedOnPixelsOnly = negatedOnPixelsOnly

			// On pixels

			if let onPixelShape = onPixelShape {
				self.content.design.shape.onPixels = onPixelShape
			}
			if let onPixelStyle = onPixelStyle {
				self.content.design.style.onPixels = onPixelStyle
			}
			if let onPixelBackgroundColor = onPixelBackgroundColor {
				self.content.design.style.onPixelsBackground = onPixelBackgroundColor
			}

			// Off pixels

			if let offPixelShape = offPixelShape {
				self.content.design.shape.offPixels = offPixelShape
			}
			if let offPixelStyle = offPixelStyle {
				self.content.design.style.offPixels = offPixelStyle
			}

			// Eye

			if let eyeShape = eyeShape {
				self.content.design.shape.eye = eyeShape
			}
			if let eyeStyle = eyeStyle {
				self.content.design.style.eye = eyeStyle
			}
			if let eyeBackgroundColor = eyeBackgroundColor {
				self.content.design.style.eyeBackground = eyeBackgroundColor
			}

			// Pupil

			if let pupilShape = pupilShape {
				self.content.design.shape.pupil = pupilShape
			}
			if let pupilStyle = pupilStyle {
				self.content.design.style.pupil = pupilStyle
			}

			if let logoTemplate = logoTemplate {
				self.content.logoTemplate = logoTemplate
			}

			self.content.design.style.shadow = shadow

			self.isValid = true
		}
		catch {
			self.isValid = false
			self.content = QRCode.Document()
		}

		if let gen = generatedDocument {
			let gend = self.content
			DispatchQueue.main.async {
				// Pass the generated document back to the caller
				gen.wrappedValue = gend
			}
		}
	}

	public var body: some View {
		QRCodeDocumentUIView(document: content)
	}
}

#if DEBUG

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6, *)
let __logoTemplate = try! CGColor(red: 1, green: 0, blue: 0, alpha: 1).swatch()

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6, *)
struct QRCodeViewUI_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			HStack {
				QRCodeViewUI(content: "This is a test")
				QRCodeViewUI(
					content: "This is a test",
					foregroundColor: CGColor(srgbRed: 0.2, green: 0.2, blue: 0.6, alpha: 1.0),
					backgroundColor: CGColor(srgbRed: 1, green: 1, blue: 0.8, alpha: 1.0),
					onPixelShape: QRCode.PixelShape.Circle(),
					eyeShape: QRCode.EyeShape.Circle()
				)
				QRCodeViewUI(
					content: "This is a test",
					foregroundColor: CGColor(srgbRed: 0.990, green: 0.849, blue: 0.844, alpha: 1.0),
					backgroundColor: CGColor(srgbRed: 0.294, green: 0.382, blue: 0.454, alpha: 1.0),
					eyeShape: QRCode.EyeShape.Leaf()
				)
			}
			HStack {
				QRCodeViewUI(
					content: "This is a test",
					foregroundColor: CGColor(srgbRed: 1, green: 0.8, blue: 0.6, alpha: 1.0),
					backgroundColor: CGColor(srgbRed: 0.2, green: 0.2, blue: 0.8, alpha: 1.0),
					onPixelShape: QRCode.PixelShape.RoundedPath(cornerRadiusFraction: 0.7, hasInnerCorners: true),
					eyeShape: QRCode.EyeShape.RoundedRect()
				)
				QRCodeViewUI(
					content: "This is a test",
					foregroundColor: CGColor(srgbRed: 1, green: 0.8, blue: 1, alpha: 1.0),
					backgroundColor: CGColor(srgbRed: 0.2, green: 0.2, blue: 0.8, alpha: 1.0),
					onPixelShape: QRCode.PixelShape.CurvePixel(),
					negatedOnPixelsOnly: true
				)
				QRCodeViewUI(
					content: "This is a test",
					foregroundColor: CGColor(red: 0.048, green: 0.121, blue: 0.248, alpha: 1.0),
					backgroundColor: CGColor(red: 0.931, green: 0.398, blue: 0.134, alpha: 1.0),
					onPixelShape: QRCode.PixelShape.CurvePixel(cornerRadiusFraction: 0.8),
					eyeShape: QRCode.EyeShape.CorneredPixels()
				)
			}
			HStack {
				QRCodeViewUI(
					content: "This is a test",
					foregroundColor: CGColor(srgbRed: 0.2, green: 0.5, blue: 0.1, alpha: 1.0),
					backgroundColor: CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1.0),
					onPixelShape: QRCode.PixelShape.Square(insetFraction: 0.1),
					eyeShape: QRCode.EyeShape.RoundedOuter(),
					logoTemplate: QRCode.LogoTemplate(
						image: __logoTemplate,
						path: CGPath(rect: CGRect(x: 0.35, y: 0.35, width: 0.3, height: 0.3), transform: nil)
					)
				)
				QRCodeViewUI(
					content: "This is a test",
					foregroundColor: CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1.0),
					backgroundColor: CGColor(srgbRed: 1, green: 0, blue: 1, alpha: 1.0),
					onPixelShape: QRCode.PixelShape.Sharp(),
					eyeShape: QRCode.EyeShape.BarsVertical(),
					eyeStyle: QRCode.FillStyle.Solid(srgbRed: 0.1, green: 0, blue: 1),
					pupilStyle: QRCode.FillStyle.Solid(srgbRed: 0.5, green: 0, blue: 1),
					logoTemplate: QRCode.LogoTemplate(
						image: __logoTemplate,
						path: CGPath(rect: CGRect(x: 0.2, y: 0.4, width: 0.6, height: 0.2), transform: nil)
					)
				)
				QRCodeViewUI(
					content: "This is a test",
					foregroundColor: CGColor(red: 1.000, green: 0.989, blue: 0.474, alpha: 1.0),
					backgroundColor: CGColor(red: 0.579, green: 0.091, blue: 0.317, alpha: 1.0),
					onPixelShape: QRCode.PixelShape.CurvePixel(cornerRadiusFraction: 0.8),
					eyeShape: QRCode.EyeShape.Squircle(),
					logoTemplate: QRCode.LogoTemplate(
						image: __logoTemplate,
						path: CGPath(ellipseIn: CGRect(x: 0.3, y: 0.3, width: 0.4, height: 0.4), transform: nil)
					)
				)
			}
			HStack {
				QRCodeViewUI(
					content: "This is a test",
					onPixelShape: QRCode.PixelShape.Square(insetFraction: 0.1),
					eyeShape: QRCode.EyeShape.RoundedOuter(),
					shadow: .init(.dropShadow, dx: 0.2, dy: -0.2, blur: 8, color: CGColor(red: 0, green: 1, blue: 0, alpha: 1))
				)
				QRCodeViewUI(
					content: "This is a test",
					onPixelShape: QRCode.PixelShape.Square(insetFraction: 0.1),
					eyeShape: QRCode.EyeShape.RoundedOuter(),
					shadow: .init(.innerShadow, dx: 0.2, dy: -0.2, blur: 8, color: CGColor(red: 0, green: 1, blue: 0, alpha: 1))
				)
			}
		}
		.frame(height: 800)
	}
}

#endif
