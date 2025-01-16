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
	@objc(QRCodeEyeShapeDotDragHorizontal) class DotDragHorizontal: NSObject, QRCodeEyeShapeGenerator {
		@objc public static let Name = "dotDragHorizontal"
		@objc public static var Title: String { "Dot Drag Horizontal" }
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodeEyeShapeGenerator { DotDragHorizontal() }
		@objc public func settings() -> [String: Any] { return [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }
		@objc public func copyShape() -> any QRCodeEyeShapeGenerator { DotDragHorizontal() }

		/// Reset the eye shape generator back to defaults
		@objc public func reset() { }

		public func eyePath() -> CGPath { eyeHorizontalOuterPath__ }
		public func eyeBackgroundPath() -> CGPath { eyeBackgroundPath__ }
		
		private static let _defaultPupil = QRCode.PupilShape.DotDragHorizontal()
		public func defaultPupil() -> any QRCodePupilShapeGenerator { Self._defaultPupil }
	}

	@objc(QRCodeEyeShapeDotDragVertical) class DotDragVertical: NSObject, QRCodeEyeShapeGenerator {
		@objc public static let Name = "dotDragVertical"
		@objc public static var Title: String { "Dot Drag Vertical" }
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodeEyeShapeGenerator { DotDragVertical() }
		@objc public func settings() -> [String: Any] { return [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }
		@objc public func copyShape() -> any QRCodeEyeShapeGenerator { DotDragVertical() }

		/// Reset the eye shape generator back to defaults
		@objc public func reset() { }

		public func eyePath() -> CGPath { eyeVerticalOuterPath__ }
		public func eyeBackgroundPath() -> CGPath { eyeBackgroundPath__ }

		private static let _defaultPupil = QRCode.PupilShape.DotDragVertical()
		public func defaultPupil() -> any QRCodePupilShapeGenerator { Self._defaultPupil }
	}
}

public extension QRCodeEyeShapeGenerator where Self == QRCode.EyeShape.DotDragHorizontal {
	/// Create a dot drag eye shape generator
	/// - Returns: An eye shape generator
	@inlinable static func dotDragHorizontal() -> QRCodeEyeShapeGenerator { QRCode.EyeShape.DotDragHorizontal() }
}

public extension QRCodeEyeShapeGenerator where Self == QRCode.EyeShape.DotDragVertical {
	/// Create a dot drag eye shape generator
	/// - Returns: An eye shape generator
	@inlinable static func dotDragVertical() -> QRCodeEyeShapeGenerator { QRCode.EyeShape.DotDragVertical() }
}

// MARK: - Path generation

private let eyeBackgroundPath__: CGPath =
	CGPath.make { eyebackgroundPath in
		eyebackgroundPath.move(to: CGPoint(x: 90, y: 77.14))
		eyebackgroundPath.line(to: CGPoint(x: 90, y: 12.86))
		eyebackgroundPath.curve(to: CGPoint(x: 77.14, y: 0), controlPoint1: CGPoint(x: 90, y: 5.76), controlPoint2: CGPoint(x: 84.24, y: -0))
		eyebackgroundPath.line(to: CGPoint(x: 12.86, y: 0))
		eyebackgroundPath.curve(to: CGPoint(x: 0, y: 12.86), controlPoint1: CGPoint(x: 5.76, y: 0), controlPoint2: CGPoint(x: 0, y: 5.76))
		eyebackgroundPath.line(to: CGPoint(x: 0, y: 77.14))
		eyebackgroundPath.curve(to: CGPoint(x: 12.86, y: 90), controlPoint1: CGPoint(x: 0, y: 84.24), controlPoint2: CGPoint(x: 5.76, y: 90))
		eyebackgroundPath.line(to: CGPoint(x: 77.14, y: 90))
		eyebackgroundPath.curve(to: CGPoint(x: 90, y: 77.14), controlPoint1: CGPoint(x: 84.24, y: 90), controlPoint2: CGPoint(x: 90, y: 84.24))
		eyebackgroundPath.close()
	}

private let eyeHorizontalOuterPath__: CGPath =
	CGPath.make { horizontalbeamseyeouterPath in
		horizontalbeamseyeouterPath.move(to: CGPoint(x: 20, y: 75))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 25, y: 70), controlPoint1: CGPoint(x: 20, y: 72.24), controlPoint2: CGPoint(x: 22.24, y: 70))
		horizontalbeamseyeouterPath.line(to: CGPoint(x: 65, y: 70))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 70, y: 75), controlPoint1: CGPoint(x: 67.76, y: 70), controlPoint2: CGPoint(x: 70, y: 72.24))
		horizontalbeamseyeouterPath.line(to: CGPoint(x: 70, y: 75))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 65, y: 80), controlPoint1: CGPoint(x: 70, y: 77.76), controlPoint2: CGPoint(x: 67.76, y: 80))
		horizontalbeamseyeouterPath.line(to: CGPoint(x: 25, y: 80))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 20, y: 75), controlPoint1: CGPoint(x: 22.24, y: 80), controlPoint2: CGPoint(x: 20, y: 77.76))
		horizontalbeamseyeouterPath.close()
		horizontalbeamseyeouterPath.move(to: CGPoint(x: 20, y: 15))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 25, y: 10), controlPoint1: CGPoint(x: 20, y: 12.24), controlPoint2: CGPoint(x: 22.24, y: 10))
		horizontalbeamseyeouterPath.line(to: CGPoint(x: 65, y: 10))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 70, y: 15), controlPoint1: CGPoint(x: 67.76, y: 10), controlPoint2: CGPoint(x: 70, y: 12.24))
		horizontalbeamseyeouterPath.line(to: CGPoint(x: 70, y: 15))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 65, y: 20), controlPoint1: CGPoint(x: 70, y: 17.76), controlPoint2: CGPoint(x: 67.76, y: 20))
		horizontalbeamseyeouterPath.line(to: CGPoint(x: 25, y: 20))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 20, y: 15), controlPoint1: CGPoint(x: 22.24, y: 20), controlPoint2: CGPoint(x: 20, y: 17.76))
		horizontalbeamseyeouterPath.close()
		horizontalbeamseyeouterPath.move(to: CGPoint(x: 80, y: 55))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 75, y: 50), controlPoint1: CGPoint(x: 80, y: 52.24), controlPoint2: CGPoint(x: 77.76, y: 50))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 70, y: 55), controlPoint1: CGPoint(x: 72.24, y: 50), controlPoint2: CGPoint(x: 70, y: 52.24))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 75, y: 60), controlPoint1: CGPoint(x: 70, y: 57.76), controlPoint2: CGPoint(x: 72.24, y: 60))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 80, y: 55), controlPoint1: CGPoint(x: 77.76, y: 60), controlPoint2: CGPoint(x: 80, y: 57.76))
		horizontalbeamseyeouterPath.close()
		horizontalbeamseyeouterPath.move(to: CGPoint(x: 80, y: 45))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 75, y: 40), controlPoint1: CGPoint(x: 80, y: 42.24), controlPoint2: CGPoint(x: 77.76, y: 40))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 70, y: 45), controlPoint1: CGPoint(x: 72.24, y: 40), controlPoint2: CGPoint(x: 70, y: 42.24))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 75, y: 50), controlPoint1: CGPoint(x: 70, y: 47.76), controlPoint2: CGPoint(x: 72.24, y: 50))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 80, y: 45), controlPoint1: CGPoint(x: 77.76, y: 50), controlPoint2: CGPoint(x: 80, y: 47.76))
		horizontalbeamseyeouterPath.close()
		horizontalbeamseyeouterPath.move(to: CGPoint(x: 80, y: 35))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 75, y: 30), controlPoint1: CGPoint(x: 80, y: 32.24), controlPoint2: CGPoint(x: 77.76, y: 30))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 70, y: 35), controlPoint1: CGPoint(x: 72.24, y: 30), controlPoint2: CGPoint(x: 70, y: 32.24))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 75, y: 40), controlPoint1: CGPoint(x: 70, y: 37.76), controlPoint2: CGPoint(x: 72.24, y: 40))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 80, y: 35), controlPoint1: CGPoint(x: 77.76, y: 40), controlPoint2: CGPoint(x: 80, y: 37.76))
		horizontalbeamseyeouterPath.close()
		horizontalbeamseyeouterPath.move(to: CGPoint(x: 80, y: 25))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 75, y: 20), controlPoint1: CGPoint(x: 80, y: 22.24), controlPoint2: CGPoint(x: 77.76, y: 20))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 70, y: 25), controlPoint1: CGPoint(x: 72.24, y: 20), controlPoint2: CGPoint(x: 70, y: 22.24))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 75, y: 30), controlPoint1: CGPoint(x: 70, y: 27.76), controlPoint2: CGPoint(x: 72.24, y: 30))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 80, y: 25), controlPoint1: CGPoint(x: 77.76, y: 30), controlPoint2: CGPoint(x: 80, y: 27.76))
		horizontalbeamseyeouterPath.close()
		horizontalbeamseyeouterPath.move(to: CGPoint(x: 80, y: 65))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 75, y: 60), controlPoint1: CGPoint(x: 80, y: 62.24), controlPoint2: CGPoint(x: 77.76, y: 60))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 70, y: 65), controlPoint1: CGPoint(x: 72.24, y: 60), controlPoint2: CGPoint(x: 70, y: 62.24))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 75, y: 70), controlPoint1: CGPoint(x: 70, y: 67.76), controlPoint2: CGPoint(x: 72.24, y: 70))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 80, y: 65), controlPoint1: CGPoint(x: 77.76, y: 70), controlPoint2: CGPoint(x: 80, y: 67.76))
		horizontalbeamseyeouterPath.close()
		horizontalbeamseyeouterPath.move(to: CGPoint(x: 20, y: 55))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 15, y: 50), controlPoint1: CGPoint(x: 20, y: 52.24), controlPoint2: CGPoint(x: 17.76, y: 50))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 10, y: 55), controlPoint1: CGPoint(x: 12.24, y: 50), controlPoint2: CGPoint(x: 10, y: 52.24))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 15, y: 60), controlPoint1: CGPoint(x: 10, y: 57.76), controlPoint2: CGPoint(x: 12.24, y: 60))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 20, y: 55), controlPoint1: CGPoint(x: 17.76, y: 60), controlPoint2: CGPoint(x: 20, y: 57.76))
		horizontalbeamseyeouterPath.close()
		horizontalbeamseyeouterPath.move(to: CGPoint(x: 20, y: 45))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 15, y: 40), controlPoint1: CGPoint(x: 20, y: 42.24), controlPoint2: CGPoint(x: 17.76, y: 40))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 10, y: 45), controlPoint1: CGPoint(x: 12.24, y: 40), controlPoint2: CGPoint(x: 10, y: 42.24))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 15, y: 50), controlPoint1: CGPoint(x: 10, y: 47.76), controlPoint2: CGPoint(x: 12.24, y: 50))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 20, y: 45), controlPoint1: CGPoint(x: 17.76, y: 50), controlPoint2: CGPoint(x: 20, y: 47.76))
		horizontalbeamseyeouterPath.close()
		horizontalbeamseyeouterPath.move(to: CGPoint(x: 20, y: 35))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 15, y: 30), controlPoint1: CGPoint(x: 20, y: 32.24), controlPoint2: CGPoint(x: 17.76, y: 30))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 10, y: 35), controlPoint1: CGPoint(x: 12.24, y: 30), controlPoint2: CGPoint(x: 10, y: 32.24))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 15, y: 40), controlPoint1: CGPoint(x: 10, y: 37.76), controlPoint2: CGPoint(x: 12.24, y: 40))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 20, y: 35), controlPoint1: CGPoint(x: 17.76, y: 40), controlPoint2: CGPoint(x: 20, y: 37.76))
		horizontalbeamseyeouterPath.close()
		horizontalbeamseyeouterPath.move(to: CGPoint(x: 20, y: 25))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 15, y: 20), controlPoint1: CGPoint(x: 20, y: 22.24), controlPoint2: CGPoint(x: 17.76, y: 20))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 10, y: 25), controlPoint1: CGPoint(x: 12.24, y: 20), controlPoint2: CGPoint(x: 10, y: 22.24))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 15, y: 30), controlPoint1: CGPoint(x: 10, y: 27.76), controlPoint2: CGPoint(x: 12.24, y: 30))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 20, y: 25), controlPoint1: CGPoint(x: 17.76, y: 30), controlPoint2: CGPoint(x: 20, y: 27.76))
		horizontalbeamseyeouterPath.close()
		horizontalbeamseyeouterPath.move(to: CGPoint(x: 20, y: 65))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 15, y: 60), controlPoint1: CGPoint(x: 20, y: 62.24), controlPoint2: CGPoint(x: 17.76, y: 60))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 10, y: 65), controlPoint1: CGPoint(x: 12.24, y: 60), controlPoint2: CGPoint(x: 10, y: 62.24))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 15, y: 70), controlPoint1: CGPoint(x: 10, y: 67.76), controlPoint2: CGPoint(x: 12.24, y: 70))
		horizontalbeamseyeouterPath.curve(to: CGPoint(x: 20, y: 65), controlPoint1: CGPoint(x: 17.76, y: 70), controlPoint2: CGPoint(x: 20, y: 67.76))
		horizontalbeamseyeouterPath.close()
	}

private let eyeVerticalOuterPath__: CGPath =
	CGPath.make { verticalbeamseyeouterPath in
		verticalbeamseyeouterPath.move(to: CGPoint(x: 75, y: 70))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 70, y: 65), controlPoint1: CGPoint(x: 72.24, y: 70), controlPoint2: CGPoint(x: 70, y: 67.76))
		verticalbeamseyeouterPath.line(to: CGPoint(x: 70, y: 25))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 75, y: 20), controlPoint1: CGPoint(x: 70, y: 22.24), controlPoint2: CGPoint(x: 72.24, y: 20))
		verticalbeamseyeouterPath.line(to: CGPoint(x: 75, y: 20))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 80, y: 25), controlPoint1: CGPoint(x: 77.76, y: 20), controlPoint2: CGPoint(x: 80, y: 22.24))
		verticalbeamseyeouterPath.line(to: CGPoint(x: 80, y: 65))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 75, y: 70), controlPoint1: CGPoint(x: 80, y: 67.76), controlPoint2: CGPoint(x: 77.76, y: 70))
		verticalbeamseyeouterPath.close()
		verticalbeamseyeouterPath.move(to: CGPoint(x: 15, y: 70))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 10, y: 65), controlPoint1: CGPoint(x: 12.24, y: 70), controlPoint2: CGPoint(x: 10, y: 67.76))
		verticalbeamseyeouterPath.line(to: CGPoint(x: 10, y: 25))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 15, y: 20), controlPoint1: CGPoint(x: 10, y: 22.24), controlPoint2: CGPoint(x: 12.24, y: 20))
		verticalbeamseyeouterPath.line(to: CGPoint(x: 15, y: 20))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 20, y: 25), controlPoint1: CGPoint(x: 17.76, y: 20), controlPoint2: CGPoint(x: 20, y: 22.24))
		verticalbeamseyeouterPath.line(to: CGPoint(x: 20, y: 65))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 15, y: 70), controlPoint1: CGPoint(x: 20, y: 67.76), controlPoint2: CGPoint(x: 17.76, y: 70))
		verticalbeamseyeouterPath.close()
		verticalbeamseyeouterPath.move(to: CGPoint(x: 55, y: 10))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 50, y: 15), controlPoint1: CGPoint(x: 52.24, y: 10), controlPoint2: CGPoint(x: 50, y: 12.24))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 55, y: 20), controlPoint1: CGPoint(x: 50, y: 17.76), controlPoint2: CGPoint(x: 52.24, y: 20))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 60, y: 15), controlPoint1: CGPoint(x: 57.76, y: 20), controlPoint2: CGPoint(x: 60, y: 17.76))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 55, y: 10), controlPoint1: CGPoint(x: 60, y: 12.24), controlPoint2: CGPoint(x: 57.76, y: 10))
		verticalbeamseyeouterPath.close()
		verticalbeamseyeouterPath.move(to: CGPoint(x: 45, y: 10))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 40, y: 15), controlPoint1: CGPoint(x: 42.24, y: 10), controlPoint2: CGPoint(x: 40, y: 12.24))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 45, y: 20), controlPoint1: CGPoint(x: 40, y: 17.76), controlPoint2: CGPoint(x: 42.24, y: 20))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 50, y: 15), controlPoint1: CGPoint(x: 47.76, y: 20), controlPoint2: CGPoint(x: 50, y: 17.76))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 45, y: 10), controlPoint1: CGPoint(x: 50, y: 12.24), controlPoint2: CGPoint(x: 47.76, y: 10))
		verticalbeamseyeouterPath.close()
		verticalbeamseyeouterPath.move(to: CGPoint(x: 35, y: 10))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 30, y: 15), controlPoint1: CGPoint(x: 32.24, y: 10), controlPoint2: CGPoint(x: 30, y: 12.24))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 35, y: 20), controlPoint1: CGPoint(x: 30, y: 17.76), controlPoint2: CGPoint(x: 32.24, y: 20))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 40, y: 15), controlPoint1: CGPoint(x: 37.76, y: 20), controlPoint2: CGPoint(x: 40, y: 17.76))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 35, y: 10), controlPoint1: CGPoint(x: 40, y: 12.24), controlPoint2: CGPoint(x: 37.76, y: 10))
		verticalbeamseyeouterPath.close()
		verticalbeamseyeouterPath.move(to: CGPoint(x: 25, y: 10))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 20, y: 15), controlPoint1: CGPoint(x: 22.24, y: 10), controlPoint2: CGPoint(x: 20, y: 12.24))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 25, y: 20), controlPoint1: CGPoint(x: 20, y: 17.76), controlPoint2: CGPoint(x: 22.24, y: 20))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 30, y: 15), controlPoint1: CGPoint(x: 27.76, y: 20), controlPoint2: CGPoint(x: 30, y: 17.76))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 25, y: 10), controlPoint1: CGPoint(x: 30, y: 12.24), controlPoint2: CGPoint(x: 27.76, y: 10))
		verticalbeamseyeouterPath.close()
		verticalbeamseyeouterPath.move(to: CGPoint(x: 65, y: 10))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 60, y: 15), controlPoint1: CGPoint(x: 62.24, y: 10), controlPoint2: CGPoint(x: 60, y: 12.24))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 65, y: 20), controlPoint1: CGPoint(x: 60, y: 17.76), controlPoint2: CGPoint(x: 62.24, y: 20))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 70, y: 15), controlPoint1: CGPoint(x: 67.76, y: 20), controlPoint2: CGPoint(x: 70, y: 17.76))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 65, y: 10), controlPoint1: CGPoint(x: 70, y: 12.24), controlPoint2: CGPoint(x: 67.76, y: 10))
		verticalbeamseyeouterPath.close()
		verticalbeamseyeouterPath.move(to: CGPoint(x: 55, y: 70))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 50, y: 75), controlPoint1: CGPoint(x: 52.24, y: 70), controlPoint2: CGPoint(x: 50, y: 72.24))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 55, y: 80), controlPoint1: CGPoint(x: 50, y: 77.76), controlPoint2: CGPoint(x: 52.24, y: 80))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 60, y: 75), controlPoint1: CGPoint(x: 57.76, y: 80), controlPoint2: CGPoint(x: 60, y: 77.76))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 55, y: 70), controlPoint1: CGPoint(x: 60, y: 72.24), controlPoint2: CGPoint(x: 57.76, y: 70))
		verticalbeamseyeouterPath.close()
		verticalbeamseyeouterPath.move(to: CGPoint(x: 45, y: 70))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 40, y: 75), controlPoint1: CGPoint(x: 42.24, y: 70), controlPoint2: CGPoint(x: 40, y: 72.24))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 45, y: 80), controlPoint1: CGPoint(x: 40, y: 77.76), controlPoint2: CGPoint(x: 42.24, y: 80))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 50, y: 75), controlPoint1: CGPoint(x: 47.76, y: 80), controlPoint2: CGPoint(x: 50, y: 77.76))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 45, y: 70), controlPoint1: CGPoint(x: 50, y: 72.24), controlPoint2: CGPoint(x: 47.76, y: 70))
		verticalbeamseyeouterPath.close()
		verticalbeamseyeouterPath.move(to: CGPoint(x: 35, y: 70))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 30, y: 75), controlPoint1: CGPoint(x: 32.24, y: 70), controlPoint2: CGPoint(x: 30, y: 72.24))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 35, y: 80), controlPoint1: CGPoint(x: 30, y: 77.76), controlPoint2: CGPoint(x: 32.24, y: 80))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 40, y: 75), controlPoint1: CGPoint(x: 37.76, y: 80), controlPoint2: CGPoint(x: 40, y: 77.76))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 35, y: 70), controlPoint1: CGPoint(x: 40, y: 72.24), controlPoint2: CGPoint(x: 37.76, y: 70))
		verticalbeamseyeouterPath.close()
		verticalbeamseyeouterPath.move(to: CGPoint(x: 25, y: 70))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 20, y: 75), controlPoint1: CGPoint(x: 22.24, y: 70), controlPoint2: CGPoint(x: 20, y: 72.24))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 25, y: 80), controlPoint1: CGPoint(x: 20, y: 77.76), controlPoint2: CGPoint(x: 22.24, y: 80))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 30, y: 75), controlPoint1: CGPoint(x: 27.76, y: 80), controlPoint2: CGPoint(x: 30, y: 77.76))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 25, y: 70), controlPoint1: CGPoint(x: 30, y: 72.24), controlPoint2: CGPoint(x: 27.76, y: 70))
		verticalbeamseyeouterPath.close()
		verticalbeamseyeouterPath.move(to: CGPoint(x: 65, y: 70))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 60, y: 75), controlPoint1: CGPoint(x: 62.24, y: 70), controlPoint2: CGPoint(x: 60, y: 72.24))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 65, y: 80), controlPoint1: CGPoint(x: 60, y: 77.76), controlPoint2: CGPoint(x: 62.24, y: 80))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 70, y: 75), controlPoint1: CGPoint(x: 67.76, y: 80), controlPoint2: CGPoint(x: 70, y: 77.76))
		verticalbeamseyeouterPath.curve(to: CGPoint(x: 65, y: 70), controlPoint1: CGPoint(x: 70, y: 72.24), controlPoint2: CGPoint(x: 67.76, y: 70))
		verticalbeamseyeouterPath.close()
	}
