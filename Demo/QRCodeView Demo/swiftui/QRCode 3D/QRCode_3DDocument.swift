//
//  QRCode_3DDocument.swift
//  QRCode 3D
//
//  Created by Darren Ford on 25/4/2024.
//

import SwiftUI
import UniformTypeIdentifiers

import QRCode

final class QRCode_3DDocument: ReferenceFileDocument {

	@Published var qrcode: QRCode.Document

	init() {
		self.qrcode = try! QRCode.Document(utf8String: "This is a QR Code")
	}

	static var readableContentTypes: [UTType] { [.org_dagronf_qrcode_encoding_json] }

	required init(configuration: ReadConfiguration) throws {
		guard let data = configuration.file.regularFileContents else {
			throw CocoaError(.fileReadCorruptFile)
		}
		self.qrcode = try QRCode.Document(jsonData: data)
	}

	func snapshot(contentType: UTType) throws -> Data {
		try qrcode.jsonData()
	}

	func fileWrapper(snapshot: Data, configuration: WriteConfiguration) throws -> FileWrapper {
		return .init(regularFileWithContents: snapshot)
	}
}
