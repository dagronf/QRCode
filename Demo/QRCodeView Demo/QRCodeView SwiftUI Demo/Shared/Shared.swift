//
//  Shared.swift
//  QRCodeView Demo
//
//  Created by Darren Ford on 25/11/21.
//

import SwiftUI
import QRCode

enum PixelShapeType {
	case square
	case roundedrect
	case circle
	case squircle
	case horizontal
	case vertical
	case roundedpath
	case pointy
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

func pixelShapeHandler(_ pixelShape: PixelShapeType, inset: Double = 0, cornerRadiusFraction: Double = 0) -> QRCodePixelShapeGenerator {
	switch pixelShape {
	case .square:
		return QRCode.PixelShape.Square(inset: inset)
	case .roundedrect:
		return QRCode.PixelShape.RoundedRect(inset: inset, cornerRadiusFraction: cornerRadiusFraction)
	case .circle:
		return QRCode.PixelShape.Circle(inset: inset)
	case .squircle:
		return QRCode.PixelShape.Squircle(inset: inset)
	case .horizontal:
		return QRCode.PixelShape.Horizontal(inset: inset, cornerRadiusFraction: cornerRadiusFraction)
	case .vertical:
		return QRCode.PixelShape.Vertical(inset: inset, cornerRadiusFraction: cornerRadiusFraction)
	case .roundedpath:
		return QRCode.PixelShape.RoundedPath()
	case .pointy:
		return QRCode.PixelShape.Pointy()
	}
}

func eyeShapeHandler(_ eyeStyle: EyeShapeType) -> QRCodeEyeShapeGenerator {
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
