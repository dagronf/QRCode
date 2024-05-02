//
//  StyleSelectorSolid.swift
//  QR Stylist
//
//  Created by Darren Ford on 1/10/2022.
//

import SwiftUI

struct StyleSelectorSolidView: View {

	@Binding var solidColor: Color

	init(solidColor: Binding<Color>) {
		self._solidColor = solidColor
	}

	var body: some View {
		ColorPicker(selection: $solidColor) {
			EmptyView()
		}
	}
}

//struct StyleSelectorSolid_Previews: PreviewProvider {
//	static var previews: some View {
//		StyleSelectorSolid()
//	}
//}
