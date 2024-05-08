//
//  QRCodeFillStyleFactory.swift
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

import Foundation

private let FillStyleTypeName = "type"
private let FillStyleSettingsName = "settings"

public class QRCodeFillStyleFactory {
	/// A shared fill style factory
	public static let shared = QRCodeFillStyleFactory()

	/// The names of the known fill style generators
	@objc public var knownTypes: [String] {
		QRCodeFillStyleFactory.registeredTypes.map { $0.Name }
	}

	@objc public func Create(settings: [String: Any]) throws -> (any QRCodeFillStyleGenerator) {
		guard
			let type = settings[FillStyleTypeName] as? String else {
			throw QRCodeError.cannotCreateGenerator
		}

		let sets = settings[FillStyleSettingsName] as? [String: Any] ?? [:]
		guard let f = QRCodeFillStyleFactory.registeredTypes.first(where: { $0.Name == type }) else {
			throw QRCodeError.cannotCreateGenerator
		}
		return try f.Create(settings: sets)
	}

	// private

	private static var registeredTypes: [any QRCodeFillStyleGenerator.Type] = [
		QRCode.FillStyle.Solid.self,
		QRCode.FillStyle.LinearGradient.self,
		QRCode.FillStyle.RadialGradient.self,
		QRCode.FillStyle.Image.self
	]
}
