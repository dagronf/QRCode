//
//  QRCodeView.swift
//
//  Copyright © 2023 Darren Ford. All rights reserved.
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
@objc @IBDesignable public class QRCodeView: QRCodeDocumentView {

	/// The correction level to use when generating the QR code
	@objc public var errorCorrection: QRCode.ErrorCorrection {
		get { return self._document.errorCorrection }
		set { self._document.errorCorrection = newValue; self.rebuildQRCode() }
	}

	/// Binary data to display in the QR code
	@objc public var data: Data {
		get { return self._document.data ?? Data() }
		set { self._document.data = newValue; self.rebuildQRCode() }
	}

	/// The QRCode document represented for this view
	public override var document: QRCode.Document? {
		get {
			self._document
		}
		set {
			self._document = newValue ?? QRCode.Document()
			self.rebuildQRCode()
		}
	}

	/// The style to use when drawing the qr code
	@objc public var design: QRCode.Design {
		get { return self._document.design }
		set { self._document.design = newValue; self.rebuildQRCode() }
	}

	@objc public var logoTemplate: QRCode.LogoTemplate? {
		get { self._document.logoTemplate }
		set { self._document.logoTemplate = newValue; self.rebuildQRCode() }
	}

	/// Returns the number of cells for a dimension in the QR code is the pixel dimension for the QR Code.  You shouldn't make the view smaller than this
	@objc public var cellDimension: Int { self._document.cellDimension }

	/// The dimension for an individual cell for the given image dimension
	@objc public var cellSize: CGFloat {
		let dimension = min(self.bounds.width, self.bounds.height)
		return self._document.cellSize(forImageDimension: Int(dimension))
	}

	/// Create a QRCodeView with default settings
	@objc public convenience init() {
		self.init(frame: .zero)
	}

	/// Create a QRCodeView with an initial document.
	///
	/// Modifying values within this view will modify the content of the document
	@objc public override init(document: QRCode.Document) {
		super.init(document: document)
		self._document = document
		self.rebuildQRCode()
	}

	@objc public init(frame frameRect: CGRect) {
		super.init()
		self.rebuildQRCode()
	}

	@objc public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.rebuildQRCode()
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

	private var _eyeShape: String = "" {
		didSet {
			self.design.shape.eye = QRCodeEyeShapeFactory.shared.named(_eyeShape) ?? QRCode.EyeShape.Square()
			self.rebuildQRCode()
		}
	}
	private var _pixelShape: String = "" {
		didSet {
			self.design.shape.onPixels = QRCodePixelShapeFactory.shared.named(_pixelShape) ?? QRCode.PixelShape.Square()
			self.rebuildQRCode()
		}
	}
	private var _pupilShape: String = "" {
		didSet {
			self.design.shape.pupil = QRCodePupilShapeFactory.shared.named(_pupilShape) ?? QRCode.PupilShape.Square()
			self.rebuildQRCode()
		}
	}

	/// The internal document.
	private var _document = QRCode.Document() {
		didSet { self.rebuildQRCode() }
	}
}

// MARK: - Interface Builder conveniences

public extension QRCodeView {
	/// The name of the shape generator for the eye
	@IBInspectable var ibEyeShape: String {
		get { _eyeShape }
		set { _eyeShape = newValue; self.rebuildQRCode() }
	}

	/// The name of the shape generator for the data
	@IBInspectable var ibPixelShape: String {
		get { _pixelShape }
		set { _pixelShape = newValue; self.rebuildQRCode() }
	}

	/// The name of the shape generator for the data
	@IBInspectable var ibPupilShape: String {
		get { _pupilShape }
		set { _pupilShape = newValue; self.rebuildQRCode() }
	}

	/// Interface builder correction level
	@IBInspectable var ibCorrectionLevel: String {
		get { return self.errorCorrection.ECLevel }
		set { self.errorCorrection = QRCode.ErrorCorrection.Create(newValue.first ?? "q") ?? .quantize; self.rebuildQRCode() }
	}

	/// Interface builder text content
	@IBInspectable var ibTextContent: String {
		get { String(data: self.data, encoding: .utf8) ?? "" }
		set { self.data = newValue.data(using: .utf8) ?? Data(); self.rebuildQRCode() }
	}

	#if os(macOS)
	/// Interface builder data color
	@IBInspectable var ibPixelColor: NSColor {
		get { NSColor(cgColor: (self.design.style.onPixels as? QRCode.FillStyle.Solid)?.color ?? .black) ?? .black }
		set { self.design.style.onPixels = QRCode.FillStyle.Solid(newValue.cgColor); self.rebuildQRCode() }
	}

	/// Interface builder eye color
	@IBInspectable var ibEyeColor: NSColor {
		get { NSColor(cgColor: (self.design.style.eye as? QRCode.FillStyle.Solid)?.color ?? .black) ?? .black }
		set { self.design.style.eye = QRCode.FillStyle.Solid(newValue.cgColor); self.rebuildQRCode() }
	}

	/// Interface builder pupil color
	@IBInspectable var ibPupilColor: NSColor {
		get { NSColor(cgColor: (self.design.style.pupil as? QRCode.FillStyle.Solid)?.color ?? .black) ?? .black }
		set { self.design.style.pupil = QRCode.FillStyle.Solid(newValue.cgColor); self.rebuildQRCode() }
	}

	/// Interface builder background color
	@IBInspectable var ibBackgroundColor: NSColor {
		get { NSColor(cgColor: (self.design.style.background as? QRCode.FillStyle.Solid)?.color ?? .white) ?? .white }
		set { self.design.style.background = QRCode.FillStyle.Solid(newValue.cgColor); self.rebuildQRCode() }
	}
	#else
	/// Interface builder data color
	@IBInspectable var ibPixelColor: UIColor {
		get { UIColor(cgColor: (self.design.style.onPixels as? QRCode.FillStyle.Solid)?.color ?? CGColor(gray: 0, alpha: 1)) }
		set { self.design.style.onPixels = QRCode.FillStyle.Solid(newValue.cgColor); self.rebuildQRCode() }
	}

	/// Interface builder eye color
	@IBInspectable var ibEyeColor: UIColor {
		get { UIColor(cgColor: (self.design.style.eye as? QRCode.FillStyle.Solid)?.color ?? CGColor(gray: 0, alpha: 1)) }
		set { self.design.style.eye = QRCode.FillStyle.Solid(newValue.cgColor); self.rebuildQRCode() }
	}

	/// Interface builder pupil color
	@IBInspectable var ibPupilColor: UIColor {
		get { UIColor(cgColor: (self.design.style.pupil as? QRCode.FillStyle.Solid)?.color ?? CGColor(gray: 0, alpha: 1)) }
		set { self.design.style.pupil = QRCode.FillStyle.Solid(newValue.cgColor); self.rebuildQRCode() }
	}

	/// Interface builder background color
	@IBInspectable var ibBackgroundColor: UIColor {
		get { UIColor(cgColor: (self.design.style.background as? QRCode.FillStyle.Solid)?.color ?? CGColor(gray: 1, alpha: 1)) }
		set { self.design.style.background = QRCode.FillStyle.Solid(newValue.cgColor); self.rebuildQRCode() }
	}

	#endif

	/// Rebuild the QR code after manual changes to the document
	func rebuildQRCode() {
		super.document = self._document
	}

	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		self.rebuildDocumentUsingStoredProperties()
	}
}

// MARK: - Drawing

extension QRCodeView {
	// Build up the qr representation
	private func rebuildDocumentUsingStoredProperties() {
		self._document.update(data: self.data, errorCorrection: self.errorCorrection)
		self._document.design.shape.onPixels = QRCodePixelShapeFactory.shared.named(_pixelShape) ?? QRCode.PixelShape.Square()
		self._document.design.shape.eye = QRCodeEyeShapeFactory.shared.named(_eyeShape) ?? QRCode.EyeShape.Square()
		self._document.design.shape.pupil = (_pupilShape.count > 0) ? QRCodePupilShapeFactory.shared.named(_pupilShape) : nil
		self._document.logoTemplate = logoTemplate
		// Push the document to the document viewer
		self.rebuildQRCode()
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
			let image = self._document.nsImage(sz, dpi: 144)

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
			let pdfData = self._document.pdfData(self.dragImageSize)
			pasteboard.setData(pdfData, forType: .pdf)
		}
		else if type == .tiff,
			let imageData = self._document.nsImage(self.dragImageSize, dpi: 144)?.tiffRepresentation {
			pasteboard.setData(imageData, forType: .tiff)
		}
		else if type == .png,
			let pngdata = self._document.nsImage(self.dragImageSize, dpi: 144)?.pngRepresentation() {
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
			
			let pdfData = self._document.pdfData(self.dragImageSize)
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
		let qrCodeData = QRCodeItemProvider(document: self._document, size: self.dragImageSize)
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
