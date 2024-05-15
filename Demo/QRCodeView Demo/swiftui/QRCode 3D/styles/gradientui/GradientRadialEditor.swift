//
//  GradientRadialEditor.swift
//  single drag test
//
//  Created by Darren Ford on 30/9/2022.
//

import SwiftUI

struct GradientRadialPositioningView: View {
	@Environment(\.colorScheme) var colorScheme

	let stopSize: Double

	let gradientStops: [Gradient.Stop]

	@Binding var centerPoint: UnitPoint

	@Binding var startRadius: Double
	@Binding var endRadius: Double

	public var body: some View {
		let gradient = RadialGradient(
			stops: gradientStops,
			center: centerPoint,
			startRadius: startRadius,
			endRadius: endRadius
		)

		VStack {
			ZStack {
				RoundedRectangle(cornerRadius: 4)
					.fill(gradient)
					.overlay(
						RoundedRectangle(cornerRadius: 4.0)
							.stroke((colorScheme == .light ? Color.black : Color.white).opacity(0.7), lineWidth: 1)
					)
				GeometryReader { inset in
					Group {
						StopperRectangleView(fillColor: .white, moveType: .freeform)
							.frame(width: stopSize, height: stopSize)
							.position(CGPoint(x: centerPoint.x * inset.size.width, y: centerPoint.y * inset.size.height))
							.gesture(
								DragGesture()
									.onChanged { value in
										let x = min(1, max(0, value.location.x / inset.size.width))
										let y = min(1, max(0, value.location.y / inset.size.height))
										centerPoint = UnitPoint(x: x, y: y)
									}
							)
							.zIndex(1)
					}
				}
				.padding(stopSize / 2 + 2)
			}
			Form {
				Slider(value: $startRadius, in: 0 ... 512) {
					Text("Start Radius")
				}
				Slider(value: $endRadius, in: 0 ... 512) {
					Text("End Radius")
				}
				.onChange(of: startRadius) { newValue in
					if endRadius <= startRadius {
						endRadius = startRadius + 1
					}
				}
				.onChange(of: endRadius) { newValue in
					if startRadius >= endRadius {
						startRadius = endRadius - 1
					}
				}
			}
		}
	}
}

public struct GradientRadialEditorView: View {
	public init(
		centerPoint: Binding<UnitPoint>,
		startRadius: Binding<Double>,
		endRadius: Binding<Double>,
		stops: Binding<[GradientStop]>,
		stopSize: Double = 24
	) {
		self._centerPoint = centerPoint
		self._startRadius = startRadius
		self._endRadius = endRadius
		self._stops = stops
		self.stopSize = stopSize
	}

	let stopSize: Double

	@Binding var centerPoint: UnitPoint
	@Binding var startRadius: Double
	@Binding var endRadius: Double
	@Binding var stops: [GradientStop]
	@State var selectedStop: UUID?

	public var body: some View {
		let uistops: [Gradient.Stop] = stops.map { stop in
			Gradient.Stop(color: Color(stop.color), location: stop.unit)
		}.sorted { a, b in a.location < b.location }

		VStack(spacing: 4) {
			GradientRadialPositioningView(
				stopSize: self.stopSize,
				gradientStops: uistops,
				centerPoint: $centerPoint,
				startRadius: $startRadius,
				endRadius: $endRadius
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
