#!/bin/zsh

set -e

ORIGDIR=$PWD

BASEDIR=$(dirname $(realpath "$0"))
#echo "$BASEDIR"

# Move back up to the QRCode root directory, or else Xcode complains...
cd "${BASEDIR}"/..

# Build qrcodegen in release
swift build -c release

TEMPDIR=$(mktemp -d)
echo $TEMPDIR

# circle, curvePixel, flower, horizontal, pointy, roundedEndIndent,
# roundedPath, roundedRect, sharp, shiny, square, squircle, star, vertical

./.build/release/qrcodegen -c H -t "This is a QR code" -d circle --output-file "${TEMPDIR}/pixel-circle.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d curvePixel --output-file "${TEMPDIR}/pixel-curvePixel.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d flower --output-file "${TEMPDIR}/pixel-flower.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d horizontal --output-file "${TEMPDIR}/pixel-horizontal.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d pointy --output-file "${TEMPDIR}/pixel-pointy.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d roundedEndIndent --output-file "${TEMPDIR}/pixel-oundedEndIndent.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d roundedPath --output-file "${TEMPDIR}/pixel-roundedPath.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d roundedRect --output-file "${TEMPDIR}/pixel-roundedRect.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d sharp --output-file "${TEMPDIR}/pixel-sharp.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d shiny --output-file "${TEMPDIR}/pixel-shiny.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square --output-file "${TEMPDIR}/pixel-square.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d squircle --output-file "${TEMPDIR}/pixel-squircle.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d star --output-file "${TEMPDIR}/pixel-star.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d vertical --output-file "${TEMPDIR}/pixel-vertical.png" 512

# barsHorizontal, barsVertical, circle, corneredPixels, edges, fireball, leaf, peacock, pixels,
# roundedOuter, roundedPointingIn, roundedPointingOut, roundedRect, shield, square, squircle,
# teardrop, ufo, usePixelShape

./.build/release/qrcodegen -c H -t "This is a QR code" -d square -e barsHorizontal --output-file "${TEMPDIR}/eye-barsHorizontal.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -e barsVertical --output-file "${TEMPDIR}/eye-barsVertical.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -e circle --output-file "${TEMPDIR}/eye-circle.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -e corneredPixels --output-file "${TEMPDIR}/eye-corneredPixels.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -e edges --output-file "${TEMPDIR}/eye-edges.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -e fireball --output-file "${TEMPDIR}/eye-fireball.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -e leaf --output-file "${TEMPDIR}/eye-leaf.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -e peacock --output-file "${TEMPDIR}/eye-peacock.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -e pixels --output-file "${TEMPDIR}/eye-pixels.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -e roundedOuter --output-file "${TEMPDIR}/eye-roundedOuter.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -e roundedPointingIn --output-file "${TEMPDIR}/eye-roundedPointingIn.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -e roundedPointingOut --output-file "${TEMPDIR}/eye-roundedPointingOut.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -e roundedRect --output-file "${TEMPDIR}/eye-roundedRect.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -e shield --output-file "${TEMPDIR}/eye-shield.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -e square --output-file "${TEMPDIR}/eye-square.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -e squircle --output-file "${TEMPDIR}/eye-squircle.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -e teardrop --output-file "${TEMPDIR}/eye-teardrop.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -e ufo --output-file "${TEMPDIR}/eye-ufo.png" 512

# barsHorizontal, barsVertical, blobby, circle, corneredPixels, edges, hexagonLeaf, leaf, pixels,
# roundedOuter, roundedPointingIn, roundedPointingOut, roundedRect, seal, shield, square, squircle, teardrop, ufo,

./.build/release/qrcodegen -c H -t "This is a QR code" -d square -p barsHorizontal --output-file "${TEMPDIR}/pupil-barsHorizontal.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -p barsVertical --output-file "${TEMPDIR}/pupil-barsVertical.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -p blobby --output-file "${TEMPDIR}/pupil-blobby.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -p circle --output-file "${TEMPDIR}/pupil-circle.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -p corneredPixels --output-file "${TEMPDIR}/pupil-corneredPixels.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -p edges --output-file "${TEMPDIR}/pupil-edges.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -p hexagonLeaf --output-file "${TEMPDIR}/pupil-hexagonLeaf.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -p leaf --output-file "${TEMPDIR}/pupil-leaf.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -p pixels --output-file "${TEMPDIR}/pupil-pixels.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -p roundedOuter --output-file "${TEMPDIR}/pupil-roundedOuter.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -p roundedPointingIn --output-file "${TEMPDIR}/pupil-roundedPointingIn.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -p roundedPointingOut --output-file "${TEMPDIR}/pupil-roundedPointingOut.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -p roundedRect --output-file "${TEMPDIR}/pupil-roundedRect.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -p seal --output-file "${TEMPDIR}/pupil-seal.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -p shield --output-file "${TEMPDIR}/pupil-shield.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -p square --output-file "${TEMPDIR}/pupil-square.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -p squircle --output-file "${TEMPDIR}/pupil-squircle.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -p teardrop --output-file "${TEMPDIR}/pupil-teardrop.png" 512
./.build/release/qrcodegen -c H -t "This is a QR code" -d square -p ufo --output-file "${TEMPDIR}/pupil-ufo.png" 512

open ${TEMPDIR}
