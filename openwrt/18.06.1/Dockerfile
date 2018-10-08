FROM debian:buster

ARG OSNAME=openwrt
ARG OSREL=18.06.1

LABEL FRR_BUILD=frr-build \
	OSNAME=${OSNAME} \
	OSREL=${OSREL}

RUN apt-get update && apt-get install -y \
	build-essential \
	curl \
	file \
	gawk \
	git \
	make \
	time \
	xz-utils

RUN useradd -m frrbuild

RUN mkdir /openwrt && chown frrbuild: /openwrt
USER frrbuild
WORKDIR /openwrt

RUN curl https://downloads.openwrt.org/releases/18.06.1/targets/ar71xx/generic/openwrt-sdk-18.06.1-ar71xx-generic_gcc-7.3.0_musl.Linux-x86_64.tar.xz \
	| tar --strip-components=1 -Jx

RUN cp feeds.conf.default feeds.conf
RUN sed -e '/routing/ c src-git routing https://github.com/cfra/openwrt-routing.git;frr' -i feeds.conf

RUN scripts/feeds update -a \
	&& scripts/feeds install frr

RUN make defconfig && make -j16 package/frr/compile
RUN make package/frr/clean && rm -rf bin/packages/mips_24kc/routing

USER root

ADD build.env /root
ADD package.sh /root
