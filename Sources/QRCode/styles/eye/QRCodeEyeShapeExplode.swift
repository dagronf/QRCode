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
	/// A 'saquare peg' (rounded rect with a circular cutout) style eye design
	@objc(QRCodeEyeShapeExplode) class Explode: NSObject, QRCodeEyeShapeGenerator {
		@objc public static let Name = "explode"
		@objc public static var Title: String { "Explode" }
		@objc public static func Create(_ settings: [String: Any]?) -> any QRCodeEyeShapeGenerator {
			return QRCode.EyeShape.Explode()
		}

		// Has no configurable settings
		@objc public func settings() -> [String: Any] { return [:] }
		@objc public func supportsSettingValue(forKey key: String) -> Bool { false }
		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool { false }

		/// Make a copy of the object
		@objc public func copyShape() -> any QRCodeEyeShapeGenerator { Explode() }

		/// Reset the eye shape generator back to defaults
		@objc public func reset() { }

		public func eyePath() -> CGPath {
			return CGPath.make { explodeeyeouterPath in
				explodeeyeouterPath.move(to: CGPoint(x: 75, y: 75))
				explodeeyeouterPath.curve(to: CGPoint(x: 45, y: 68), controlPoint1: CGPoint(x: 75, y: 75), controlPoint2: CGPoint(x: 60, y: 68))
				explodeeyeouterPath.curve(to: CGPoint(x: 15, y: 75), controlPoint1: CGPoint(x: 30, y: 68), controlPoint2: CGPoint(x: 15, y: 75))
				explodeeyeouterPath.curve(to: CGPoint(x: 22, y: 45), controlPoint1: CGPoint(x: 15, y: 75), controlPoint2: CGPoint(x: 22, y: 60))
				explodeeyeouterPath.curve(to: CGPoint(x: 15, y: 15), controlPoint1: CGPoint(x: 22, y: 30), controlPoint2: CGPoint(x: 15, y: 15))
				explodeeyeouterPath.curve(to: CGPoint(x: 45, y: 22), controlPoint1: CGPoint(x: 15, y: 15), controlPoint2: CGPoint(x: 30, y: 22))
				explodeeyeouterPath.curve(to: CGPoint(x: 75, y: 15), controlPoint1: CGPoint(x: 60, y: 22), controlPoint2: CGPoint(x: 75, y: 15))
				explodeeyeouterPath.curve(to: CGPoint(x: 68, y: 45), controlPoint1: CGPoint(x: 75, y: 15), controlPoint2: CGPoint(x: 68, y: 30))
				explodeeyeouterPath.curve(to: CGPoint(x: 75, y: 75), controlPoint1: CGPoint(x: 68, y: 60), controlPoint2: CGPoint(x: 75, y: 75))
				explodeeyeouterPath.close()
				explodeeyeouterPath.move(to: CGPoint(x: 80, y: 80))
				explodeeyeouterPath.curve(to: CGPoint(x: 80, y: 10), controlPoint1: CGPoint(x: 80, y: 80), controlPoint2: CGPoint(x: 80, y: 10))
				explodeeyeouterPath.line(to: CGPoint(x: 10, y: 10))
				explodeeyeouterPath.line(to: CGPoint(x: 10, y: 80))
				explodeeyeouterPath.line(to: CGPoint(x: 80, y: 80))
				explodeeyeouterPath.line(to: CGPoint(x: 80, y: 80))
				explodeeyeouterPath.close()
			}
		}

		@objc public func eyeBackgroundPath() -> CGPath {
			CGPath.make { explodeeyebackgroundPath in
				explodeeyebackgroundPath.move(to: CGPoint(x: 0, y: 0))
				explodeeyebackgroundPath.line(to: CGPoint(x: 90, y: 0))
				explodeeyebackgroundPath.line(to: CGPoint(x: 90, y: 90))
				explodeeyebackgroundPath.line(to: CGPoint(x: 0, y: 90))
				explodeeyebackgroundPath.line(to: CGPoint(x: 0, y: 0))
				explodeeyebackgroundPath.close()
			}
		}

		private static let _defaultPupil = QRCode.PupilShape.Explode()
		public func defaultPupil() -> any QRCodePupilShapeGenerator { Self._defaultPupil }
	}
}

public extension QRCodeEyeShapeGenerator where Self == QRCode.EyeShape.Explode {
	/// Create an explode eye shape
	/// - Returns: An eye shape generator
	@inlinable static func explode() -> QRCodeEyeShapeGenerator { QRCode.EyeShape.Explode() }
}
