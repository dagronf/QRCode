//
//  WatchQRApp.swift
//  WatchQR WatchKit Extension
//
//  Created by Darren Ford on 12/8/2022.
//

import SwiftUI

@main
struct WatchQRApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
