//
//  AppDelegate.swift
//  QRCodeView iOS Demo
//
//  Created by Darren Ford on 9/11/21.
//

import QRCode
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		self.generateQRCodeImage()
		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}
}

extension AppDelegate {
	func generateQRCodeImage() {
		let c = QRCode()
		c.update("This is a test".data(using: .utf8)!, errorCorrection: .max)
		let im = c.image(CGSize(width: 400, height: 400))
		let iii = UIImage(cgImage: im!)
		Swift.print(iii)
	}
}
