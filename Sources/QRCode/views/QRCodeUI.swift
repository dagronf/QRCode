//
//  QRCodeUI.swift
//
//  Copyright © 2022 Darren Ford. All rights reserved.
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
		shape: QRCode.Shape = QRCode.Shape(),
		generator: QRCodeEngine? = nil
	) {
		self.data__ = data
		self.errorCorrection__ = errorCorrection
		self.components__ = components
		self.shape__ = shape
		if let g = generator {
			self.qrCodeGenerator__.generator = g
		}
		self.qrCodeGenerator__.update(data, errorCorrection: errorCorrection)
	}

	/// Create a QRCode shape using the specified text
	public init?(
		text: String,
		errorCorrection: QRCode.ErrorCorrection = .low,
		components: QRCode.Components = .all,
		shape: QRCode.Shape = QRCode.Shape(),
		generator: QRCodeEngine? = nil
	) {
		guard let data = text.data(using: .utf8) else { return nil }
		self.data__ = data
		self.errorCorrection__ = errorCorrection
		self.components__ = components
		self.shape__ = shape
		if let g = generator {
			self.qrCodeGenerator__.generator = g
		}
		self.qrCodeGenerator__.update(data, errorCorrection: errorCorrection)
	}

	/// Create a QRCode shape using the specified message formatter
	public init(
		message: QRCodeMessageFormatter,
		errorCorrection: QRCode.ErrorCorrection = .low,
		components: QRCode.Components = .all,
		shape: QRCode.Shape = QRCode.Shape(),
		generator: QRCodeEngine? = nil
	) {
		self.data__ = message.data
		self.errorCorrection__ = errorCorrection
		self.components__ = components
		self.shape__ = shape
		if let g = generator {
			self.qrCodeGenerator__.generator = g
		}
		self.qrCodeGenerator__.update(self.data__, errorCorrection: errorCorrection)
	}

	// Private
	private let data__: Data
	private let shape__: QRCode.Shape
	private let components__: QRCode.Components
	private let errorCorrection__: QRCode.ErrorCorrection
	private let qrCodeGenerator__ = QRCode()
}

// MARK: - Modifiers

@available(macOS 11, iOS 13.0, tvOS 13.0, *)
public extension QRCodeUI {

	/// Returns a copy of the qrcode using the specified error correction level
	func errorCorrection(_ errorCorrection: QRCode.ErrorCorrection) -> QRCodeUI {
		return QRCodeUI(
			data: self.data__,
			errorCorrection: errorCorrection,
			components: self.components__,
			shape: self.shape__.copyShape(),
			generator: self.qrCodeGenerator__.generator
		)
	}

	/// Returns a copy of the qrcode using only the specified components being generated.
	func components(_ components: QRCode.Components) -> QRCodeUI {
		return QRCodeUI(
			data: self.data__,
			errorCorrection: self.errorCorrection__,
			components: components,
			shape: self.shape__.copyShape(),
			generator: self.qrCodeGenerator__.generator
		)
	}

	/// Returns a copy of the qrcode using the specified shape (both eye and data)
	@available(*, deprecated, renamed: "shape")
	func contentShape(_ shape: QRCode.Shape) -> QRCodeUI {
		self.shape(shape)
	}

	/// Returns a copy of the qrcode using the specified shape (both eye and data)
	@available(*, deprecated, renamed: "shape")
	func shape(_ shape: QRCode.Shape) -> QRCodeUI {
		return QRCodeUI(
			data: self.data__,
			errorCorrection: self.errorCorrection__,
			components: self.components__,
			shape: shape.copyShape(),
			generator: self.qrCodeGenerator__.generator
		)
	}

	/// Change the eye shape to another shape
	func eyeShape(_ eyeShape: QRCodeEyeShapeGenerator) -> QRCodeUI {
		let shape = self.shape__.copyShape()
		shape.eye = eyeShape
		return QRCodeUI(
			data: self.data__,
			errorCorrection: self.errorCorrection__,
			components: self.components__,
			shape: shape,
			generator: self.qrCodeGenerator__.generator
		)
	}

	/// Change the 'on' pixel shape
	@available(*, deprecated, renamed: "onPixelShape")
	func pixelShape(_ pixelShape: QRCodePixelShapeGenerator) -> QRCodeUI {
		onPixelShape(pixelShape)
	}

	/// Change the 'on' pixel shape
	func onPixelShape(_ pixelShape: QRCodePixelShapeGenerator) -> QRCodeUI {
		let shape = self.shape__.copyShape()
		shape.onPixels = pixelShape
		return QRCodeUI(
			data: self.data__,
			errorCorrection: self.errorCorrection__,
			components: self.components__,
			shape: shape,
			generator: self.qrCodeGenerator__.generator
		)
	}

	/// Change the 'off' pixel shape
	func offPixelShape(_ pixelShape: QRCodePixelShapeGenerator) -> QRCodeUI {
		let shape = self.shape__.copyShape()
		shape.offPixels = pixelShape
		return QRCodeUI(
			data: self.data__,
			errorCorrection: self.errorCorrection__,
			components: self.components__,
			shape: shape,
			generator: self.qrCodeGenerator__.generator
		)
	}

	/// Override the pupil shape
	func pupilShape(_ pupilShape: QRCodePupilShapeGenerator) -> QRCodeUI {
		let shape = self.shape__.copyShape()
		shape.pupil = pupilShape
		return QRCodeUI(
			data: self.data__,
			errorCorrection: self.errorCorrection__,
			components: self.components__,
			shape: shape,
			generator: self.qrCodeGenerator__.generator
		)
	}

	/// Deprecated. Use `pixelShape` instead.
	@available(*, deprecated, renamed: "pixelShape")
	func dataShape(_ dataShape: QRCodePixelShapeGenerator) -> QRCodeUI {
		pixelShape(dataShape)
	}
}

// MARK: - Paths

@available(macOS 11, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension QRCodeUI {
	/// Returns the path for the qr code
	func path(in rect: CGRect) -> Path {
		let path = self.qrCodeGenerator__.path(rect.size, components: self.components__, shape: self.shape__)
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
		VStack {
			HStack {
				QRCodeUI(text: DemoContent, errorCorrection: .low)!
					.components(.all)
					.onPixelShape(QRCodePixelShapeFactory.shared.named("circle")!)
				QRCodeUI(text: DemoContent2, errorCorrection: .medium)!
			}

			Text("Components")

			VStack {
				HStack {
					VStack {
						QRCodeUI(text: "Hello there how are you", errorCorrection: .low)!
							.components(.onPixels)
						Text("'on' pixels only")
					}
					VStack {
						QRCodeUI(text: "Hello there how are you", errorCorrection: .low)!
							.offPixelShape(QRCode.PixelShape.Square())
							.components(.offPixels)
						Text("'off' pixels only")
					}
				}
				HStack {
					VStack {
					QRCodeUI(text: "Hello there how are you", errorCorrection: .low)!
						.components(.eyeOuter)
						Text("eye outer only")
					}
					VStack {
					QRCodeUI(text: "Hello there how are you", errorCorrection: .low)!
						.components(.eyePupil)
						Text("pupil only")
					}
				}
			}
		}
	}
}
