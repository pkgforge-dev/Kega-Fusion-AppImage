#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
tee -a /etc/pacman.conf <<EOF

[multilib]
Include = /etc/pacman.d/mirrorlist
EOF
pacman -Syu --noconfirm \
    lib32-alsa-plugins  \
    lib32-atk           \
    lib32-cairo         \
    lib32-gdk-pixbuf2   \
    lib32-glib2         \
    lib32-libcups       \
    lib32-librsvg       \
    lib32-libx11        \
    lib32-libxcomposite \
    lib32-libxcursor    \
    lib32-libxdamage    \
    lib32-libxext       \
    lib32-libxfixes     \
    lib32-libxi         \
    lib32-libxinerama   \
    lib32-libxrandr     \
    lib32-libxrender    \
    lib32-pango

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
make-aur-package gtk2
make-aur-package lib32-gtk2
make-aur-package kega-fusion

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
