#!/usr/bin/env bash

APPIMAGETOOL_URL=https://github.com/AppImage/AppImageKit/releases/download/13/appimagetool-x86_64.AppImage

mkdir -p $AWD_ACTION_BINDIR

case "$RUNNER_OS" in
    Linux*)
        sudo apt-get update
        sudo apt-get install -y \
             libdbus-1-dev libibus-1.0-dev libudev-dev \
             libegl1-mesa-dev libgl1-mesa-dev libgles2-mesa-dev \
             libwayland-dev \
             libx11-dev libxcursor-dev libxext-dev libxi-dev libxinerama-dev libxkbcommon-dev \
             libxrandr-dev libxt-dev libxv-dev libxxf86vm-dev
        curl -L "$APPIMAGETOOL_URL" \
             --output $AWD_ACTION_BINDIR/appimagetool \
            && chmod +x $AWD_ACTION_BINDIR/appimagetool
    ;;
    *)
        echo "Unsupported OS: $RUNNER_OS"
        exit -1
    ;;
esac
