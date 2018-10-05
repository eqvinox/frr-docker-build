FROM fedora:28
RUN dnf -y install git autoconf automake libtool make gawk \
  readline-devel texinfo net-snmp-devel groff pkgconfig \
  json-c-devel pam-devel perl-XML-LibXML python3-pytest bison flex \
  c-ares-devel python3-devel python3-sphinx
RUN dnf -y install patch

ADD build.env /root/
RUN useradd -m frrbuild
