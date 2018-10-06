FROM debian:buster
RUN apt-get update
RUN apt-get install -y git autoconf automake libtool make \
  libreadline-dev texinfo libjson-c-dev pkg-config bison flex \
  libc-ares-dev python3-dev python3-pytest python3-sphinx
RUN apt-get install -y debhelper dh-make dh-autoreconf dpkg-dev
RUN apt-get install -y texlive-latex-base texlive-generic-recommended \
  libpam0g-dev libcap-dev libpcre3-dev chrpath libsnmp-dev libsystemd-dev \
  dh-systemd python-ipaddr install-info
RUN apt-get install -y gawk

ADD build.env /root/
ADD package.sh /root/
RUN useradd -m frrbuild
