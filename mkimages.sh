#!/bin/sh

defprefix="frr-build/"

help() {
	cat <<EOF
FRR docker image creator

Usage:
	./mkimages.sh [-p PREFIX] [-H HTTP_PROXY] [IMAGES]

git input options:
    -p PREFIX		name prefix to add on image tag names.  defaults to
			"$defprefix", so images will be tagged as
			${defprefix}debian/jessie and co.  Make sure to include
			the / if you want it.

    -H HTTP_PROXY	value to pass to docker using --build-args http_proxy.
			default: none.

			Note: other docker args can be passed by setting an
			environment variable named DOCKER_ARGS.

IMAGES: name(s) of images to be built.  evaluated with egrep (use regex).
default: build all images.

The following images are available:
EOF
	egrep -v '^(\s*$|#)' "$selfdir/images.lst" \
		| sort | sed -e 's%^\s*%\t%'
}

set -e

options=`getopt -o 'hp:H:B:' -- "$@"`
set - $options

prefix="$defprefix"

base="`pwd`"
cd "`dirname \"$0\"`"
selfdir="`pwd`"

while test $# -gt 0; do
	arg="$1"; shift; optarg=$1
	case "$arg" in
	-h)	help
		exit 0
		;;
	-p)	eval prefix=$optarg
		shift
		;;
	-H)	eval http_proxy=$optarg
		shift
		;;
	--)	break;
		;;
	*)	echo something went wrong with getopt
		exit 1
		;;
	esac
done

test -n "$http_proxy" && http_proxy="--build-arg http_proxy=$http_proxy"

imagelist="`mktemp`"
onexit() {
	rm "$imagelist"
}
trap onexit EXIT

add_image() {
	local spec specv

	spec="$1"
	eval "specv=$spec"
	test "$specv" = "all" && spec="''"
	egrep -v '^(\s*$|#)' "$selfdir/images.lst" | \
		eval egrep $spec | \
		while read N; do
			if fgrep "$N" "$imagelist"; then
				true
			else
				echo "$N" >> "$imagelist"
			fi
		done
}

do_build() {
	set -x
	docker build $DOCKER_ARGS $http_proxy \
		--build-arg "OSNAME=$OSNAME" \
		--build-arg "OSREL=$OSREL" \
		"$@"
	rv="$?"
	set +x
	return $rv
}

image() {
	local image OSVER OSREL osdir

	image="$1"
	archimage="$2"

	OSNAME="${archimage%/*}"
	OSREL="${archimage##*/}"
	osdir="${image%/*}"

	if test -d "$image"; then
		do_build -t "$prefix$archimage" "$image"
		return $?
	fi
	if test -d "$osdir" -a -f "$osdir/Dockerfile"; then
		do_build -t "$prefix$archimage" -f "$osdir/Dockerfile" "$osdir"
		return $?
	fi
	if test "${image#i386/}" != "$image"; then
		image "${image#i386/}" "$image"
		return $?
	fi

	echo "no idea how to build $image!" >&2
	return 1
}

test $# -eq 0 && set -- all
while test $# -gt 0; do
	add_image $1
	shift
done
echo 'building the following images:' >&2
cat "$imagelist" | sed -e 's%^%\t%' >&2
echo '' >&2

cat "$imagelist" | while read i; do
	image "$i" "$i"
done
