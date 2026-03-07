#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q kega-fusion | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/pixmaps/kega-fusion.png
export DESKTOP=/usr/share/applications/kega-fusion.desktop
export DEPLOY_OPENGL=1
export LIB_DIR=/usr/lib32 

# Deploy dependencies
quick-sharun /usr/bin/kega-fusion /usr/lib/kega-fusion

sed -i -e 's|/usr|$APPDIR|g' ./AppDir/bin/kega-fusion

# because kega-fusion is a shell script that launches
# $APPDIR/lib/kega-fusion/Fusion, this causes sharun to fail to find
# SHARUN_DIR, since sharun can only be executed outside $APPDIR/bin
# when the SHARUN_DIR env variable is set
echo 'export SHARUN_DIR=$APPDIR' > ./AppDir/bin/set-sharun-dir.src.hook

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
