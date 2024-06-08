//
//  QRCode+Detection.swift
//
//  Copyright © 2024 Darren Ford. All rights reserved.
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

#if !os(watchOS)

import CoreGraphics
import CoreImage
import Foundation

public extension QRCode {

	/// QRCode detection accuracy
	@objc(QRCodeDetectionAccuracy) enum DetectionAccuracy: Int {
		/// Faster but less accurate
		case low = 0
		/// Slower but more accurate
		case high = 1

		/// Mapping between `DetectionAccuracy` and the `CIDetectorAccuracy` strings
		@inlinable internal var mode: String {
			switch self {
			case .low: return CIDetectorAccuracyLow
			case .high: return CIDetectorAccuracyHigh
			}
		}
	}

	/// Detect QR code(s) in the specified image using CoreImage
	/// - Parameters:
	///   - cgImage: The image in which to detect QRCodes
	///   - accuracy: The accuracy to use when detecting codes. `.low` is faster, but less accurate.
	/// - Returns: An array of detected QR Codes
	///
	/// Note: If the QR code contains raw data (ie. not a string) CoreImage has no mechanism to extract raw data.
	@objc static func DetectQRCodes(_ cgImage: CGImage, accuracy: DetectionAccuracy = .high) -> [CIQRCodeFeature] {
		var options: [String: Any] = [CIDetectorAccuracy: accuracy.mode]
		let context = CIContext()
		let ciImage = CIImage(cgImage: cgImage)
		guard let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options) else {
			return []
		}
		if ciImage.properties.keys.contains(kCGImagePropertyOrientation as String) {
			options = [CIDetectorImageOrientation: ciImage.properties[kCGImagePropertyOrientation as String] ?? 1]
		}
		else {
			options = [CIDetectorImageOrientation: 1]
		}
		return qrDetector
			.features(in: ciImage, options: options)
			.compactMap { $0 as? CIQRCodeFeature }
	}

	/// Detect QR coded strings in the specified image using CoreImage
	/// - Parameters:
	///   - cgImage: The image in which to detect QRCodes
	///   - accuracy: The accuracy to use when detecting codes. `.low` is faster, but less accurate.
	/// - Returns: An array of detected qrcode-encoded strings within the image
	///
	/// Note: If the QR code contains raw data (ie. not a string) CoreImage has no mechanism to extract raw data.
	@objc @inlinable static func DetectQRStrings(_ cgImage: CGImage, accuracy: DetectionAccuracy = .high) -> [String] {
		QRCode.DetectQRCodes(cgImage, accuracy: accuracy)
			.compactMap { $0.messageString }
	}
}

public extension CGImage {
	/// Returns all qrcode strings that were encoded in this image
	/// - Returns: An array of detected qr code strings
	///
	/// Note: If the QR code contains raw data (ie. not a string) CoreImage has no mechanism to extract raw data.
	@inlinable func detectQRCodeStrings() -> [String] {
		return QRCode.DetectQRStrings(self)
	}
}

#endif

#if os(macOS)

import AppKit
public extension QRCode {
	/// Detect QR code(s) in the specified image
	/// - Parameter image: The image in which to detect QRCodes
	/// - Returns: An array of detected QR Codes
	///
	/// Note: If the QR code contains raw data (ie. not a string) CoreImage has no mechanism to extract raw data.
	@objc static func DetectQRCodes(in image: NSImage) -> [CIQRCodeFeature] {
		guard let im = image.cgImage else { return [] }
		return Self.DetectQRCodes(im)
	}
}

#elseif os(iOS) || os(tvOS) || os(visionOS)

import UIKit
public extension QRCode {
	/// Detect QR code(s) in the specified image
	/// - Parameter image: The image in which to detect QRCodes
	/// - Returns: An array of detected QR Codes
	///
	/// Note: If the QR code contains raw data (ie. not a string) CoreImage has no mechanism to extract raw data.
	@objc static func DetectQRCodes(in image: UIImage) -> [CIQRCodeFeature] {
		guard let im = image.cgImage else { return [] }
		return Self.DetectQRCodes(im)
	}
}

#endif
