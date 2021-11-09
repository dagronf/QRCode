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
	@State var correction: QRCodeView.ErrorCorrection = .low
	@State var foregroundColor: CGColor = Color.primary.cgColor ?? CGColor(gray: 0, alpha: 1)
	@State var backgroundColor: CGColor = CGColor(gray: 0, alpha: 0)

	var body: some View {
		HSplitView {
			VStack {
				HStack {
					Text("Content")
					TextField("Text", text: $content)
				}
				Picker(selection: $correction, label: Text("Error correction:")) {
					Text("Low (L)").tag(QRCodeView.ErrorCorrection.low)
					Text("Medium (M)").tag(QRCodeView.ErrorCorrection.medium)
					Text("High (Q)").tag(QRCodeView.ErrorCorrection.high)
					Text("Max (H)").tag(QRCodeView.ErrorCorrection.max)
				}.pickerStyle(RadioGroupPickerStyle())

				ColorPicker("Foreground", selection: $foregroundColor)
				ColorPicker("Background", selection: $backgroundColor)

				Spacer()
			}
			.frame(alignment: .top)
			.padding()
			QRCodeViewUI(
				text: content,
				errorCorrection: correction,
				foregroundColor: Color(cgColor: foregroundColor),
				backgroundColor: Color(cgColor: backgroundColor)
			)
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
