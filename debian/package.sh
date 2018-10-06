#!/bin/sh

tar zxvf frr-dist.tar.gz
cd frr-dist
ln -s debianpkg debian

if test -f /usr/lib/*/pkgconfig/rtrlib.pc; then
	sed -e 's%WANT_RPKI ?= 0%WANT_RPKI = 1%' -i debian/rules
	profile="--build-profiles=pkg.frr.rtrlib"
fi

sed -e 's%WANT_SNMP ?= 0%WANT_SNMP = 1%' -i debian/rules

dpkg-buildpackage -b $profile
cd ..
mv *.deb output/
test *.buildinfo != '*.buildinfo' && mv *.buildinfo output/
test *.changes   != '*.changes'   && mv *.changes   output/
