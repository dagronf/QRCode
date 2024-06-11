//
//  QRCodeEngine.swift
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

/// A protocol for qr code generation
@objc public protocol QRCodeEngine {
	/// The engine name
	@objc var name: String { get }

	/// Generate QR Code matrix from the specified data
	@objc func generate(data: Data, errorCorrection: QRCode.ErrorCorrection) throws -> BoolMatrix

	/// Generate QR Code matrix from the specified string
	@objc func generate(text: String, errorCorrection: QRCode.ErrorCorrection) throws -> BoolMatrix
}

extension QRCode {
	/// Create a default engine for the platform
	@objc(QRCodeDefaultEngine) public static func DefaultEngine() -> any QRCodeEngine {
#if os(watchOS)
		// A third-party qr code generator
		return QRCodeEngineExternal()
#else
		return QRCodeEngineCoreImage()
#endif
	}

	/// Returns the engines supported for this platform
	/// - Returns: An array of QR Code engines supported on this platform
	@objc(QRCodeAvailableEngines) public static func AvailableEngines() -> [any QRCodeEngine] {
#if os(watchOS)
	return [QRCodeEngineExternal()]
#else
	return [QRCodeEngineCoreImage(), QRCodeEngineExternal()]
#endif
	}
}
