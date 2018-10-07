#!/bin/sh

set -e -x

tar zxf frr-dist.tar.gz
cd frr-dist
ln -s debianpkg debian

VERSION="`dpkg-parsechangelog -S Version`"
# suffix is used to have packages for different releases without name
# collisions.  +pkgdeb is used instead of +deb to signal it's not an
# official Debian thing.
case "`cat /etc/debian_version`" in
buster*|10|10.*)	SUFFIX="+pkgdeb10" ;;
stretch*|9|9.*)		SUFFIX="+pkgdeb9" ;;
jessie*|8|8.*)		SUFFIX="+pkgdeb8" ;;
*)			SUFFIX="+unknown" ;;
esac

# TODO: need incremental snapshot numbers or something here
sed -e "1 s%(.*)%($VERSION$SUFFIX)%" -i debian/changelog
sed -e "1 s%(.*)%($VERSION$SUFFIX)%" -i debian/changelog.in

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
