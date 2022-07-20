import Cocoa

import QRCode

var greeting = "Hello, playground"

// MARK: - Error correction levels

do {
	// Basic QRCode
	let codeL = QRCode(text: "This is a basic test", errorCorrection: .low)
	_ = codeL.cgImage(dimension: 100)

	let codeM = QRCode(text: "This is a basic test", errorCorrection: .medium)
	_ = codeM.cgImage(dimension: 100)

	let codeQ = QRCode(text: "This is a basic test", errorCorrection: .quantize)
	_ = codeQ.cgImage(dimension: 100)

	let codeH = QRCode(text: "This is a basic test", errorCorrection: .high)
	_ = codeH.cgImage(dimension: 100)
}

// MARK: - Basic colors

do {
	// background color
	let code = QRCode.Document(utf8String: "This is a basic test")
	code.design.backgroundColor(CGColor(red: 1, green: 1, blue: 0, alpha: 1))
	_ = code.cgImage(dimension: 100)

	// simple foreground color
	let code2 = QRCode.Document(utf8String: "This is a basic test")
	code2.design.foregroundColor(CGColor(red: 0.5, green: 0, blue: 1, alpha: 1))
	_ = code2.cgImage(dimension: 100)
}

do {
	let url = QRCode.Message.Link(string: "https://web.archive.org/web/20220629/https://www.apple.com/mac-studio/")!
	let code = QRCode.Document(message: url)
	code.design.shape.eye = QRCode.EyeShape.Leaf()
	_ = code.cgImage(dimension: 150)

	code.design.backgroundColor(CGColor(red: 0, green: 0, blue: 0.2, alpha: 1))
	code.design.foregroundColor(CGColor(red: 0.4, green: 0.4, blue: 1, alpha: 1))
	code.design.shape.eye = QRCode.EyeShape.RoundedOuter()
	code.design.shape.onPixels = QRCode.DataShape.RoundedPath()
	code.design.style.eye = QRCode.FillStyle.Solid(CGColor(red: 0.3, green: 1, blue: 0.3, alpha: 1))

	code.design.style.pupil = QRCode.FillStyle.Solid(CGColor(red: 1, green: 0.3, blue: 0.3, alpha: 1))
	_ = code.cgImage(dimension: 512)
}

// MARK: - UTF8 encoding test

do {
	let url = QRCode.Message.Text("बिलार आ कुकुर आ मछरी आ चिरई-चुरुंग के")!
	let code = QRCode.Document(message: url)

	_ = code.cgImage(dimension: 512)
}
