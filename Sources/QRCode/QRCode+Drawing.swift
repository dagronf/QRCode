//
//  QRCode+Drawing.swift
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

// MARK: - Drawing

public extension QRCode {
	/// Draw the current qrcode into the context using the specified style
	@objc func draw(
		ctx: CGContext,
		rect: CGRect,
		design: QRCode.Design,
		logoTemplate: QRCode.LogoTemplate? = nil
	) {
		// Only works with a 1:1 rect
		let sz = min(rect.width, rect.height)

		let dx = sz / CGFloat(self.cellDimension)
		let dy = sz / CGFloat(self.cellDimension)

		let dm = min(dx, dy)

		let xoff = (rect.width - (CGFloat(self.cellDimension) * dm)) / 2.0
		let yoff = (rect.height - (CGFloat(self.cellDimension) * dm)) / 2.0

		// This is the final position for the generated qr code
		let finalRect = CGRect(x: xoff, y: yoff, width: sz, height: sz)

		let style = design.style

		// Fill the background first
		let backgroundStyle = style.background ?? QRCode.FillStyle.clear
		ctx.usingGState { context in
			backgroundStyle.fill(ctx: context, rect: finalRect)
		}

		if design.shape.negatedOnPixelsOnly {
			var negatedMatrix = self.boolMatrix.inverted()
			if let logoTemplate = logoTemplate {
				negatedMatrix = logoTemplate.applyingMask(matrix: negatedMatrix, dimension: sz)
			}
			let negatedPath = design.shape.onPixels.generatePath(from: negatedMatrix, size: CGSize(dimension: sz))
			ctx.usingGState { context in
				style.onPixels.fill(ctx: context, rect: rect, path: negatedPath)
			}
		}
		else {
			// Draw the background color behind the eyes
			if let eColor = design.style.eyeBackground {
				let eyeBackgroundPath = self.path(rect.size, components: .eyeBackground, shape: design.shape)
				ctx.usingGState { context in
					ctx.setFillColor(eColor)
					ctx.addPath(eyeBackgroundPath)
					ctx.fillPath()
				}
			}

			// Draw the outer eye
			let eyeOuterPath = self.path(rect.size, components: .eyeOuter, shape: design.shape)
			ctx.usingGState { context in
				style.actualEyeStyle.fill(ctx: context, rect: rect, path: eyeOuterPath)
			}

			// Draw the eye 'pupil'
			let eyePupilPath = self.path(rect.size, components: .eyePupil, shape: design.shape)
			ctx.usingGState { context in
				style.actualPupilStyle.fill(ctx: context, rect: rect, path: eyePupilPath)
			}

			// Now, the 'on' pixels background
			if let c = design.style.onPixelsBackground {
				onPixelBackgroundDesign.style.onPixels = QRCode.FillStyle.Solid(c)
				let qrPath2 = self.path(rect.size, components: .onPixels, shape: onPixelBackgroundDesign.shape, logoTemplate: logoTemplate)
				ctx.usingGState { context in
					onPixelBackgroundDesign.style.onPixels.fill(ctx: context, rect: rect, path: qrPath2)
				}
			}

			// Now, the 'on' pixels
			let qrPath = self.path(rect.size, components: .onPixels, shape: design.shape, logoTemplate: logoTemplate)
			ctx.usingGState { context in
				style.onPixels.fill(ctx: context, rect: rect, path: qrPath)
			}

			// The 'off' pixels ONLY IF the user specifies both a offPixels shape AND an offPixels style.
			if let s = style.offPixels, let _ = design.shape.offPixels {
				// Draw the 'off' pixels background IF the caller has set a color
				if let c = design.style.offPixelsBackground {
					offPixelBackgroundDesign.style.offPixels = QRCode.FillStyle.Solid(c)
					let qrPath2 = self.path(rect.size, components: .offPixels, shape: offPixelBackgroundDesign.shape, logoTemplate: logoTemplate)
					ctx.usingGState { context in
						offPixelBackgroundDesign.style.offPixels?.fill(ctx: context, rect: rect, path: qrPath2)
					}
				}

				let qrPath = self.path(rect.size, components: .offPixels, shape: design.shape, logoTemplate: logoTemplate)
				ctx.usingGState { context in
					s.fill(ctx: context, rect: rect, path: qrPath)
				}
			}
		}

		if let logoTemplate = logoTemplate {
			ctx.saveGState()
			// Get the absolute rect within the generated image of the mask path
			let absMask = logoTemplate.absolutePathForMaskPath(dimension: sz, flipped: true)

			// logo drawing is flipped.
			ctx.scaleBy(x: 1, y: -1)
			ctx.translateBy(x: xoff, y: yoff - sz)

			// Clip to the mask path.
			ctx.addPath(absMask)
			ctx.clip()

			// Draw the logo image into the mask bounds
			ctx.draw(logoTemplate.image, in: absMask.boundingBoxOfPath.insetBy(dx: logoTemplate.inset, dy: logoTemplate.inset))
			ctx.restoreGState()
		}
	}
}
