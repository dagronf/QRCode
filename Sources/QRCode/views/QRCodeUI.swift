//
//  QRCodeUI.swift
//
//  Created by Darren Ford on 9/11/21.
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

// SwiftUI implementation

import SwiftUI

/// SwiftUI implementation of a basic QR Code view
@available(macOS 11, iOS 13.0, tvOS 13.0, *)
public struct QRCodeUI: Shape {
	/// Create a QRCode shape using the specified data
	public init(
		data: Data,
		errorCorrection: QRCode.ErrorCorrection = .low,
		components: QRCode.Components = .all,
		contentShape: QRCode.Shape = QRCode.Shape()
	) {
		self.data = data
		self.errorCorrection = errorCorrection
		self.components = components
		self.contentShape = contentShape
		self.generator.update(data, errorCorrection: errorCorrection)
	}

	/// Create a QRCode shape using the specified text
	public init?(
		text: String,
		errorCorrection: QRCode.ErrorCorrection = .low,
		components: QRCode.Components = .all,
		contentShape: QRCode.Shape = QRCode.Shape()
	) {
		guard let data = text.data(using: .utf8) else { return nil }
		self.data = data
		self.errorCorrection = errorCorrection
		self.components = components
		self.contentShape = contentShape
		self.generator.update(data, errorCorrection: errorCorrection)
	}

	/// Create a QRCode shape using the specified message formatter
	public init(
		message: QRCodeMessageFormatter,
		errorCorrection: QRCode.ErrorCorrection = .low,
		components: QRCode.Components = .all,
		contentShape: QRCode.Shape = QRCode.Shape()
	) {
		self.data = message.data
		self.errorCorrection = errorCorrection
		self.components = components
		self.contentShape = contentShape
		self.generator.update(self.data, errorCorrection: errorCorrection)
	}

	// Private
	private let data: Data
	private let contentShape: QRCode.Shape
	private let components: QRCode.Components
	private let errorCorrection: QRCode.ErrorCorrection
	private let generator = QRCode()
}

// MARK: - Modifiers

@available(macOS 11, iOS 13.0, tvOS 13.0, *)
public extension QRCodeUI {

	/// Returns a copy of the qrcode using the specified error correction level
	func errorCorrection(_ errorCorrection: QRCode.ErrorCorrection) -> QRCodeUI {
		return QRCodeUI(
			data: self.data,
			errorCorrection: errorCorrection,
			components: self.components,
			contentShape: self.contentShape.copyShape()
		)
	}

	/// Returns a copy of the qrcode using only the specified components being generated.
	func components(_ components: QRCode.Components) -> QRCodeUI {
		return QRCodeUI(
			data: self.data,
			errorCorrection: self.errorCorrection,
			components: components,
			contentShape: self.contentShape.copyShape()
		)
	}

	/// Returns a copy of the qrcode using the specified shape (both eye and data)
	func contentShape(_ shape: QRCode.Shape) -> QRCodeUI {
		return QRCodeUI(
			data: self.data,
			errorCorrection: self.errorCorrection,
			components: self.components,
			contentShape: shape.copyShape()
		)
	}

	/// Change the eye shape to another shape
	func eyeShape(_ eyeShape: QRCodeEyeShapeHandler) -> QRCodeUI {
		let shape = self.contentShape.copyShape()
		shape.eye = eyeShape
		return QRCodeUI(
			data: self.data,
			errorCorrection: self.errorCorrection,
			components: self.components,
			contentShape: shape
		)
	}

	/// Change the data shape to another shape
	func dataShape(_ dataShape: QRCodeDataShapeHandler) -> QRCodeUI {
		let shape = self.contentShape.copyShape()
		shape.data = dataShape
		return QRCodeUI(
			data: self.data,
			errorCorrection: self.errorCorrection,
			components: self.components,
			contentShape: shape
		)
	}
}

// MARK: - Paths

@available(macOS 11, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension QRCodeUI {
	/// Returns the path for the qr code
	func path(in rect: CGRect) -> Path {
		let path = self.generator.path(rect.size, components: self.components, shape: self.contentShape) // pixelStyle: self.pixelStyle)
		return Path(path)
	}
}

// MARK: - Previews

let DemoContent = "https://goo.gl/maps/Z4d9uVV87gVifrZKA"
let DemoContent2 = "Harness the power of Quartz technology to perform lightweight 2D rendering with high-fidelity output. Handle path-based drawing, antialiased rendering, gradients, images, color management, PDF documents, and more."

// Unfortunately, there is no point in creating more previews as
// XCode refuses to display them either with a compilation error, or with a
// 'fail to send message to helper'.  Grrrr...

@available(macOS 11, iOS 14, tvOS 14, watchOS 6.0, *)
struct QRCodeUI_Previews: PreviewProvider {
	static var previews: some View {
		HStack {
			QRCodeUI(text: DemoContent, errorCorrection: .low)!
				.components(.all)
		}
	}
}
