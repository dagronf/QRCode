//
//  QRCodeEyeShape.swift
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

import CoreGraphics
import Foundation

// MARK: - Eye shape

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
	@objc func pupilPath() -> CGPath
}

private let EyeShapeTypeName = "type"
private let EyeShapeSettingsName = "settings"

public extension QRCodeEyeShapeGenerator {
	var name: String { return Self.Name }
	
	internal func coreSettings() -> [String: Any] {
		var core: [String: Any] = [EyeShapeTypeName: self.name]
		core[EyeShapeSettingsName] = self.settings()
		return core
	}
}

@objc public class QRCodeEyeShapeFactory: NSObject {

	/// A shared eye shape factory
	@objc public static let shared = QRCodeEyeShapeFactory()

	internal var registeredTypes: [QRCodeEyeShapeGenerator.Type]

	@objc public override init() {
		self.registeredTypes = [
			QRCode.EyeShape.Circle.self,
			QRCode.EyeShape.RoundedRect.self,
			QRCode.EyeShape.RoundedPointingIn.self,
			QRCode.EyeShape.Squircle.self,
			QRCode.EyeShape.RoundedOuter.self,
			QRCode.EyeShape.Square.self,
			QRCode.EyeShape.Leaf.self,
		]
		super.init()
	}

	@objc public var availableGeneratorNames: [String] {
		self.registeredTypes.map { $0.Name }
	}

	/// Return a new instance of an eye shape generator with the specified name and optional settings
	@objc public func named(_ name: String, settings: [String: Any]? = nil) -> QRCodeEyeShapeGenerator? {
		guard let f = self.registeredTypes.first(where: { $0.Name == name }) else {
			return nil
		}
		return f.Create(settings)
	}

	/// Create an eye shape generator from the specified shape settings
	@objc public func create(settings: [String: Any]) -> QRCodeEyeShapeGenerator? {
		guard let type = settings[EyeShapeTypeName] as? String else { return nil }
		let settings = settings[EyeShapeSettingsName] as? [String: Any] ?? [:]
		return self.named(type, settings: settings)
	}
}

public extension QRCodeEyeShapeFactory {
	func image(eye: QRCodeEyeShapeGenerator, dimension: CGFloat, foregroundColor: CGColor) -> CGImage? {
		let width = Int(dimension)
		let height = Int(dimension)
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		guard let context = CGContext(
			data: nil,
			width: width,
			height: height,
			bitsPerComponent: 8,
			bytesPerRow: 0,
			space: colorSpace,
			bitmapInfo: bitmapInfo.rawValue
		)
		else {
			return nil
		}
		
		context.scaleBy(x: 1, y: -1)
		context.translateBy(x: 0, y: -dimension)
		
		let fitScale = dimension / 90
		var scaleTransform = CGAffineTransform.identity
		scaleTransform = scaleTransform.scaledBy(x: fitScale, y: fitScale)
		
		// Draw the qr with the required styles
		let path = CGMutablePath()
		path.addPath(eye.eyePath(), transform: scaleTransform)
		path.addPath(eye.pupilPath(), transform: scaleTransform)
		
		context.addPath(path)
		context.setFillColor(foregroundColor)
		context.fillPath()
		
		let im = context.makeImage()
		return im
	}
}

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public extension QRCodeEyeShapeFactory {
#if os(macOS)
	func nsImage(eye: QRCodeEyeShapeGenerator, dimension: CGFloat, foregroundColor: NSColor) -> NSImage? {
		if let cgi = image(eye: eye, dimension: dimension, foregroundColor: foregroundColor.cgColor) {
			return NSImage(cgImage: cgi, size: .zero)
		}
		return nil
	}
#endif
}
