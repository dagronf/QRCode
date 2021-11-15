//
//  ContentView.swift
//  Shared
//
//  Created by Darren Ford on 8/11/21.
//

import SwiftUI
import QRCodeView

struct ContentView: View {

	@State var content: String = "This is a test of the QR code control"
	@State var correction: QRCodeContent.ErrorCorrection = .low
	@State var foregroundColor: Color = .primary
	@State var eyeColor: Color = .primary
	@State var backgroundColor: Color = .clear

	var body: some View {
		HSplitView {
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
				}.pickerStyle(RadioGroupPickerStyle())

				ColorPicker("Foreground", selection: $foregroundColor)
				ColorPicker("Eye Color", selection: $eyeColor)
				ColorPicker("Background", selection: $backgroundColor)

				Spacer()
			}
			.frame(alignment: .top)
			.padding()

			ZStack {
				backgroundColor
				QRCode.Eye(
					data: content.data(using: .utf8)!,
					errorCorrection: correction
				)
				.fill(eyeColor)
				QRCode.Content(
					data: content.data(using: .utf8)!,
					errorCorrection: correction
				)
				.fill(foregroundColor)
			}

			.frame(alignment: .center)
			.padding()

		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
