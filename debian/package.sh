#!/bin/sh

set -e -x

tar zxf frr-dist.tar.gz
cd frr-dist
ln -s debianpkg debian

VERSION="`dpkg-parsechangelog -S Version`"

getsuffix() {
	# suffix is used to have packages for different releases without name
	# collisions.  +pkgdeb is used instead of +deb to signal it's not an
	# official Debian thing.

	local NAME VERSION ID ID_LIKE PRETTY_NAME VERSION_ID
	. /etc/os-release

	if test -z "$VERSION_ID"; then
		dver="`cat /etc/debian_version`"
		case "$dver" in
		buster*)	VERSION_ID=10 ;;
		*)		VERSION_ID=X ;;
		esac
	fi
	SUFFIX="+`echo $ID | cut -c 1-3`$VERSION_ID"
}

getsuffix

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
