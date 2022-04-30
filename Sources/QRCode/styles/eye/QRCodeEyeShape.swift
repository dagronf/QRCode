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
	@objc static func Create(_ settings: [String: Any]) -> QRCodeEyeShapeGenerator
	@objc func settings() -> [String: Any]
	@objc func copyShape() -> QRCodeEyeShapeGenerator
	@objc func eyePath() -> CGPath
	@objc func pupilPath() -> CGPath
}

public extension QRCodeEyeShapeGenerator {
	var name: String { return Self.Name }
}

public class QRCodeEyeShapeFactory {
	public static var registeredTypes: [QRCodeEyeShapeGenerator.Type] = [
		QRCode.EyeShape.Circle.self,
		QRCode.EyeShape.RoundedRect.self,
		QRCode.EyeShape.RoundedPointingIn.self,
		QRCode.EyeShape.Squircle.self,
		QRCode.EyeShape.RoundedOuter.self,
		QRCode.EyeShape.Square.self,
		QRCode.EyeShape.Leaf.self,
	]
	
	@objc public var knownTypes: [String] {
		QRCodeEyeShapeFactory.registeredTypes.map { $0.Name }
	}
	
	@objc public func Create(settings: [String: Any]) -> QRCodeEyeShapeGenerator? {
		guard let type = settings["type"] as? String else { return nil }
		guard let f = QRCodeEyeShapeFactory.registeredTypes.first(where: { $0.Name == type }) else {
			return nil
		}
		return f.Create(settings)
	}
	
	//	@objc public func Create(named name: String) -> QRCodeEyeShapeHandler? {
	//		if let f = QRCodeEyeShapeFactory.registeredTypes.first(where: { $0.Name == name }) {
	//			return f.Create(nil)
	//		}
	//		return nil
	//	}
}

public let EyeShapeFactory = QRCodeEyeShapeFactory()

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
