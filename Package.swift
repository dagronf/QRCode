// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "QRCode",
	platforms: [
		.macOS(.v10_11),
		.iOS(.v13),
		.tvOS(.v13),
		.watchOS(.v6)
	],
	products: [

		// Static/Dynamic QRCode libraries

		.library(
			name: "QRCode",
			type: .static,
			targets: ["QRCode"]
		),
		.library(
			name: "QRCodeDynamic",
			type: .dynamic,
			targets: ["QRCode"]
		),

		// watchOS convenience including the 3rd party generator

		.library(
			name: "QRCodeWatchOS",
			type: .static,
			targets: ["QRCode", "QRCode3rdPartyGenerator"]
		),

		.library(
			name: "QRCodeWatchOSDynamic",
			type: .dynamic,
			targets: ["QRCode", "QRCode3rdPartyGenerator"]
		),

		// A wrapper around a 3rd party QR Code generator

		.library(
			name: "QRCode3rdPartyGenerator",
			type: .static,
			targets: ["QRCode3rdPartyGenerator"]
		),
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
		)
	],
	targets: [
		// The core qr code library
		.target(
			name: "QRCode",
			dependencies: []
		),

		// The wrapper library for the 3rd party qr code generator
		.target(
			name: "QRCode3rdPartyGenerator",
			dependencies: [
				.product(
					name: "QRCodeGenerator",
					package: "swift-qrcode-generator"
				),
				.byNameItem(name: "QRCode", condition: nil)
			]
		),

		// the qrcodegen command-line tool
		.executableTarget(
			 name: "qrcodegen",
			 dependencies: [
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
				.byNameItem(name: "QRCode", condition: nil)
			 ]),

		// testing target
		.testTarget(
			name: "QRCodeTests",
			dependencies: ["QRCode", "QRCode3rdPartyGenerator"],
			resources: [
				.process("resources"),
			]
		),
	]
)
