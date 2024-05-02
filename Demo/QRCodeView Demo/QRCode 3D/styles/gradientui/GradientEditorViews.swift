//
//  GradientEditorViews.swift
//  single drag test
//
//  Created by Darren Ford on 30/9/2022.
//

import SwiftUI

private let colorTarget = NSColorPanelWrapper()

public enum StopperMoveType {
	case none
	case horizontal
	case freeform
}

struct StopperRectangleView: View {
	@Environment(\.colorScheme) var colorScheme
	let fillColor: Color
	let moveType: StopperMoveType
	var body: some View {
		GeometryReader { geo in
			ZStack {
				RoundedRectangle(cornerRadius: 6)
					.fill(fillColor)
					.shadow(color: .black, radius: 2, x: 1, y: 1)
				RoundedRectangle(cornerRadius: 4)
					.stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 1)
				RoundedRectangle(cornerRadius: 4)
					.stroke(colorScheme == .light ? Color.white : Color.black, lineWidth: 1)
					.padding(1)
				if moveType == .horizontal {
					Image(systemName: "arrowtriangle.left.and.line.vertical.and.arrowtriangle.right")
						.resizable()
						.font(.system(size: 10, weight: .heavy))
						.foregroundColor(fillColor.contrastingColor)
						.padding(geo.size.width / 5)
						.onHover { inside in
#if os(macOS)
							inside ? NSCursor.openHand.push() : NSCursor.pop()
#endif
						}
				}
				else if moveType == .freeform {
					Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
						.resizable()
					//.font(.system(size: 10, weight: .medium))
						.foregroundColor(fillColor.contrastingColor)
						.padding(geo.size.width / 5)
						.onHover { inside in
#if os(macOS)
							inside ? NSCursor.openHand.push() : NSCursor.pop()
#endif
						}
				}
			}
		}
	}
}

struct GradientEditorSingleSliderView: View {

	@Environment(\.colorScheme) var colorScheme

	@Binding var position: GradientStop

	@Binding var selectedStop: UUID?
	@Binding var colorPickerSelectedColor: Color

	let shouldDeleteStop: (UUID) -> Void

#if !os(macOS)
	@State var showColorPicker: Bool = false
#endif

	let stopSize: CGFloat
	let isSelected: Bool

	internal init(
		position: Binding<GradientStop>,
		selectedStop: Binding<UUID?>,
		colorPickerSelectedColor: Binding<Color>,
		shouldDeleteStop: @escaping (UUID) -> Void,
		stopSize: CGFloat
	) {
		self._position = position
		self._selectedStop = selectedStop
		self._colorPickerSelectedColor = colorPickerSelectedColor
		self.stopSize = stopSize
		self.shouldDeleteStop = shouldDeleteStop

		self.isSelected = (selectedStop.wrappedValue == position.wrappedValue.id)
		if self.isSelected {
#if os(macOS)
			colorTarget.target(currentColor: position.wrappedValue.color) { newColor in
				DispatchQueue.main.async {
					position.wrappedValue.color = newColor.cgColor
				}
			}
#endif
		}
	}

	var body: some View {
		GeometryReader { geo in

			let sliderY = geo.size.height / 2

			ZStack {
				StopperRectangleView(fillColor: Color(position.color), moveType: position.isMovable ? .horizontal : .none )
					.frame(width: stopSize, height: stopSize)
					.position(CGPoint(x: position.unit * geo.size.width, y: sliderY))
					.gesture(DragGesture().onChanged({ value in
						if position.isMovable {
							position.unit = min(1, max(0, value.location.x / geo.size.width))
						}
					}))
					.onTapGesture {
						selectedStop = position.id
						colorPickerSelectedColor = Color(position.color)
					}
#if !os(macOS)
					.onChange(of: colorPickerSelectedColor) { newValue in
						if self.selectedStop == position.id {
							position.color = newValue.cgColor ?? CGColor(gray: 0, alpha: 0)
						}
					}
#endif

				if isSelected {
					ZStack {
						RoundedRectangle(cornerRadius: 5)
							.stroke(Color.white, lineWidth: 6)
							.frame(width: stopSize, height: stopSize)
							.position(CGPoint(x: position.unit * geo.size.width, y: sliderY))
						RoundedRectangle(cornerRadius: 5)
							.stroke(Color.black, lineWidth: 1)
							.frame(width: stopSize + 5, height: stopSize + 5)
							.position(CGPoint(x: position.unit * geo.size.width, y: sliderY))
						RoundedRectangle(cornerRadius: 4)
							.stroke(Color.black, lineWidth: 1)
							.frame(width: stopSize - 5, height: stopSize - 5)
							.position(CGPoint(x: position.unit * geo.size.width, y: sliderY))
					}
					.accessibilityAddTraits(.isSelected)
				}
			}
			.contextMenu {
				Button {
					self.shouldDeleteStop(position.id)
				} label: {
					Text("Remove Stop")
				}
				.disabled(!position.isMovable)
				.help("Remove the currently selected gradient stop")
			}
		}
		//		.focusable(true) { isFocused in
		//			self.isFocussed = isFocused
		//			if isFocused {
		//				colorTarget.target(currentColor: position.color) { newColor in
		//					position.color = newColor.cgColor
		//				}
		//			}
		//		}
	}
}

class NSColorPanelWrapper: NSObject {

#if os(macOS)

	static let shared = NSColorPanelWrapper()

	override init() {
		super.init()
	}

	deinit {
		NSColorPanel.shared.setTarget(nil)
		NSColorPanel.shared.setAction(nil)
	}

	var target_: ((NSColor) -> Void)?
	func target(currentColor: CGColor, _ block: @escaping (NSColor) -> Void) {
		self.target_ = block
		NSColorPanel.shared.setTarget(self)
		NSColorPanel.shared.setAction(#selector(colorChanged(_:)))
		NSColorPanel.shared.color = NSColor(cgColor: currentColor)!
		NSColorPanel.shared.orderFront(self)
	}

	@objc func colorChanged(_ sender: NSColorPanel) {
		target_?(sender.color)
	}

#endif
}

struct GradientEditorStopsTrackView: View {

	let stopSize: CGFloat
	@Binding var positions: [GradientStop]
	@Binding var selectedStop: UUID?
	@Binding var colorPickerSelectedColor: Color

	var body: some View {
		ZStack {
			ForEach($positions) { position in
				GradientEditorSingleSliderView(
					position: position,
					selectedStop: $selectedStop,
					colorPickerSelectedColor: $colorPickerSelectedColor,
					shouldDeleteStop: deleteStop,
					stopSize: stopSize
				)
				.zIndex(position.wrappedValue.isMovable ? 1 : 0)
			}
		}
		.frame(height: stopSize)
		.padding([.leading, .trailing], stopSize / 2)
	}

	func deleteStop(_ identifier: UUID) {
		positions.removeAll { $0.id == identifier }
	}
}

struct GradientEditorGradientTrackView: View {
	@Environment(\.colorScheme) var colorScheme

	let stopSize: CGFloat
	@Binding var positions: [GradientStop]

	@Binding var selectedStop: UUID?
	@State var selectedColor: Color = .black

	let addStopBlock: () -> Void

	var body: some View {

		let stops: [Gradient.Stop] = positions.map { stop in
			Gradient.Stop(color: Color(stop.color), location: stop.unit)
		}.sorted { a, b in a.location < b.location }

		let gr = LinearGradient(stops: stops, startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 0))

		HStack {
			ZStack {
				RoundedRectangle(cornerRadius: 4)
					.fill(gr)
					.frame(height: stopSize / 2)
					.overlay(
						RoundedRectangle(cornerRadius: 4.0)
							.stroke((colorScheme == .light ? Color.black : Color.white).opacity(0.7), lineWidth: 1)
					)
					.padding(stopSize / 2.0)

				GradientEditorStopsTrackView(
					stopSize: self.stopSize,
					positions: $positions,
					selectedStop: $selectedStop,
					colorPickerSelectedColor: $selectedColor
				)
				.frame(maxWidth: .infinity)
			}

			Divider()
				.frame(width: 1)
				.frame(height: 30)

#if !os(macOS)
			ColorPicker(selection: $selectedColor) {
			}
			.disabled(selectedStop == nil)

			.frame(width: 32)

			Divider()
				.frame(width: 1)
				.frame(height: 30)
#endif

			Button {
				addStopBlock()
			} label: {
				Image(systemName: "plus.square.fill")
					.resizable()
			}
			.buttonStyle(.borderless)
			.frame(width: stopSize, height: stopSize)
			.help("Add a new gradient stop")

			Button {
				if let selected = self.selectedStop {
					positions.removeAll { s in s.id == selected  }
				}
			} label: {
				Image(systemName: "minus.square.fill")
					.resizable()
			}
			.disabled(selectedStop == nil || !self.isSelectedTrackRemovable())
			.buttonStyle(.borderless)
			.frame(width: stopSize, height: stopSize)
			.help("Remove the currently selected gradient stop")
		}
		//		.contextMenu {
		//			Button {
		//				addStopBlock()
		//			} label: {
		//				Text("Add Stop")
		//			}
		//			.help("Add a new gradient stop")
		//
		//			Button {
		//				if let selected = self.selectedStop {
		//					positions.removeAll { s in s.id == selected  }
		//				}
		//			} label: {
		//				Text("Remove Stop")
		//			}
		//			.disabled(selectedStop == nil || !self.isSelectedTrackRemovable())
		//			.help("Remove the currently selected gradient stop")
		//		}
	}

	func colorForSelection() -> Color {
		guard let selected = selectedStop else { return .clear }
		guard let position = positions.first(where: { $0.id == selected } ) else { return .clear }
		return Color(position.color)
	}

	func isSelectedTrackRemovable() -> Bool {
		guard let selected = selectedStop else { return false }
		if let s = positions.first(where: { s in s.id == selected }) {
			return s.isMovable
		}
		return false
	}
}
