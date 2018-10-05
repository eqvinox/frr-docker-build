#!/bin/sh

tar zxvf frr-dist.tar.gz
cd frr-dist
ln -s debianpkg debian

if test -f /usr/lib/*/pkgconfig/rtrlib.pc; then
	sed -e 's%WANT_RPKI ?= 0%WANT_RPKI = 1%' -i debian/rules
fi

sed -e 's%WANT_SNMP ?= 0%WANT_SNMP = 1%' -i debian/rules

dpkg-buildpackage -b
cd ..
mv *.deb *.buildinfo *.changes output/
