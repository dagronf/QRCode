//
//  ViewController.swift
//  iOS QRCode Detector
//
//  Created by Darren Ford on 2/7/2022.
//

import QRCode
import UIKit

class ViewController: UIViewController {
	let detector = QRCode.VideoDetector()
	var previewLayer: CALayer?

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		do {
			try self.detector.startDetecting { [weak self] _, features in
				self?.updateForQRCodes(features)
			}
		}
		catch {
			Swift.print("Could not start video capture (error: \(error))")
			Swift.print("Note that the simulator does not have a video capture device, so you need to run this on a 'real' device")
			fatalError()
		}

		let pl = try! self.detector.makePreviewLayer()

		self.view.layer.addSublayer(pl)
		pl.frame = self.view.layer.bounds
		self.previewLayer = pl
	}

	func updateForQRCodes(_ features: [CIQRCodeFeature]) {
		Swift.print("\(features.count) QR code(s) detected [")
		features.forEach { feature in
			Swift.print("- \(feature.messageString ?? ""), bounds=\(feature.bounds)")
		}
		Swift.print("]")
	}
}
