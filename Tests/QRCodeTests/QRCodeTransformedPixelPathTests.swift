import CoreGraphics
import Foundation
import XCTest
@testable import QRCode

final class QRCodeTransformedPixelPathTests: XCTestCase {

	private var transforms: [CGAffineTransform] {
		[
			.identity,
			CGAffineTransform(translationX: 7.25, y: -3.5),
			CGAffineTransform(scaleX: 1.75, y: 0.625),
			CGAffineTransform(rotationAngle: .pi / 3),
			CGAffineTransform(scaleX: -1, y: 1),
			CGAffineTransform(scaleX: 0, y: 0),
			CGAffineTransform(scaleX: 0, y: 1.5),
			CGAffineTransform(a: 1, b: 0.3, c: -0.2, d: 1, tx: 0.25, ty: -1.75),
			CGAffineTransform(scaleX: -0.75, y: 1.25)
				.rotated(by: -.pi / 5).translatedBy(x: 3.25, y: 8.5),
		]
	}

	func testNativeAppendEquivalenceForPixelTemplates() throws {
		let sources = moduleFixtures()
		// Open contours are valid; a pending move-only subpath is not a template.
		let destinations = [sources[0], sources[1], sources[2], sources[5]]
		for (destinationIndex, destination) in destinations.enumerated() {
			for (sourceIndex, source) in sources.enumerated() {
				let originalSource = elements(source)
				for (transformIndex, transform) in transforms.enumerated() {
					let actual = try XCTUnwrap(destination.mutableCopy())
					let expected = try XCTUnwrap(destination.mutableCopy())
					// Keep the original CoreGraphics operation independent of the helper.
					expected.addPath(source, transform: transform)
					actual.addPixelPath(source, transform: transform)
					let label = "destination \(destinationIndex), source \(sourceIndex), transform \(transformIndex)"
					try check(actual, expected, label: label)
					XCTAssertEqual(elements(source), originalSource, label)
				}
			}
		}
	}

	func testRepeatedModulesAndNewSubpath() throws {
		let actual = CGMutablePath()
		let expected = CGMutablePath()
		for source in moduleFixtures() {
			for transform in transforms {
				expected.addPath(source, transform: transform)
				actual.addPixelPath(source, transform: transform)
				try check(actual, expected, label: "repeated append")
			}
		}
		// Start a new subpath when extending a completed pixel path. Native append has
		// different internal continuation bookkeeping after a close; do not depend on it.
		for path in [actual, expected] {
			path.move(to: CGPoint(x: 2.25, y: 3.5))
			path.addLine(to: CGPoint(x: 13.25, y: 9.5))
			path.closeSubpath()
		}
		try check(actual, expected, label: "continued subpath")
	}

	func testHolesUnderBothFillRules() throws {
		for oppositeWinding in [false, true] {
			let source = ring(oppositeWinding: oppositeWinding)
			for transform in transforms where transform.a * transform.d - transform.b * transform.c != 0 {
				let actual = CGMutablePath()
				let expected = CGMutablePath()
				actual.addPixelPath(source, transform: transform)
				expected.addPath(source, transform: transform)
				for rule: CGPathFillRule in [.winding, .evenOdd] {
					XCTAssertEqual(actual.contains(CGPoint(x: 10, y: 10).applying(transform), using: rule),
						!oppositeWinding && rule == .winding)
					XCTAssertTrue(actual.contains(CGPoint(x: 2, y: 10).applying(transform), using: rule))
				}
				try check(actual, expected, label: "ring, opposite winding \(oppositeWinding)")
			}
		}
	}

	private func moduleFixtures() -> [CGPath] {
		let original = fixtures()
		return [original[0]] + Array(original[2...])
	}

	private func fixtures() -> [CGPath] {
		let empty = CGMutablePath()
		let move = CGMutablePath()
		move.move(to: CGPoint(x: 3.25, y: 4.5))
		let open = CGMutablePath()
		open.move(to: CGPoint(x: 1.25, y: 2.5))
		open.addLine(to: CGPoint(x: 18.75, y: 4))
		open.addLine(to: CGPoint(x: 7, y: 19.5))
		let closed = open.mutableCopy()!
		closed.closeSubpath()
		let quadratic = CGMutablePath()
		quadratic.move(to: CGPoint(x: 1, y: 3))
		quadratic.addQuadCurve(to: CGPoint(x: 21, y: 9), control: CGPoint(x: 6, y: 28))
		let cubic = CGMutablePath()
		cubic.move(to: CGPoint(x: 2, y: 1))
		cubic.addCurve(to: CGPoint(x: 22, y: 19), control1: CGPoint(x: -8, y: 31), control2: CGPoint(x: 32, y: -7))
		cubic.closeSubpath()
		let multiple = CGMutablePath()
		for path in [closed, quadratic, cubic, open] { multiple.addPath(path) }
		return [empty, move, open, closed, quadratic, cubic, multiple,
			CGPath(rect: CGRect(x: 1.25, y: 2.5, width: 17.75, height: 13.125), transform: nil),
			CGPath(ellipseIn: CGRect(x: 1.25, y: 2.5, width: 17.75, height: 13.125), transform: nil),
			ring(oppositeWinding: false), ring(oppositeWinding: true)]
	}

	private func ring(oppositeWinding: Bool) -> CGPath {
		let path = CGMutablePath()
		path.addRect(CGRect(x: 0, y: 0, width: 20, height: 20))
		let inner = [CGPoint(x: 5, y: 5), CGPoint(x: 15, y: 5), CGPoint(x: 15, y: 15), CGPoint(x: 5, y: 15)]
		let points = oppositeWinding ? Array(inner.reversed()) : inner
		path.addLines(between: points)
		path.closeSubpath()
		return path
	}

	private struct Element: Equatable {
		let type: CGPathElementType
		let points: [CGPoint]
	}

	private func elements(_ path: CGPath) -> [Element] {
		var result: [Element] = []
		path.applyWithBlockSafe { pointer in
			let element = pointer.pointee
			let count: Int
			switch element.type {
			case .moveToPoint, .addLineToPoint: count = 1
			case .addQuadCurveToPoint: count = 2
			case .addCurveToPoint: count = 3
			case .closeSubpath: count = 0
			@unknown default: XCTFail("Unexpected path element"); count = 0
			}
			result.append(Element(type: element.type, points: Array(UnsafeBufferPointer(start: element.points, count: count))))
		}
		return result
	}

	private func check(_ actual: CGPath, _ expected: CGPath, label: String,
		file: StaticString = #filePath, line: UInt = #line) throws {
		let got = elements(actual)
		let wanted = elements(expected)
		XCTAssertEqual(got.count, wanted.count, label, file: file, line: line)
		for (a, e) in zip(got, wanted) {
			XCTAssertEqual(a.type, e.type, label, file: file, line: line)
			XCTAssertEqual(a.points.count, e.points.count, label, file: file, line: line)
			for (ap, ep) in zip(a.points, e.points) {
				XCTAssertEqual(ap.x, ep.x, accuracy: 1e-10, label, file: file, line: line)
				XCTAssertEqual(ap.y, ep.y, accuracy: 1e-10, label, file: file, line: line)
			}
		}
		XCTAssertEqual(actual.isEmpty, expected.isEmpty, label, file: file, line: line)
		XCTAssertEqual(actual.currentPoint.x, expected.currentPoint.x, accuracy: 1e-10, label, file: file, line: line)
		XCTAssertEqual(actual.currentPoint.y, expected.currentPoint.y, accuracy: 1e-10, label, file: file, line: line)
		// The identity-append control-bounds cache is intentionally not required to
		// match native transformed append. Tight bounds, ordered geometry and pixels are.
		for (boundsName, a, e) in [("path bounds", actual.boundingBoxOfPath, expected.boundingBoxOfPath)] {
			// Native rectangle/ellipse expansion can differ in the last few bits; use
			// the same coordinate tolerance as the style suites, with exact raster checks.
			if a.isNull || e.isNull { XCTAssertEqual(a, e, label, file: file, line: line) }
			else {
				for (av, ev) in [(a.minX, e.minX), (a.minY, e.minY), (a.maxX, e.maxX), (a.maxY, e.maxY)] {
					XCTAssertEqual(av, ev, accuracy: 1e-10, "\(label): \(boundsName)", file: file, line: line)
				}
			}
		}
		for mode: CGPathDrawingMode in [.fill, .eoFill, .stroke] {
			XCTAssertEqual(try raster(actual, mode: mode), try raster(expected, mode: mode), label, file: file, line: line)
		}
	}

	private func raster(_ path: CGPath, mode: CGPathDrawingMode) throws -> Data {
		let width = 192
		let height = 192
		var bytes = [UInt8](repeating: 0, count: width * height * 4)
		try bytes.withUnsafeMutableBytes { buffer in
			let context = try XCTUnwrap(CGContext(data: buffer.baseAddress, width: width, height: height,
				bitsPerComponent: 8, bytesPerRow: width * 4, space: CGColorSpaceCreateDeviceRGB(),
				bitmapInfo: CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue))
			context.translateBy(x: 64, y: 64)
			let color = CGColor(red: 0.15, green: 0.35, blue: 0.7, alpha: 0.65)
			context.setFillColor(color)
			context.setStrokeColor(color)
			context.setLineWidth(0.75)
			context.addPath(path)
			context.drawPath(using: mode)
		}
		return Data(bytes)
	}
}
