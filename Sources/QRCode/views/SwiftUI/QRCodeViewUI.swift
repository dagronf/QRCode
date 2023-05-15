//
//  QRCodeViewUI.swift
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

// A basic SwiftUI view that doesn't require a document

import Foundation
import SwiftUI

/// A SwiftUI qrcode view with just the basics
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6, *)
public struct QRCodeViewUI: View {
	private let content: QRCode.Document
	public init(
		content: String,
		errorCorrection: QRCode.ErrorCorrection = .high,
		foregroundColor: CGColor = CGColor(gray: 0, alpha: 1),
		backgroundColor: CGColor = CGColor(gray: 1, alpha: 1),
		pixelStyle: QRCodePixelShapeGenerator? = nil,
		eyeStyle: QRCodeEyeShapeGenerator? = nil,
		pupilStyle: QRCodePupilShapeGenerator? = nil,
		logoTemplate: QRCode.LogoTemplate? = nil,
		negatedOnPixelsOnly: Bool? = nil,
		generator: QRCodeEngine? = nil,
		additionalQuietZonePixels: UInt = 0,
		backgroundFractionalCornerRadius: CGFloat = 0
	) {
		self.content = QRCode.Document(
			utf8String: content,
			errorCorrection: errorCorrection,
			generator: generator
		)
		self.content.design.foregroundColor(foregroundColor)
		self.content.design.backgroundColor(backgroundColor)

		self.content.design.additionalQuietZonePixels = additionalQuietZonePixels
		self.content.design.style.backgroundFractionalCornerRadius = backgroundFractionalCornerRadius

		if let pixelStyle = pixelStyle {
			self.content.design.shape.onPixels = pixelStyle
		}
		if let eyeStyle = eyeStyle {
			self.content.design.shape.eye = eyeStyle
		}
		if let pupilStyle = pupilStyle {
			self.content.design.shape.pupil = pupilStyle
		}
		if let logoTemplate = logoTemplate {
			self.content.logoTemplate = logoTemplate
		}
		if let negatedOnPixelsOnly = negatedOnPixelsOnly {
			self.content.design.shape.negatedOnPixelsOnly = negatedOnPixelsOnly
		}
	}

	public var body: some View {
		QRCodeDocumentUIView(document: content)
	}
}

#if DEBUG

let __logoTemplate = CGColor(red: 1, green: 0, blue: 0, alpha: 1).swatch()!

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
					pixelStyle: QRCode.PixelShape.Circle(),
					eyeStyle: QRCode.EyeShape.Circle()
				)
				QRCodeViewUI(
					content: "This is a test",
					foregroundColor: CGColor(srgbRed: 0.990, green: 0.849, blue: 0.844, alpha: 1.0),
					backgroundColor: CGColor(srgbRed: 0.294, green: 0.382, blue: 0.454, alpha: 1.0),
					eyeStyle: QRCode.EyeShape.Leaf()
				)
			}
			HStack {
				QRCodeViewUI(
					content: "This is a test",
					foregroundColor: CGColor(srgbRed: 1, green: 0.8, blue: 0.6, alpha: 1.0),
					backgroundColor: CGColor(srgbRed: 0.2, green: 0.2, blue: 0.8, alpha: 1.0),
					pixelStyle: QRCode.PixelShape.RoundedPath(cornerRadiusFraction: 0.7, hasInnerCorners: true),
					eyeStyle: QRCode.EyeShape.RoundedRect()
				)
				QRCodeViewUI(
					content: "This is a test",
					foregroundColor: CGColor(srgbRed: 1, green: 0.8, blue: 1, alpha: 1.0),
					backgroundColor: CGColor(srgbRed: 0.2, green: 0.2, blue: 0.8, alpha: 1.0),
					pixelStyle: QRCode.PixelShape.CurvePixel(),
					negatedOnPixelsOnly: true
				)
				QRCodeViewUI(
					content: "This is a test",
					foregroundColor: CGColor(red: 0.048, green: 0.121, blue: 0.248, alpha: 1.0),
					backgroundColor: CGColor(red: 0.931, green: 0.398, blue: 0.134, alpha: 1.0),
					pixelStyle: QRCode.PixelShape.CurvePixel(cornerRadiusFraction: 0.8),
					eyeStyle: QRCode.EyeShape.CorneredPixels()
				)
			}
			HStack {
				QRCodeViewUI(
					content: "This is a test",
					foregroundColor: CGColor(srgbRed: 0.2, green: 0.5, blue: 0.1, alpha: 1.0),
					backgroundColor: CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1.0),
					pixelStyle: QRCode.PixelShape.Square(insetFraction: 0.1),
					eyeStyle: QRCode.EyeShape.RoundedOuter(),
					logoTemplate: QRCode.LogoTemplate(
						image: __logoTemplate,
						path: CGPath(rect: CGRect(x: 0.35, y: 0.35, width: 0.3, height: 0.3), transform: nil)
					)
				)
				QRCodeViewUI(
					content: "This is a test",
					foregroundColor: CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1.0),
					backgroundColor: CGColor(srgbRed: 1, green: 0, blue: 1, alpha: 1.0),
					pixelStyle: QRCode.PixelShape.Sharp(),
					eyeStyle: QRCode.EyeShape.BarsVertical(),
					logoTemplate: QRCode.LogoTemplate(
						image: __logoTemplate,
						path: CGPath(rect: CGRect(x: 0.2, y: 0.4, width: 0.6, height: 0.2), transform: nil)
					)
				)
				QRCodeViewUI(
					content: "This is a test",
					foregroundColor: CGColor(red: 1.000, green: 0.989, blue: 0.474, alpha: 1.0),
					backgroundColor: CGColor(red: 0.579, green: 0.091, blue: 0.317, alpha: 1.0),
					pixelStyle: QRCode.PixelShape.CurvePixel(cornerRadiusFraction: 0.8),
					eyeStyle: QRCode.EyeShape.Squircle(),
					logoTemplate: QRCode.LogoTemplate(
						image: __logoTemplate,
						path: CGPath(ellipseIn: CGRect(x: 0.3, y: 0.3, width: 0.4, height: 0.4), transform: nil)
					)
				)
			}
		}
	}
}

#endif
