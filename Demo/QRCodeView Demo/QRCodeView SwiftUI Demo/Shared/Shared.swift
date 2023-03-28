//
//  Shared.swift
//  QRCodeView Demo
//
//  Created by Darren Ford on 25/11/21.
//

import SwiftUI
import QRCode

//enum EyeShapeType: Int {
//	case square = 0
//	case circle = 1
//	case leaf = 2
//	case roundedRect = 3
//	case roundedOuter = 4
//	case roundedPointingIn = 5
//	case squircle = 6
//	case barHorizontal = 7
//	case barVertical = 8
//	case pixels = 9
//}
//
//enum PupilShapeType: Int {
//	case square = 0
//	case circle = 1
//	case leaf = 2
//	case roundedRect = 3
//	case roundedOuter = 4
//	case roundedPointingIn = 5
//	case squircle = 6
//	case barHorizontal = 7
//	case barVertical = 8
//	case pixels = 9
//}

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
		QRCode.SettingsKey.randomInset: randomInset
	])!
}

func eyeShapeHandler(_ eyeStyle: String) -> QRCodeEyeShapeGenerator {
	QRCodeEyeShapeFactory.shared.named(eyeStyle)!
}

func pupilShapeHandler(_ pupilShape: String) -> QRCodePupilShapeGenerator {
	QRCodePupilShapeFactory.shared.named(pupilShape)!
}
