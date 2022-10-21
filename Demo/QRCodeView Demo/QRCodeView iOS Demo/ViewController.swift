//
//  ViewController.swift
//  QRCodeView iOS Demo
//
//  Created by Darren Ford on 9/11/21.
//

import QRCode
import UIKit

class ViewController: UIViewController {
	@IBOutlet var qrCodeView: QRCodeView!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Put a custom eye design
	let eyeShape = QRCode.EyeShape.Squircle()
		self.qrCodeView.design.shape.eye = eyeShape

		let pixelShape = QRCode.PixelShape.Horizontal(insetFraction: 0.1, cornerRadiusFraction: 1)
		self.qrCodeView.design.shape.onPixels = pixelShape
	}
}
