//
//  ContentView.swift
//  ShareLink Demo
//
//  Created by Darren Ford on 18/10/2024.
//

import SwiftUI
import QRCode
import Combine

struct ContentView: View {

	static let initialContent = "Żółte słonie"

	@State var document: QRCode.Document
	@State var content: String
	@State var qrImage: Image
	@State var qrDescription: String

	init() {
		self.document = try! QRCode.Document(utf8String: Self.initialContent)
		self.content = Self.initialContent
		self.qrImage = Image(systemName: "exclamationmark.triangle.fill")
		self.qrDescription = "QR Code: \(Self.initialContent)"
	}

	private func updateContent(_ content: String) {
		self.document.utf8String = content
		self.document.setHasChanged()
		self.qrImage = try! self.document.imageUI(
			CGSize(width: 600, height: 600),
			label: Text(self.qrDescription)
		)
		self.qrDescription = "QR Code: \(content)"
	}

	var body: some View {
		NavigationStack {
			VStack {
				TextField("Content", text: Binding(
					get: { self.document.utf8String ?? ""},
					set: { self.updateContent($0) }
				))
				.textFieldStyle(.roundedBorder)
				QRCodeDocumentUIView(document: self.document)
			}
			.padding()
			.toolbar {
				ShareLink(
					item: self.qrImage,
					preview: SharePreview(
						self.qrDescription,
						image: self.qrImage
					)
				)
			}
		}
	}
}

#Preview {
	ContentView()
}
