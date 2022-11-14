import Foundation

@testable import QRCode
@testable import QRCodeExternal

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

let __tmpFolder: URL = {
	let u = FileManager.default
		.temporaryDirectory
		.appendingPathComponent("qrcodeTests")
		.appendingPathComponent(UUID().uuidString)
	try! FileManager.default.createDirectory(at: u, withIntermediateDirectories: true)
	Swift.print("Temp files at: \(u)")
	return u
}()

func testFilenameWithName(_ name: String) throws -> URL {
	__tmpFolder.appendingPathComponent(name)
}

extension String {
	@discardableResult func writeToTempFile(named filename: String, encoding: String.Encoding = .utf8) throws -> URL {
		let tempURL = try testFilenameWithName(filename)
		try self.write(to: tempURL, atomically: true, encoding: encoding)
		return tempURL
	}
}

extension Data {
	@discardableResult func writeToTempFile(named filename: String) throws -> URL {
		let tempURL = try testFilenameWithName(filename)
		try self.write(to: tempURL)
		return tempURL
	}
}

extension String {
	func termCount(_ term: String) -> Int {
		self.components(separatedBy: term).count - 1
	}
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
	@available(macOS 10.13, *)
	convenience init(cgPath: CGPath) {
		 self.init()
		 cgPath.applyWithBlock { (elementPointer: UnsafePointer<CGPathElement>) in
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
