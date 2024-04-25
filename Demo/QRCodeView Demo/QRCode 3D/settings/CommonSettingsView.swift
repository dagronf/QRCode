//
//  CommonSettingsView.swift
//  QRCode 3D
//
//  Created by Darren Ford on 25/4/2024.
//

import SwiftUI
import QRCode

struct CommonSettingsView: View {
	@EnvironmentObject var document: QRCode_3DDocument
	
	@State var text: String = "This is a qr code"
	@State var quietSpace: Double = 0
	@State var cornerRadius: Double = 0
	@State var negate: Bool = false
	@State var correction: QRCode.ErrorCorrection = .quantize
	
	var body: some View {
		Form {
			TextField("text", text: $text)
			Picker("error correction", selection: $correction) {
				Text("Low").tag(QRCode.ErrorCorrection.low)
				Text("Medium").tag(QRCode.ErrorCorrection.medium)
				Text("Quantize").tag(QRCode.ErrorCorrection.quantize)
				Text("High").tag(QRCode.ErrorCorrection.high)
			}
			Slider(value: $quietSpace, in: 0 ... 10, step: 1) {
				Text("quiet space")
			}
			Slider(value: $cornerRadius, in: 0 ... 1) {
				Text("corner radius")
			}
			Toggle(isOn: $negate, label: {
				Text("negate")
			})
		}
		.onAppear {
			text = document.qrcode.utf8String ?? ""
			quietSpace = Double(document.qrcode.design.additionalQuietZonePixels)
			correction = document.qrcode.errorCorrection
			negate = document.qrcode.design.shape.negatedOnPixelsOnly
			cornerRadius = document.qrcode.design.style.backgroundFractionalCornerRadius
		}
		.onChange(of: text) { newValue in
			document.qrcode.utf8String = text
			document.objectWillChange.send()
		}
		.onChange(of: quietSpace) { newValue in
			document.qrcode.design.additionalQuietZonePixels = UInt(quietSpace)
			document.objectWillChange.send()
		}
		.onChange(of: negate) { newValue in
			document.qrcode.design.shape.negatedOnPixelsOnly = newValue
			document.objectWillChange.send()
		}
		.onChange(of: correction) { newValue in
			document.qrcode.errorCorrection = correction
			document.objectWillChange.send()
		}
		.onChange(of: cornerRadius) { newValue in
			document.qrcode.design.style.backgroundFractionalCornerRadius = newValue
			document.objectWillChange.send()
		}
	}
}

#Preview {
	CommonSettingsView().environmentObject(QRCode_3DDocument())
		.controlSize(.small)
		.padding()
		.frame(width: 400)
}
