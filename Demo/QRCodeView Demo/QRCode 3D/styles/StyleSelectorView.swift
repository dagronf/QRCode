//
//  StyleSelection.swift
//  QR Stylist
//
//  Created by Darren Ford on 29/9/2022.
//

import SwiftUI
import QRCode

private let _DefaultGradient = DSFGradient(pins: [
	DSFGradient.Pin(CGColor(gray: 0, alpha: 1), 0),
	DSFGradient.Pin(CGColor(gray: 1, alpha: 1), 1)
])!

struct StyleSelectorView: View {
	@Binding var fillStyle: QRCodeFillStyleGenerator?

	let supportsNoFill: Bool

	@State var fillStyleSelector: Int = 0

	@State var solid = Color.black
	@State var linear = StyleLinearGradient()
	@State var radial = StyleRadialGradient()
	@State var image = StyleImage()

	init(fillStyle: Binding<QRCodeFillStyleGenerator?>, supportsNoFill: Bool = false) {
		self._fillStyle = fillStyle
		self.supportsNoFill = supportsNoFill
	}

	var body: some View {
		HStack(spacing: 2) {
			Picker(selection: $fillStyleSelector) {
				if supportsNoFill {
					Text("None").tag(0)
				}
				Text("Solid").tag(1)
				Text("Linear").tag(2)
				Text("Radial").tag(3)
				Text("Image").tag(4)
			} label: {
				EmptyView()
			}

			Group {
				switch fillStyleSelector {
				case 0:
					EmptyView()
				case 1:
					StyleSelectorSolidView(solidColor: $solid)
				case 2:
					StyleSelectorLinearView(linearGradient: $linear)
				case 3:
					StyleSelectorRadialView(radialGradient: $radial)
				case 4:
					StyleSelectorImageView(image: $image)
				default:
					fatalError()
				}
			}
			.frame(width: 46, height: 24)
		}
		.onAppear {
			guard let fillStyle = fillStyle else {
				fillStyleSelector = 0
				return
			}
			if fillStyle is QRCode.FillStyle.Solid { fillStyleSelector = 1 }
			else if fillStyle is QRCode.FillStyle.LinearGradient { fillStyleSelector = 2 }
			else if fillStyle is QRCode.FillStyle.RadialGradient { fillStyleSelector = 3 }
			else if fillStyle is QRCode.FillStyle.Image { fillStyleSelector = 4 }
			else { fatalError() }
		}
		.frame(minHeight: 28)

		.onChange(of: solid) { newValue in
			fillStyle = QRCode.FillStyle.Solid(solid.cgColor ?? .black)
		}
		.onChange(of: linear) { newValue in
			fillStyle = newValue.style
		}
		.onChange(of: radial) { newValue in
			fillStyle = newValue.style
		}
		.onChange(of: image) { newValue in
			fillStyle = newValue.style
		}
	}
}
