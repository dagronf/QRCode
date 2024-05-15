//
//  GradientLinearEditor.swift
//  single drag test
//
//  Created by Darren Ford on 30/9/2022.
//

import SwiftUI



struct GradientLinearPositioningView: View {
	@Environment(\.colorScheme) var colorScheme

	let stopSize: CGFloat
	let gradientStops: [Gradient.Stop]

	@Binding var startPoint: UnitPoint
	@Binding var endPoint: UnitPoint

	var body: some View {

		let gradient = LinearGradient(stops: gradientStops, startPoint: startPoint, endPoint: endPoint)

		ZStack {
			RoundedRectangle(cornerRadius: 4)
				.fill(gradient)
				.overlay(
					RoundedRectangle(cornerRadius: 4.0)
						.stroke((colorScheme == .light ? Color.black : Color.white).opacity(0.7), lineWidth: 1)
				)
			GeometryReader { inset in
				Group {
					StopperRectangleView(fillColor: gradientStops.first!.color, moveType: .freeform)
						.frame(width: stopSize, height: stopSize)
						.position(CGPoint(x: startPoint.x * inset.size.width, y: startPoint.y * inset.size.height))
						.gesture(
							DragGesture()
								.onChanged { value in
									let x = min(1, max(0, value.location.x / inset.size.width))
									let y = min(1, max(0, value.location.y / inset.size.height))
									startPoint = UnitPoint(x: x, y: y)
								}
						)
						.zIndex(1)

					StopperRectangleView(fillColor: gradientStops.last!.color, moveType: .freeform)
						.frame(width: stopSize, height: stopSize)
						.position(CGPoint(x: endPoint.x * inset.size.width, y: endPoint.y * inset.size.height))
						.gesture(
							DragGesture()
								.onChanged { value in
									let x = min(1, max(0, value.location.x / inset.size.width))
									let y = min(1, max(0, value.location.y / inset.size.height))
									endPoint = UnitPoint(x: x, y: y)
								}
						)
						.zIndex(1)

					Path() { path in
						path.move(to: CGPoint(x: startPoint.x * inset.size.width, y: startPoint.y * inset.size.height))
						path.addLine(to: CGPoint(x: endPoint.x * inset.size.width, y: endPoint.y * inset.size.height))
					}
					.stroke(Color.gray, lineWidth: 6)
					.zIndex(0)
				}
			}
			.padding(14)
		}
	}
}

public struct GradientLinearEditorView: View {

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
			GradientLinearPositioningView(
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
