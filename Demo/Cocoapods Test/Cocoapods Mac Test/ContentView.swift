//
//  ContentView.swift
//  Cocoapods Mac Test
//
//  Created by Darren Ford on 5/3/2023.
//

import SwiftUI
import QRCode

struct ContentView: View {
	@State var content = "Hello, world!"

	let style1 = QRCode.PixelShape.RoundedPath(cornerRadiusFraction: 0.8, hasInnerCorners: true)

	var body: some View {
		VStack {
			Image(systemName: "globe")
				.imageScale(.large)
				.foregroundColor(.accentColor)
			TextField("", text: $content)
				.multilineTextAlignment(.center)
			QRCodeViewUI(
				content: content,
				pixelStyle: style1,
				additionalQuietZonePixels: 3,
				backgroundFractionalCornerRadius: 2
			)
			.frame(minWidth: 300, minHeight: 300)
		}
		.padding()
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
