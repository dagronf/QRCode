#!/bin/bash

# Basic sanity check before commit that all the expected targets build and test

# Note: don't include 'arch=' within the destination on macOS builds so it _should_ work for M1 arm based macs as well as Intel

# Stop on error
set -e

ORIGDIR=$PWD
BASEDIR=$(dirname $(realpath "$0"))

pushd .

# Move back up to the QRCode root directory, or else Xcode complains...
cd "${BASEDIR}"/../..

echo ">>>> macOS build and test..."

echo "---> macOS build command line..."
swift build -c release --arch x86_64

echo "---> macOS build command line (ARM64)..."
swift build -c release --arch arm64

echo "---> macOS build library..."
xcodebuild clean build archive test -scheme "QRCode" -destination 'platform=macOS,variant=macos' -quiet

echo "<<<< macOS build and test COMPLETE..."

popd
