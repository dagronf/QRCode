//
//  GradientStop.swift
//  QRCode 3D
//
//  Created by Darren Ford on 30/4/2024.
//

import Foundation
import SwiftUI

public struct GradientStop: Identifiable, Equatable {
	public init(isMovable: Bool, unit: CGFloat, color: CGColor) {
		self.isMovable = isMovable
		self.unit = unit
		self.color = color
	}

	public let id = UUID()
	public let isMovable: Bool
	public var unit: CGFloat
	public var color: CGColor
}
