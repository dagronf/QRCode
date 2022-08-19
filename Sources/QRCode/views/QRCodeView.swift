//
//  QRCodeView.swift
//
//  Created by Darren Ford on 9/11/21.
//  Copyright © 2022 Darren Ford. All rights reserved.
//
//  MIT license
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial
//  portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
//  OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#if !os(watchOS)

import CoreGraphics
import CoreImage

#if os(macOS)
import AppKit
#else
import UIKit
#endif

// MARK: - QRCode View

/// A simple NSView/UIView that displays a QR Code
@objc @IBDesignable public class QRCodeView: DSFView {
	/// The qrcode document to render
	@objc public var document = QRCode.Document() {
		didSet { self.setNeedsDisplay() }
	}

	/// The correction level to use when generating the QR code
	@objc public var errorCorrection: QRCode.ErrorCorrection {
		get { return self.document.errorCorrection }
		set { self.document.errorCorrection = newValue; self.setNeedsDisplay() }
	}

	/// Binary data to display in the QR code
	@objc public var data: Data {
		get { return self.document.data }
		set { self.document.data = newValue; self.setNeedsDisplay() }
	}

	/// The style to use when drawing the qr code
	@objc public var design: QRCode.Design {
		get { return self.document.design }
		set { self.document.design = newValue; self.setNeedsDisplay() }
	}

	/// This is the pixel dimension for the QR Code.  You shouldn't make the view smaller than this
	@objc public var pixelSize: Int { self.document.pixelSize }

	@objc public convenience init() {
		self.init(frame: .zero)
	}

	@objc override public init(frame frameRect: CGRect) {
		super.init(frame: frameRect)
		self.setup()
	}

	@objc public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.setup()
	}

#if os(iOS)
	public override func didMoveToWindow() {
		super.didMoveToWindow()
		if self.supportsDrag {
			let dragInteraction = UIDragInteraction(delegate: self)
			self.addInteraction(dragInteraction)

			self.isUserInteractionEnabled = true
		}
	}
#endif

	/// Text content to display in the QR code
	@objc @inlinable public func setString(_ text: String) -> Bool {
		guard let msg = text.data(using: .utf8) else { return false }
		self.data = msg
		return true
	}

	/// Set the content of the displayed QR code using the provided message formatter
	@objc @inlinable func setMessage(_ msgType: QRCodeMessageFormatter) {
		self.data = msgType.data
	}

	/// If true, the view allows dragging a QRCode representation out
	@IBInspectable var supportsDrag: Bool = false

	/// The size of the QRCode image when dragged out of the view
	@IBInspectable var dragImageSize: CGSize = CGSize(width: 512, height: 512)

	private var _eyeShape: String = ""
	private var _pixelShape: String = ""
}

// MARK: - Interface Builder conveniences

public extension QRCodeView {
	/// The name of the shape generator for the eye
	@IBInspectable var ibEyeShape: String {
		get { _eyeShape }
		set { _eyeShape = newValue; self.regenerate() }
	}

	/// The name of the shape generator for the data
	@IBInspectable var ibPixelShape: String {
		get { _pixelShape }
		set { _pixelShape = newValue; self.regenerate() }
	}

	/// Interface builder correction level
	@IBInspectable var ibCorrectionLevel: String {
		get { return self.errorCorrection.ECLevel }
		set { self.errorCorrection = QRCode.ErrorCorrection.Create(newValue.first ?? "q") ?? .quantize }
	}

	/// Interface builder text content
	@IBInspectable var ibTextContent: String {
		get { String(data: self.data, encoding: .utf8) ?? "" }
		set { self.data = newValue.data(using: .utf8) ?? Data() }
	}

	#if os(macOS)
	/// Interface builder data color
	@IBInspectable var ibPixelColor: NSColor {
		get { NSColor(cgColor: (self.design.style.onPixels as? QRCode.FillStyle.Solid)?.color ?? .black) ?? .black }
		set { self.design.style.onPixels = QRCode.FillStyle.Solid(newValue.cgColor) }
	}

	/// Interface builder eye color
	@IBInspectable var ibEyeColor: NSColor {
		get { NSColor(cgColor: (self.design.style.eye as? QRCode.FillStyle.Solid)?.color ?? .black) ?? .black }
		set { self.design.style.eye = QRCode.FillStyle.Solid(newValue.cgColor) }
	}

	/// Interface builder pupil color
	@IBInspectable var ibPupilColor: NSColor {
		get { NSColor(cgColor: (self.design.style.pupil as? QRCode.FillStyle.Solid)?.color ?? .black) ?? .black }
		set { self.design.style.pupil = QRCode.FillStyle.Solid(newValue.cgColor) }
	}

	/// Interface builder background color
	@IBInspectable var ibBackgroundColor: NSColor {
		get { NSColor(cgColor: (self.design.style.background as? QRCode.FillStyle.Solid)?.color ?? .white) ?? .white }
		set { self.design.style.background = QRCode.FillStyle.Solid(newValue.cgColor) }
	}
	#else
	/// Interface builder data color
	@IBInspectable var ibPixelColor: UIColor {
		get { UIColor(cgColor: (self.design.style.onPixels as? QRCode.FillStyle.Solid)?.color ?? CGColor(gray: 0, alpha: 1)) }
		set { self.design.style.onPixels = QRCode.FillStyle.Solid(newValue.cgColor) }
	}

	/// Interface builder eye color
	@IBInspectable var ibEyeColor: UIColor {
		get { UIColor(cgColor: (self.design.style.eye as? QRCode.FillStyle.Solid)?.color ?? CGColor(gray: 0, alpha: 1)) }
		set { self.design.style.eye = QRCode.FillStyle.Solid(newValue.cgColor) }
	}

	/// Interface builder pupil color
	@IBInspectable var ibPupilColor: UIColor {
		get { UIColor(cgColor: (self.design.style.pupil as? QRCode.FillStyle.Solid)?.color ?? CGColor(gray: 0, alpha: 1)) }
		set { self.design.style.pupil = QRCode.FillStyle.Solid(newValue.cgColor) }
	}

	/// Interface builder background color
	@IBInspectable var ibBackgroundColor: UIColor {
		get { UIColor(cgColor: (self.design.style.background as? QRCode.FillStyle.Solid)?.color ?? CGColor(gray: 1, alpha: 1)) }
		set { self.design.style.background = QRCode.FillStyle.Solid(newValue.cgColor) }
	}

	#endif

	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		self.setup()
	}
}

// MARK: - Drawing

extension QRCodeView {
	#if os(macOS)
	override public var isFlipped: Bool { true }
	#endif

	private func setup() {
		self.regenerate()
	}

	#if os(macOS)
	override public func draw(_ dirtyRect: NSRect) {
		if let ctx = NSGraphicsContext.current?.cgContext {
			self.draw(ctx)
		}
	}
	#else
	override public func draw(_ rect: CGRect) {
		if let ctx = UIGraphicsGetCurrentContext() {
			self.draw(ctx)
		}
	}
	#endif

	// Draw the QR Code into the specified context
	private func draw(_ ctx: CGContext) {
		self.document.draw(ctx: ctx, rect: self.bounds)
	}

	// Build up the qr representation
	private func regenerate() {
		self.document.update(self.data, errorCorrection: self.errorCorrection)
		self.document.design.shape.onPixels = QRCodePixelShapeFactory.shared.named(_pixelShape) ?? QRCode.PixelShape.Square()
		self.document.design.shape.eye = QRCodeEyeShapeFactory.shared.named(_eyeShape) ?? QRCode.EyeShape.Square()
		self.setNeedsDisplay()
	}
}

// MARK: - Drag drop support for macOS

#if os(macOS)

let PasteboardFileURLPromise = NSPasteboard.PasteboardType(rawValue: kPasteboardTypeFileURLPromise)
let PasteboardFilePromiseContent = NSPasteboard.PasteboardType(rawValue: kPasteboardTypeFilePromiseContent)
let PasteboardFilePasteLocation = NSPasteboard.PasteboardType(rawValue: "com.apple.pastelocation")

extension QRCodeView {
	override public func mouseDown(with event: NSEvent) {
		if self.supportsDrag {
			let pasteboardItem = NSPasteboardItem()

			// 1. The sender promises kPasteboardTypeFileURLPromise for a file yet to be created.
			// 2. The sender adds kPasteboardTypeFilePromiseContent containing the UTI describing the file's content.
			pasteboardItem.setDataProvider(self, forTypes: [.pdf, .png, .tiff, PasteboardFileURLPromise, PasteboardFilePromiseContent])

			// 3.
			let draggingItem = NSDraggingItem(pasteboardWriter: pasteboardItem)

			// Generate drag representation
			let sz = CGSize(width: 128, height: 128)
			let image = self.document.nsImage(sz, scale: 2)

			draggingItem.setDraggingFrame(CGRect(origin: .zero, size: sz), contents: image)

			beginDraggingSession(with: [draggingItem], event: event, source: self)
		}
	}
}

extension QRCodeView: NSDraggingSource {
	public func draggingSession(_: NSDraggingSession, sourceOperationMaskFor _: NSDraggingContext) -> NSDragOperation {
		if self.supportsDrag {
			return .copy
		}
		return []
	}
}

extension QRCodeView: NSPasteboardItemDataProvider {
	public func pasteboard(_ pasteboard: NSPasteboard?, item: NSPasteboardItem, provideDataForType type: NSPasteboard.PasteboardType) {
		// If there's no pasteboard, we can't do anything
		guard let pasteboard = pasteboard else {
			return
		}

		if type == .pdf {
			let pdfData = self.document.pdfData(self.dragImageSize)
			pasteboard.setData(pdfData, forType: .pdf)
		}
		else if type == .tiff,
			let imageData = self.document.nsImage(self.dragImageSize, scale: 2)?.tiffRepresentation {
			pasteboard.setData(imageData, forType: .tiff)
		}
		else if type == .png,
			let pngdata = self.document.nsImage(self.dragImageSize, scale: 2)?.pngRepresentation {
			pasteboard.setData(pngdata, forType: .png)
		}
		else if type == PasteboardFilePromiseContent {
			// 3. The receiver asks for kPasteboardTypeFilePromiseContent to decide if it wants the file.
			// In our case, we are dropping a PDF file, so send back the pdf mime type
			pasteboard.setString(String(kUTTypePDF), forType: PasteboardFilePromiseContent)
		}
		else if type == PasteboardFileURLPromise {
			// 4. The receiver asks for kPasteboardTypeFileURLPromise.
			guard let str = pasteboard.string(forType: PasteboardFilePasteLocation),
				let destinationFolderURL = URL(string: str) else {
				return
			}

			// Make sure we have a unique name for the dropped file
			let dest = FileManager.UniqueFileURL(for: "Dropped QRCode.pdf", in: destinationFolderURL)
			
			let pdfData = self.document.pdfData(self.dragImageSize)
			do {
				try pdfData?.write(to: dest, options: .atomic)

				// 5. The sender's promise callback for kPasteboardTypeFileURLPromise is called.
				pasteboard.setString(dest.absoluteString, forType: PasteboardFileURLPromise)
			}
			catch {
				print(error)
			}
		}
	}
}
#endif

#if os(iOS)

extension QRCodeView: UIDragInteractionDelegate {
	public func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
		let qrCodeData = QRCodeItemProvider(document: self.document, size: self.dragImageSize)
		return [UIDragItem(itemProvider: NSItemProvider(object: qrCodeData))]
	}
}

internal class QRCodeItemProvider: NSObject, NSItemProviderWriting {
	static var writableTypeIdentifiersForItemProvider = [ "com.adobe.pdf", "public.png" ]

	func loadData(
		withTypeIdentifier typeIdentifier: String,
		forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress?
	{
		if typeIdentifier == "com.adobe.pdf" {
			completionHandler(self.pdfData, nil)
		}
		else if typeIdentifier == "public.png" {
			completionHandler(self.pngData, nil)
		}
		return nil
	}

	let pdfData: Data?
	let pngData: Data?
	init(document: QRCode.Document, size: CGSize) {
		self.pdfData = document.pdfData(size)
		self.pngData = document.uiImage(size)?.pngData()
		super.init()
	}
}

#endif

#endif
