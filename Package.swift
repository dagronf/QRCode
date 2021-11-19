// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "QRCode",
	platforms: [
		.macOS(.v10_11),
		.iOS(.v13),
		.tvOS(.v13),
	],
	products: [
		// Products define the executables and libraries a package produces, and make them visible to other packages.
		.library(
			name: "QRCode",
			type: .dynamic,
			targets: ["QRCode"]
		),
		.library(
			name: "QRCodeStatic",
			type: .static,
			targets: ["QRCode"]
		),
	],
	dependencies: [
		// Dependencies declare other packages that this package depends on.
		// .package(url: /* package url */, from: "1.0.0"),
		.package(
			name: "swift-argument-parser",
			url: "https://github.com/apple/swift-argument-parser",
			.upToNextMinor(from: "0.4.3")
		),
	],
	targets: [
		// Targets are the basic building blocks of a package. A target can define a module or a test suite.
		// Targets can depend on other targets in this package, and on products in packages this package depends on.
		.target(
			name: "QRCode",
			dependencies: []
		),
		.executableTarget(
			 name: "qrcodegen",
			 dependencies: [
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
				.byNameItem(name: "QRCode", condition: nil)
			 ]),
		.testTarget(
			name: "QRCodeTests",
			dependencies: ["QRCode"]
		),
	]
)
