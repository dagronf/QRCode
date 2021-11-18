//
//  ViewController.swift
//  QRCodeView Demo
//
//  Created by Darren Ford on 9/11/21.
//

import Cocoa
import QRCode

class ViewController: NSViewController {
	@IBOutlet weak var q1: QRCodeView!
	@IBOutlet weak var q2: QRCodeView!
	@IBOutlet weak var q3: QRCodeView!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

extension ViewController: NSControlTextEditingDelegate {
	func controlTextDidChange(_ obj: Notification) {
		guard let msg = (obj.object as? NSTextField)?.stringValue else { return }
		_ = q1.setString(msg)
		_ = q2.setString(msg)
		_ = q3.setString(msg)
	}
}
