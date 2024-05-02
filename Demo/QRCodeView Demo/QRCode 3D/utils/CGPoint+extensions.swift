//
//  CGPoint+extensions.swift
//  QRCode 3D
//
//  Created by Darren Ford on 2/5/2024.
//

import Foundation
import CoreGraphics
import SwiftUI

extension CGPoint {
	var unitPoint: UnitPoint { UnitPoint(x: max(0, min(1, x)), y: max(0, min(1, y))) }
}

extension UnitPoint {
	var cgPoint: CGPoint { CGPoint(x: x, y: y) }
}
