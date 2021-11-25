//
//  Shared.swift
//  QRCodeView Demo
//
//  Created by Darren Ford on 25/11/21.
//

import SwiftUI
import QRCode

enum DataShapeType {
	case square
	case roundrect
	case circle
	case horizontal
	case vertical
	case roundedpath
}

enum EyeShapeType {
	case square
	case circle
	case leaf
	case roundedRect
	case roundedOuter
	case roundedPointingIn
	case squircle
}

func dataShapeHandler(_ dataShape: DataShapeType) -> QRCodeDataShapeHandler {
	switch dataShape {
	case .square:
		return QRCode.DataShape.Pixel(pixelType: .square)
	case .roundrect:
		return QRCode.DataShape.Pixel(pixelType: .roundedRect, cornerRadiusFraction: 0.7)
	case .circle:
		return QRCode.DataShape.Pixel(pixelType: .circle)
	case .horizontal:
		return QRCode.DataShape.Horizontal(inset: 0.5, cornerRadiusFraction: 1)
	case .vertical:
		return QRCode.DataShape.Vertical(inset: 0.5, cornerRadiusFraction: 1)
	case.roundedpath:
		return QRCode.DataShape.RoundedPath()
	}
}

func eyeShapeHandler(_ eyeStyle: EyeShapeType) -> QRCodeEyeShapeHandler {
	switch eyeStyle {
	case .square:
		return QRCode.EyeShape.Square()
	case .roundedRect:
		return QRCode.EyeShape.RoundedRect()
	case .circle:
		return QRCode.EyeShape.Circle()
	case .leaf:
		return QRCode.EyeShape.Leaf()
	case .roundedOuter:
		return QRCode.EyeShape.RoundedOuter()
	case .roundedPointingIn:
		return QRCode.EyeShape.RoundedPointingIn()
	case .squircle:
		return QRCode.EyeShape.Squircle()
	}
}
