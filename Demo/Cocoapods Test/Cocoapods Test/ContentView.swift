//
//  ContentView.swift
//  Cocoapods Test
//
//  Created by Darren Ford on 3/3/2023.
//

import SwiftUI

import QRCode

struct ContentView: View {
	@State var content = "Hello, world!"

	let pixelShape = QRCode.PixelShape.RoundedPath(cornerRadiusFraction: 0.8, hasInnerCorners: true)

	var body: some View {
		VStack {
			TextField("Content", text: $content)
				.multilineTextAlignment(.center)
			Divider()
			QRCodeViewUI(
				content: content,
				additionalQuietZonePixels: 3,
				backgroundFractionalCornerRadius: 2,
				onPixelShape: pixelShape
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
