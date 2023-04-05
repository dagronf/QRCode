#!/bin/zsh

set -e

ORIGDIR=$PWD

BASEDIR=$(dirname $(realpath "$0"))
#echo "$BASEDIR"

# Move back up to the QRCode root directory, or else Xcode complains...
cd "${BASEDIR}"/..

# macOS
env DEVELOPER_DIR="/Applications/Xcode.app" xcrun swift build --target QRCode --arch arm64
env DEVELOPER_DIR="/Applications/Xcode.app" xcrun swift build --target QRCode --arch x86_64

# iOS
env DEVELOPER_DIR="/Applications/Xcode.app" xcrun xcodebuild -IDEClonedSourcePackagesDirPathOverride="$PWD/sanitybuild/.dependencies" -derivedDataPath "$PWD/sanitybuild/.derivedData" build -scheme QRCode -destination "generic/platform=ios"

# watchOS
env DEVELOPER_DIR="/Applications/Xcode.app" xcrun xcodebuild -IDEClonedSourcePackagesDirPathOverride="$PWD/sanitybuild/.dependencies" -derivedDataPath "$PWD/sanitybuild/.derivedData" build -scheme QRCode -destination "generic/platform=watchos"

# tvOS
env DEVELOPER_DIR="/Applications/Xcode.app" xcrun xcodebuild -IDEClonedSourcePackagesDirPathOverride="$PWD/sanitybuild/.dependencies" -derivedDataPath "$PWD/sanitybuild/.derivedData" build -scheme QRCode -destination "generic/platform=tvos"

# Move back into the original folder
cd ${ORIGDIR}