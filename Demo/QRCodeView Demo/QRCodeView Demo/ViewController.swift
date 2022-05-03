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
	@IBOutlet weak var q4: QRCodeView!

	override func viewDidLoad() {
		super.viewDidLoad()

		//q1.design.shape.data = QRCode.DataShape.RoundedPath()
		q2.design.shape.data = QRCode.DataShape.Horizontal(inset: 1, cornerRadiusFraction: 0.75)
		q2.design.shape.eye  = QRCode.EyeShape.Leaf()
		q3.design.shape.data = QRCode.DataShape.RoundedPath()
		q3.design.shape.eye  = QRCode.EyeShape.RoundedPointingIn()


		let gr = QRCode.FillStyle.RadialGradient(
			DSFGradient(pins: [
				DSFGradient.Pin(CGColor(red: 0.8, green: 0, blue: 0, alpha: 1), 0),
				DSFGradient.Pin(CGColor(red: 0.1, green: 0, blue: 0, alpha: 1), 1)
			])!,
			centerPoint: CGPoint(x: 0.5, y: 0.5))

		q4.design.style.background = gr
		q4.design.shape.data = QRCode.DataShape.Squircle()
		q4.design.shape.eye  = QRCode.EyeShape.Squircle()

		// Do any additional setup after loading the view.

		let lf = QRCode.EyeShape.Leaf()
		let im = QRCodeEyeShapeFactory.shared.image(eye: lf, dimension: 200, foregroundColor: NSColor.systemGreen.cgColor)!
		let imn = NSImage(cgImage: im, size: .zero)
		Swift.print(imn)

		///

		let lf3 = QRCode.DataShape.RoundedRect(inset: 4, cornerRadiusFraction: 0.5)
		let im3 = QRCodeDataShapeFactory.shared.image(dataShape: lf3, isOn: false, dimension: 200, foregroundColor: NSColor.systemGray.withAlphaComponent(0.1).cgColor)!
		let imn3 = NSImage(cgImage: im3, size: .zero)

		let lf2 = QRCode.DataShape.RoundedPath()
		let im2 = QRCodeDataShapeFactory.shared.image(dataShape: lf2, dimension: 200, foregroundColor: NSColor.systemRed.cgColor)!
		let imn2 = NSImage(cgImage: im2, size: .zero)
		imn2.isTemplate = true
		Swift.print(imn2)

		//let result = NSImage(size: CGSize(width: 90, height: 90))
		imn3.lockFocus()
		//imn3.draw(at: .zero, from: .zero, operation: .sourceOver, fraction: 1.0)
		imn2.draw(at: .zero, from: .zero, operation: .sourceOver, fraction: 1.0)
		imn3.unlockFocus()
		Swift.print(imn3)
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
		_ = q4.setString(msg)
	}
}
