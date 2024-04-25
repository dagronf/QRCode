//
//  SettingsView.swift
//  QRCode 3D
//
//  Created by Darren Ford on 25/4/2024.
//

import SwiftUI

struct SettingsView: View {
	var body: some View {
		VStack {
			GroupBox("Common Settings") {
				CommonSettingsView()
			}
			ScrollView(.vertical) {
				DesignSettingsView()
			}
		}
		.padding(8)
		.controlSize(.small)
	}
}

struct DesignSettingsView: View {
	var body: some View {
		VStack {
			GroupBox("On Pixels") {
				PixelSettingsView()
			}
			GroupBox("Eye") {
				EyeSettingsView()
			}
			GroupBox("Pupil") {
				PupilSettingsView()
			}
		}
	}
}

#Preview("flat settings") {
	DesignSettingsView().environmentObject(QRCode_3DDocument())
		.frame(maxWidth: 300)
}

#Preview {
	SettingsView().environmentObject(QRCode_3DDocument())
		.frame(maxWidth: 300)
}
