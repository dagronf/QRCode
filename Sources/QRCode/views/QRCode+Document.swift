//
//  File.swift
//  
//
//  Created by Darren Ford on 23/1/2022.
//

import Foundation

public extension QRCode {

	@objc(QRCodeDocument) class Document: NSObject {

		/// The correction level to use when generating the QR code
		@objc public var errorCorrection: QRCode.ErrorCorrection = .low {
			didSet {
				self.regenerate()
			}
		}

		/// Binary data to display in the QR code
		@objc public var data = Data() {
			didSet {
				self.regenerate()
			}
		}

		/// The style to use when drawing the qr code
		@objc public var design = QRCode.Design()

		/// This is the pixel dimension for the QR Code.
		@objc public var pixelSize: Int {
			return self.qrcode.pixelSize
		}

		/// A simple ASCII representation of the core QRCode data
		@objc public var asciiRepresentation: String { return self.qrcode.asciiRepresentation() }

		/// A simple smaller ASCII representation of the core QRCode data
		@objc public var smallAsciiRepresentation: String { return self.qrcode.smallAsciiRepresentation() }

		// The qrcode content generator
		private let qrcode = QRCode()

		// Build up the qr representation
		private func regenerate() {
			self.qrcode.update(self.data, errorCorrection: self.errorCorrection)
		}

		/// The current settings for the data, shape and design for the QRCode
		public var settings: [String: Any] {
			return [
				"correction": errorCorrection.ECLevel,
				"data": data.base64EncodedString(),
				"design": self.design.settings()
			]
		}

		@objc public static func Create(settings: [String: Any]) -> QRCode.Document? {
			let doc = QRCode.Document()

			let data: Data = {
				if let value = settings["data"] as? String,
					let data = Data(base64Encoded: value) {
					return data
				}
				return Data()
			}()
			doc.data = data

			let ec: QRCode.ErrorCorrection = {
				if let value = settings["correction"] as? Character,
					let ec = QRCode.ErrorCorrection.Create(value) {
					return ec
				}
				return .quantize
			}()
			doc.errorCorrection = ec

			if let design = settings["design"] as? [String: Any],
				let d = QRCode.Design.Create(settings: design) {
				doc.design = d
			}

			doc.regenerate()

			return doc
		}
	}
}

public extension QRCode.Document {
	/// Draw the current qrcode into the context using the specified style
	@objc func draw(ctx: CGContext, rect: CGRect, design: QRCode.Design) {
		self.qrcode.draw(ctx: ctx, rect: rect, design: design)
	}

	/// Build the QR Code using the given data and error correction
	@objc func update(_ data: Data, errorCorrection: QRCode.ErrorCorrection) {
		self.qrcode.update(data, errorCorrection: errorCorrection)
	}

	/// Build the QR Code using the given text and error correction
	@objc func update(text: String, errorCorrection: QRCode.ErrorCorrection = .default) {
		self.qrcode.update(text: text, errorCorrection: errorCorrection)
	}

	/// Build the QR Code using the given message formatter and error correction
	@objc func update(message: QRCodeMessageFormatter, errorCorrection: QRCode.ErrorCorrection = .default) {
		self.qrcode.update(message: message, errorCorrection: errorCorrection)
	}
}
