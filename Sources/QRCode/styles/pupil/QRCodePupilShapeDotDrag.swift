//
//  QRCodePupilShapeSeal.swift
//
//  Copyright © 2024 Darren Ford, Aydin Aghayev. All rights reserved.
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

// MARK: Pupil

public extension QRCode.PupilShape {
	/// A horizontal bars style pupil design
	@objc(QRCodePupilShapeDotDragHorizontal) class DotDragHorizontal: NSObject, QRCodePupilShapeGenerator {
		@objc public static var Name: String { "dotDragHorizontal" }
		/// The generator title
		@objc public static var Title: String { "Dot Drag Horizontal" }
		@objc public static func Create(_ settings: [String : Any]?) -> any QRCodePupilShapeGenerator { DotDragHorizontal() }
		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePupilShapeGenerator { DotDragHorizontal() }
		/// Reset the pupil shape generator back to defaults
		@objc public func reset() { }

		@objc public func settings() -> [String : Any] { [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath { horizontalPupilShapePath__ }
	}

	/// A horizontal bars style pupil design
	@objc(QRCodePupilShapeDotDragVertical) class DotDragVertical: NSObject, QRCodePupilShapeGenerator {
		@objc public static var Name: String { "dotDragVertical" }
		/// The generator title
		@objc public static var Title: String { "Dot Drag Vertical" }
		@objc public static func Create(_ settings: [String : Any]?) -> any QRCodePupilShapeGenerator { DotDragVertical() }
		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodePupilShapeGenerator { DotDragVertical() }
		/// Reset the pupil shape generator back to defaults
		@objc public func reset() { }

		@objc public func settings() -> [String : Any] { [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath { verticalPupilShapePath__ }
	}
}

// MARK: Pupil Paths

private let horizontalPupilShapePath__: CGPath = {
	CGPath.make { eyepupilPath in
		eyepupilPath.move(to: CGPoint(x: 30, y: 55))
		eyepupilPath.curve(to: CGPoint(x: 35, y: 50), controlPoint1: CGPoint(x: 30, y: 52.24), controlPoint2: CGPoint(x: 32.24, y: 50))
		eyepupilPath.line(to: CGPoint(x: 55, y: 50))
		eyepupilPath.curve(to: CGPoint(x: 60, y: 55), controlPoint1: CGPoint(x: 57.76, y: 50), controlPoint2: CGPoint(x: 60, y: 52.24))
		eyepupilPath.line(to: CGPoint(x: 60, y: 55))
		eyepupilPath.curve(to: CGPoint(x: 55, y: 60), controlPoint1: CGPoint(x: 60, y: 57.76), controlPoint2: CGPoint(x: 57.76, y: 60))
		eyepupilPath.line(to: CGPoint(x: 35, y: 60))
		eyepupilPath.curve(to: CGPoint(x: 30, y: 55), controlPoint1: CGPoint(x: 32.24, y: 60), controlPoint2: CGPoint(x: 30, y: 57.76))
		eyepupilPath.close()
		eyepupilPath.move(to: CGPoint(x: 30, y: 45))
		eyepupilPath.curve(to: CGPoint(x: 35, y: 40), controlPoint1: CGPoint(x: 30, y: 42.24), controlPoint2: CGPoint(x: 32.24, y: 40))
		eyepupilPath.line(to: CGPoint(x: 55, y: 40))
		eyepupilPath.curve(to: CGPoint(x: 60, y: 45), controlPoint1: CGPoint(x: 57.76, y: 40), controlPoint2: CGPoint(x: 60, y: 42.24))
		eyepupilPath.line(to: CGPoint(x: 60, y: 45))
		eyepupilPath.curve(to: CGPoint(x: 55, y: 50), controlPoint1: CGPoint(x: 60, y: 47.76), controlPoint2: CGPoint(x: 57.76, y: 50))
		eyepupilPath.line(to: CGPoint(x: 35, y: 50))
		eyepupilPath.curve(to: CGPoint(x: 30, y: 45), controlPoint1: CGPoint(x: 32.24, y: 50), controlPoint2: CGPoint(x: 30, y: 47.76))
		eyepupilPath.close()
		eyepupilPath.move(to: CGPoint(x: 30, y: 35))
		eyepupilPath.curve(to: CGPoint(x: 35, y: 30), controlPoint1: CGPoint(x: 30, y: 32.24), controlPoint2: CGPoint(x: 32.24, y: 30))
		eyepupilPath.line(to: CGPoint(x: 55, y: 30))
		eyepupilPath.curve(to: CGPoint(x: 60, y: 35), controlPoint1: CGPoint(x: 57.76, y: 30), controlPoint2: CGPoint(x: 60, y: 32.24))
		eyepupilPath.line(to: CGPoint(x: 60, y: 35))
		eyepupilPath.curve(to: CGPoint(x: 55, y: 40), controlPoint1: CGPoint(x: 60, y: 37.76), controlPoint2: CGPoint(x: 57.76, y: 40))
		eyepupilPath.line(to: CGPoint(x: 35, y: 40))
		eyepupilPath.curve(to: CGPoint(x: 30, y: 35), controlPoint1: CGPoint(x: 32.24, y: 40), controlPoint2: CGPoint(x: 30, y: 37.76))
		eyepupilPath.close()
	}
}()

private let verticalPupilShapePath__: CGPath =
	CGPath.make { verticaleyepupilPath in
		verticaleyepupilPath.move(to: CGPoint(x: 55, y: 60))
		verticaleyepupilPath.curve(to: CGPoint(x: 50, y: 55), controlPoint1: CGPoint(x: 52.24, y: 60), controlPoint2: CGPoint(x: 50, y: 57.76))
		verticaleyepupilPath.line(to: CGPoint(x: 50, y: 35))
		verticaleyepupilPath.curve(to: CGPoint(x: 55, y: 30), controlPoint1: CGPoint(x: 50, y: 32.24), controlPoint2: CGPoint(x: 52.24, y: 30))
		verticaleyepupilPath.line(to: CGPoint(x: 55, y: 30))
		verticaleyepupilPath.curve(to: CGPoint(x: 60, y: 35), controlPoint1: CGPoint(x: 57.76, y: 30), controlPoint2: CGPoint(x: 60, y: 32.24))
		verticaleyepupilPath.line(to: CGPoint(x: 60, y: 55))
		verticaleyepupilPath.curve(to: CGPoint(x: 55, y: 60), controlPoint1: CGPoint(x: 60, y: 57.76), controlPoint2: CGPoint(x: 57.76, y: 60))
		verticaleyepupilPath.close()
		verticaleyepupilPath.move(to: CGPoint(x: 45, y: 60))
		verticaleyepupilPath.curve(to: CGPoint(x: 40, y: 55), controlPoint1: CGPoint(x: 42.24, y: 60), controlPoint2: CGPoint(x: 40, y: 57.76))
		verticaleyepupilPath.line(to: CGPoint(x: 40, y: 35))
		verticaleyepupilPath.curve(to: CGPoint(x: 45, y: 30), controlPoint1: CGPoint(x: 40, y: 32.24), controlPoint2: CGPoint(x: 42.24, y: 30))
		verticaleyepupilPath.line(to: CGPoint(x: 45, y: 30))
		verticaleyepupilPath.curve(to: CGPoint(x: 50, y: 35), controlPoint1: CGPoint(x: 47.76, y: 30), controlPoint2: CGPoint(x: 50, y: 32.24))
		verticaleyepupilPath.line(to: CGPoint(x: 50, y: 55))
		verticaleyepupilPath.curve(to: CGPoint(x: 45, y: 60), controlPoint1: CGPoint(x: 50, y: 57.76), controlPoint2: CGPoint(x: 47.76, y: 60))
		verticaleyepupilPath.close()
		verticaleyepupilPath.move(to: CGPoint(x: 35, y: 60))
		verticaleyepupilPath.curve(to: CGPoint(x: 30, y: 55), controlPoint1: CGPoint(x: 32.24, y: 60), controlPoint2: CGPoint(x: 30, y: 57.76))
		verticaleyepupilPath.line(to: CGPoint(x: 30, y: 35))
		verticaleyepupilPath.curve(to: CGPoint(x: 35, y: 30), controlPoint1: CGPoint(x: 30, y: 32.24), controlPoint2: CGPoint(x: 32.24, y: 30))
		verticaleyepupilPath.line(to: CGPoint(x: 35, y: 30))
		verticaleyepupilPath.curve(to: CGPoint(x: 40, y: 35), controlPoint1: CGPoint(x: 37.76, y: 30), controlPoint2: CGPoint(x: 40, y: 32.24))
		verticaleyepupilPath.line(to: CGPoint(x: 40, y: 55))
		verticaleyepupilPath.curve(to: CGPoint(x: 35, y: 60), controlPoint1: CGPoint(x: 40, y: 57.76), controlPoint2: CGPoint(x: 37.76, y: 60))
		verticaleyepupilPath.close()
	}

// MARK: - Conveniences

public extension QRCodePupilShapeGenerator where Self == QRCode.PupilShape.DotDragHorizontal {
	/// Create a horizontal bar pupil shape generator
	/// - Returns: A pupil shape generator
	@inlinable static func dotDragHorizontal() -> QRCodePupilShapeGenerator { QRCode.PupilShape.DotDragHorizontal() }
}

public extension QRCodePupilShapeGenerator where Self == QRCode.PupilShape.DotDragVertical {
	/// Create a horizontal bar pupil shape generator
	/// - Returns: A pupil shape generator
	@inlinable static func dotDragVertical() -> QRCodePupilShapeGenerator { QRCode.PupilShape.DotDragVertical() }
}
