//
//  ContentView.swift
//  QRCode 3D
//
//  Created by Darren Ford on 25/4/2024.
//

import SwiftUI
import QRCode

struct ContentView: View {
	@EnvironmentObject var document: QRCode_3DDocument
	var body: some View {
		#if os(macOS)
		HSplitView {
			ZStack(alignment: .topTrailing) {
				QRCodePreviewView()
				Button {
				} label: {
					Text("Reset")
				}
				.padding(8)
			}
			SettingsView()
				.frame(maxWidth: 310)
		}
		#else
		NavigationSplitView {
			SettingsView()
				.frame(width: 320)
		} detail: {
			QRCodePreviewView()
		}
		#endif
	}
}

#Preview {
	ContentView().environmentObject(QRCode_3DDocument())
}
