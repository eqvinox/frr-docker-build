#!/bin/sh

tar zxvf frr-dist.tar.gz
cd frr-dist
ln -s debianpkg debian

if pkg-config --exists rtrlib; then
	sed -e 's%WANT_RPKI ?= 0%WANT_RPKI = 1%' -i debian/rules
	profile="-Ppkg.frr.rtrlib"
else
	profile="-Ppkg.frr.nortrlib"
fi

sed -e 's%WANT_SNMP ?= 0%WANT_SNMP = 1%' -i debian/rules

dpkg-buildpackage -b $profile
cd ..
mv *.deb output/
test *.buildinfo != '*.buildinfo' && mv *.buildinfo output/
test *.changes   != '*.changes'   && mv *.changes   output/
