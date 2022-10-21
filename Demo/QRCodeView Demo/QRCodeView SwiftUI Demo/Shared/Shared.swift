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

enum EyeShapeType: Int {
	case square = 0
	case circle = 1
	case leaf = 2
	case roundedRect = 3
	case roundedOuter = 4
	case roundedPointingIn = 5
	case squircle = 6
	case barHorizontal = 7
	case barVertical = 8
	case pixels = 9
}

enum PupilShapeType: Int {
	case square = 0
	case circle = 1
	case leaf = 2
	case roundedRect = 3
	case roundedOuter = 4
	case roundedPointingIn = 5
	case squircle = 6
	case barHorizontal = 7
	case barVertical = 8
	case pixels = 9
}

func pixelShapeHandler(_ pixelShape: PixelShapeType, insetFraction: Double = 0, cornerRadiusFraction: Double = 0) -> QRCodePixelShapeGenerator {
	switch pixelShape {
	case .square:
		return QRCode.PixelShape.Square(insetFraction: insetFraction)
	case .roundedrect:
		return QRCode.PixelShape.RoundedRect(insetFraction: insetFraction, cornerRadiusFraction: cornerRadiusFraction)
	case .circle:
		return QRCode.PixelShape.Circle(insetFraction: insetFraction)
	case .squircle:
		return QRCode.PixelShape.Squircle(insetFraction: insetFraction)
	case .horizontal:
		return QRCode.PixelShape.Horizontal(insetFraction: insetFraction, cornerRadiusFraction: cornerRadiusFraction)
	case .vertical:
		return QRCode.PixelShape.Vertical(insetFraction: insetFraction, cornerRadiusFraction: cornerRadiusFraction)
	case .roundedpath:
		return QRCode.PixelShape.RoundedPath(cornerRadiusFraction: cornerRadiusFraction)
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
	case .barHorizontal:
		return QRCode.EyeShape.BarsHorizontal()
	case .barVertical:
		return QRCode.EyeShape.BarsVertical()
	case .pixels:
		return QRCode.EyeShape.Pixels()
	}
}

func pupilShapeHandler(_ pupilShape: PupilShapeType) -> QRCodePupilShapeGenerator {
	switch pupilShape {
	case .square:
		return QRCode.PupilShape.Square()
	case .roundedRect:
		return QRCode.PupilShape.RoundedRect()
	case .circle:
		return QRCode.PupilShape.Circle()
	case .leaf:
		return QRCode.PupilShape.Leaf()
	case .roundedOuter:
		return QRCode.PupilShape.RoundedOuter()
	case .roundedPointingIn:
		return QRCode.PupilShape.RoundedPointingIn()
	case .squircle:
		return QRCode.PupilShape.Squircle()
	case .barHorizontal:
		return QRCode.PupilShape.BarsHorizontal()
	case .barVertical:
		return QRCode.PupilShape.BarsVertical()
	case .pixels:
		return QRCode.PupilShape.Pixels()
	}
}
