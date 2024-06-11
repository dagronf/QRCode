//
//  StyleSelectorRadialView.swift
//  QR Stylist
//
//  Created by Darren Ford on 1/10/2022.
//

import SwiftUI
import QRCode

struct StyleRadialGradient: Equatable {
	var centerPoint: UnitPoint = .init(x: 0.5, y: 0.5)
	var startRadius: Double = 0
	var endRadius: Double = 1
	var gradientStops: [GradientStop]

	init() {
		self.gradientStops = [
			GradientStop(isMovable: false, unit: 0, color: CGColor(gray: 0, alpha: 1)),
			GradientStop(isMovable: false, unit: 1, color: CGColor(gray: 1, alpha: 1)),
		]
	}

	init(_ fillStyle: QRCode.FillStyle.RadialGradient) {
		self.centerPoint = fillStyle.centerPoint.unitPoint
		self.gradientStops = fillStyle.gradient
			.pins
			.sorted(by: { a, b in a.position < b.position })
			.map {
				GradientStop(isMovable: $0.position == 0 || $0.position == 1, unit: $0.position, color: $0.color)
			}
	}

	var style: QRCode.FillStyle.RadialGradient {
		.init(
			try! DSFGradient(
				pins: gradientStops.map { DSFGradient.Pin($0.color, $0.unit) }
			),
			centerPoint: self.centerPoint.cgPoint
		)
	}

	func radialGradient(startPos: Double, endPos: Double) -> RadialGradient {
		RadialGradient(
			stops: gradientStops
				.sorted(by: { a, b in a.unit < b.unit })
				.map { Gradient.Stop(color: Color($0.color), location: $0.unit) },
			center: centerPoint,
			startRadius: startPos,
			endRadius: endPos
		)
	}
}

struct StyleSelectorRadialView: View {
	@Binding var gradient: StyleRadialGradient
	@State private var showingRadialGradient = false

	init(radialGradient: Binding<StyleRadialGradient>) {
		self._gradient = radialGradient
	}

	var body: some View {
		GeometryReader { geo in
			let fixedEnd = max(geo.size.width, geo.size.height)
			Button {
				showingRadialGradient = true
				disconnectColorPickerFromPanel()
			} label: {
				self.gradient.radialGradient(startPos: 0, endPos: fixedEnd)
				.cornerRadius(4)
			}
			.popover(isPresented: $showingRadialGradient, arrowEdge: .bottom) {
				GradientRadialEditorView(
					centerPoint: $gradient.centerPoint,
					startRadius: $gradient.startRadius,
					endRadius: $gradient.endRadius,
					stops: $gradient.gradientStops,
					stopSize: 24
				)
				.frame(width: 300, height: 350)
				.padding(8)
			}
			.onChange(of: showingRadialGradient, perform: { newValue in
				if newValue == false {
					disconnectColorPickerFromPanel()
				}
			})
		}
	}
}
