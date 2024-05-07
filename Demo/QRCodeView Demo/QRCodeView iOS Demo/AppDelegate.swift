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

		let doc = QRCode.Document()
		doc.utf8String = "This is a test"
		doc.errorCorrection = .high

		// Generate a CGPath object containing the QR code
		let path = doc.path(CGSize(width: 400, height: 400))
		assert(!path.isEmpty)

		// Generate an image using the default styling (square, black foreground, white background) with 3x resolution
		let image = try! doc.uiImage(CGSize(width: 400, height: 400), dpi: 216)

		// Generate pdf data containing the qr code
		let pdfdata = try! doc.pdfData(CGSize(width: 400, height: 400))
	}
}
