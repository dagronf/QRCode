import Foundation

@testable import QRCode

#if os(watchOS)
let __testGenerator = QRCodeGenerator_External()
#else
let __testGenerator = QRCodeGenerator_CoreImage()
#endif

#if os(macOS)
import AppKit
typealias CommonImage = NSImage
#else
import UIKit
typealias CommonImage = UIImage
#endif

extension CGPoint {
	@inlinable static func _P(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x, y: y) }
	@inlinable static func _P(_ x: Int, _ y: Int) -> CGPoint { CGPoint(x: x, y: y) }
	@inlinable static func _P(_ x: Double, _ y: Double) -> CGPoint { CGPoint(x: x, y: y) }
}

extension CGColor {
	/// Compare two colors by converting them to srgba colorspace and comparing the components
	func dumbEquality(with other: CGColor, accuracy: Double) -> Bool {
		guard
			let s = self.sRGBAComponents(),
			let o = other.sRGBAComponents()
		else {
			return false
		}
		return abs(s.r - o.r) < accuracy &&
			abs(s.g - o.g) < accuracy &&
			abs(s.b - o.b) < accuracy &&
			abs(s.a - o.a) < accuracy
	}
}

extension String {
	func termCount(_ term: String) -> Int {
		self.components(separatedBy: term).count - 1
	}
}

enum TestErrors: Error {
	case invalidURL
	case invalidImage
}

func loadImageResource(_ resource: String, withExtension extn: String) throws -> CGImage {
	guard let logoURL = Bundle.module.url(forResource: resource, withExtension: extn) else {
		throw TestErrors.invalidURL
	}

	guard let logoImage = CommonImage(contentsOfFile: logoURL.path)?.cgImage() else {
		throw TestErrors.invalidImage
	}
	return logoImage
}

func roundTripEncodeDecode<Object: Codable>(_ object: Object) throws -> (data: Data, object: Object) {
	let data = try JSONEncoder().encode(object)
	return (data, try JSONDecoder().decode(Object.self, from: data))
}

#if os(macOS)

import AppKit

extension NSBezierPath {

	/// Create a CGPath from this object
	public var cgPath: CGPath {
		let path = CGMutablePath()
		var points = [CGPoint](repeating: .zero, count: 3)
		for i in 0 ..< self.elementCount {
			let type = self.element(at: i, associatedPoints: &points)
			switch type {
			case .moveTo: path.move(to: points[0])
			case .lineTo: path.addLine(to: points[0])
			case .curveTo: path.addCurve(to: points[2], control1: points[0], control2: points[1])
			case .closePath: path.closeSubpath()
			default:
				// Ignore
				print("Unexpected path type?")
			}
		}
		return path
	}

	// https://stackoverflow.com/a/49011112
	convenience init(cgPath: CGPath) {
		self.init()
		cgPath.applyWithBlockSafe { [weak self] (elementPointer: UnsafePointer<CGPathElement>) in
			guard let `self` = self else { return }
			let element = elementPointer.pointee
			let points = element.points
			switch element.type {
			case .moveToPoint:
				self.move(to: points.pointee)
			case .addLineToPoint:
				self.line(to: points.pointee)
			case .addQuadCurveToPoint:
				let qp0 = self.currentPoint
				let qp1 = points.pointee
				let qp2 = points.successor().pointee
				let m = 2.0/3.0
				let cp1 = NSPoint(
					x: qp0.x + ((qp1.x - qp0.x) * m),
					y: qp0.y + ((qp1.y - qp0.y) * m)
				)
				let cp2 = NSPoint(
					x: qp2.x + ((qp1.x - qp2.x) * m),
					y: qp2.y + ((qp1.y - qp2.y) * m)
				)
				self.curve(to: qp2, controlPoint1: cp1, controlPoint2: cp2)
			case .addCurveToPoint:
				let cp1 = points.pointee
				let cp2 = points.advanced(by: 1).pointee
				let target = points.advanced(by: 2).pointee
				self.curve(to: target, controlPoint1: cp1, controlPoint2: cp2)
			case .closeSubpath:
				self.close()
			@unknown default:
				fatalError("Unknown type \(element.type)")
			}
		}
	}
}

#endif
