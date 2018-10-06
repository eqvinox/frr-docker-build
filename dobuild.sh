#!/bin/sh

set -e -x
if [ "`id -u`" = "0" ]; then
	cd /build
	chown -R frrbuild: . /root
	# do NOT make this an "exec", su can't be pid 1
	su frrbuild /build/dobuild.sh "$@"
	exit $?
fi

export PATH="/build:$PATH"
[ -f /root/build.env ] && . /root/build.env

target="$1"

cd /build
mkdir output

if [ -x /build/tsrun ]; then
	tsrun="tsrun -cao /build/log --"
else
	echo "tsrun not available, log won\'t be timestamped and saved" >&2
fi

tarball() {
	echo "building dist tarball..."
	cd frr-source
	$tsrun autoreconf -f -i -s
	cd ..

	mkdir frr-distbuild
	cd frr-distbuild
	$tsrun ../frr-source/configure --enable-numeric-version
	$tsrun make distdir=frr-dist dist-gzip
	cd ..
	cp frr-distbuild/frr-dist.tar.gz output/
	ln -s output/frr-dist.tar.gz frr-dist.tar.gz

	rm -rf frr-distbuild
	rm -rf frr-source
}

need_tarball() {
	if test -d frr-source; then
		tarball
	elif test \! -f frr-dist.tar.gz; then
		echo ERROR: no source directory and no tarball supplied >&2
		exit 1
	fi
}

build() {
	need_tarball

	$tsrun tar zxf frr-dist.tar.gz
	mkdir frr-build
	cd frr-build
	$tsrun ../frr-dist/configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var $FRR_CONFIGURE_ARGS
	$tsrun make -j16
	[ -d hosttools ] || $tsrun make -j16 check
	$tsrun make DESTDIR=/build/frr-install install
	cd /build/frr-install
	tar zcvpf /build/output/frr-fs.tar.gz --transform='s%^./%/%' .
}

package() {
	need_tarball

	if test -x /root/package.sh; then
		echo package: target-specific build
		$tsrun /root/package.sh
	else
		echo package: generic build
		/bin/bash --login
		build
	fi
}

shell() {
	/bin/bash
}

$target
