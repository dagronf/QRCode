//
//  MultiselectPickerView.swift
//  QRCode 3D
//
//  Created by Darren Ford on 25/4/2024.
//

import SwiftUI

struct MultiSelectPickerView: View {
	// The list of items we want to show
	@State var allItems: [String]

	// Binding to the selected items we want to track
	@Binding var selectedItems: [String]

	var body: some View {
		HStack(spacing: 1) {
			ForEach(allItems, id: \.self) { item in
				let isSelected = self.selectedItems.contains(item)
				return Button(action: {
					withAnimation {
						if self.selectedItems.contains(item) {
							self.selectedItems.removeAll(where: { $0 == item })
						} else {
							self.selectedItems.append(item)
						}
					}
				}) {
					Text(item)
				}
				.buttonStyle(.borderedProminent) //isSelected ? .borderedProminent : .bordered)
				.tint(isSelected ? Color.accentColor : Color.secondary)
			}
		}
		.background {
			RoundedRectangle(cornerRadius: 4)
				.fill(Color.primary.opacity(0.1))
				.padding(-2)
		}
	}
}

#Preview {
	MultiSelectPickerView(
		allItems: ["􀰼", "􀄔", "􀄖", "􀄘"],
		selectedItems: .constant(["􀰼", "􀄖"])
	)
	.padding()
}
