@testable import QRCode
import XCTest

#if canImport(CoreGraphics)

//extension CGPath {
//	public func subtracting(_ other: CGPath, using rule: CGPathFillRule = .winding) -> CGPath {
//		assert(false)
//		return other
//	}
//}

final class CGPathCoderTests: XCTestCase {
	func testCGPathEncodeDecode() throws {
		do {
			// Basic rect
			let path1 = CGPath(rect: CGRect(x: 0.30, y: 0.30, width: 0.40, height: 0.40), transform: nil)
			let data = try XCTUnwrap(CGPathCoder.encode(path1))
			let path2 = try CGPathCoder.decode(data)
			if #available(macOS 13.0, iOS 16, tvOS 16, watchOS 9, *) {
				XCTAssertTrue(path1.subtracting(path2).boundingBoxOfPath.isEmpty)
			}
			else {
				Swift.print("WARNING: Cannot validate testCGPathEncodeDecode returns equal path on older OS versions")
			}
		}
		do {
			// Ellipse
			let path1 = CGPath(ellipseIn: CGRect(x: 0.30, y: 0.30, width: 0.40, height: 0.40), transform: nil)
			let data = try XCTUnwrap(CGPathCoder.encode(path1))
			let path2 = try CGPathCoder.decode(data)
			if #available(macOS 13.0, iOS 16, tvOS 16, watchOS 9, *) {
				XCTAssertTrue(path1.subtracting(path2).boundingBoxOfPath.isEmpty)
			}
			else {
				Swift.print("WARNING: Cannot validate testCGPathEncodeDecode returns equal path on older OS versions")
			}
		}

		do {
			// Rounded rectangle
			let path1 = CGPath(roundedRect: CGRect(x: 0, y: 0, width: 200, height: 150), cornerWidth: 8, cornerHeight: 100, transform: nil)
			let data = try XCTUnwrap(CGPathCoder.encode(path1))
			let path2 = try CGPathCoder.decode(data)
			if #available(macOS 13.0, iOS 16, tvOS 16, watchOS 9, *) {
				XCTAssertTrue(path1.subtracting(path2).boundingBoxOfPath.isEmpty)
			}
			else {
				Swift.print("WARNING: Cannot validate testCGPathEncodeDecode returns equal path on older OS versions")
			}
		}

		do {
			let path1 = githubPath()
			let data = try XCTUnwrap(CGPathCoder.encode(path1))
			let path2 = try CGPathCoder.decode(data)
			if #available(macOS 13.0, iOS 16, tvOS 16, watchOS 9, *) {
				XCTAssertTrue(path1.subtracting(path2).boundingBoxOfPath.isEmpty)
			}
			else {
				Swift.print("WARNING: Cannot validate testCGPathEncodeDecode returns equal path on older OS versions")
			}
		}
	}
}

private func githubPath() -> CGPath {
	let bezierPath = CGMutablePath()
	bezierPath.move(to: CGPoint(x: 114.86, y: 69.09))
	bezierPath.addCurve(to: CGPoint(x: 115.66, y: 59.2), control1: CGPoint(x: 115.31, y: 66.12), control2: CGPoint(x: 115.59, y: 62.86))
	bezierPath.addCurve(to: CGPoint(x: 107, y: 35.39), control1: CGPoint(x: 115.64, y: 43.53), control2: CGPoint(x: 108.4, y: 37.99))
	bezierPath.addCurve(to: CGPoint(x: 105.55, y: 16.26), control1: CGPoint(x: 109.05, y: 23.51), control2: CGPoint(x: 106.66, y: 18.11))
	bezierPath.addCurve(to: CGPoint(x: 85.72, y: 23.96), control1: CGPoint(x: 101.45, y: 14.75), control2: CGPoint(x: 91.27, y: 20.15))
	bezierPath.addCurve(to: CGPoint(x: 50.32, y: 24.67), control1: CGPoint(x: 76.66, y: 21.21), control2: CGPoint(x: 57.51, y: 21.48))
	bezierPath.addCurve(to: CGPoint(x: 30.07, y: 16.34), control1: CGPoint(x: 37.07, y: 14.84), control2: CGPoint(x: 30.07, y: 16.34))
	bezierPath.addCurve(to: CGPoint(x: 28.87, y: 37.07), control1: CGPoint(x: 30.07, y: 16.34), control2: CGPoint(x: 25.54, y: 24.76))
	bezierPath.addCurve(to: CGPoint(x: 21.26, y: 57.69), control1: CGPoint(x: 24.51, y: 42.83), control2: CGPoint(x: 21.26, y: 46.9))
	bezierPath.addCurve(to: CGPoint(x: 21.68, y: 65.07), control1: CGPoint(x: 21.26, y: 60.28), control2: CGPoint(x: 21.41, y: 62.72))
	bezierPath.addCurve(to: CGPoint(x: 56.44, y: 95.87), control1: CGPoint(x: 25.43, y: 85.52), control2: CGPoint(x: 41.07, y: 94.35))
	bezierPath.addCurve(to: CGPoint(x: 50.97, y: 105.13), control1: CGPoint(x: 54.13, y: 97.69), control2: CGPoint(x: 51.35, y: 101.13))
	bezierPath.addCurve(to: CGPoint(x: 37.67, y: 106.24), control1: CGPoint(x: 48.06, y: 107.07), control2: CGPoint(x: 42.22, y: 107.72))
	bezierPath.addCurve(to: CGPoint(x: 19.33, y: 92.95), control1: CGPoint(x: 31.31, y: 104.15), control2: CGPoint(x: 28.87, y: 91.09))
	bezierPath.addCurve(to: CGPoint(x: 19.47, y: 95.96), control1: CGPoint(x: 17.27, y: 93.35), control2: CGPoint(x: 17.68, y: 94.76))
	bezierPath.addCurve(to: CGPoint(x: 27.22, y: 105.53), control1: CGPoint(x: 22.37, y: 97.91), control2: CGPoint(x: 25.11, y: 100.34))
	bezierPath.addCurve(to: CGPoint(x: 43.01, y: 116.64), control1: CGPoint(x: 28.84, y: 109.52), control2: CGPoint(x: 32.24, y: 116.64))
	bezierPath.addCurve(to: CGPoint(x: 50.28, y: 116.12), control1: CGPoint(x: 47.29, y: 116.64), control2: CGPoint(x: 50.28, y: 116.12))
	bezierPath.addCurve(to: CGPoint(x: 50.37, y: 130.24), control1: CGPoint(x: 50.28, y: 116.12), control2: CGPoint(x: 50.37, y: 126.28))
	bezierPath.addCurve(to: CGPoint(x: 44.43, y: 138.27), control1: CGPoint(x: 50.37, y: 134.8), control2: CGPoint(x: 44.43, y: 136.08))
	bezierPath.addCurve(to: CGPoint(x: 47.97, y: 139.22), control1: CGPoint(x: 44.43, y: 139.14), control2: CGPoint(x: 46.39, y: 139.22))
	bezierPath.addCurve(to: CGPoint(x: 57.59, y: 131.79), control1: CGPoint(x: 51.09, y: 139.22), control2: CGPoint(x: 57.59, y: 136.53))
	bezierPath.addCurve(to: CGPoint(x: 57.65, y: 113.15), control1: CGPoint(x: 57.59, y: 128.02), control2: CGPoint(x: 57.65, y: 115.36))
	bezierPath.addCurve(to: CGPoint(x: 60.15, y: 106.76), control1: CGPoint(x: 57.65, y: 108.3), control2: CGPoint(x: 60.15, y: 106.76))
	bezierPath.addCurve(to: CGPoint(x: 59.55, y: 136.08), control1: CGPoint(x: 60.15, y: 106.76), control2: CGPoint(x: 60.46, y: 132.61))
	bezierPath.addCurve(to: CGPoint(x: 56.55, y: 141.39), control1: CGPoint(x: 58.48, y: 140.16), control2: CGPoint(x: 56.55, y: 139.58))
	bezierPath.addCurve(to: CGPoint(x: 66.95, y: 136.13), control1: CGPoint(x: 56.55, y: 144.1), control2: CGPoint(x: 64.36, y: 142.05))
	bezierPath.addCurve(to: CGPoint(x: 68.06, y: 106.15), control1: CGPoint(x: 68.96, y: 131.5), control2: CGPoint(x: 68.06, y: 106.15))
	bezierPath.addLine(to: CGPoint(x: 70.15, y: 106.1))
	bezierPath.addCurve(to: CGPoint(x: 70.1, y: 123.02), control1: CGPoint(x: 70.15, y: 106.1), control2: CGPoint(x: 70.17, y: 117.71))
	bezierPath.addCurve(to: CGPoint(x: 72.63, y: 138.73), control1: CGPoint(x: 70.03, y: 128.51), control2: CGPoint(x: 69.48, y: 135.46))
	bezierPath.addCurve(to: CGPoint(x: 81.03, y: 141.22), control1: CGPoint(x: 74.7, y: 140.89), control2: CGPoint(x: 81.03, y: 144.67))
	bezierPath.addCurve(to: CGPoint(x: 76.59, y: 132.13), control1: CGPoint(x: 81.03, y: 139.21), control2: CGPoint(x: 76.59, y: 137.56))
	bezierPath.addLine(to: CGPoint(x: 76.59, y: 107.12))
	bezierPath.addCurve(to: CGPoint(x: 79.85, y: 115.34), control1: CGPoint(x: 79.29, y: 107.12), control2: CGPoint(x: 79.85, y: 115.34))
	bezierPath.addLine(to: CGPoint(x: 80.82, y: 130.61))
	bezierPath.addCurve(to: CGPoint(x: 86.63, y: 138.51), control1: CGPoint(x: 80.82, y: 130.61), control2: CGPoint(x: 80.17, y: 136.19))
	bezierPath.addCurve(to: CGPoint(x: 94.01, y: 138.17), control1: CGPoint(x: 88.91, y: 139.34), control2: CGPoint(x: 93.78, y: 139.56))
	bezierPath.addCurve(to: CGPoint(x: 88.08, y: 130.41), control1: CGPoint(x: 94.24, y: 136.78), control2: CGPoint(x: 88.14, y: 134.73))
	bezierPath.addCurve(to: CGPoint(x: 88.19, y: 114.82), control1: CGPoint(x: 88.05, y: 127.79), control2: CGPoint(x: 88.19, y: 126.25))
	bezierPath.addCurve(to: CGPoint(x: 81.55, y: 95.81), control1: CGPoint(x: 88.19, y: 103.4), control2: CGPoint(x: 86.71, y: 99.18))
	bezierPath.addCurve(to: CGPoint(x: 114.86, y: 69.09), control1: CGPoint(x: 96.52, y: 94.22), control2: CGPoint(x: 112.06, y: 87.3))
	bezierPath.closeSubpath()

	return bezierPath
}

#endif
