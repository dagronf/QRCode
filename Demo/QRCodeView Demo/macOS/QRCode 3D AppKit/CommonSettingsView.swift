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
		HStack(alignment: .firstBaseline) {
			Label("text:").font(.callout)
			TextField(qrText)
				.height(72)
				.width(250)
		}
		.hugging(h: 1)

		Grid {
			GridRow {
				Label("error correction:").font(.callout)
				PopupButton {
					MenuItem("Low")
					MenuItem("Medium")
					MenuItem("Quantize")
					MenuItem("High")
				}
				.controlSize(.small)
				.bindSelection(self.errorCorrection.transform { $0.rawValue })
				.onChange { popupIndex in
					self.errorCorrection.wrappedValue = QRCode.ErrorCorrection(rawValue: popupIndex)!
				}
			}

			GridRow {
				Label("generator:").font(.callout)
				PopupButton {
					MenuItem("core image")
					MenuItem("external")
				}
				.controlSize(.small)
				.bindSelection(generatorSelection)
				.horizontalHuggingPriority(.init(1))
			}

			GridRow {
				Label("quiet space:").font(.callout)
				Slider(quietSpacePixels, range: 0.0 ... 10.0)
					.controlSize(.small)
					.numberOfTickMarks(9, allowsTickMarkValuesOnly: true)
					.horizontalCompressionResistancePriority(.defaultHigh)
			}
			GridRow {
				Label("corner radius:").font(.callout)
				Slider(backgroundCornerRadius, range: 0.0 ... 1.0)
					.controlSize(.small)
					.horizontalCompressionResistancePriority(.defaultHigh)
			}
			GridRow {
				Label("negate:").font(.callout)
				Toggle()
					.controlSize(.small)
					.bindOnOff(negatePixels)
			}
		}
		.columnFormatting(xPlacement: .trailing, atColumn: 0)
		.rowSpacing(6)
	}
	.edgeInsets(top: 4, left: 4, bottom: 4, right: 4)
	.hugging(h: 10)

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

	private lazy var generatorSelection = ValueBinder<Int>(0) { newValue in
		switch newValue {
		case 0: self.qrCode.engine = nil
		case 1: self.qrCode.engine = QRCodeEngineExternal()
		default: fatalError()
		}
		self.update()
	}
}
