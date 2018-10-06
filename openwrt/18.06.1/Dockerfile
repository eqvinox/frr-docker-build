FROM debian:buster
RUN apt-get update
RUN apt-get install -y git curl gawk time xz-utils
RUN apt-get install -y make build-essential

#  autoconf automake libtool make \
#  libreadline-dev texinfo libjson-c-dev pkg-config bison flex \
#  libc-ares-dev python3-dev python3-pytest python3-sphinx

RUN useradd -m frrbuild

RUN mkdir /openwrt
RUN chown frrbuild: /openwrt
USER frrbuild
WORKDIR /openwrt

RUN curl -O https://downloads.openwrt.org/releases/18.06.1/targets/ar71xx/generic/openwrt-sdk-18.06.1-ar71xx-generic_gcc-7.3.0_musl.Linux-x86_64.tar.xz
RUN tar --strip-components=1 -Jxf openwrt-sdk-18.06.1-ar71xx-generic_gcc-7.3.0_musl.Linux-x86_64.tar.xz

RUN cp feeds.conf.default feeds.conf
RUN sed -e '/routing/ c src-git routing https://github.com/cfra/openwrt-routing.git;frr' -i feeds.conf

RUN scripts/feeds update -a
RUN scripts/feeds install frr

RUN make defconfig
RUN make -j16 package/frr/compile
RUN make package/frr/clean
RUN rm -rf bin/packages/mips_24kc/routing

USER root
RUN apt-get install -y file

ADD build.env /root
ADD package.sh /root
