//
//  Copyright © 2025 Darren Ford. All rights reserved.
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

import CoreGraphics
import Foundation

internal extension QRCode.PixelShape {
	// A data shape generator where every pixel in the qr code becomes a discrete shape
	class CommonPixelGenerator {
		enum PixelType: String, CaseIterable {
			case square
			case circle
			case crt
			case roundedRect
			case squircle
			case sharp
			case star
			case heart
			case flower
			case shiny
			case arrow
			case wave
			case spikyCircle
			case stitch
			case hexagon
			case wex
			case diamond
			case koala
			case diagonal
			case flame
			static var availableTypes: [String] = Self.allCases.map { $0.rawValue }
		}

		let pixelType: PixelType

		// Pixel inset routine
		var insetGenerator: QRCodePixelInsetGenerator

		// The inset fraction
		var insetFraction: CGFloat = 0

		// The fractional corner radius for the pixel (0.0 -> 1.0)
		var cornerRadiusFraction: CGFloat

		// Pixel inset routine
		var rotationGenerator: QRCodePixelRotationGenerator

		// The rotation for each pixel (0.0 -> 1.0)
		var rotationFraction: CGFloat = 0

		/// Create
		/// - Parameters:
		///   - pixelType: The type of pixel to use (eg. square, circle)
		///   - cornerRadiusFraction: For types that support it, the roundedness of the corners (0 -> 1)
		///   - insetGenerator: The inset function to apply across the matrix
		///   - insetFraction: The inset within the each pixel to generate the pixel's path (0 -> 1)
		///   - rotationGenerator: The rotation function to apply across the matrix
		///   - rotationFraction: The rotation fraction (-1.0 -> 1.0) to apply to the rotation of each pixel
		init(
			pixelType: PixelType,
			cornerRadiusFraction: CGFloat = 0,
			insetGenerator: QRCodePixelInsetGenerator = QRCode.PixelInset.Fixed(),
			insetFraction: CGFloat = 0,
			rotationGenerator: QRCodePixelRotationGenerator = QRCode.PixelRotation.Fixed(),
			rotationFraction: CGFloat = 0
		) {
			self.pixelType = pixelType

			self.insetGenerator = insetGenerator
			self.insetFraction = insetFraction

			self.cornerRadiusFraction = cornerRadiusFraction.clamped(to: 0 ... 1)

			self.rotationGenerator = rotationGenerator
			self.rotationFraction = rotationFraction.clamped(to: -1 ... 1)
		}

		func generatePath(from matrix: BoolMatrix, size: CGSize) -> CGPath {
			let dx = size.width / CGFloat(matrix.dimension)
			let dy = size.height / CGFloat(matrix.dimension)
			let dm = min(dx, dy)

			let xoff = (size.width - (CGFloat(matrix.dimension) * dm)) / 2.0
			let yoff = (size.height - (CGFloat(matrix.dimension) * dm)) / 2.0

			let path = CGMutablePath()

			// Reset the inset generator
			self.insetGenerator.reset()

			// Reset the rotation generator
			self.rotationGenerator.reset()

			for row in 0 ..< matrix.dimension {
				for col in 0 ..< matrix.dimension {
					// If the pixel is 'off' then we move on to the next
					guard matrix[row, col] == true else { continue }

					// Calculate the required pixel inset
					let insetFraction = self.insetGenerator.insetValue(
						for: matrix,
						row: row,
						column: col,
						insetFraction: self.insetFraction
					)

					let origX = xoff + (CGFloat(col) * dm) + (dm / 2)
					let origY = yoff + (CGFloat(row) * dm) + (dm / 2)

					let r = CGRect(x: xoff + (CGFloat(col) * dm), y: yoff + (CGFloat(row) * dm), width: dm, height: dm)
					let insetValue = insetFraction * (r.height / 2.0)
					let ri = r.insetBy(dx: insetValue, dy: insetValue)

					// Calculate the rotation
					let rotationValue = self.rotationGenerator.rotationValue(
						for: matrix,
						row: row,
						column: col,
						rotationFraction: self.rotationFraction
					)

					let rotatetfm = CGAffineTransform(rotationAngle: rotationValue * (CGFloat.pi * 2))
					var rotateTransform = CGAffineTransform(translationX: -origX, y: -origY)
						.concatenating(rotatetfm)
						.concatenating(CGAffineTransform(translationX: origX, y: origY))

					if self.pixelType == .roundedRect {
						let cr = (ri.height / 2.0) * self.cornerRadiusFraction
						path.addPath(CGPath(roundedRect: ri, cornerWidth: cr, cornerHeight: cr, transform: &rotateTransform))
					}
					else if self.pixelType == .circle {
						let transform = CGAffineTransform(scaleX: ri.width / 10, y: ri.width / 10)
							.concatenating(CGAffineTransform(
								translationX: xoff + (CGFloat(col) * dm) + insetValue,
								y: yoff + (CGFloat(row) * dm) + insetValue
							))
						path.addPath(Circle.Circle10x10, transform: transform)
					}
					else if self.pixelType == .squircle {
						let transform = CGAffineTransform(scaleX: ri.width / 10, y: ri.width / 10)
							.concatenating(CGAffineTransform(
								translationX: xoff + (CGFloat(col) * dm) + insetValue,
								y: yoff + (CGFloat(row) * dm) + insetValue
							))
							.concatenating(rotateTransform)

						let sq = Squircle.squircle10x10()
						path.addPath(sq, transform: transform)
					}
					else if self.pixelType == .crt {
						let transform = CGAffineTransform(scaleX: ri.width / 10, y: ri.width / 10)
							.concatenating(CGAffineTransform(
								translationX: xoff + (CGFloat(col) * dm) + insetValue,
								y: yoff + (CGFloat(row) * dm) + insetValue
							))
							.concatenating(rotateTransform)

						let sq = CRT.crtPixel10x10()
						path.addPath(sq, transform: transform)
					}
					else if self.pixelType == .sharp {
						let transform = CGAffineTransform(scaleX: ri.width / 10, y: ri.width / 10)
							.concatenating(CGAffineTransform(
								translationX: xoff + (CGFloat(col) * dm) + insetValue,
								y: yoff + (CGFloat(row) * dm) + insetValue
							))
							.concatenating(rotateTransform)

						let sq = Sharp.sharp10x10()
						path.addPath(sq, transform: transform)
					}
					else if self.pixelType == .star {
						let transform = CGAffineTransform(scaleX: ri.width / 10, y: ri.width / 10)
							.concatenating(CGAffineTransform(
								translationX: xoff + (CGFloat(col) * dm) + insetValue,
								y: yoff + (CGFloat(row) * dm) + insetValue
							))
							.concatenating(rotateTransform)
						let sq = Star.star10x10()
						path.addPath(sq, transform: transform)
					}
					else if self.pixelType == .heart {
						let transform = CGAffineTransform(scaleX: ri.width / 10, y: ri.width / 10)
							.concatenating(CGAffineTransform(
								translationX: xoff + (CGFloat(col) * dm) + insetValue,
								y: yoff + (CGFloat(row) * dm) + insetValue
							))
							.concatenating(rotateTransform)
						let sq = Heart.heart10x10()
						path.addPath(sq, transform: transform)
					}
					else if self.pixelType == .spikyCircle {
						let transform = CGAffineTransform(scaleX: ri.width / 10, y: ri.width / 10)
							.concatenating(CGAffineTransform(
								translationX: xoff + (CGFloat(col) * dm) + insetValue,
								y: yoff + (CGFloat(row) * dm) + insetValue
							))
							.concatenating(rotateTransform)
						let sq = SpikyCircle.spikyCircle10x10()
						path.addPath(sq, transform: transform)
					}
					else if self.pixelType == .arrow {
						let transform = CGAffineTransform(scaleX: ri.width / 10, y: ri.width / 10)
							.concatenating(CGAffineTransform(
								translationX: xoff + (CGFloat(col) * dm) + insetValue,
								y: yoff + (CGFloat(row) * dm) + insetValue
							))
							.concatenating(rotateTransform)
						let sq = Arrow.arrow10x10()
						path.addPath(sq, transform: transform)
					}
					else if self.pixelType == .diamond {
						let transform = CGAffineTransform(scaleX: ri.width / 10, y: ri.width / 10)
							.concatenating(CGAffineTransform(
								translationX: xoff + (CGFloat(col) * dm) + insetValue,
								y: yoff + (CGFloat(row) * dm) + insetValue
							))
							.concatenating(rotateTransform)
						let sq = Diamond.diamond10x10()
						path.addPath(sq, transform: transform)
					}
					else if self.pixelType == .wave {
						let transform = CGAffineTransform(scaleX: ri.width / 10, y: ri.width / 10)
							.concatenating(CGAffineTransform(
								translationX: xoff + (CGFloat(col) * dm) + insetValue,
								y: yoff + (CGFloat(row) * dm) + insetValue
							))
							.concatenating(rotateTransform)
						let sq = Wave.wave10x10()
						path.addPath(sq, transform: transform)
					}
					else if self.pixelType == .flower {
						let transform = CGAffineTransform(scaleX: ri.width / 10, y: ri.width / 10)
							.concatenating(CGAffineTransform(
								translationX: xoff + (CGFloat(col) * dm) + insetValue,
								y: yoff + (CGFloat(row) * dm) + insetValue
							))
							.concatenating(rotateTransform)
						let sq = Flower.flower10x10()
						path.addPath(sq, transform: transform)
					}
					else if self.pixelType == .shiny {
						let transform = CGAffineTransform(scaleX: ri.width / 8, y: ri.width / 8)
							.concatenating(CGAffineTransform(
								translationX: xoff + (CGFloat(col) * dm),
								y: yoff + (CGFloat(row) * dm)
							))
							.concatenating(CGAffineTransform(
								translationX: -(ri.width / 8),
								y: -(ri.width / 8)
							))
						let sq = Shiny.pathShiny(row: row, col: col)
						path.addPath(sq, transform: transform)
					}
					else if self.pixelType == .stitch {
						let transform = CGAffineTransform(scaleX: ri.width / 10, y: ri.width / 10)
							.concatenating(CGAffineTransform(
								translationX: xoff + (CGFloat(col) * dm),
								y: yoff + (CGFloat(row) * dm)
							))
						path.addPath(Stitch.pixelShape_, transform: transform)
					}
					else if self.pixelType == .hexagon {
						let transform = CGAffineTransform(scaleX: ri.width / 10, y: ri.width / 10)
							.concatenating(CGAffineTransform(
								translationX: xoff + (CGFloat(col) * dm) + insetValue,
								y: yoff + (CGFloat(row) * dm) + insetValue
							))
							.concatenating(rotateTransform)
						let sq = Hexagon.HexagonPixel10x10
						path.addPath(sq, transform: transform)
					}
					else if self.pixelType == .wex {
						let transform = CGAffineTransform(scaleX: ri.width / 10, y: ri.width / 10)
							.concatenating(CGAffineTransform(
								translationX: xoff + (CGFloat(col) * dm) + insetValue,
								y: yoff + (CGFloat(row) * dm) + insetValue
							))
							.concatenating(rotateTransform)
						let sq = Wex.WexPixel10x10
						path.addPath(sq, transform: transform)
					}
					else if self.pixelType == .koala {
						let transform = CGAffineTransform(scaleX: ri.width / 10, y: ri.width / 10)
							.concatenating(CGAffineTransform(
								translationX: xoff + (CGFloat(col) * dm) + insetValue,
								y: yoff + (CGFloat(row) * dm) + insetValue
							))
							.concatenating(rotateTransform)
						let sq = Koala.koala10x10()
						path.addPath(sq, transform: transform)
					}
					else if self.pixelType == .flame {
						let transform = CGAffineTransform(scaleX: ri.width / 10, y: ri.width / 10)
							.concatenating(CGAffineTransform(
								translationX: xoff + (CGFloat(col) * dm) + insetValue,
								y: yoff + (CGFloat(row) * dm) + insetValue
							))
							.concatenating(rotateTransform)
						let sq = Flame.flame10x10()
						path.addPath(sq, transform: transform)
					}
					else if self.pixelType == .diagonal {
						let transform = CGAffineTransform(scaleX: ri.width / 10, y: ri.width / 10)
							.concatenating(CGAffineTransform(
								translationX: xoff + (CGFloat(col) * dm) + insetValue,
								y: yoff + (CGFloat(row) * dm) + insetValue
							))
							.concatenating(rotateTransform)
						let sq = Diagonal.diagonal10x10()
						path.addPath(sq, transform: transform)
					}
					else if self.pixelType == .square {
						let transform = CGAffineTransform(scaleX: ri.width / 10, y: ri.width / 10)
							.concatenating(CGAffineTransform(
								translationX: xoff + (CGFloat(col) * dm) + insetValue,
								y: yoff + (CGFloat(row) * dm) + insetValue
							))
							.concatenating(rotateTransform)
						path.addPath(Square.Square10x10, transform: transform)
					}
					else {
						path.addPath(CGPath(rect: ri, transform: &rotateTransform))
					}
				}
			}
			return path
		}
	}
}

extension QRCode.PixelShape.CommonPixelGenerator {

	// Inset

	func setInsetFractionValue(_ value: Any?) -> Bool {
		guard let v = value else {
			self.insetFraction = 0
			return true
		}
		guard let v = CGFloatValue(v) else { return false }
		self.insetFraction = v
		return true
	}

	func setInsetGenerator(_ generator: QRCodePixelInsetGenerator) -> Bool {
		self.insetGenerator = generator
		return true
	}

	func setInsetGenerator(named value: Any?) -> Bool {
		guard
			let v = value as? String,
			let generator = QRCode.PixelInset.generator(named: v)
		else {
			return false
		}
		self.insetGenerator = generator
		return true
	}

	// Rotation

	func setRotationFraction(_ value: Any?) -> Bool {
		guard let v = value, let v = CGFloatValue(v) else {
			self.rotationFraction = 0.0
			return true
		}
		self.rotationFraction = v
		return true
	}

	func setRotationGenerator(named value: Any?) -> Bool {
		guard
			let v = value as? String,
			let generator = QRCode.PixelRotation.generator(named: v)
		else {
			return false
		}
		self.rotationGenerator = generator
		return true
	}

	// Corner radius fraction

	func setCornerRadiusFraction(_ value: Any?) -> Bool {
		guard let v = value else {
			self.cornerRadiusFraction = 0
			return true
		}
		guard let v = CGFloatValue(v)?.clamped(to: 0 ... 1) else { return false }
		self.cornerRadiusFraction = v
		return true
	}
}
