//
//  ViewController.swift
//  QRCodeView Documentation Images
//
//  Created by Darren Ford on 14/5/2022.
//

import Cocoa
import QRCode

class ViewController: NSViewController {



	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.

		self.buildEyeContent()

	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	func buildEyeContent() {

		let imageSize: Double = 120

		// unique name
		let tempFolderName = ProcessInfo.processInfo.globallyUniqueString

		// create the temporary folder url
		let tempURL = try! FileManager.default.url(
			for: .itemReplacementDirectory,
			in: .userDomainMask,
			appropriateFor: URL(fileURLWithPath: NSTemporaryDirectory()),
			create: true
		)
		.appendingPathComponent(tempFolderName)
		try! FileManager.default.createDirectory(at: tempURL, withIntermediateDirectories: true, attributes: nil)

		for name in QRCodeEyeShapeFactory.shared.availableGeneratorNames.sorted() {
			guard
				let gen = QRCodeEyeShapeFactory.shared.named(name),
				let eyeImage = QRCodeEyeShapeFactory.shared.image(
					eye: gen,
					dimension: imageSize * 2,
					foregroundColor: .black,
					backgroundColor: .white)
			else {
				fatalError()
			}
			let nsImage = NSImage(cgImage: eyeImage, size: CGSize(width: imageSize, height: imageSize))

			if let tiff = nsImage.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
				let pngData = tiffData.representation(using: .png, properties: [:])
				try! pngData?.write(to: tempURL.appendingPathComponent("eye_" + name).appendingPathExtension("png"))
			}
		}

		for name in QRCodePixelShapeFactory.shared.availableGeneratorNames.sorted() {
			guard
				let gen = QRCodePixelShapeFactory.shared.named(name, settings: ["inset": 1, "cornerRadiusFraction": 0.75]),
				let dataImage = QRCodePixelShapeFactory.shared.image(
					pixelShape: gen,
					dimension: imageSize * 2,
					foregroundColor: .black,
					backgroundColor: .white)
			else {
				fatalError()
			}
			let nsImage = NSImage(cgImage: dataImage, size: CGSize(width: imageSize, height: imageSize))

			if let tiff = nsImage.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
				let pngData = tiffData.representation(using: .png, properties: [:])
				try! pngData?.write(to: tempURL.appendingPathComponent("data_" + name).appendingPathExtension("png"))
			}
		}

		do {
			let doc1 = QRCode.Document(utf8String: "Hi there noodle")
			doc1.design.backgroundColor(NSColor.white.cgColor)
			doc1.design.shape.eye = QRCode.EyeShape.RoundedOuter()
			doc1.design.shape.onPixels = QRCode.PixelShape.Circle()
			doc1.design.style.onPixels = QRCode.FillStyle.Solid(NSColor.systemGreen.cgColor)
			doc1.design.shape.offPixels = QRCode.PixelShape.Horizontal(inset: 4, cornerRadiusFraction: 1) //inset: 4)
			doc1.design.style.offPixels = QRCode.FillStyle.Solid(NSColor.systemGreen.withAlphaComponent(0.4).cgColor)

			let cg1 = doc1.cgImage(CGSize(width: 300, height: 300))!
			let im1 = NSImage(cgImage: cg1, size: CGSize(width: 150, height: 150))
			if let tiff = im1.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
				let pngData = tiffData.representation(using: .png, properties: [:])
				try! pngData?.write(to: tempURL.appendingPathComponent("offPixels.png"))
			}
		}

		do {
			let doc2 = QRCode.Document(utf8String: "Github example for colors")
			doc2.design.backgroundColor(NSColor.white.cgColor)
			doc2.design.shape.eye = QRCode.EyeShape.Leaf()
			doc2.design.style.eye = QRCode.FillStyle.Solid(NSColor.systemGreen.cgColor)
			doc2.design.style.pupil = QRCode.FillStyle.Solid(NSColor.systemBlue.cgColor)
			
			doc2.design.shape.onPixels = QRCode.PixelShape.RoundedPath()
			doc2.design.style.onPixels = QRCode.FillStyle.Solid(NSColor.systemBrown.cgColor)
			
			let cg2 = doc2.cgImage(CGSize(width: 300, height: 300))!
			let im2 = NSImage(cgImage: cg2, size: CGSize(width: 150, height: 150))
			if let tiff = im2.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
				let pngData = tiffData.representation(using: .png, properties: [:])
				try! pngData?.write(to: tempURL.appendingPathComponent("eye_colorstyles.png"))
			}
		}

		do {
			// Set the background color to a solid white
			let doc3 = QRCode.Document(utf8String: "Github example for colors")
			doc3.design.style.background = QRCode.FillStyle.Solid(CGColor.white)

			// Set the fill color for the data to radial gradient
			let radial = QRCode.FillStyle.RadialGradient(
				DSFGradient(pins: [
					DSFGradient.Pin(CGColor(red: 0.8, green: 0, blue: 0, alpha: 1), 0),
					DSFGradient.Pin(CGColor(red: 0.1, green: 0, blue: 0, alpha: 1), 1)
				])!,
				centerPoint: CGPoint(x: 0.5, y: 0.5)
			)
			doc3.design.style.onPixels = radial

			let cg3 = doc3.cgImage(CGSize(width: 300, height: 300))!
			let im3 = NSImage(cgImage: cg3, size: CGSize(width: 150, height: 150))
			if let tiff = im3.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
				let pngData = tiffData.representation(using: .png, properties: [:])
				try! pngData?.write(to: tempURL.appendingPathComponent("fillstyles.png"))
			}
		}

		NSWorkspace.shared.open(tempURL)

	}


}

