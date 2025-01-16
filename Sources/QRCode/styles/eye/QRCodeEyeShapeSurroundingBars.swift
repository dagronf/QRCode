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

public extension QRCode.EyeShape {
	/// An eye generator drawing Rounded bars surrounging the pupil
	@objc(QRCodeEyeShapeSurroundingBars) class SurroundingBars: NSObject, QRCodeEyeShapeGenerator {
		@objc public static let Name = "surroundingBars"
		@objc public static var Title: String { "Surrounding bars" }
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodeEyeShapeGenerator { SurroundingBars() }

		/// Returns a storable representation of the shape handler
		@objc public func settings() -> [String: Any] { return [:] }
		/// Does the shape generator support setting values for a particular key?
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		/// Set a configuration value for a particular setting key
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodeEyeShapeGenerator { SurroundingBars() }
		/// Reset the eye shape generator back to defaults
		@objc public func reset() { }
		/// Return the default pupil generator for this eye
		@objc public func defaultPupil() -> any QRCodePupilShapeGenerator { self.defaultPupil__ }

		/// The eye path
		@objc public func eyePath() -> CGPath { eyePath__ }
		/// The eye's background path
		@objc public func eyeBackgroundPath() -> CGPath { eyeBackgroundPath__ }

		// private
		private let defaultPupil__ = QRCode.PupilShape.RoundedRect()
	}
}

public extension QRCodeEyeShapeGenerator where Self == QRCode.EyeShape.SurroundingBars {
	/// Create a bars eye shape generator
	/// - Returns: An eye shape generator
	@inlinable static func surroundingBars() -> QRCodeEyeShapeGenerator { QRCode.EyeShape.SurroundingBars() }
}

// MARK: - Paths

private let eyePath__: CGPath =
	CGPath.make { eyeouterpathPath in
		eyeouterpathPath.move(to: CGPoint(x: 10, y: 25))
		eyeouterpathPath.curve(to: CGPoint(x: 15, y: 20), controlPoint1: CGPoint(x: 10, y: 22.24), controlPoint2: CGPoint(x: 12.24, y: 20))
		eyeouterpathPath.line(to: CGPoint(x: 15, y: 20))
		eyeouterpathPath.curve(to: CGPoint(x: 20, y: 25), controlPoint1: CGPoint(x: 17.76, y: 20), controlPoint2: CGPoint(x: 20, y: 22.24))
		eyeouterpathPath.line(to: CGPoint(x: 20, y: 65))
		eyeouterpathPath.curve(to: CGPoint(x: 15, y: 70), controlPoint1: CGPoint(x: 20, y: 67.76), controlPoint2: CGPoint(x: 17.76, y: 70))
		eyeouterpathPath.line(to: CGPoint(x: 15, y: 70))
		eyeouterpathPath.curve(to: CGPoint(x: 10, y: 65), controlPoint1: CGPoint(x: 12.24, y: 70), controlPoint2: CGPoint(x: 10, y: 67.76))
		eyeouterpathPath.line(to: CGPoint(x: 10, y: 25))
		eyeouterpathPath.close()
		eyeouterpathPath.move(to: CGPoint(x: 70, y: 25))
		eyeouterpathPath.curve(to: CGPoint(x: 75, y: 20), controlPoint1: CGPoint(x: 70, y: 22.24), controlPoint2: CGPoint(x: 72.24, y: 20))
		eyeouterpathPath.line(to: CGPoint(x: 75, y: 20))
		eyeouterpathPath.curve(to: CGPoint(x: 80, y: 25), controlPoint1: CGPoint(x: 77.76, y: 20), controlPoint2: CGPoint(x: 80, y: 22.24))
		eyeouterpathPath.line(to: CGPoint(x: 80, y: 65))
		eyeouterpathPath.curve(to: CGPoint(x: 75, y: 70), controlPoint1: CGPoint(x: 80, y: 67.76), controlPoint2: CGPoint(x: 77.76, y: 70))
		eyeouterpathPath.line(to: CGPoint(x: 75, y: 70))
		eyeouterpathPath.curve(to: CGPoint(x: 70, y: 65), controlPoint1: CGPoint(x: 72.24, y: 70), controlPoint2: CGPoint(x: 70, y: 67.76))
		eyeouterpathPath.line(to: CGPoint(x: 70, y: 25))
		eyeouterpathPath.close()
		eyeouterpathPath.move(to: CGPoint(x: 20, y: 75))
		eyeouterpathPath.curve(to: CGPoint(x: 25, y: 70), controlPoint1: CGPoint(x: 20, y: 72.24), controlPoint2: CGPoint(x: 22.24, y: 70))
		eyeouterpathPath.line(to: CGPoint(x: 65, y: 70))
		eyeouterpathPath.curve(to: CGPoint(x: 70, y: 75), controlPoint1: CGPoint(x: 67.76, y: 70), controlPoint2: CGPoint(x: 70, y: 72.24))
		eyeouterpathPath.line(to: CGPoint(x: 70, y: 75))
		eyeouterpathPath.curve(to: CGPoint(x: 65, y: 80), controlPoint1: CGPoint(x: 70, y: 77.76), controlPoint2: CGPoint(x: 67.76, y: 80))
		eyeouterpathPath.line(to: CGPoint(x: 25, y: 80))
		eyeouterpathPath.curve(to: CGPoint(x: 20, y: 75), controlPoint1: CGPoint(x: 22.24, y: 80), controlPoint2: CGPoint(x: 20, y: 77.76))
		eyeouterpathPath.close()
		eyeouterpathPath.move(to: CGPoint(x: 20, y: 15))
		eyeouterpathPath.curve(to: CGPoint(x: 25, y: 10), controlPoint1: CGPoint(x: 20, y: 12.24), controlPoint2: CGPoint(x: 22.24, y: 10))
		eyeouterpathPath.line(to: CGPoint(x: 65, y: 10))
		eyeouterpathPath.curve(to: CGPoint(x: 70, y: 15), controlPoint1: CGPoint(x: 67.76, y: 10), controlPoint2: CGPoint(x: 70, y: 12.24))
		eyeouterpathPath.line(to: CGPoint(x: 70, y: 15))
		eyeouterpathPath.curve(to: CGPoint(x: 65, y: 20), controlPoint1: CGPoint(x: 70, y: 17.76), controlPoint2: CGPoint(x: 67.76, y: 20))
		eyeouterpathPath.line(to: CGPoint(x: 25, y: 20))
		eyeouterpathPath.curve(to: CGPoint(x: 20, y: 15), controlPoint1: CGPoint(x: 22.24, y: 20), controlPoint2: CGPoint(x: 20, y: 17.76))
		eyeouterpathPath.close()
	}

private let eyeBackgroundPath__: CGPath =
	CGPath.make { eyebackgroundpathPath in
		eyebackgroundpathPath.move(to: CGPoint(x: 79.55, y: 79.55))
		eyebackgroundpathPath.curve(to: CGPoint(x: 90, y: 66), controlPoint1: CGPoint(x: 85.56, y: 77.98), controlPoint2: CGPoint(x: 90, y: 72.51))
		eyebackgroundpathPath.line(to: CGPoint(x: 90, y: 24))
		eyebackgroundpathPath.curve(to: CGPoint(x: 79.55, y: 10.45), controlPoint1: CGPoint(x: 90, y: 17.49), controlPoint2: CGPoint(x: 85.56, y: 12.02))
		eyebackgroundpathPath.curve(to: CGPoint(x: 66, y: 0), controlPoint1: CGPoint(x: 77.98, y: 4.44), controlPoint2: CGPoint(x: 72.51, y: -0))
		eyebackgroundpathPath.line(to: CGPoint(x: 24, y: 0))
		eyebackgroundpathPath.curve(to: CGPoint(x: 10.45, y: 10.45), controlPoint1: CGPoint(x: 17.49, y: 0), controlPoint2: CGPoint(x: 12.02, y: 4.44))
		eyebackgroundpathPath.curve(to: CGPoint(x: 0, y: 24), controlPoint1: CGPoint(x: 4.44, y: 12.02), controlPoint2: CGPoint(x: 0, y: 17.49))
		eyebackgroundpathPath.line(to: CGPoint(x: 0, y: 66))
		eyebackgroundpathPath.curve(to: CGPoint(x: 10.45, y: 79.55), controlPoint1: CGPoint(x: 0, y: 72.51), controlPoint2: CGPoint(x: 4.44, y: 77.98))
		eyebackgroundpathPath.curve(to: CGPoint(x: 24, y: 90), controlPoint1: CGPoint(x: 12.02, y: 85.56), controlPoint2: CGPoint(x: 17.49, y: 90))
		eyebackgroundpathPath.line(to: CGPoint(x: 66, y: 90))
		eyebackgroundpathPath.curve(to: CGPoint(x: 79.55, y: 79.55), controlPoint1: CGPoint(x: 72.51, y: 90), controlPoint2: CGPoint(x: 77.98, y: 85.56))
		eyebackgroundpathPath.close()
	}
