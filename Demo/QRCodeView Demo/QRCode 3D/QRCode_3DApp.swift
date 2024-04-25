//
//  QRCode_3DApp.swift
//  QRCode 3D
//
//  Created by Darren Ford on 25/4/2024.
//

import SwiftUI
import QRCode

@main
struct QRCode_3DApp: App {
	var body: some Scene {
		DocumentGroup(newDocument: { QRCode_3DDocument() }) { configuration in
			ContentView()
		}
	}
}
