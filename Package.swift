// swift-tools-version: 5.4

import PackageDescription

let package = Package(
	name: "QRCode",
	defaultLocalization: "en",
	platforms: [
		.macOS(.v10_11),
		.iOS(.v13),
		.tvOS(.v13),
		.watchOS(.v6)
	],
	products: [
		.library(name: "QRCode", targets: ["QRCode"]),
		.library(name: "QRCodeStatic", type: .static, targets: ["QRCode"]),
		.library(name: "QRCodeDynamic", type: .dynamic, targets: ["QRCode"]),
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
			.upToNextMinor(from: "1.0.3")
		),

		// A microframework for cleaning handling image conversion
		.package(
			url: "https://github.com/dagronf/SwiftImageReadWrite",
			.upToNextMinor(from: "1.1.6")
		),
	],
	targets: [
		// The qr code library
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
