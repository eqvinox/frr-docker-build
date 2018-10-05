#!/bin/sh

help() {
	cat <<EOF
FRR docker build runner

Usage:
	./build.sh -i IMAGE [-s GITPATH] [-C GITCOMMIT] [TARGET]
	./build.sh -i IMAGE -T TARBALL [TARGET]

git input options:
    -s GITPATH		path to git working tree or bare repository.
			default: current directory
    -C GITCOMMIT	git commit / branch to build
			default: HEAD

tarball input options:
    -T TARBALL		path to FRR dist tarball

general options:
    -i IMAGE		docker image to use for building (mandatory)
    -d WORKDIR		work directory to use
			default: /tmp/frrbuild.XXXXXX
TARGETs:
    tarball	(also automatically built)
    build	(default - "configure && make && make install")
    package	(image-specific)
EOF
}

set -e

image=""
options=`getopt -o 'hi:s:C:T:d:' -- "$@"`
set - $options
while test $# -gt 0; do
	arg="$1"; shift; optarg=$1
	case "$arg" in
	-h)	help
		exit 0
		;;
	-i)	eval image=$optarg
		shift
		;;
	-s)	eval src=$optarg
		shift
		;;
	-d)	eval dir=$optarg
		shift
		;;
	-C)	eval commit=$optarg
		shift
		;;
	-T)	eval tarball=$optarg
		shift
		;;
	--)	break;
		;;
	*)	echo something went wrong with getopt
		exit 1
		;;
	esac
done

onexit() {
	rv="$?"
	echo ""
	echo ""
	if test "$rv" -ne 0; then
		echo "something went wrong.  temporary directory:"
		echo "$dir"
		ls -lA "$dir"
		echo ""
	fi
	echo "$dir/output"
	find "$dir/output" -ls
	echo ""
	echo "use   rm -rf \"$dir\"   to clean up"
	exit "$rv"
}
trap onexit EXIT

target="build"
if test $# -gt 0; then
	eval target=$1
	shift
fi

base="`pwd`"
src="${src:-$base}"
cd "`dirname \"$0\"`"
selfdir="`pwd`"
if test -z "$dir"; then
	dir="`mktemp -d -t frrbuild.XXXXXX`"
	chmod 0755 "$dir"
fi

cd "$dir"
[ -f "$selfdir/tsrun" ] && cp "$selfdir/tsrun" .
cp "$selfdir/dobuild.sh" .

if test -z "$tarball"; then
	commit="`git -C \"$src\" rev-list --max-count=1 \"${commit:-HEAD}\"`"

	echo building in $dir, src $src, commit $commit:
	git -C "$src" --no-pager log -n 1 --pretty=oneline "$commit"

	git clone -n "$src" frr-source
	cd frr-source
	git fetch origin "$commit"
	git checkout -b build "$commit"
else
	cd "$base"
	cp "$tarball" "$dir/frr-dist.tar.gz"
	cd "$dir"
fi

docker run --rm -ti \
	--network none \
	--volume "$dir":/build \
	"$image" \
	/build/dobuild.sh "$target"
