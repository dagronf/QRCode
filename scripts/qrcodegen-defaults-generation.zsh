#!/bin/zsh

set -e

ORIGDIR=$PWD

BASEDIR=$(dirname $(realpath "$0"))

# Move back up to the QRCode root directory, or else Xcode complains...
cd "${BASEDIR}"/..

# Build qrcodegen in release
swift build -c release

TEMPDIR=$(mktemp -d)
echo $TEMPDIR

# Pixel styles

pixelStyles=(`./.build/release/qrcodegen --all-pixel-shapes`)
for i in ${pixelStyles[@]}
do
	./.build/release/qrcodegen -c H -t "This is a QR code" -d $i --data-color "0.7,0.0,0.0,1.0" --eye-color "0.0,0.0,0.0,1.0" --output-format pdf --output-file "${TEMPDIR}/pixel-${i}.pdf" 512
done

# Eye styles

eyeStyles=(`./.build/release/qrcodegen --all-eye-shapes`)
for i in ${eyeStyles[@]}
do
	./.build/release/qrcodegen -c H -t "This is a QR code" -d square -e $i --eye-color "0.7,0.0,0.0,1.0" --output-format pdf --output-file "${TEMPDIR}/eye-${i}.pdf" 512
done

# Pupil styles

pupilStyles=(`./.build/release/qrcodegen --all-pupil-shapes`)
for i in ${pupilStyles[@]}
do
	./.build/release/qrcodegen -c H -t "This is a QR code" -d square -p $i --pupil-color "0.7,0.0,0.0,1.0" --output-format pdf --output-file "${TEMPDIR}/pupil-${i}.pdf" 512
done

open ${TEMPDIR}
