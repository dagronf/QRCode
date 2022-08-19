#!/bin/bash

# Basic sanity check before commit that all the expected targets build and test

# Note: don't include 'arch=' within the destination on macOS builds so it _should_ work for M1 arm based macs as well as Intel

# Stop on error
set -e

echo "**"
echo "** macOS x86 command line tool build..."
echo "**"
swift build -c release --arch x86_64

echo "**"
echo "** Basic ARM64 build attempt for macOS..."
echo "**"
swift build -c release --arch arm64

echo "**"
echo "** macOS build and test..."
echo "**"
xcodebuild clean build archive test -scheme "QRCode" -destination 'platform=macOS' -quiet
xcodebuild clean build archive test -scheme "QRCodeExternal" -destination 'platform=macOS' -quiet

echo "**"
echo "** macCatalyst build and test..."
echo "**"
xcodebuild clean build archive test -scheme "QRCode" -destination 'platform=macOS,variant=Mac Catalyst' -quiet
xcodebuild clean build archive test -scheme "QRCodeExternal" -destination 'platform=macOS,variant=Mac Catalyst' -quiet

echo "**"
echo "** iOS build and test..."
echo "**"
xcodebuild clean build archive test -scheme "QRCode" -destination 'platform=iOS Simulator,name=IPhone 11 Pro Max' -quiet
xcodebuild clean build archive test -scheme "QRCodeExternal" -destination 'platform=iOS Simulator,name=IPhone 11 Pro Max' -quiet

echo "**"
echo "** ipadOS build and test..."
echo "**"
xcodebuild clean build archive test -scheme "QRCode" -destination 'platform=iOS Simulator,name=iPad Air (5th generation)' -quiet
xcodebuild clean build archive test -scheme "QRCodeExternal" -destination 'platform=iOS Simulator,name=iPad Air (5th generation)' -quiet

echo "**"
echo "** tvOS build and test..."
echo "**"
xcodebuild clean build archive test -scheme "QRCode" -destination 'platform=tvOS Simulator,name=Apple TV' -quiet
xcodebuild clean build archive test -scheme "QRCodeExternal" -destination 'platform=tvOS Simulator,name=Apple TV' -quiet

echo "**"
echo "** watchOS build and test..."
echo "**"
xcodebuild clean build archive test -scheme "QRCodeExternal" -destination 'platform=watchOS Simulator,name=Apple Watch Series 6 - 44mm' -quiet
