//
//  QRCode+Platform
//
//  Created by Darren Ford on 20/11/21.
//  Copyright © 2021 Darren Ford. All rights reserved.
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

// Platform specific routines

import Foundation

#if os(macOS)
import AppKit
#else
import UIKit
#endif

#if canImport(SwiftUI)
import SwiftUI
#endif

#if os(iOS) || os(tvOS) || os(watchOS)
extension CGColor {
	/// Convenience for a 'clear' color
	static let clear = CGColor(gray: 0, alpha: 0)
}
#endif

#if os(macOS)
public extension QRCode {
	/// Returns an NSImage representation of the qr code using the specified style
	/// - Parameters:
	///   - size: The pixel size of the image to generate
	///   - scale: The scale
	///   - design: The design for the qr code
	/// - Returns: The image, or nil if an error occurred
	@objc func nsImage(
		_ size: CGSize,
		scale: CGFloat = 1,
		design: QRCode.Design = QRCode.Design()) -> NSImage?
	{
		guard let qrImage = self.cgImage(size, design: design) else { return nil }
		return NSImage(cgImage: qrImage, size: .zero)
	}
}
#endif

#if os(iOS) || os(tvOS) || os(watchOS)
public extension QRCode {
	/// Returns a UIImage representation of the qr code using the specified style
	/// - Parameters:
	///   - size: The pixel size of the image to generate
	///   - scale: The scale
	///   - design: The design for the qr code
	/// - Returns: The image, or nil if an error occurred
	@objc func uiImage(
		_ size: CGSize,
		scale: CGFloat = 1,
		design: QRCode.Design = QRCode.Design()) -> UIImage?
	{
		guard let qrImage = self.cgImage(size, design: design) else { return nil }
		return UIImage(cgImage: qrImage)
	}
}
#endif

#if canImport(SwiftUI)
@available(macOS 11, iOS 13, tvOS 13, *)
public extension QRCode {
	/// Create a SwiftUI Image object for the QR code
	/// - Parameters:
	///   - size: The pixel size of the image to generate
	///   - scale: The scale
	///   - design: The design for the qr code
	///   - label: The label associated with the image. SwiftUI uses the label for accessibility.
	/// - Returns: An image, or nil if an error occurred
	func imageUI(
		_ size: CGSize,
		scale: CGFloat = 1,
		design: QRCode.Design = QRCode.Design(),
		label: Text) -> SwiftUI.Image?
	{
		guard let qrImage = self.cgImage(size, design: design) else { return nil }
		return SwiftUI.Image(qrImage, scale: 1, label: label)
	}
}
#endif
