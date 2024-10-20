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

import Foundation
import CoreGraphics

extension QRCode {

	/// The shadow type
	@objc public enum ShadowType: Int {
		/// Drop shadow
		case dropShadow
		/// Inner shadow
		case innerShadow
	}

	@objc public class Shadow: NSObject {
		/// The offset value represents the _fraction_ of a generated pixel size that the shadow is offset
		@objc public var offset: CGSize
		/// The blur size
		@objc public var blur: CGFloat
		/// The shadow color
		@objc public var color: CGColor
		@objc public let type: ShadowType
		@objc public init(offset: CGSize, blur: CGFloat, color: CGColor, type: ShadowType = .dropShadow) {
			self.offset = offset
			self.blur = blur
			self.color = color
			self.type = type
			super.init()
		}

		@objc public init(dx: CGFloat, dy: CGFloat, blur: CGFloat, color: CGColor, type: ShadowType = .dropShadow) {
			self.offset = CGSize(width: dx, height: dy)
			self.blur = blur
			self.color = color
			self.type = type
			super.init()
		}

		@objc public convenience override init() {
			self.init(dx: 0.1, dy: -0.1, blur: 3, color: .commonBlack.copy(alpha: 0.8)!)
		}

		func copyShadow() -> QRCode.Shadow {
			Shadow(offset: self.offset, blur: self.blur, color: self.color, type: self.type)
		}

		@objc public static func Create(_ settings: [String: Any]?) -> Shadow? {
			if
				let offsetWidth = CGFloatValue(settings?["offset-width"]),
				let offsetHeight = CGFloatValue(settings?["offset-height"]),
				let blur = CGFloatValue(settings?["blur"]),
				let shadowTypeRaw = IntValue(settings?["type"]),
				let shadowType = QRCode.ShadowType(rawValue: shadowTypeRaw),
				let colorString = settings?["color"] as? String,
				let color = try? CGColor.UnarchiveSRGBA(colorString)
			{
				return Shadow(
					offset: CGSize(width: offsetWidth, height: offsetHeight),
					blur: blur,
					color: color,
					type: shadowType
				)
			}
			return nil
		}

		func settings() throws -> [String: Any] {
			[
				"offset-width": self.offset.width,
				"offset-height": self.offset.height,
				"blur": self.blur,
				"type": self.type.rawValue,
				"color": try self.color.archiveSRGBA()
			]
		}
	}
}

extension QRCode.Shadow {
	func buildSVGFilterDef(expectedPixelSize: CGFloat, named name: String) throws -> String {

		let rgba = try self.color.sRGBAComponents()
		let r: Int = Int(rgba.r * 255)
		let g: Int = Int(rgba.g * 255)
		let b: Int = Int(rgba.b * 255)

		let dx = expectedPixelSize * self.offset.width
		let dy = expectedPixelSize * self.offset.height
		let blurSize = self.blur / 2.0

		var result = ""
		result += "<filter\n"
		result += "   style='color-interpolation-filters:sRGB'\n"
		result += "   id='\(name)'\n"
		result += "   x='-0.1'\n"
		result += "   y='-0.1'\n"
		result += "   width='1.2'\n"
		result += "   height='1.2'>\n"
		result += "     <feFlood\n"
		result += "      result='flood-\(name)'\n"
		result += "      in='SourceGraphic'\n"
		result += "      flood-opacity='\(rgba.a)'\n"
		result += "      flood-color='rgb(\(r),\(g),\(b))'\n"
		result += "      id='feFlood-\(name)' />\n"
		result += "     <feGaussianBlur\n"
		result += "      result='blur'\n"
		result += "      in='SourceGraphic'\n"
		result += "      stdDeviation='\(blurSize)'\n"
		result += "      id='feGaussian-\(name)' />\n"
		result += "     <feOffset\n"
		result += "      result='offset-\(name)'\n"
		result += "      in='blur'\n"
		result += "      dx='\(dx)'\n"
		result += "      dy='\(-dy)'\n"
		result += "      id='feOffset-\(name)' />\n"
		result += "     <feComposite\n"
		result += "      result='comp1'\n"
		result += "      operator='in'\n"
		result += "      in='flood-\(name)'\n"
		result += "      in2='offset-\(name)'\n"
		result += "      id='feComposite-\(name)-6' />\n"
		result += "     <feComposite\n"
		result += "      result='comp2'\n"
		result += "      operator='over'\n"
		result += "      in='SourceGraphic'\n"
		result += "      in2='comp1'\n"
		result += "      id='feComposite-\(name)-7' />\n"
		result += "   </filter>\n"
		return result
	}
}
