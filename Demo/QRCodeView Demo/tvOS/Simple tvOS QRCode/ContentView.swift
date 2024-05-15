//
//  ContentView.swift
//  Simple tvOS QRCode
//
//  Created by Darren Ford on 5/10/2022.
//

import SwiftUI

import QRCode

struct _namedImage: Identifiable {
	let id: String
	let image: CGImage
}

let _pixelImages = try! QRCodePixelShapeFactory.shared.generateSampleImages(
	dimension: 80,
	foregroundColor: CGColor(gray: 0, alpha: 1),
	backgroundColor: CGColor(gray: 0, alpha: 0)
).map { _namedImage(id: $0.name, image: $0.image) }

let _eyeImages = try! QRCodeEyeShapeFactory.shared.generateSampleImages(
	dimension: 80,
	foregroundColor: CGColor(gray: 0, alpha: 1),
	backgroundColor: CGColor(gray: 0, alpha: 0)
).map { _namedImage(id: $0.name, image: $0.image) }

let _pupilImages = try! QRCodePupilShapeFactory.shared.generateSampleImages(
	dimension: 80,
	foregroundColor: CGColor(gray: 0, alpha: 1),
	backgroundColor: CGColor(gray: 0, alpha: 0)
).map { _namedImage(id: $0.name, image: $0.image) }

struct ContentView: View {

	@StateObject var qrcode = try! QRCode.build
		.engine(QRCodeEngineExternal())
		.url(URL(string: "https://www.apple.com.au")!)
		.foregroundColor(CGColor(gray: 1, alpha: 1))
		.backgroundColor(CGColor(gray: 0, alpha: 0))
		.eye.shape(QRCode.EyeShape.Leaf())
		.document

	@State var eyeSelection: String = ""
	@State private var bgColor =
			Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)

	var body: some View {
		HStack {

			HStack(spacing: 0) {
				VStack(alignment: .center) {
					Text("Pixels").font(.headline)
					List(_pixelImages) { item in
						Button(action: {
							let g = try! QRCodePixelShapeFactory.shared.named(item.id)
							qrcode.design.shape.onPixels = g
							qrcode.objectWillChange.send()
						}, label: {
							Image(uiImage: UIImage(cgImage: item.image).withRenderingMode(.alwaysTemplate))
								.resizable()
								.aspectRatio(contentMode: .fit)
								.padding(4)
						})
						.frame(height: 100)
						.buttonStyle(.card)
					}
					.padding([.top, .bottom], 20)
				}
				.frame(width: 140)

				VStack {
					Text("Eye").font(.headline)
					List(_eyeImages) { item in
						Button(action: {
							let g = try! QRCodeEyeShapeFactory.shared.named(item.id)
							qrcode.design.shape.eye = g
							qrcode.objectWillChange.send()
						}, label: {
							Image(uiImage: UIImage(cgImage: item.image).withRenderingMode(.alwaysTemplate))
								.resizable()
								.aspectRatio(contentMode: .fit)
								.padding(4)
						})
						.frame(height: 100)
						.buttonStyle(.card)
					}
					.padding([.top, .bottom], 20)
				}
				.frame(width: 140)

				VStack {
					Text("Pupil").font(.headline)
					List(_pupilImages) { item in
						Button(action: {
							let g = try! QRCodePupilShapeFactory.shared.named(item.id)
							qrcode.design.shape.pupil = g
							qrcode.objectWillChange.send()
						}, label: {
							Image(uiImage: UIImage(cgImage: item.image).withRenderingMode(.alwaysTemplate))
								.resizable()
								.aspectRatio(contentMode: .fit)
								.padding(4)
						})
						.frame(height: 100)
						.buttonStyle(.card)
					}
					.padding([.top, .bottom], 20)
				}
				.frame(width: 140)

				Spacer()
			}

			VStack {
				QRCodeDocumentUIView(document: qrcode)
					.aspectRatio(contentMode: .fit)
					.shadow(radius: 10)
				Text("Scan this code with your phone to visit Apple online")
			}
		}
		.padding()
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
