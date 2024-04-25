//
//  CornerPicker.swift
//  QRCode 3D
//
//  Created by Darren Ford on 26/4/2024.
//

import SwiftUI
import QRCode

struct CornerPicker: View {
	@Binding var corners: QRCode.Corners

	init(corners: Binding<QRCode.Corners>) {
		self._corners = corners
	}

	var body: some View {
		HStack(spacing: 1) {
			if corners.contains(.tl) {
				Button("􀰹") { corners.remove(.tl) }
				.buttonStyle(.borderedProminent)
			}
			else {
				Button("􀰹") { corners.insert(.tl) }
				.buttonStyle(.bordered)
			}

			if corners.contains(.tr) {
				Button("􀄯") { corners.remove(.tr) }
				.buttonStyle(.borderedProminent)
			}
			else {
				Button("􀄯") { corners.insert(.tr) }
				.buttonStyle(.bordered)
			}

			if corners.contains(.bl) {
				Button("􀄰") { corners.remove(.bl) }
				.buttonStyle(.borderedProminent)
			}
			else {
				Button("􀄰") { corners.insert(.bl) }
				.buttonStyle(.bordered)
			}

			if corners.contains(.br) {
				Button("􀄱") { corners.remove(.br) }
				.buttonStyle(.borderedProminent)
			}
			else {
				Button("􀄱") { corners.insert(.br) }
				.buttonStyle(.bordered)
			}

			EmptyView()
		}
	}
}

#Preview {
	CornerPicker(corners: .constant([.tl, .bl]))
		.padding()
}
