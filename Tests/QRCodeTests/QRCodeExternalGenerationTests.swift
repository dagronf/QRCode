import XCTest

@testable import QRCode

// The external QR Code generator has some optimizations that be triggered
// when the provided text has the following characteristics...
//
// 1. All characters are numeric, or
// 2. All characters in "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ $%*+-./:"
//

final class QRCodeExternalGenerationTests: XCTestCase {

	let outputFolder = try! testResultsContainer.subfolder(with: "QRCodeExternalGenerationTests")

	func testBasicAlpha() throws {
		let eGen = QRCodeEngineExternal()

		// A string that's purely uppercase alphanumeric. This is optimizable (thus should be smaller)
		let g1 = try eGen.generate(text: "THIS IS A TEST THIS IS A TEST THIS IS A TEST", errorCorrection: .quantize)
		XCTAssertEqual(g1.dimension, 31)
		let g2 = try eGen.generate(text: "this IS A TEST THIS IS A TEST THIS IS A TEST", errorCorrection: .quantize)
		XCTAssertEqual(g2.dimension, 35)

		// A string that is purely uppercase ascii, which the external generator can optimize to produce
		// a smaller QR code
		let s1 = "THIS IS A TEST THIS IS A TEST THIS IS A TEST "
		let docG1 = QRCode.Document(utf8String: s1, engine: QRCodeEngineExternal())
		XCTAssertEqual(g1.dimension, docG1.boolMatrix.dimension)

		// The first 4 characters are NOT compatible with text optimizations, so the QR code should be larger
		let s2 = "this IS A TEST THIS IS A TEST THIS IS A TEST "
		let docG2 = QRCode.Document(utf8String: s2, engine: QRCodeEngineExternal())
		XCTAssertEqual(g2.dimension, docG2.boolMatrix.dimension)
	}

	func testNumericEncoding() throws {
		let eGen = QRCodeEngineExternal()

		let v1 = "0123456790123456789"
		// Optimizable (purely numbers)
		let docN1 = QRCode.Document(utf8String: v1, engine: eGen)
		XCTAssertEqual(23, docN1.boolMatrix.dimension)
		// Setting as data, therefore not optimized
		let docN2 = QRCode.Document(data: try XCTUnwrap(v1.data(using: .utf8)), engine: eGen)
		XCTAssertEqual(27, docN2.boolMatrix.dimension)
	}

	func testBasicNumeric() throws {
		let eGen = QRCodeEngineExternal()

		// Only numbers. The external encoder should be able to optimize this more
		let m31 = "0123456789012345678901234567890123456789"
		let g31 = try eGen.generate(text: m31, errorCorrection: .quantize)
		XCTAssertEqual(g31.dimension, 27)
		let d31 = QRCode.Document(utf8String: m31, engine: eGen)
		XCTAssertEqual(27, d31.boolMatrix.dimension)
		let data31 = try XCTUnwrap(d31.imageData(.png(), dimension: 300))
		try outputFolder.write(data31, to: "extgen_numerics_only.png")

#if !os(watchOS)
		// Make sure we can detect the generated QR code
		let i31 = try XCTUnwrap(d31.cgImage(dimension: 300))
		let det31 = QRCode.DetectQRCodes(i31)
		XCTAssertEqual(1, det31.count)
		XCTAssertEqual(det31[0].messageString, m31)
#endif
	}

	func testBasicAlphaNumeric() throws {
		let eGen = QRCodeEngineExternal()

		// Adding a non-numeric should expand the QRCode dimensions (cannot optimize as strongly due to the 'A')
		// However, because the character is an upper case ascii value, it can optimize further than the generic case
		let m32 = "012345678901234567890123456789012345678A"
		let g32 = try eGen.generate(text: m32, errorCorrection: .quantize)
		XCTAssertEqual(g32.dimension, 31)
		let d32 = QRCode.Document(utf8String: m32, engine: eGen)
		XCTAssertEqual(31, d32.boolMatrix.dimension)
		let d32d = try XCTUnwrap(d32.imageData(.png(), dimension: 300))
		try outputFolder.write(d32d, to: "extgen_alphanumerics_only.png")

#if !os(watchOS)
		// Make sure we can detect the generated QR code
		let i32 = try XCTUnwrap(d32.cgImage(dimension: 300))
		let det32 = QRCode.DetectQRCodes(i32)
		XCTAssertEqual(1, det32.count)
		XCTAssertEqual(det32[0].messageString, m32)
#endif
	}

	func testBasicGenericString() throws {
		let eGen = QRCodeEngineExternal()

		// Adding a non-numeric should expand the QRCode dimensions (cannot optimize due to the 'a')
		let m33 = "012345678901234567890123456789012345678a"
		let g33 = try eGen.generate(text: m33, errorCorrection: .quantize)
		XCTAssertEqual(g33.dimension, 35)
		let d33 = QRCode.Document(utf8String: m33, engine: eGen)
		XCTAssertEqual(35, d33.boolMatrix.dimension)
		let d33d = try XCTUnwrap(d33.imageData(.png(), dimension: 300))
		try outputFolder.write(d33d, to: "extgen_generic_text.png")

#if !os(watchOS)
		// Make sure we can detect the generated QR code
		let i33 = try XCTUnwrap(d33.cgImage(dimension: 300))
		let det33 = QRCode.DetectQRCodes(i33)
		XCTAssertEqual(1, det33.count)
		XCTAssertEqual(det33[0].messageString, m33)
#endif
	}

	func testUtf8EncodingThing() throws {
		let eGen = QRCodeEngineExternal()

		do {
			let m33 = "اربك تكست هو اول موقع يسمح"
			let g33 = try XCTUnwrap(eGen.generate(text: m33, errorCorrection: .quantize))
			XCTAssertEqual(g33.dimension, 39)
			let d33 = QRCode.Document(utf8String: m33, engine: eGen)
			XCTAssertEqual(39, d33.boolMatrix.dimension)
			let d33d = try XCTUnwrap(d33.imageData(.png(), dimension: 300))
			try outputFolder.write(d33d, to: "extgen_arabic_text_utf8.png")

#if !os(watchOS)
			// Make sure we can detect the generated QR code
			let i33 = try XCTUnwrap(d33.cgImage(dimension: 300))
			let det33 = QRCode.DetectQRCodes(i33)
			XCTAssertEqual(1, det33.count)
			XCTAssertEqual(det33[0].messageString, m33)
#endif
		}

		do {
			let m33 = "Emoji work -> 🐔👨‍👨‍👦 and also 🏋🏾"
			let g33 = try XCTUnwrap(eGen.generate(text: m33, errorCorrection: .quantize))
			XCTAssertEqual(g33.dimension, 39)
			let d33 = QRCode.Document(utf8String: m33, engine: eGen)
			XCTAssertEqual(39, d33.boolMatrix.dimension)
			let d33d = try XCTUnwrap(d33.imageData(.png(), dimension: 300))
			try outputFolder.write(d33d, to: "extgen_emojis_text_utf8.png")

#if !os(watchOS)
			// Make sure we can detect the generated QR code
			let i33 = try XCTUnwrap(d33.cgImage(dimension: 300))
			let det33 = QRCode.DetectQRCodes(i33)
			XCTAssertEqual(1, det33.count)
			XCTAssertEqual(det33[0].messageString, m33)
#endif
		}
	}

	func testOptimizationWorkingNumerics() throws {
		let eGen = QRCodeEngineExternal()

		let text = "0123456789012345678901234567890123456789"
		let data = try XCTUnwrap(text.data(using: .ascii))

		// Setting the text as a data representation, we avoid triggering the optimizations
		// This will be our baseline for checking whether we trigger the optimizations
		let orig = try XCTUnwrap(eGen.generate(data: data, errorCorrection: .quantize))
		XCTAssertEqual(orig.dimension, 35)
		let origDoc = QRCode.Document(data: data, engine: eGen)
		XCTAssertEqual(35, origDoc.boolMatrix.dimension)

#if !os(watchOS)
		do {
			// Make sure we can detect the generated QR code
			let origImage = try XCTUnwrap(origDoc.cgImage(dimension: 300))
			let det1 = QRCode.DetectQRCodes(origImage)
			XCTAssertEqual(1, det1.count)
			XCTAssertEqual(det1[0].messageString, text)
		}
#endif

		// Now, call the generator using the text, which means that the generator can optimize the content
		let optim = try XCTUnwrap(eGen.generate(text: text, errorCorrection: .quantize))
		XCTAssertEqual(optim.dimension, 27)
		let optDoc = QRCode.Document(utf8String: text, engine: eGen)
		XCTAssertEqual(27, optDoc.boolMatrix.dimension)

		XCTAssertGreaterThan(origDoc.boolMatrix.dimension, optDoc.boolMatrix.dimension)

#if !os(watchOS)
		do {
			// Make sure we can detect the generated QR code
			let optimImage = try XCTUnwrap(optDoc.cgImage(dimension: 300))
			let det2 = QRCode.DetectQRCodes(optimImage)
			XCTAssertEqual(1, det2.count)
			XCTAssertEqual(det2[0].messageString, text)
		}
#endif
	}

	func testOptimizationWorkingAlphaNumerics() throws {
		let eGen = QRCodeEngineExternal()

		let text = "THIS IS A TEST. 0123456789 - ABCDFEGH"
		let data = try XCTUnwrap(text.data(using: .ascii))

		// Setting the text as a data representation, we avoid triggering the optimizations
		// This will be our baseline for checking whether we trigger the optimizations
		let orig = try XCTUnwrap(eGen.generate(data: data, errorCorrection: .quantize))
		XCTAssertEqual(orig.dimension, 35)
		let origDoc = QRCode.Document(data: data, engine: eGen)
		XCTAssertEqual(35, origDoc.boolMatrix.dimension)

#if !os(watchOS)
		do {
			// Make sure we can detect the generated QR code
			let origImage = try XCTUnwrap(origDoc.cgImage(dimension: 300))
			let det1 = QRCode.DetectQRCodes(origImage)
			XCTAssertEqual(1, det1.count)
			XCTAssertEqual(det1[0].messageString, text)
		}
#endif

		// Now, call the generator using the text, which means that the generator can optimize the content
		let optim = try XCTUnwrap(eGen.generate(text: text, errorCorrection: .quantize))
		XCTAssertEqual(optim.dimension, 31)
		let optDoc = QRCode.Document(utf8String: text, engine: eGen)
		XCTAssertEqual(31, optDoc.boolMatrix.dimension)

		XCTAssertGreaterThan(origDoc.boolMatrix.dimension, optDoc.boolMatrix.dimension)

#if !os(watchOS)
		do {
			// Make sure we can detect the generated QR code
			let optimImage = try XCTUnwrap(optDoc.cgImage(dimension: 300))
			let det2 = QRCode.DetectQRCodes(optimImage)
			XCTAssertEqual(1, det2.count)
			XCTAssertEqual(det2[0].messageString, text)
		}
#endif

	}

	func testAlphaNum() throws {
		let eGen = QRCodeEngineExternal()

		do {
			let message = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ $%*+-./:"
			let data = try XCTUnwrap(message.data(using: .ascii))

			let orig = try XCTUnwrap(eGen.generate(data: data, errorCorrection: .quantize))
			XCTAssertEqual(35, orig.dimension)

			let opti = try XCTUnwrap(eGen.generate(text: message, errorCorrection: .quantize))
			XCTAssertEqual(31, opti.dimension)

			// Don't need to check this (its already true via the above asserts), but my brain won't let it go.
			XCTAssertGreaterThan(orig.dimension, opti.dimension)
		}

		do {
			// The 'z' is now lowercase, so the optimization shouldn't kick in.
			let message = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYz $%*+-./:"
			let data = try XCTUnwrap(message.data(using: .ascii))

			let orig = try XCTUnwrap(eGen.generate(data: data, errorCorrection: .quantize))
			XCTAssertEqual(35, orig.dimension)

			let opti = try XCTUnwrap(eGen.generate(text: message, errorCorrection: .quantize))
			XCTAssertEqual(35, opti.dimension)

			// Don't need to check this (its already true via the above asserts), but my brain won't let it go.
			XCTAssertEqual(orig.dimension, opti.dimension)
		}
	}
}
