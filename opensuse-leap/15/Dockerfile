FROM opensuse/leap:15
RUN zypper install -y git autoconf automake libtool make gawk texinfo groff pkgconfig bison flex
RUN zypper install -y gcc readline-devel pam-devel libjson-c-devel \
	python3-devel c-ares-devel
RUN zypper install -y python3-Sphinx python3-pytest
RUN zypper install -y patch gzip

ADD build.env /root/
RUN useradd -m frrbuild
