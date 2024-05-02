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

	let supportsNoFill: Bool
	let current: QRCodeFillStyleGenerator?

	@State var fillStyleSelector: Int = 0

	@State var solid = Color.black
	@State var linear = StyleLinearGradient()
	@State var radial = StyleRadialGradient()
	@State var image = StyleImage()

	let styleDidChange: (QRCodeFillStyleGenerator) -> Void

	init(current: QRCodeFillStyleGenerator?, supportsNoFill: Bool = false, _ styleDidChange: @escaping (QRCodeFillStyleGenerator) -> Void) {
		self.current = current
		self.supportsNoFill = supportsNoFill
		self.styleDidChange = styleDidChange
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
			guard let current = current else {
				fillStyleSelector = 0
				return
			}
			if current is QRCode.FillStyle.Solid { fillStyleSelector = 1 }
			else if current is QRCode.FillStyle.LinearGradient { fillStyleSelector = 2 }
			else if current is QRCode.FillStyle.RadialGradient { fillStyleSelector = 3 }
			else if current is QRCode.FillStyle.Image { fillStyleSelector = 4 }
			else { fatalError() }
		}
		.frame(minHeight: 28)

		.onChange(of: solid) { newValue in
			styleDidChange(QRCode.FillStyle.Solid(solid.cgColor ?? CGColor(gray: 0, alpha: 1)))
		}
		.onChange(of: linear) { newValue in
			styleDidChange(newValue.style)
		}
		.onChange(of: radial) { newValue in
			styleDidChange(newValue.style)
		}
		.onChange(of: image) { newValue in
			styleDidChange(newValue.style)
		}
	}
}
