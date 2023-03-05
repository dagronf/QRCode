//
//  ContentView.swift
//  Cocoapods Test
//
//  Created by Darren Ford on 3/3/2023.
//

import SwiftUI

import QRCode

struct ContentView: View {
	var body: some View {
		VStack {
			Image(systemName: "globe")
				.imageScale(.large)
				.foregroundColor(.accentColor)
			Text("Hello, world!")
			QRCodeViewUI(content: "Hello, world!")
				.frame(width: 300, height: 300)
		}
		.padding()
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
