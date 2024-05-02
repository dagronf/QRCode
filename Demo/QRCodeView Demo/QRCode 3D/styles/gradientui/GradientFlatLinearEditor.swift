//
//  GradientLinearEditor.swift
//  single drag test
//
//  Created by Darren Ford on 30/9/2022.
//

import SwiftUI



struct GradientFlatLinearPositioningView: View {
	@Environment(\.colorScheme) var colorScheme

	let stopSize: CGFloat
	let gradientStops: [Gradient.Stop]

	@Binding var startPoint: UnitPoint
	@Binding var endPoint: UnitPoint

	var body: some View {

		let gradient = LinearGradient(
			stops: gradientStops,
			startPoint: UnitPoint(x: 0, y: 0),
			endPoint: UnitPoint(x: 1, y: 0)
		)

		ZStack {
			RoundedRectangle(cornerRadius: 4)
				.fill(gradient)
				.overlay(
					RoundedRectangle(cornerRadius: 4.0)
						.stroke((colorScheme == .light ? Color.black : Color.white).opacity(0.7), lineWidth: 1)
				)
		}
		.padding(14)
	}
}

public struct GradientFlatLinearEditorView: View {

	@State private var isEnded = false

	let stopSize: CGFloat

	public init(
		startPoint: Binding<UnitPoint>,
		endPoint: Binding<UnitPoint>,
		stops: Binding<[GradientStop]>,
		stopSize: CGFloat = 24
	) {
		self._startPoint = startPoint
		self._endPoint = endPoint
		self._stops = stops
		self.stopSize = stopSize
	}

	@Binding var startPoint: UnitPoint
	@Binding var endPoint: UnitPoint
	@Binding var stops: [GradientStop]

	@State var selectedStop: UUID?

	public var body: some View {

		let uistops: [Gradient.Stop] = stops.map { stop in
			Gradient.Stop(color: Color(stop.color), location: stop.unit)
		}.sorted { a, b in a.location < b.location }

		VStack(spacing: 4) {
			GradientFlatLinearPositioningView(
				stopSize: stopSize,
				gradientStops: uistops,
				startPoint: $startPoint,
				endPoint: $endPoint
			)
			GradientEditorGradientTrackView(
				stopSize: self.stopSize,
				positions: $stops,
				selectedStop: $selectedStop,
				addStopBlock: {
					let stop = GradientStop(isMovable: true, unit: 0.5, color: CGColor(red: 1.0, green: 0, blue: 0, alpha: 1.0))
					stops.append(stop)
					selectedStop = stop.id
				}
			)
		}
	}
}
