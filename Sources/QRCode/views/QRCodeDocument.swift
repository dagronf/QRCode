//
//  File.swift
//  
//
//  Created by Darren Ford on 23/1/2022.
//

import Foundation

@objc class QRCodeDocument: NSObject {

	// The qrcode content generator
	private let qrCodeContent = QRCode()

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

	/// A simple ASCII representation of the core QRCode data
	@objc public var asciiRepresentation: String { return self.qrCodeContent.asciiRepresentation() }
	
	/// A simple smaller ASCII representation of the core QRCode data
	@objc public var smallAsciiRepresentation: String { return self.qrCodeContent.smallAsciiRepresentation() }

	// Build up the qr representation
	private func regenerate() {
		self.qrCodeContent.update(self.data, errorCorrection: self.errorCorrection)
	}

	/// The current settings for the data, shape and design for the QRCode
	public var settings: [String: Any] {
		return [
			"correction": errorCorrection.ECLevel,
			"data": data.base64EncodedString(),
			"design": self.design.settings()
		]
	}

	@objc public static func Create(settings: [String: Any]) -> QRCodeDocument? {
		let doc = QRCodeDocument()

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
