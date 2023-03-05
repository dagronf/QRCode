//
//  QRCodeDocumentView+macOS.swift
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

// Basic document view for AppKit. It provides no additional functionality.
// If you want built-in drag/drop, pasteboard support and customising settings use QRCodeView instead.

#if os(macOS)

import AppKit

// MARK: - NSView

/// Very simple QRCode base view for displaying a document in an NSView
///
/// This view provides background loading functionality so if the QRCode document is complex,
/// a spinner will display until the content is ready.
@objc public class QRCodeDocumentView: NSView {
	/// The document to display
	@IBOutlet public var document: QRCode.Document? {
		didSet {
			self.documentDidChange(document: self.document)
		}
	}

	/// Create a document view
	/// - Parameter document: The document to display
	@objc public init(document: QRCode.Document = QRCode.Document()) {
		self.document = document
		super.init(frame: .zero)
		self.setup()
		self.documentDidChange(document: document)
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.setup()
		self.documentDidChange(document: document)
	}

	// private

	private let imageLayer = CALayer()
	private let debounceDocumentChange = DSFDebounce(seconds: 0.1)
	private var displayProgressDelayTimer: Timer?
	private let progressView = NSProgressIndicator(frame: .zero)
}

public extension QRCodeDocumentView {
	override var isFlipped: Bool { true }
	override var isOpaque: Bool { false }

	override func setFrameSize(_ newSize: NSSize) {
		super.setFrameSize(newSize)
		CATransaction.setDisableActions(true)
		self.imageLayer.frame = self.bounds

		self.progressView.frame = CGRect(
			x: (newSize.width / 2) - (16),
			y: (newSize.height / 2) - (16),
			width: 32,
			height: 32)
	}
}

private extension QRCodeDocumentView {
	func setup() {
		self.wantsLayer = true
		let baseLayer = self.layer!

		// Add in an image layer
		baseLayer.addSublayer(self.imageLayer)
		self.imageLayer.frame = baseLayer.bounds
		self.imageLayer.contentsGravity = .resizeAspect

		// Add in the progress view
		self.progressView.isIndeterminate = true
		self.progressView.isDisplayedWhenStopped = false
		self.progressView.usesThreadedAnimation = true
		self.progressView.style = .spinning
		if #available(macOS 11.0, *) {
			self.progressView.controlSize = .large
		} else {
			self.progressView.controlSize = .regular
		}
		self.addSubview(self.progressView)
	}

	func documentDidChange(document: QRCode.Document?) {
		// Debounce the document change
		debounceDocumentChange.debounce { [weak self] in
			self?._documentDidChange(document: document)
		}
	}

	func _documentDidChange(document: QRCode.Document?) {

		if displayProgressDelayTimer == nil {
			displayProgressDelayTimer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(timerFired), userInfo: nil, repeats: false)
		}

		// Generate the image on a background thread to make the UI more responsive
		let workItem = DispatchWorkItem { [weak self] in
			if
				let data = document?.pdfData(dimension: 512),
				let image = NSImage(data: data)
			{
				self?.updateDisplay(with: image)
			}
			else {
				self?.updateDisplay(with: nil)
			}
		}

		DispatchQueue.global(qos: .background).async(execute: workItem)
	}

	private func updateDisplay(with image: NSImage?) {
		DispatchQueue.main.async { [weak self ] in
			guard let `self` = self else { return }
			self.displayProgressDelayTimer?.invalidate()
			self.displayProgressDelayTimer = nil
			self.imageLayer.contents = image
			self.imageLayer.opacity = 1.0
			self.progressView.stopAnimation(self)
		}
	}

	@objc func timerFired() {
		self.imageLayer.opacity = 0.2
		self.progressView.startAnimation(self)
	}
}

#endif
