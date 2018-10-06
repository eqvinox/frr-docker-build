ARG OSNAME=debian
ARG OSREL=buster
FROM ${OSNAME}:${OSREL} AS base
ARG OSNAME
ARG OSREL

LABEL FRR_BUILD=frr-build \
	OSNAME=${OSNAME} \
	OSREL=${OSREL}

RUN apt-get update && apt-get install -y \
	autoconf \
	automake \
	bison \
	chrpath \
	debhelper \
	dh-autoreconf \
	dh-make \
	dh-systemd \
	dpkg-dev \
	flex \
	gawk \
	git \
	install-info \
	libc-ares-dev \
	libcap-dev \
	libjson-c-dev \
	libpam0g-dev \
	libpcre3-dev \
	libreadline-dev \
	libsnmp-dev \
	libssh-dev \
	libsystemd-dev \
	libtool \
	make \
	pkg-config \
	python-ipaddr \
	python3-dev \
	python3-pytest \
	python3-sphinx \
	texinfo \
	texlive-generic-recommended \
	texlive-latex-base

RUN useradd -m frrbuild

FROM base AS rpkibuild
RUN apt-get install -y \
	cmake \
	doxygen

USER frrbuild
WORKDIR /home/frrbuild
RUN git clone https://github.com/rtrlib/rtrlib.git
RUN cd rtrlib && \
	git checkout -b build v0.5.0 && \
	sed -e '1i /usr/lib/*/pkgconfig/rtrlib.pc' -i debian/librtr-dev.install && \
	dpkg-buildpackage -F

FROM base
COPY --from=rpkibuild /home/frrbuild/librtr0_0.5.0-1_amd64.deb /tmp
COPY --from=rpkibuild /home/frrbuild/librtr-dev_0.5.0-1_amd64.deb /tmp
RUN	dpkg -i /tmp/librtr0_0.5.0-1_amd64.deb && \
	dpkg -i /tmp/librtr-dev_0.5.0-1_amd64.deb && \
	rm /tmp/librtr0_0.5.0-1_amd64.deb /tmp/librtr-dev_0.5.0-1_amd64.deb

ADD build.env /root/
ADD package.sh /root/
