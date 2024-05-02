//
//  StyleSelectorLinear.swift
//  QR Stylist
//
//  Created by Darren Ford on 1/10/2022.
//

import SwiftUI
import QRCode

struct StyleLinearGradient: Equatable {
	var startPoint: UnitPoint = .init(x: 0, y: 0)
	var endPoint: UnitPoint = .init(x: 1, y: 1)
	var gradientStops: [GradientStop]

	init() {
		self.startPoint = .init(x: 0, y: 0)
		self.endPoint = .init(x: 1, y: 1)
		self.gradientStops = [
			GradientStop(isMovable: false, unit: 0, color: CGColor(gray: 0, alpha: 1)),
			GradientStop(isMovable: false, unit: 1, color: CGColor(gray: 1, alpha: 1)),
		]
	}

	init(_ fillStyle: QRCode.FillStyle.LinearGradient) {
		self.startPoint = fillStyle.startPoint.unitPoint
		self.endPoint = fillStyle.endPoint.unitPoint
		self.gradientStops = fillStyle.gradient
			.pins
			.sorted(by: { a, b in a.position < b.position })
			.map {
				GradientStop(isMovable: $0.position == 0 || $0.position == 1, unit: $0.position, color: $0.color)
			}
	}

	var style: QRCode.FillStyle.LinearGradient {
		QRCode.FillStyle.LinearGradient(
			DSFGradient(
				pins: gradientStops.map { DSFGradient.Pin($0.color, $0.unit) }
			)!,
			startPoint: self.startPoint.cgPoint,
			endPoint: self.endPoint.cgPoint
		)
	}

	func linearGradient() -> LinearGradient {
		LinearGradient(
			stops: gradientStops
				.sorted(by: { a, b in a.unit < b.unit })
				.map { Gradient.Stop(color: Color($0.color), location: $0.unit) },
			startPoint: startPoint,
			endPoint: endPoint
		)
	}
}

struct StyleSelectorLinearView: View {
	@State private var showingLinearGradient = false
	@Binding var linearGradient: StyleLinearGradient

	init(linearGradient: Binding<StyleLinearGradient>) {
		self._linearGradient = linearGradient
	}
	
	var body: some View {
		Button {
			showingLinearGradient = true
			disconnectColorPickerFromPanel()
		} label: {
			linearGradient.linearGradient()
			.cornerRadius(4)
		}
		.popover(isPresented: $showingLinearGradient, arrowEdge: .bottom) {
			GradientLinearEditorView(
				startPoint: $linearGradient.startPoint,
				endPoint: $linearGradient.endPoint,
				stops: $linearGradient.gradientStops
			)
			.frame(width: 300, height: 350)
			.padding(8)
		}
		.onChange(of: showingLinearGradient) { newValue in
			if newValue == false {
				disconnectColorPickerFromPanel()
			}
		}
	}
}
