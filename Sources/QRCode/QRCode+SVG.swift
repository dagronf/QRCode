//
//  QRCode+SVG.swift
//
//  Copyright © 2022 Darren Ford. All rights reserved.
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

import Foundation
import CoreGraphics

// QRCode SVG representation

public extension QRCode {
	/// Returns a string of SVG code for an image depicting this QR Code, with the given number of border modules.
	/// - Parameters:
	///   - outputDimension: The dimension of the output svg
	///   - border: The number of pixels for the border to the svg qrcode
	///   - foreground: The foreground color
	///   - background: The background color
	/// - Returns: An SVG representation of the QR code
	///
	/// Currently doesn't support any of the design formatting other than foreground and background colors.
	///
	/// The string always uses Unix newlines (\n), regardless of the platform.
	@objc func svg(
		outputDimension: UInt = 0,
		border: UInt = 0,
		foreground: CGColor = .black,
		background: CGColor? = nil
	) -> String {
		let border = Int(border)

		let size = self.boolMatrix.dimension
		let dimension = size + (border * 2)

		let scale: Double = {
			if outputDimension > 0 {
				return CGFloat(outputDimension) / CGFloat(dimension)
			}
			return 1.0
		}()

		let od = (outputDimension > 0) ? Int(outputDimension) : dimension

		// Colors

		let fc = foreground.hexCode() ?? "#000000"
		let bc = background?.hexCode()

		let backgroundRect: String = {
			if let bc = bc {
				return "<rect width=\"100%\" height=\"100%\" fill=\"\(bc)\"/>"
			}
			return ""
		}()

		let path = (0..<size).map { y in
			(0..<size).map { x in
				self.boolMatrix[x, y]
				? "\(x != 0 || y != 0 ? " " : "")M\((Double(x) + Double(border))*scale),\((Double(y) + Double(border))*scale)h\(scale)v\(scale)h-\(scale)z"
				: ""
			}.joined()
		}.joined()

		return """
			<?xml version="1.0" encoding="UTF-8"?>
			<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
			<svg xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 \(od) \(od)" stroke="none">
			\(backgroundRect)
			<path d="\(path)" fill="\(fc)"/>
			</svg>
			"""
	}
}
