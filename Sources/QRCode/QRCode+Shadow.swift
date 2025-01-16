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

import Foundation
import CoreGraphics

extension QRCode {

	/// The shadow type
	@objc(QRCodeShadowType) public enum ShadowType: Int {
		/// Drop shadow
		case dropShadow = 0
		/// Inner shadow
		case innerShadow = 1

		/// The shadow type name
		public var name: String {
			switch self {
			case .dropShadow: return "dropShadow"
			case .innerShadow: return "innerShadow"
			}
		}
	}

	@objc(QRCodeShadow) public class Shadow: NSObject {
		/// The offset value represents the _fraction_ of a generated pixel size that the shadow is offset
		@objc public var offset: CGSize
		/// The blur size
		@objc public var blur: CGFloat
		/// The shadow color
		@objc public var color: CGColor
		/// The shadow type
		@objc public var type: ShadowType

		/// Create a shadow
		/// - Parameters:
		///   - type: The type of shadow
		///   - dx: The shadow’s horizontal relative position
		///   - dy: The shadow’s vertical relative position
		///   - blur: The blur radius of the shadow
		///   - color: The color of the shadow
		@objc public init(_ type: ShadowType = .dropShadow, dx: CGFloat, dy: CGFloat, blur: CGFloat, color: CGColor) {
			self.offset = CGSize(width: dx, height: dy)
			self.blur = blur
			self.color = color
			self.type = type
			super.init()
		}

		/// Create a shadow
		/// - Parameters:
		///   - type: The type of shadow
		///   - offset: The shadow’s relative position, which you specify with horizontal and vertical offset values
		///   - blur: The blur radius of the shadow
		///   - color: The color of the shadow
		@objc public convenience init(_ type: ShadowType = .dropShadow, offset: CGSize, blur: CGFloat, color: CGColor) {
			self.init(type, dx: offset.width, dy: offset.height, blur: blur, color: color)
		}

		/// Create a shadow with default values
		@objc public convenience override init() {
			self.init(dx: 0.2, dy: -0.2, blur: 4, color: .commonBlack.copy(alpha: 0.8)!)
		}

		/// Make a copy of this shadow
		@objc public func copyShadow() -> QRCode.Shadow {
			Shadow(self.type, offset: self.offset, blur: self.blur, color: self.color)
		}


		/// Create a QRCode shadow from a settings dictionary
		/// - Parameter settings: The shadow settings dictionary
		/// - Returns: A new shadow object, or nil if the shadow couldn't be created
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
					shadowType,
					offset: CGSize(width: offsetWidth, height: offsetHeight),
					blur: blur,
					color: color
				)
			}
			return nil
		}

		/// Return the shadow settings as a dictionary
		/// - Returns: The shadow's settings
		@objc public func settings() throws -> [String: Any] {
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
	func buildSVGDropShadowFilterDef(expectedPixelSize: CGFloat, named name: String) throws -> String {

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

	func buildSVGInnerShadowFilterDef(expectedPixelSize: CGFloat, named name: String) throws -> String {
		let rgba = try self.color.sRGBAComponents()
		let r: Int = Int(rgba.r * 255)
		let g: Int = Int(rgba.g * 255)
		let b: Int = Int(rgba.b * 255)

		let dx = expectedPixelSize * self.offset.width
		let dy = expectedPixelSize * self.offset.height
		let blurSize = self.blur / 2.0

		var result = ""

		result += "<filter\n"
		result += " style='color-interpolation-filters:sRGB'\n"
		result += " id='\(name)'\n"
		result += "   x='-0.1'\n"
		result += "   y='-0.1'\n"
		result += "   width='1.2'\n"
		result += "   height='1.2'>\n"
		result += "  <feFlood\n"
		result += "      result='flood-\(name)'\n"
		result += "      in='SourceGraphic'\n"
		result += "      flood-opacity='\(rgba.a)'\n"
		result += "      flood-color='rgb(\(r),\(g),\(b))'\n"
		result += "      id='feFlood-\(name)' />\n"
		result += "  <feGaussianBlur\n"
		result += "      result='blur'\n"
		result += "      in='SourceGraphic'\n"
		result += "      stdDeviation='\(blurSize)'\n"
		result += "      id='feGaussian-\(name)' />\n"
		result += "  <feOffset\n"
		result += "      result='offset-\(name)'\n"
		result += "      in='blur'\n"
		result += "      dx='\(dx)'\n"
		result += "      dy='\(-dy)'\n"
		result += "      id='feOffset-\(name)' />\n"
		result += "  <feComposite\n"
		result += "      result='comp1'\n"
		result += "      operator='out'\n"
		result += "      in='flood-\(name)'\n"
		result += "      in2='offset-\(name)'\n"
		result += "      id='feComposite-\(name)-6' />\n"
		result += "  <feComposite\n"
		result += "      result='comp2'\n"
		result += "      operator='atop'\n"
		result += "      in='comp1'\n"
		result += "      in2='SourceGraphic'\n"
		result += "     id='feComposite-\(name)-7' />\n"
		result += "</filter>\n"
		return result
	}
}
