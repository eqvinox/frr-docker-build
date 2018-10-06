#!/bin/sh

cd /openwrt
eval "`tar -Oxf /build/frr-dist.tar.gz frr-dist/configure | egrep '^PACKAGE_VERSION='`"
echo "version: $PACKAGE_VERSION"

sed \
	-e '/^PKG_BUILD_DIR/ c PKG_BUILD_DIR = $(BUILD_DIR)/$(PKG_NAME)-dist' \
	-e '/^PKG_VERSION/ c PKG_VERSION:='"$PACKAGE_VERSION" \
	-e '/^PKG_SOURCE_URL/ d' \
	-i feeds/routing/frr/Makefile

cp /build/frr-dist.tar.gz "dl/frr-$PACKAGE_VERSION.tar.gz"

rmfiles="feeds/routing/frr/patches/001-openwrt-python-zlib-fix-link.patch \
feeds/routing/frr/patches/002-watchfrr-fix-global-restart.patch"
for i in $rmfiles; do rm -vf "$i"; done

make package/frr/compile V=s

cd bin/packages
find . | grep /frr- | tar cT /dev/fd/0 | tar xvC /build/output
