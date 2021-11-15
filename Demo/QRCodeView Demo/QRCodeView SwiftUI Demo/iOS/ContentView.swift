//
//  ContentView.swift
//  Shared
//
//  Created by Darren Ford on 8/11/21.
//

import QRCodeView
import SwiftUI

struct ContentView: View {
	@State var content: String = "This is a test of the QR code control"
	@State var correction: QRCodeContent.ErrorCorrection = .low
	@State var foregroundColor: Color = .primary
	@State var backgroundColor: Color = .clear

	let gradient = Gradient(colors: [.black, .pink])

	var body: some View {
		ScrollView {
			VStack {
				VStack {
					HStack {
						Text("Content")
						TextField("Text", text: $content)
					}
					Picker(selection: $correction, label: Text("Error correction:")) {
						Text("Low (L)").tag(QRCodeContent.ErrorCorrection.low)
						Text("Medium (M)").tag(QRCodeContent.ErrorCorrection.medium)
						Text("High (Q)").tag(QRCodeContent.ErrorCorrection.high)
						Text("Max (H)").tag(QRCodeContent.ErrorCorrection.max)
					}.pickerStyle(WheelPickerStyle())

					ColorPicker("Foreground", selection: $foregroundColor)
					ColorPicker("Background", selection: $backgroundColor)
				}
				.frame(alignment: .top)
				.padding()

				ZStack {
					backgroundColor
					QRCode(
						data: content.data(using: .utf8)!,
						errorCorrection: correction
					)
					.fill(foregroundColor)
					.frame(width: 250, height: 250, alignment: .center)
				}
				.frame(alignment: .center)
				.padding()

				QRCode(
					message: QRCodeLink(string: "https://wwww.apple.com.au/")!,
					errorCorrection: .max
				)
				.fill(LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
				.shadow(color: .black, radius: 1, x: 1, y: 1)
				.frame(width: 250, height: 250, alignment: .center)
			}
		}
	}
}
