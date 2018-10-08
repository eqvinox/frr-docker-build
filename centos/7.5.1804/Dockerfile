ARG OSNAME=centos
ARG OSREL=7.5.1804
FROM ${OSNAME}:${OSREL}
ARG OSNAME
ARG OSREL

LABEL FRR_BUILD=frr-build \
	OSNAME=${OSNAME} \
	OSREL=${OSREL}

RUN yum -y install \
	autoconf \
	automake \
	bison \
	c-ares-devel \
	flex \
	gawk \
	git \
	groff \
	json-c-devel \
	libcap-devel \
	libtool \
	make \
	net-snmp-devel \
	pam-devel \
	pkgconfig \
	pytest \
	python-devel \
	python-sphinx \
	readline-devel \
	rpm-build \
	systemd-devel \
	texinfo

ADD build.env /root/
ADD package.sh /root/
RUN useradd -m frrbuild
