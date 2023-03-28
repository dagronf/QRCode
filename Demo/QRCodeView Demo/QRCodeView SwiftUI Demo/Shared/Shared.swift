//
//  Shared.swift
//  QRCodeView Demo
//
//  Created by Darren Ford on 25/11/21.
//

import SwiftUI
import QRCode

func pixelShapeHandler(
	_ pixelShape: String,
	insetFraction: Double = 0,
	cornerRadiusFraction: Double = 0,
	rotationFraction: Double = 0,
	randomInset: Bool = false
) -> QRCodePixelShapeGenerator {
	QRCodePixelShapeFactory.shared.named(pixelShape, settings: [
		QRCode.SettingsKey.insetFraction: insetFraction,
		QRCode.SettingsKey.cornerRadiusFraction: cornerRadiusFraction,
		QRCode.SettingsKey.rotationFraction: rotationFraction,
		QRCode.SettingsKey.useRandomInset: randomInset
	])!
}

func eyeShapeHandler(_ eyeStyle: String) -> QRCodeEyeShapeGenerator {
	QRCodeEyeShapeFactory.shared.named(eyeStyle)!
}

func pupilShapeHandler(_ pupilShape: String) -> QRCodePupilShapeGenerator {
	QRCodePupilShapeFactory.shared.named(pupilShape)!
}
