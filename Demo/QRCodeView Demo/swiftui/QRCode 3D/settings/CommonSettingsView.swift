//
//  CommonSettingsView.swift
//  QRCode 3D
//
//  Created by Darren Ford on 25/4/2024.
//

import SwiftUI
import QRCode

class ObservedFillStyle: ObservableObject, Equatable {
	static func == (lhs: ObservedFillStyle, rhs: ObservedFillStyle) -> Bool {
		lhs.style === rhs.style
	}

	@Published var style: QRCodeFillStyleGenerator?
	init(style: QRCodeFillStyleGenerator) {
		self.style = style
	}
}

struct CommonSettingsView: View {
	@EnvironmentObject var document: QRCode_3DDocument
	
	@State var text: String = "This is a qr code"
	@State var quietSpace: Double = 0
	@State var cornerRadius: Double = 0
	@State var negate: Bool = false
	@State var correction: QRCode.ErrorCorrection = .quantize

	@State var generator: Int = 0

	var body: some View {
		Form {
			TextField("text", text: $text)
			Picker("correction", selection: $correction) {
				Text("low").tag(QRCode.ErrorCorrection.low)
				Text("medium").tag(QRCode.ErrorCorrection.medium)
				Text("quantize").tag(QRCode.ErrorCorrection.quantize)
				Text("high").tag(QRCode.ErrorCorrection.high)
			}
			Divider()
			Picker("generator", selection: $generator) {
				Text("core image").tag(0)
				Text("external").tag(1)
			}
			Divider()
			Slider(value: $quietSpace, in: 0 ... 10, step: 1) {
				Text("quiet space")
			}
			Slider(value: $cornerRadius, in: 0 ... 1) {
				Text("corner radius")
			}
			LabeledContent("style") {
				StyleSelectorView(
					current: document.qrcode.design.style.background, supportsNoFill: true) { newFill in
						document.qrcode.design.style.background = newFill
						document.objectWillChange.send()
				}
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
		.onChange(of: generator) { newValue in
			switch newValue {
			case 0: document.qrcode.engine = nil
			case 1: document.qrcode.engine = QRCodeEngineExternal()
			default: fatalError()
			}
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
