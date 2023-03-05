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

echo "** macOS build and test COMPLETE..."
echo

echo "**"
echo "** macCatalyst build and test..."
echo "**"

xcodebuild clean build archive -scheme "QRCode" -destination 'generic/platform=macOS,variant=Mac Catalyst' -quiet
xcodebuild test -scheme "QRCode" -destination 'platform=macOS,variant=Mac Catalyst' -quiet

echo "** macCatalyst build and test COMPLETE..."
echo

echo "**"
echo "** iOS build and test..."
echo "**"

xcodebuild clean build archive -scheme "QRCode" -destination 'generic/platform=iOS' -quiet
xcodebuild test -scheme "QRCode" -destination 'platform=iOS Simulator,name=iPhone 11 Pro Max' -quiet

echo "** iOS build and test COMPLETE..."
echo

echo "**"
echo "** ipadOS build and test..."
echo "**"

xcodebuild test -scheme "QRCode" -destination 'platform=iOS Simulator,name=iPad Air (5th generation)' -quiet

echo "** ipadOS build and test COMPLETE..."
echo

echo "**"
echo "** tvOS build and test..."
echo "**"

xcodebuild clean build archive -scheme "QRCode" -destination 'generic/platform=tvOS' -quiet
xcodebuild test -scheme "QRCode" -destination 'platform=tvOS Simulator,name=Apple TV' -quiet

echo "** tvOS build and test COMPLETE..."
echo

echo "**"
echo "** watchOS build and test..."
echo "**"

xcodebuild clean build archive -scheme "QRCode" -destination 'generic/platform=watchOS' -quiet
xcodebuild test -scheme "QRCode" -destination 'platform=watchOS Simulator,name=Apple Watch Series 5 (40mm)' -quiet

echo "** watchOS build and test COMPLETE..."
