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

		let gr = QRGradient(pins: [
			QRGradient.Pin(CGColor.init(red: 1, green: 0, blue: 0, alpha: 1), 0),
			QRGradient.Pin(CGColor.init(red: 0, green: 1, blue: 0, alpha: 1), 0.5),
			QRGradient.Pin(CGColor.init(red: 0, green: 0, blue: 1, alpha: 1), 1),
		])!
		gr.start = CGPoint(x: 0, y: 0.5)
		gr.end = CGPoint(x: 1, y: 0.5)
		let style = QRCodeContent.Style()
		style.foregroundStyle = QRCodeFillStyleLinearGradient(gr)

		style.pixelStyle = QRCodePixelStyleRoundedSquare(cornerRadius: 0.8, edgeInsets: 1)


		let c = QRCodeContent()
		c.generate(message: QRCodeLink(string: "https://www.apple.com.au")!, errorCorrection: .max)
		let im = c.image(CGSize(width: 400, height: 400), style: style)
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

