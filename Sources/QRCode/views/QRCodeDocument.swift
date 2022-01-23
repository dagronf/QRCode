//
//  File.swift
//  
//
//  Created by Darren Ford on 23/1/2022.
//

import Foundation

class QRCodeDocument {

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


	// Build up the qr representation
	private func regenerate() {
		self.qrCodeContent.update(self.data, errorCorrection: self.errorCorrection)
	}

}
