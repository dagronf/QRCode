//
//  StyleSelectorImageView.swift
//  QR Stylist
//
//  Created by Darren Ford on 1/10/2022.
//

import SwiftUI
import QRCode

struct StyleImage: Equatable {
	var image: CGImage?

	var style: QRCode.FillStyle.Image {
		QRCode.FillStyle.Image(image)
	}
}

struct StyleSelectorImageView: View {
	@Binding var imageStyle: StyleImage

	@State var showOpenDialog = false

	init(image: Binding<StyleImage>) {
		self._imageStyle = image
	}

	var body: some View {
//		GeometryReader { geo in
			//			let fixedEnd = max(geo.size.width, geo.size.height)

			Button {
				showOpenDialog = true
			} label: {
				Text("…")
			}
			.fileImporter(
				isPresented: $showOpenDialog,
				allowedContentTypes: [.image],
				allowsMultipleSelection: false
			) { result in
				do {
					guard let selectedFile: URL = try result.get().first else { return }
#if os(macOS)
					guard selectedFile.startAccessingSecurityScopedResource() else {
						return
					}
					defer { selectedFile.stopAccessingSecurityScopedResource() }

					let pimage = NSImage(contentsOf: selectedFile)?.cgImage
#else
					let pimage = UIImage(contentsOfFile: selectedFile.path)?.cgImage
#endif

					imageStyle.image = pimage
				}
				catch {

				}
			}
//		}
	}
}
