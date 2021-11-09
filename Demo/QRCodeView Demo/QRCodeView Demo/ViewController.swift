//
//  ViewController.swift
//  QRCodeView Demo
//
//  Created by Darren Ford on 9/11/21.
//

import Cocoa
import QRCodeView

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
		q1.content = msg
		q2.content = msg
		q3.content = msg
	}
}
