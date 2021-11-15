//
//  QRCodeView.swift
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

import CoreImage
import SwiftUI

/// SwiftUI implementation of a basic QR Code view
@available(macOS 11, iOS 14.0, tvOS 14.0, *)
public struct QRCode: Shape {
	public init(data: Data, errorCorrection: QRCodeContent.ErrorCorrection = .low) {
		self.data = data
		self.ec = errorCorrection
		self.generator.generate(data, errorCorrection: errorCorrection)
	}

	public init(text: String, errorCorrection: QRCodeContent.ErrorCorrection = .low) {
		self.data = text.data(using: .utf8) ?? Data()
		self.ec = errorCorrection
		self.generator.generate(data, errorCorrection: errorCorrection)
	}

	public init(message: QRCodeMessageFormatter, errorCorrection: QRCodeContent.ErrorCorrection = .low) {
		self.data = message.data
		self.ec = errorCorrection
		self.generator.generate(data, errorCorrection: errorCorrection)
	}

	public func path(in rect: CGRect) -> Path {
		let path = self.generator.path(rect.size)
		return Path(path)
	}

	// Private
	private let data: Data
	private let ec: QRCodeContent.ErrorCorrection
	private let generator = QRCodeContent()
}

@available(macOS 11, iOS 14.0, tvOS 14.0, *)
public extension QRCode {
	struct Eye: Shape {
		public init(data: Data, errorCorrection: QRCodeContent.ErrorCorrection = .low) {
			self.data = data
			self.ec = errorCorrection
			self.generator.generate(data, errorCorrection: errorCorrection)
		}

		public func path(in rect: CGRect) -> Path {
			let path = self.generator.eyesPath(rect.size)
			return Path(path)
		}

		// Private
		private let data: Data
		private let ec: QRCodeContent.ErrorCorrection
		private let generator = QRCodeContent()
	}
}

@available(macOS 11, iOS 14.0, tvOS 14.0, *)
public extension QRCode {
	struct Content: Shape {
		public init(data: Data, errorCorrection: QRCodeContent.ErrorCorrection = .low) {
			self.data = data
			self.ec = errorCorrection
			self.generator.generate(data, errorCorrection: errorCorrection)
		}

		public func path(in rect: CGRect) -> Path {
			let path = self.generator.contentPath(rect.size)
			return Path(path)
		}

		// Private
		private let data: Data
		private let ec: QRCodeContent.ErrorCorrection
		private let generator = QRCodeContent()
	}
}

// MARK: - Previews

let DemoContent = "https://goo.gl/maps/Z4d9uVV87gVifrZKA"
let DemoContent2 = "Harness the power of Quartz technology to perform lightweight 2D rendering with high-fidelity output. Handle path-based drawing, antialiased rendering, gradients, images, color management, PDF documents, and more."

@available(macOS 11, iOS 14, tvOS 14, *)
struct QRCode_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			HStack {
				VStack {
					Text("Low (L)")
					QRCode(text: DemoContent, errorCorrection: .low)
						.frame(width: 150, height: 150)
				}
				VStack {
					Text("Medium (M)")
					QRCode(text: DemoContent, errorCorrection: .medium)
						.frame(width: 150, height: 150)
				}
				VStack {
					Text("High (Q)")
					QRCode(text: DemoContent, errorCorrection: .high)
						.frame(width: 150, height: 150)
				}
				VStack {
					Text("Max (H)")
					QRCode(text: DemoContent, errorCorrection: .max)
						.frame(width: 150, height: 150)
				}
			}

			HStack {
				QRCode(text: "caterpillar-noodle")
					.fill(.red)
					.frame(width: 100, height: 100)
				QRCode(text: "caterpillar-noodle")
					.fill(.green)
					.frame(width: 100, height: 100)
				QRCode(text: "caterpillar-noodle")
					.fill(.blue)
					.frame(width: 100, height: 100)
			}

			HStack {
				QRCode(text: "caterpillar-noodle")
					.fill(.red)
					.frame(width: 100, height: 100)
				QRCode(text: "caterpillar-noodle")
					.fill(.green)
					.frame(width: 100, height: 100)
				QRCode(text: "caterpillar-noodle")
					.fill(.blue)
					.frame(width: 100, height: 100)
			}

			HStack {
				QRCode(text: DemoContent2)
					.fill(.black)
					.frame(width: 150, height: 150)
				QRCode(text: DemoContent2)
					.fill(.black)
					.frame(width: 150, height: 150)
				QRCode(text: DemoContent2)
					.fill(.black)
					.frame(width: 300, height: 300)
			}
		}
	}
}
