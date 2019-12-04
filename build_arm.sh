#!/bin/bash

# Build and package QGroundControl for arm

echo "Creating ${SHADOW_BUILD_DIR}"

mkdir -p ${SHADOW_BUILD_DIR}
cd ${SHADOW_BUILD_DIR}

echo "Configuring project"

qmake -r /build/qgroundcontrol.pro CONFIG+=installer DEFINES+=__rasp_pi2__

echo "Building project"

make -j2

echo "Preparing deployment"

cd /build
./deploy/create_linux_appimage_arm.sh /build ${SHADOW_BUILD_DIR}/release ${SHADOW_BUILD_DIR}/release/package
