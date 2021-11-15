//
//  AppDelegate.swift
//  QRCodeView Demo
//
//  Created by Darren Ford on 9/11/21.
//

import Cocoa

import QRCodeView

@main
class AppDelegate: NSObject, NSApplicationDelegate {

	


	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application

		//let im: NSImage? = QRCodeView.Image(content: "Message", size: CGSize(width: 100, height: 100))
		//Swift.print(im)

		let c = QRCodeContent()
		c.generate(message: QRCodeLink(string: "https://www.apple.com.au")!, errorCorrection: .max)
		let im = c.image(CGSize(width: 400, height: 400))
		Swift.print(im)
		let iii = NSImage(cgImage: im!, size: .zero)
		Swift.print(iii)
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

	func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
		return true
	}


}

