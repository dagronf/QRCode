//
//  QRCodeFillStyle.swift
//
//  Created by Darren Ford on 29/11/21.
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

// MARK: - Fill style support

public extension QRCode {
	@objc(QRCodeFillStyle) class FillStyle: NSObject {
		/// Simple convenience for a clear fill
		@objc public static let clear = FillStyle.Solid(.clear)
	}
}

/// A protocol for wrapping fill styles for image generation
@objc public protocol QRCodeFillStyleGenerator {
	@objc static var Name: String { get }
	@objc static func Create(settings: [String: Any]) -> QRCodeFillStyleGenerator?

	func copyStyle() -> QRCodeFillStyleGenerator
	func settings() -> [String: Any]
	func fill(ctx: CGContext, rect: CGRect)
	func fill(ctx: CGContext, rect: CGRect, path: CGPath)
}
public extension QRCodeFillStyleGenerator {
	var name: String { return Self.Name }
}

public class QRCodeFillStyleFactory {

	static public var registeredTypes: [QRCodeFillStyleGenerator.Type] = [
		QRCode.FillStyle.Solid.self,
		QRCode.FillStyle.LinearGradient.self,
		QRCode.FillStyle.RadialGradient.self,
	]

	@objc public var knownTypes: [String] {
		QRCodeFillStyleFactory.registeredTypes.map { $0.Name }
	}

	@objc public func Create(settings: [String: Any]) -> QRCodeFillStyleGenerator? {
		guard let type = settings["type"] as? String else { return nil }
		guard let f = QRCodeFillStyleFactory.registeredTypes.first(where: { $0.Name == type }) else {
			return nil
		}
		return f.Create(settings: settings)
	}
}

public let FillStyleFactory = QRCodeFillStyleFactory()
