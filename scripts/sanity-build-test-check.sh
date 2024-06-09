#!/bin/bash

# Basic sanity check before commit that all the expected targets build and test

# Note: don't include 'arch=' within the destination on macOS builds so it _should_ work for M1 arm based macs as well as Intel

# Stop on error
set -e

ORIGDIR=$PWD
BASEDIR=$(dirname $(realpath "$0"))

echo "Testing starting..."

${BASEDIR}/platform/macOS-build-test.sh
${BASEDIR}/platform/macCatalyst-build-test.sh
${BASEDIR}/platform/iOS-build-test.sh
${BASEDIR}/platform/ipadOS-build-test.sh
${BASEDIR}/platform/tvOS-build-test.sh
${BASEDIR}/platform/watchOS-build-test.sh

echo "... testing complete"
