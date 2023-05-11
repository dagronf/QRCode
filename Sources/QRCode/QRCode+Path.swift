//
//  QRCode+Path.swift
//
//  Copyright © 2023 Darren Ford. All rights reserved.
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

// MARK: - QR Code path generation

public extension QRCode {
	/// The components of the QR code
	@objc(QRCodeComponents) class Components: NSObject, OptionSet {
		/// The outer ring of the eye
		public static let eyeOuter = Components(rawValue: 1 << 0)
		/// The pupil (center) of the eye
		public static let eyePupil = Components(rawValue: 1 << 1)
		/// All components of the eye
		public static let eyeAll: Components = [Components.eyeOuter, Components.eyePupil]

		/// The non-eye, 'on' pixels
		public static let onPixels = Components(rawValue: 1 << 2)
		/// The non-eye, 'off' pixels
		public static let offPixels = Components(rawValue: 1 << 3)
		/// The background of the eye
		public static let eyeBackground = Components(rawValue: 1 << 4)

		/// The path representing the 'negative' component of the qr code (ie. the off and on components are swapped)
		public static let negative = Components(rawValue: 1 << 5)

		/// The path for the background of the ON pixels in the QR Code
		public static let onPixelsBackground = Components(rawValue: 1 << 6)
		/// The path for the background of the OFF pixels in the QR Code
		public static let offPixelsBackground = Components(rawValue: 1 << 7)

		/// The entire qrcode without offPixels (default presentation)
		public static let all: Components = [Components.eyeOuter, Components.eyePupil, Components.onPixels]

		/// Every component of the QR code, including the off pixels
		public static let everything: Components = [
			Components.eyeOuter,
			Components.eyeBackground,
			Components.eyePupil,
			Components.onPixels,
			Components.offPixels
		]

		public var rawValue: Int8
		@objc public required init(rawValue: Int8) {
			self.rawValue = rawValue
		}

		// OptionSet requirement for class implementation (needed for Objective-C)

		public func contains(_ member: QRCode.Components) -> Bool {
			return (self.rawValue & member.rawValue) != 0
		}
	}

	/// Generate a path containing the QR Code components
	/// - Parameters:
	///   - size: The dimensions of the generated path
	///   - components: The components of the QR code to include in the path
	///   - shape: The shape definitions for genering the path components
	///   - logoTemplate: The definition for the logo
	///   - additionalQuietSpace: Additional spacing around the outside of the QR code
	/// - Returns: A path containing the components
	@objc func path(
		_ size: CGSize,
		components: Components = .all,
		shape: QRCode.Shape = QRCode.Shape(),
		logoTemplate: LogoTemplate? = nil,
		additionalQuietSpace: CGFloat = 0
	) -> CGPath {
		if self.cellDimension == 0 {
			// There is no data in the qrcode
			return CGPath(rect: .zero, transform: nil)
		}

		// The qrcode size is the smallest dimension of the rect
		let sz = min(size.width, size.height)

		let quietspaceTransform = CGAffineTransform(translationX: additionalQuietSpace, y: additionalQuietSpace)

		let dx = sz / CGFloat(self.cellDimension)
		let dy = sz / CGFloat(self.cellDimension)

		let dm = min(dx, dy)

		let xoff = (size.width - (CGFloat(self.cellDimension) * dm)) / 2.0
		let yoff = (size.height - (CGFloat(self.cellDimension) * dm)) / 2.0
		let posTransform = CGAffineTransform(translationX: xoff, y: yoff)

		let fitScale = (dm * 9) / 90
		var scaleTransform = CGAffineTransform.identity
		scaleTransform = scaleTransform.scaledBy(x: fitScale, y: fitScale)

		let path = CGMutablePath()

		if components.contains(.negative) {
			var current = self.current.inverted()
			if let template = logoTemplate {
				current = template.applyingMask(matrix: current, dimension: sz)
			}
			path.addPath(shape.onPixels.generatePath(from: current, size: size), transform: quietspaceTransform)
			return path
		}

		// The outer part of the eye
		let eyeShape = shape.eye

		// The background of the eye.

		if components.contains(.eyeBackground) {

			var plt = CGAffineTransform(scaleX: 1, y: -1)
				.concatenating(CGAffineTransform(translationX: 0, y: 90))

			let p = eyeShape.eyeBackgroundPath().copy(using: &plt)!
			var scaledTopLeft = scaleTransform.concatenating(posTransform).concatenating(quietspaceTransform)

			// top left
			let tl = p.copy(using: &scaledTopLeft)!
			path.addPath(tl)

			// bottom left
			var blt = CGAffineTransform(scaleX: 1, y: -1)
				.concatenating(CGAffineTransform(translationX: 0, y: 90))
				.concatenating(scaledTopLeft)

			var bl = p.copy(using: &blt)!
			var bltrans = CGAffineTransform(translationX: 0, y: (dm * CGFloat(self.cellDimension)) - (9 * dm))
			bl = bl.copy(using: &bltrans)!
			path.addPath(bl)

			// top right
			var tlt = CGAffineTransform(scaleX: -1, y: 1)
				.concatenating(CGAffineTransform(translationX: 90, y: 0))
				.concatenating(scaledTopLeft)

			var br = p.copy(using: &tlt)!
			var brtrans = CGAffineTransform(translationX: (dm * CGFloat(self.cellDimension)) - (9 * dm), y: 0)
			br = br.copy(using: &brtrans)!
			path.addPath(br)
		}

		if components.contains(.eyeOuter) {
			let p = eyeShape.eyePath()
			var scaledTopLeft = scaleTransform.concatenating(posTransform).concatenating(quietspaceTransform)

			// top left
			let tl = p.copy(using: &scaledTopLeft)!
			path.addPath(tl)

			// bottom left
			var blt = CGAffineTransform(scaleX: 1, y: -1)
				.concatenating(CGAffineTransform(translationX: 0, y: 90))
				.concatenating(scaledTopLeft)

			var bl = p.copy(using: &blt)!
			var bltrans = CGAffineTransform(translationX: 0, y: (dm * CGFloat(self.cellDimension)) - (9 * dm))
			bl = bl.copy(using: &bltrans)!
			path.addPath(bl)

			// top right
			var tlt = CGAffineTransform(scaleX: -1, y: 1)
				.concatenating(CGAffineTransform(translationX: 90, y: 0))
				.concatenating(scaledTopLeft)

			var br = p.copy(using: &tlt)!
			var brtrans = CGAffineTransform(translationX: (dm * CGFloat(self.cellDimension)) - (9 * dm), y: 0)
			br = br.copy(using: &brtrans)!
			path.addPath(br)
		}

		// Add the pupils if wanted

		if components.contains(.eyePupil) {
			let pupil = shape.actualPupilShape
			let p = pupil.pupilPath()
			var scaledTopLeft = scaleTransform.concatenating(posTransform).concatenating(quietspaceTransform)

			// top left
			let tl = p.copy(using: &scaledTopLeft)!
			path.addPath(tl)

			// bottom left
			var blt = CGAffineTransform(scaleX: 1, y: -1)
				.concatenating(CGAffineTransform(translationX: 0, y: 90))
				.concatenating(scaledTopLeft)

			var bl = p.copy(using: &blt)!
			var bltrans = CGAffineTransform(translationX: 0, y: (dm * CGFloat(self.cellDimension)) - (9 * dm))
			bl = bl.copy(using: &bltrans)!
			path.addPath(bl)

			// top right
			var tlt = CGAffineTransform(scaleX: -1, y: 1)
				.concatenating(CGAffineTransform(translationX: 90, y: 0))
				.concatenating(scaledTopLeft)

			var br = p.copy(using: &tlt)!
			var brtrans = CGAffineTransform(translationX: (dm * CGFloat(self.cellDimension)) - (9 * dm), y: 0)
			br = br.copy(using: &brtrans)!
			path.addPath(br)
		}

		// The background squares for the 'off' pixels
		if components.contains(.offPixelsBackground) {
			var masked = self.current.inverted()
			masked = masked.maskingQREyes(inverted: false)
			if let template = logoTemplate {
				masked = template.applyingMask(matrix: masked, dimension: sz)
			}
			path.addPath(QRCode.PixelShape.Square().generatePath(from: masked, size: size), transform: quietspaceTransform)
		}

		// 'off' pixels
		if components.contains(.offPixels) {
			let offPixelShape = shape.offPixels ?? QRCode.PixelShape.Square()

			var masked = self.current.inverted()
			masked = masked.maskingQREyes(inverted: false)
			if let template = logoTemplate {
				masked = template.applyingMask(matrix: masked, dimension: sz)
			}
			path.addPath(offPixelShape.generatePath(from: masked, size: size), transform: quietspaceTransform)
		}

		// The background squares for the 'on' pixels
		if components.contains(.onPixelsBackground) {
			var masked = self.current.maskingQREyes(inverted: false)
			if let template = logoTemplate {
				masked = template.applyingMask(matrix: masked, dimension: sz)
			}
			path.addPath(QRCode.PixelShape.Square().generatePath(from: masked, size: size), transform: quietspaceTransform)
		}

		// 'on' content
		if components.contains(.onPixels) {
			// Mask out the eyes
			var masked = self.current.maskingQREyes(inverted: false)
			if let template = logoTemplate {
				masked = template.applyingMask(matrix: masked, dimension: sz)
			}
			path.addPath(shape.onPixels.generatePath(from: masked, size: size), transform: quietspaceTransform)
		}

		return path
	}
}

public extension QRCode {

	func pathForSample(size: CGSize, pixelShape: QRCodePixelShapeGenerator) -> CGPath {
		let DummyData = BoolMatrix(dimension: 5, flattened: [
			false, false, true, true, false,
			false, false, false, true, false,
			true, false, true, true, true,
			true, true, true, true, false,
			false, false, true, false, true
		])
		return pathForSample(DummyData, size: size, pixelShape: pixelShape)
	}

	func pathForSample(_ matrix: BoolMatrix, size: CGSize, pixelShape: QRCodePixelShapeGenerator) -> CGPath {
		let qr = QRCode(generator: self.generator)
		qr.current = matrix
		let sh = QRCode.Shape()
		sh.onPixels = pixelShape
		return qr.path(size, components: [.onPixels], shape: sh)
	}
}
