//
//  AppDelegate.swift
//  QRCodeView Demo
//
//  Created by Darren Ford on 9/11/21.
//

import Cocoa

import QRCode

@main
class AppDelegate: NSObject, NSApplicationDelegate {
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application

		generateQRCodeImage()
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

	func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
		return true
	}
}

extension AppDelegate {
	func generateQRCodeImage() {
		let gr = DSFGradient(pins: [
			DSFGradient.Pin(CGColor(red: 1, green: 0, blue: 0, alpha: 1), 0),
			DSFGradient.Pin(CGColor(red: 0, green: 1, blue: 0, alpha: 1), 0.5),
			DSFGradient.Pin(CGColor(red: 0, green: 0, blue: 1, alpha: 1), 1),
		])!

		let design = QRCode.Design()

		let style = QRCode.Style()
		style.onPixels = QRCode.FillStyle.LinearGradient(gr, startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 1, y: 0.5))
		design.style = style

		let contentShape = QRCode.Shape()
		contentShape.onPixels = QRCode.PixelShape.RoundedRect(insetFraction: 0.1, cornerRadiusFraction: 0.8)
		contentShape.eye = QRCode.EyeShape.RoundedRect()
		design.shape = contentShape

		let c = QRCode()
		c.update(message: QRCode.Message.Link(string: "https://www.apple.com.au")!, errorCorrection: .high)
		let iii = c.nsImage(CGSize(width: 400, height: 400), scale: 3, design: design)!
		Swift.print(iii)
	}
}
