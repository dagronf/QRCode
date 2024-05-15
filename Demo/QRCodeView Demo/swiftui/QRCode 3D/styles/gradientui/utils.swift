//
//  SwiftUIView.swift
//  
//
//  Created by Darren Ford on 30/9/2022.
//

import SwiftUI

extension Color {
	var contrastingColor: Color {
		guard let c = self.cgColor?.converted(
			to: CGColorSpace(name: CGColorSpace.displayP3)!,
			intent: .perceptual,
			options: nil
		) else {
			return .black
		}
		let r = 0.299 * c.components![0]
		let g = 0.587 * c.components![1]
		let b = 0.114 * c.components![2]
		let avgGray: CGFloat = 1 - (r + g + b)
		return (avgGray >= 0.45) ? .white : .black
	}
}

	public func disconnectColorPickerFromPanel() {
#if os(macOS)
		NSColorPanel.shared.setTarget(nil)
		NSColorPanel.shared.setAction(nil)
		// This is a hack to make any previously selected colorwell to disconnect
		do {
			let cw = NSColorWell(frame: .zero)
			cw.activate(true)
			cw.deactivate()
		}
#endif
	}
