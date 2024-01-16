// swift-tools-version: 5.4

import PackageDescription

let package = Package(
	name: "QRCode",
	platforms: [
		.macOS(.v10_13),
		.iOS(.v13),
		.tvOS(.v13),
		.watchOS(.v6)
	],
	products: [
		// QR Code generation library
		.library(name: "QRCode", targets: ["QRCode"]),
		.library(name: "QRCodeStatic", type: .static, targets: ["QRCode"]),
		.library(name: "QRCodeDynamic", type: .dynamic, targets: ["QRCode"]),

		// QR Code video detection library
		.library(name: "QRCodeDetector", type: .dynamic, targets: ["QRCodeDetector"]),
	],
	dependencies: [
		// Swift argument parser is used for the command-line application
		.package(
			name: "swift-argument-parser",
			url: "https://github.com/apple/swift-argument-parser",
			.upToNextMinor(from: "0.4.3")
		),

		// A 3rd-party QR code generation library for watchOS, forked from https://github.com/fwcd/swift-qrcode-generator
		.package(
			url: "https://github.com/dagronf/swift-qrcode-generator",
			.upToNextMinor(from: "2.0.2")
		),

		// A microframework for cleaning handling image conversion
		.package(
			url: "https://github.com/dagronf/SwiftImageReadWrite",
			.upToNextMinor(from: "1.6.1")
		),
	],
	targets: [
		// The QRCode core library
		.target(
			name: "QRCode",
			dependencies: [
				"SwiftImageReadWrite",
				.product(
					name: "QRCodeGenerator",
					package: "swift-qrcode-generator"
				),
			]
		),

		// The QR code detector library
		.target(name: "QRCodeDetector"),

		// the qrcodegen command-line tool
		.executableTarget(
			name: "qrcodegen",
			dependencies: [
				"QRCode",
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
			]),

		// testing target
		.testTarget(
			name: "QRCodeTests",
			dependencies: ["QRCode"],
			resources: [
				.process("Resources"),
			]
		),
	]
)
