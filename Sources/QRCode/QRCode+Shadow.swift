//
//  QRCode+Shadow.swift
//  QRCode
//
//  Created by Darren Ford on 18/10/2024.
//

import Foundation
import CoreGraphics

extension QRCode {

	@objc public enum ShadowType: Int {
		case dropShadow
		case innerShadow
	}

	@objc public class Shadow: NSObject {
		@objc public var offset: CGSize
		@objc public var blur: CGFloat
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
			self.init(dx: 2, dy: -2, blur: 3, color: .commonBlack.copy(alpha: 0.8)!)
		}

		func copyShadow() -> QRCode.Shadow {
			Shadow(offset: self.offset, blur: self.blur, color: self.color, type: self.type)
		}

		func set(_ ctx: CGContext) {
			ctx.setShadow(offset: self.offset, blur: self.blur, color: self.color)
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
	func buildSVGFilterDef(named name: String) throws -> String {

		let rgba = try self.color.sRGBAComponents()
		let r: Int = Int(rgba.r * 255)
		let g: Int = Int(rgba.g * 255)
		let b: Int = Int(rgba.b * 255)

		var result = ""
		result += "<filter\n"
		result += "   style='color-interpolation-filters:sRGB'\n"
		result += "   id='\(name)'\n"
		result += "   x='-0.01295999'\n"
		result += "   y='-0.018359985'\n"
		result += "   width='1.03132'\n"
		result += "   height='1.03132'>\n"
		result += "     <feFlood\n"
		result += "      result='flood-\(name)'\n"
		result += "      in='SourceGraphic'\n"
		result += "      flood-opacity='\(rgba.a)'\n"
		result += "      flood-color='rgb(\(r),\(g),\(b))'\n"
		result += "      id='feFlood-\(name)' />\n"
		result += "     <feGaussianBlur\n"
		result += "      result='blur'\n"
		result += "      in='SourceGraphic'\n"
		result += "      stdDeviation='\(self.blur / 2.0)'\n"
		result += "      id='feGaussian-\(name)' />\n"
		result += "     <feOffset\n"
		result += "      result='offset-\(name)'\n"
		result += "      in='blur'\n"
		result += "      dx='\(self.offset.width)'\n"
		result += "      dy='\(-self.offset.height)'\n"
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
