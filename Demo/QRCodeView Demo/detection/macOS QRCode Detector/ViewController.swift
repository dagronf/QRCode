//
//  ViewController.swift
//  macOS QRCode Detector
//
//  Created by Darren Ford on 2/7/2022.
//

import Cocoa
import QRCodeDetector

class ViewController: NSViewController {

	let detector = QRCodeDetector.VideoDetector()
	var previewLayer: CALayer?

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override var representedObject: Any? {
		didSet {
			// Update the view, if already loaded.
		}
	}

	override func viewDidAppear() {
		super.viewDidAppear()
		try! detector.startDetecting { [weak self] _, features in
			self?.updateForQRCodes(features)
		}

		self.view.wantsLayer = true

		let pl = try! detector.makePreviewLayer()

		let l = self.view.layer!
		l.addSublayer(pl)
		pl.frame = l.bounds
		previewLayer = pl
	}

	func updateForQRCodes(_ features: [CIQRCodeFeature]) {
		Swift.print("\(features.count) QR code(s) detected [")
		features.forEach { feature in
			Swift.print("- \(feature.messageString ?? ""), bounds=\(feature.bounds)")
		}
		Swift.print("]")
	}

	override func viewDidLayout() {
		CATransaction.setDisableActions(true)
		self.view.layer?.frame = self.view.bounds
		previewLayer?.frame = self.view.bounds
	}

	override func viewWillDisappear() {
		super.viewWillDisappear()
		detector.stopDetection()
	}
}

