#!/usr/bin/env bash

version=0.4.0

mkdir -p build && cd build

wget -nc "https://raw.githubusercontent.com/TheAssassin/linuxdeploy-plugin-conda/master/linuxdeploy-plugin-conda.sh"
wget -nc "https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage"
chmod +x linuxdeploy-x86_64.AppImage linuxdeploy-plugin-conda.sh
cp ../appimage/AppRun.sh .

cat > tmon.desktop <<EOF
[Desktop Entry]
Type=Application
Name=tmon
GenericName=Temperature Monitor
Comment=Temperature Monitor -- a CLI tool for monitoring/reporting CPU temperatures.
Icon=tmon
Exec=tmon
Terminal=true
Categories=Utility;
EOF

export PKG_OUT_DIR=pkg-out

mkdir -p $PKG_OUT_DIR
conda build --output-folder $PKG_OUT_DIR ..

export CONDA_CHANNELS='local;conda-forge'
export CONDA_PACKAGES=$PKG_OUT_DIR/linux-64/tmon-$version-py37_0.tar.bz2
# export PIP_REQUIREMENTS='numpy pandas scipy'

./linuxdeploy-x86_64.AppImage \
    --appdir AppDir \
    -i ../data/tmon.png \
    -d tmon.desktop \
    --plugin conda \
    --custom-apprun AppRun.sh \
    --output appimage
