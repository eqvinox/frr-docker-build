#!/bin/sh

mkdir rpmbuild
mkdir rpmbuild/SOURCES
mkdir rpmbuild/SPECS

tar zxf frr-dist.tar.gz
cp frr-dist/redhat/frr.spec rpmbuild/SPECS/frr.spec

frrver="`rpm -q --qf '%{name}-%{version}\n' --specfile frr-dist/redhat/frr.spec | head -n 1`"
echo "FRR RPM version: $frrver"

mv frr-dist "$frrver"
tar zcf "rpmbuild/SOURCES/$frrver.tar.gz" "$frrver"
rm -r "$frrver"

rpmbuild --define "_topdir `pwd`/rpmbuild" -ba rpmbuild/SPECS/frr.spec

mv rpmbuild/{S,}RPMS output/
