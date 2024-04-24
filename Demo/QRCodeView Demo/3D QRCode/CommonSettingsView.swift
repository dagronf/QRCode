//
//  CommonSettingsView.swift
//  3D QRCode
//
//  Created by Darren Ford on 24/4/2024.
//

import Foundation
import AppKit

import DSFAppKitBuilder
import QRCode
import DSFValueBinders
import DSFMenuBuilder

class CommonSettingsView: Element {

	init(qrCode: Observable<QRCode.Document>, _ updateBlock: @escaping () -> Void ) {
		self.qrCodeObject = qrCode
		self.updateBlock = updateBlock
		super.init()
		self.qrCodeObject.register { [weak self] _ in
			self?.sync()
		}
	}

	let qrCodeObject: Observable<QRCode.Document>
	var qrCode: QRCode.Document { qrCodeObject.object }

	let updateBlock: () -> Void

	override func view() -> NSView { return self.body.view() }
	lazy var body: Element =
	VStack {
		HStack {
			Label("Text:").font(.callout)
			TextField(qrText)
		}
		HStack {
			Label("Quiet space:").font(.callout)
			Slider(quietSpacePixels, range: 0.0 ... 10.0)
				.controlSize(.small)
				.numberOfTickMarks(9, allowsTickMarkValuesOnly: true)
				.horizontalCompressionResistancePriority(.defaultHigh)
		}
		HStack {
			Label("Corner radius:").font(.callout)
			Slider(backgroundCornerRadius, range: 0.0 ... 1.0)
				.controlSize(.small)
				.horizontalCompressionResistancePriority(.defaultHigh)
		}
		HStack {
			Label("Negate:").font(.callout)
			Toggle()
				.controlSize(.small)
				.bindOnOff(negatePixels)
			EmptyView()
		}
		HStack(alignment: .centerY) {
			Label("Error Correction:").font(.callout)
			PopupButton {
				MenuItem("Low")
				MenuItem("Medium")
				MenuItem("Quantize")
				MenuItem("High")
			}
			.bindSelection(self.errorCorrection.transform { $0.rawValue })
			.onChange { popupIndex in
				self.errorCorrection.wrappedValue = QRCode.ErrorCorrection(rawValue: popupIndex)!
			}
			EmptyView()
		}
	}
	.edgeInsets(top: 4, left: 4, bottom: 4, right: 4)

	private func update() {
		self.updateBlock()
	}

	private func sync() {
		qrText.wrappedValue = self.qrCode.utf8String ?? ""
		errorCorrection.wrappedValue = self.qrCode.errorCorrection
		negatePixels.wrappedValue = self.qrCode.design.shape.negatedOnPixelsOnly
		quietSpacePixels.wrappedValue = Double(self.qrCode.design.additionalQuietZonePixels)
		backgroundCornerRadius.wrappedValue = self.qrCode.design.style.backgroundFractionalCornerRadius
	}

	// Bindings

	private lazy var qrText: ValueBinder<String> = ValueBinder("This is a QR code") { newValue in
		self.qrCode.utf8String = newValue
		self.update()
	}

	private lazy var quietSpacePixels = ValueBinder(0.0) { newValue in
		_ = self.qrCode.design.additionalQuietZonePixels = UInt(newValue)
		self.update()
	}

	private lazy var backgroundCornerRadius = ValueBinder(0.0) { newValue in
		_ = self.qrCode.design.style.backgroundFractionalCornerRadius = newValue
		self.update()
	}

	///

	private lazy var negatePixels = ValueBinder(false) { newValue in
		_ = self.qrCode.design.shape.negatedOnPixelsOnly = newValue
		self.update()
	}


	private lazy var errorCorrection: ValueBinder<QRCode.ErrorCorrection> = .init(.high) { newValue in
		_ = self.qrCode.errorCorrection = newValue
		self.update()
	}
}
