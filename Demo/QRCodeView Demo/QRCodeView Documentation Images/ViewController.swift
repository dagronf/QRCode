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

		self.buildQuietSpaceContent()
		self.buildEyeContent()

	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	func buildQuietSpaceContent() {



//		doc1.design.shape.eye = QRCode.EyeShape.RoundedOuter()
//		doc1.design.shape.onPixels = QRCode.PixelShape.Circle()
//		doc1.design.style.onPixels = QRCode.FillStyle.Solid(NSColor.systemGreen.cgColor)
//		doc1.design.shape.offPixels = QRCode.PixelShape.Horizontal(insetFraction: 0.4, cornerRadiusFraction: 1) //inset: 4)
//		doc1.design.style.offPixels = QRCode.FillStyle.Solid(NSColor.systemGreen.withAlphaComponent(0.4).cgColor)

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

		do {
			let doc = QRCode.Document(utf8String: "https://www.swift.org/about/")
			doc.design.style.background = QRCode.FillStyle.Solid(0.410, 1.000, 0.375)

			[0, 5, 10, 15].forEach { aqs in
				doc.design.additionalQuietZonePixels = UInt(aqs)
				let cg1 = doc.cgImage(CGSize(width: 300, height: 300))!
				let im1 = NSImage(cgImage: cg1, size: CGSize(width: 150, height: 150))
				if let tiff = im1.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
					let pngData = tiffData.representation(using: .png, properties: [:])
					try! pngData?.write(to: tempURL.appendingPathComponent("quiet-space-\(aqs).png"))
				}
			}

			do {
				let image = NSImage(named: "swift-logo")!
				doc.design.style.background = QRCode.FillStyle.Image(image.cgImage(forProposedRect: nil, context: nil, hints: nil))
				doc.design.additionalQuietZonePixels = 4
				let cg1 = doc.cgImage(CGSize(width: 300, height: 300))!
				let im1 = NSImage(cgImage: cg1, size: CGSize(width: 150, height: 150))
				if let tiff = im1.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
					let pngData = tiffData.representation(using: .png, properties: [:])
					try! pngData?.write(to: tempURL.appendingPathComponent("quiet-space-background-image.png"))
				}
			}
		}

		do {
			let doc = QRCode.Document(utf8String: "Corner radius checking", errorCorrection: .high)
			doc.design.style.background = QRCode.FillStyle.Solid(1, 0, 0)
			doc.design.foregroundStyle(QRCode.FillStyle.Solid(1, 1, 1))
			doc.design.additionalQuietZonePixels = 4
			 [0, 2, 4, 6].forEach { cr in
				doc.design.style.backgroundFractionalCornerRadius = cr
				let cg1 = doc.cgImage(CGSize(width: 300, height: 300))!
				let im1 = NSImage(cgImage: cg1, size: CGSize(width: 150, height: 150))
				if let tiff = im1.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
					let pngData = tiffData.representation(using: .png, properties: [:])
					try! pngData?.write(to: tempURL.appendingPathComponent("corner-radius-\(Int(cr)).png"))
				}
			}
		}

		do {
			let doc = QRCode.Document(utf8String: "Corner radius checking")
			doc.design.style.background = QRCode.FillStyle.Solid(0, 0, 0.7)
			doc.design.foregroundStyle(QRCode.FillStyle.Solid(1, 1, 1))
			doc.design.shape.eye = QRCode.EyeShape.RoundedOuter()
			doc.design.additionalQuietZonePixels = 2
			doc.design.style.backgroundFractionalCornerRadius = 3.0
			let qrcodeImage = doc.cgImage(CGSize(width: 300, height: 300))!
			let im1 = NSImage(cgImage: qrcodeImage, size: CGSize(width: 150, height: 150))
			if let tiff = im1.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
				let pngData = tiffData.representation(using: .png, properties: [:])
				try! pngData?.write(to: tempURL.appendingPathComponent("corner-radius-example.png"))
			}
		}

		do {
			// Eye sample images
			let eyeShapes = QRCodeEyeShapeFactory.shared.generateSampleImages(
				dimension: imageSize * 2,
				foregroundColor: .black,
				backgroundColor: CGColor(gray: 0.9, alpha: 1)
			)

			eyeShapes.forEach { sample in
				let nsImage = NSImage(cgImage: sample.image, size: CGSize(width: imageSize, height: imageSize))
				if let tiff = nsImage.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
					let pngData = tiffData.representation(using: .png, properties: [:])
					try! pngData?.write(to: tempURL.appendingPathComponent("eye_" + sample.name).appendingPathExtension("png"))
				}
			}
		}

		do {
			// Pixels sample images
			let commonPixelSettings: [String: Any] = [
				QRCode.SettingsKey.insetFraction: 0.1,
				QRCode.SettingsKey.cornerRadiusFraction: 0.75
			]
			let pixelShapes = QRCodePixelShapeFactory.shared.generateSampleImages(
				dimension: imageSize * 2,
				foregroundColor: .black,
				backgroundColor: CGColor(gray: 0.9, alpha: 1),
				commonSettings: commonPixelSettings
			)

			pixelShapes.forEach { sample in
				let nsImage = NSImage(cgImage: sample.image, size: CGSize(width: imageSize, height: imageSize))
				if let tiff = nsImage.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
					let pngData = tiffData.representation(using: .png, properties: [:])
					try! pngData?.write(to: tempURL.appendingPathComponent("data_" + sample.name).appendingPathExtension("png"))
				}
			}
		}

		do {
			// Pupil sample images
			let pupilShapes = QRCodePupilShapeFactory.shared.generateSampleImages(
				dimension: imageSize * 2,
				foregroundColor: .black,
				backgroundColor: CGColor(gray: 0.9, alpha: 1)
			)

			pupilShapes.forEach { sample in
				let nsImage = NSImage(cgImage: sample.image, size: CGSize(width: imageSize, height: imageSize))
				if let tiff = nsImage.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
					let pngData = tiffData.representation(using: .png, properties: [:])
					try! pngData?.write(to: tempURL.appendingPathComponent("pupil_" + sample.name).appendingPathExtension("png"))
				}
			}
		}

		do {
			let doc1 = QRCode.Document(utf8String: "Hi there noodle")
			doc1.design.backgroundColor(NSColor.white.cgColor)
			doc1.design.shape.eye = QRCode.EyeShape.RoundedOuter()
			doc1.design.shape.onPixels = QRCode.PixelShape.Circle()
			doc1.design.style.onPixels = QRCode.FillStyle.Solid(NSColor.systemGreen.cgColor)
			doc1.design.shape.offPixels = QRCode.PixelShape.Horizontal(insetFraction: 0.4, cornerRadiusFraction: 1) //inset: 4)
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

		do {
			let doc = QRCode.Document(utf8String: "Custom pupil")
			doc.design.style.background = QRCode.FillStyle.Solid(CGColor.white)
			doc.design.shape.eye = QRCode.EyeShape.Squircle()
			doc.design.style.eye = QRCode.FillStyle.Solid(0.149, 0.137, 0.208)
			doc.design.shape.pupil = QRCode.PupilShape.BarsHorizontal()
			doc.design.style.pupil = QRCode.FillStyle.Solid(0.314, 0.235, 0.322)
			doc.design.style.onPixels = QRCode.FillStyle.Solid(0.624, 0.424, 0.400)
			if let image = doc.nsImage(CGSize(width: 150, height: 150)),
				let tiff = image.tiffRepresentation,
				let tiffData = NSBitmapImageRep(data: tiff)
			{
				let pngData = tiffData.representation(using: .png, properties: [:])
				try! pngData?.write(to: tempURL.appendingPathComponent("custompupil.png"))
			}
		}

		do {
			let doc = QRCode.Document(utf8String: "QR Code with overlaid logo", errorCorrection: .high)
			doc.design.backgroundColor(CGColor(srgbRed: 0.149, green: 0.137, blue: 0.208, alpha: 1.000))
			doc.design.shape.onPixels = QRCode.PixelShape.CurvePixel(cornerRadiusFraction: 0.8)
			doc.design.style.onPixels = QRCode.FillStyle.Solid(1.000, 0.733, 0.424, alpha: 1.000)

			doc.design.style.eye   = QRCode.FillStyle.Solid(0.831, 0.537, 0.416, alpha: 1.000)
			doc.design.style.pupil = QRCode.FillStyle.Solid(0.624, 0.424, 0.400, alpha: 1.000)

			doc.design.shape.eye = QRCode.EyeShape.RoundedPointingIn()

			let image = NSImage(named: "square-logo")!

			// Centered square logo
			doc.logoTemplate = QRCode.LogoTemplate(
				image: image.cgImage(forProposedRect: nil, context: nil, hints: nil)!,
				path: CGPath(rect: CGRect(x: 0.35, y: 0.35, width: 0.30, height: 0.30), transform: nil),
				inset: 2
			)

			let logoQRCode = doc.platformImage(dimension: 300, dpi: 144)!
			if let tiff = logoQRCode.tiffRepresentation,
				let tiffData = NSBitmapImageRep(data: tiff)
			{
				let pngData = tiffData.representation(using: .png, properties: [:])
				try! pngData?.write(to: tempURL.appendingPathComponent("qrcode-with-logo.png"))
			}

			let pdfData = doc.pdfData(dimension: 300)!
			try! pdfData.write(to: tempURL.appendingPathComponent("qrcode-with-logo.pdf"))

		}

		do {
			let doc = QRCode.Document(utf8String: "QR Code with overlaid logo center square", errorCorrection: .high)

			// Create a logo 'template'
			doc.logoTemplate = QRCode.LogoTemplate(
				image: NSImage(named: "square-logo")!.cgImage(forProposedRect: nil, context: nil, hints: nil)!,
				path: CGPath(rect: CGRect(x: 0.35, y: 0.35, width: 0.30, height: 0.30), transform: nil),
				inset: 3
			)

			let logoQRCode = doc.platformImage(dimension: 300, dpi: 144)!
			if let tiff = logoQRCode.tiffRepresentation,
				let tiffData = NSBitmapImageRep(data: tiff)
			{
				let pngData = tiffData.representation(using: .png, properties: [:])
				try! pngData?.write(to: tempURL.appendingPathComponent("qrcode-with-logo-example.png"))
			}
		}

		do {
			let doc = QRCode.Document(utf8String: "QR Code with overlaid logo bottom right circular", errorCorrection: .high)

			// Create a logo 'template'
			doc.logoTemplate = QRCode.LogoTemplate(
				image: NSImage(named: "instagram-icon")!.cgImage(forProposedRect: nil, context: nil, hints: nil)!,
				path: CGPath(ellipseIn: CGRect(x: 0.7, y: 0.7, width: 0.30, height: 0.30), transform: nil),
				inset: 8
			)

			let logoQRCode = doc.platformImage(dimension: 300, dpi: 144)!
			if let tiff = logoQRCode.tiffRepresentation,
				let tiffData = NSBitmapImageRep(data: tiff)
			{
				let pngData = tiffData.representation(using: .png, properties: [:])
				try! pngData?.write(to: tempURL.appendingPathComponent("qrcode-with-logo-example-bottom-right.png"))
			}
		}

		do {
			let doc = QRCode.Document(utf8String: "https://www.qrcode.com/en/history/", errorCorrection: .high)

			doc.design.shape.eye = QRCode.EyeShape.Squircle()
			doc.design.style.eye = QRCode.FillStyle.Solid(108.0 / 255.0, 76.0 / 255.0, 191.0 / 255.0)
			doc.design.style.pupil = QRCode.FillStyle.Solid(168.0 / 255.0, 33.0 / 255.0, 107.0 / 255.0)

			doc.design.shape.onPixels = QRCode.PixelShape.Squircle(insetFraction: 0.1)

			let c = QRCode.FillStyle.RadialGradient(
				DSFGradient(pins: [
					DSFGradient.Pin(CGColor(red: 1, green: 1, blue: 0.75, alpha: 1), 1),
					DSFGradient.Pin(CGColor(red: 1, green: 1, blue: 0.95, alpha: 1), 0),
					]
				)!,
				centerPoint: CGPoint(x: 0.5, y: 0.5))

			doc.design.style.background = c

			// Create a logo 'template'
			doc.logoTemplate = QRCode.LogoTemplate(
				image: NSImage(named: "apple-logo")!.cgImage(forProposedRect: nil, context: nil, hints: nil)!,
				path: CGPath(rect: CGRect(x: 0.49, y: 0.4, width: 0.45, height: 0.22), transform: nil),
				inset: 4
			)

			let svg = doc.svg(dimension: 200)
			try! svg.write(to: tempURL.appendingPathComponent("qrcode-with-basic-logo.svg"), atomically: true, encoding: .ascii)

			let pdfData = doc.pdfData(dimension: 200)!
			try! pdfData.write(to: tempURL.appendingPathComponent("qrcode-with-basic-logo.pdf"))
		}

		do {
			let doc = QRCode.Document(utf8String: "QRCode drawing only the 'off' pixels of the qr code", errorCorrection: .high)
			doc.design.shape.onPixels = QRCode.PixelShape.Circle(insetFraction: 0.05)
			doc.design.shape.negatedOnPixelsOnly = true
			doc.design.style.background = QRCode.FillStyle.Solid(gray: 0)
			doc.design.foregroundStyle(QRCode.FillStyle.Solid(gray: 1))

			let pdfData = doc.pngData(dimension: 600, dpi: 144)!
			try! pdfData.write(to: tempURL.appendingPathComponent("qrcode-with-negated.png"))
		}

		NSWorkspace.shared.open(tempURL)
	}
}

