//
//  QRCodePupilShapeShield.swift
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

// MARK: - Pupil shape

public extension QRCode.PupilShape {
	/// A 'shield' style pupil design with configurable corner styles
	@objc(QRCodePupilShapeShield) class Shield: NSObject, QRCodePupilShapeGenerator {
		@objc public static var Name: String { "shield" }
		/// The generator title
		@objc public static var Title: String { "Shield" }

		/// The corners to 'push in'
		public var corners: QRCode.Corners = .all

		@objc public override init() {
			self.corners = .all
			super.init()
		}

		/// Create a Shield pupil shape compatible with objective-c
		@objc public init(topLeft: Bool, topRight: Bool, bottomLeft: Bool, bottomRight: Bool) {
			self.corners = .none
			if topLeft { self.corners.insert(.tl) }
			if topRight { self.corners.insert(.tr) }
			if bottomLeft { self.corners.insert(.bl) }
			if bottomRight { self.corners.insert(.br) }
			super.init()
		}

		/// Create a shield pupil shape
		public init(corners: QRCode.Corners = .all) {
			self.corners = corners
			super.init()
		}

		/// Create a shield pupil shape using the provided settings
		@objc public static func Create(_ settings: [String : Any]?) -> QRCodePupilShapeGenerator {
			if let value = IntValue(settings?[QRCode.SettingsKey.corners]) {
				return Shield(corners: QRCode.Corners(rawValue: value))
			}
			return Shield()
		}

		/// Make a copy of the object
		@objc public func copyShape() -> QRCodePupilShapeGenerator {
			Self.Create(self.settings())
		}

		@objc public func settings() -> [String: Any] { [
			QRCode.SettingsKey.corners: self.corners.rawValue
		] }

		@objc public func supportsSettingValue(forKey key: String) -> Bool {
			key == QRCode.SettingsKey.corners
		}

		@objc public func setSettingValue(_ value: Any?, forKey key: String) -> Bool {
			if key == QRCode.SettingsKey.corners,
				let value = IntValue(value)
			{
				self.corners = QRCode.Corners(rawValue: value)
				return true
			}
			return false
		}
		
		/// The pupil centered in the 90x90 square
		@objc public func pupilPath() -> CGPath {
			let pupilPath = CGMutablePath()
			corners.contains(.tl) ? pupilPath.addPath(tlIN()) : pupilPath.addPath(tlOUT())
			corners.contains(.tr) ? pupilPath.addPath(trIN()) : pupilPath.addPath(trOUT())
			corners.contains(.bl) ? pupilPath.addPath(blIN()) : pupilPath.addPath(blOUT())
			corners.contains(.br) ? pupilPath.addPath(brIN()) : pupilPath.addPath(brOUT())
			return pupilPath
		}
	}
}

public extension QRCode.PupilShape.Shield {

	func trIN() -> CGPath {
		let trINPath = CGMutablePath()
		trINPath.move(to: CGPoint(x: 52.42, y: 60))
		trINPath.curve(to: CGPoint(x: 60, y: 52.42), controlPoint1: CGPoint(x: 53.97, y: 56.66), controlPoint2: CGPoint(x: 56.66, y: 53.97))
		trINPath.curve(to: CGPoint(x: 60, y: 45), controlPoint1: CGPoint(x: 60, y: 48.7), controlPoint2: CGPoint(x: 60, y: 45))
		trINPath.line(to: CGPoint(x: 45, y: 45))
		trINPath.line(to: CGPoint(x: 45, y: 60))
		trINPath.line(to: CGPoint(x: 52.42, y: 60))
		trINPath.close()
		return trINPath
	}

	func trOUT() -> CGPath {
		let trOUTPath = CGMutablePath()
		trOUTPath.move(to: CGPoint(x: 45, y: 45))
		trOUTPath.line(to: CGPoint(x: 60, y: 45))
		trOUTPath.line(to: CGPoint(x: 60, y: 56))
		trOUTPath.curve(to: CGPoint(x: 56, y: 60), controlPoint1: CGPoint(x: 60, y: 58.21), controlPoint2: CGPoint(x: 58.21, y: 60))
		trOUTPath.line(to: CGPoint(x: 45, y: 60))
		trOUTPath.line(to: CGPoint(x: 45, y: 45))
		trOUTPath.close()
		return trOUTPath
	}

	func tlIN() -> CGPath {
		let tlINPath = CGMutablePath()
		tlINPath.move(to: CGPoint(x: 37.58, y: 60))
		tlINPath.curve(to: CGPoint(x: 30, y: 52.42), controlPoint1: CGPoint(x: 36.03, y: 56.66), controlPoint2: CGPoint(x: 33.34, y: 53.97))
		tlINPath.curve(to: CGPoint(x: 30, y: 45), controlPoint1: CGPoint(x: 30, y: 48.7), controlPoint2: CGPoint(x: 30, y: 45))
		tlINPath.line(to: CGPoint(x: 45, y: 45))
		tlINPath.line(to: CGPoint(x: 45, y: 60))
		tlINPath.line(to: CGPoint(x: 37.58, y: 60))
		tlINPath.close()
		return tlINPath
	}

	func tlOUT() -> CGPath {
		let tlOUTPath = CGMutablePath()
		tlOUTPath.move(to: CGPoint(x: 45, y: 45))
		tlOUTPath.line(to: CGPoint(x: 30, y: 45))
		tlOUTPath.line(to: CGPoint(x: 30, y: 56))
		tlOUTPath.curve(to: CGPoint(x: 34, y: 60), controlPoint1: CGPoint(x: 30, y: 58.21), controlPoint2: CGPoint(x: 31.79, y: 60))
		tlOUTPath.line(to: CGPoint(x: 45, y: 60))
		tlOUTPath.line(to: CGPoint(x: 45, y: 45))
		tlOUTPath.close()
		return tlOUTPath
	}

	func brIN() -> CGPath {
		let brINPath = CGMutablePath()
		brINPath.move(to: CGPoint(x: 52.42, y: 30))
		brINPath.curve(to: CGPoint(x: 60, y: 37.58), controlPoint1: CGPoint(x: 53.97, y: 33.34), controlPoint2: CGPoint(x: 56.66, y: 36.03))
		brINPath.curve(to: CGPoint(x: 60, y: 45), controlPoint1: CGPoint(x: 60, y: 41.3), controlPoint2: CGPoint(x: 60, y: 45))
		brINPath.line(to: CGPoint(x: 45, y: 45))
		brINPath.line(to: CGPoint(x: 45, y: 30))
		brINPath.line(to: CGPoint(x: 52.42, y: 30))
		brINPath.close()
		return brINPath
	}

	func brOUT() -> CGPath {
		let brOUTPath = CGMutablePath()
		brOUTPath.move(to: CGPoint(x: 45, y: 45))
		brOUTPath.line(to: CGPoint(x: 60, y: 45))
		brOUTPath.line(to: CGPoint(x: 60, y: 34))
		brOUTPath.curve(to: CGPoint(x: 56, y: 30), controlPoint1: CGPoint(x: 60, y: 31.79), controlPoint2: CGPoint(x: 58.21, y: 30))
		brOUTPath.line(to: CGPoint(x: 45, y: 30))
		brOUTPath.line(to: CGPoint(x: 45, y: 45))
		brOUTPath.close()
		return brOUTPath
	}

	func blIN() -> CGPath {
		let blINPath = CGMutablePath()
		blINPath.move(to: CGPoint(x: 37.58, y: 30))
		blINPath.curve(to: CGPoint(x: 30, y: 37.58), controlPoint1: CGPoint(x: 36.03, y: 33.34), controlPoint2: CGPoint(x: 33.34, y: 36.03))
		blINPath.curve(to: CGPoint(x: 30, y: 45), controlPoint1: CGPoint(x: 30, y: 41.3), controlPoint2: CGPoint(x: 30, y: 45))
		blINPath.line(to: CGPoint(x: 45, y: 45))
		blINPath.line(to: CGPoint(x: 45, y: 30))
		blINPath.line(to: CGPoint(x: 37.58, y: 30))
		blINPath.close()
		return blINPath
	}

	func blOUT() -> CGPath {
		let blOUTPath = CGMutablePath()
		blOUTPath.move(to: CGPoint(x: 45, y: 45))
		blOUTPath.line(to: CGPoint(x: 30, y: 45))
		blOUTPath.line(to: CGPoint(x: 30, y: 34))
		blOUTPath.curve(to: CGPoint(x: 34, y: 30), controlPoint1: CGPoint(x: 30, y: 31.79), controlPoint2: CGPoint(x: 31.79, y: 30))
		blOUTPath.line(to: CGPoint(x: 45, y: 30))
		blOUTPath.line(to: CGPoint(x: 45, y: 45))
		blOUTPath.close()
		return blOUTPath
	}

}
