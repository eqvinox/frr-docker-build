FROM debian:buster
RUN apt-get update
RUN apt-get install -y git autoconf automake libtool make \
  libreadline-dev texinfo libjson-c-dev pkg-config bison flex \
  libc-ares-dev python3-dev python3-pytest python3-sphinx
RUN apt-get install -y curl

WORKDIR /root
RUN curl -O https://downloads.openwrt.org/releases/18.06.1/targets/ar71xx/generic/openwrt-sdk-18.06.1-ar71xx-generic_gcc-7.3.0_musl.Linux-x86_64.tar.xz

RUN mkdir /opt/openwrt
WORKDIR /opt/openwrt
RUN tar xvf /root/openwrt-sdk-18.06.1-ar71xx-generic_gcc-7.3.0_musl.Linux-x86_64.tar.xz
WORKDIR /opt/openwrt/openwrt-sdk-18.06.1-ar71xx-generic_gcc-7.3.0_musl.Linux-x86_64
RUN cp feeds.conf.default feeds.conf
RUN sed -e '/routing/ c src-git routing https://github.com/cfra/openwrt-routing.git;frr' -i feeds.conf

RUN apt-get install -y gawk
RUN scripts/feeds update -a
RUN scripts/feeds install frr

