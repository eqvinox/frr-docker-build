#
# prepare packages that we need for CentOS 6
#
FROM centos:6.10 as builder
RUN yum -y install git autoconf automake libtool make gawk \
   readline-devel texinfo net-snmp-devel groff pkgconfig \
   json-c-devel pam-devel flex epel-release perl-XML-LibXML \
   c-ares-devel rpm-build
WORKDIR /build
RUN mkdir /pkgs
RUN curl -O http://vault.centos.org/7.0.1406/os/Source/SPackages/bison-2.7-4.el7.src.rpm \
	&& rpmbuild --rebuild ./bison-2.7-4.el7.src.rpm
RUN cp /root/rpmbuild/RPMS/x86_64/bison-2.7-4.el6.x86_64.rpm /pkgs \
	&& rm -rf rpmbuild
RUN curl -O http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz \
	&& tar xvf autoconf-2.69.tar.gz && cd autoconf-2.69 \
	&& ./configure --prefix=/usr && make && make DESTDIR=/build/inst-ac install \
	&& cd .. && tar zcpf /pkgs/autoconf.tar.gz -C inst-ac . \
	&& rm -rf autoconf-2.69
RUN tar zxpf /pkgs/autoconf.tar.gz -C /
RUN curl -O http://ftp.gnu.org/gnu/automake/automake-1.15.tar.gz \
	&& tar xvf automake-1.15.tar.gz && cd automake-1.15 \
	&& ./configure --prefix=/usr && make && make DESTDIR=/build/inst-am install \
	&& cd .. && tar zcpf /pkgs/automake.tar.gz -C inst-am . \
	&& rm -rf automake-1.15

#
# make the actual build image
#
FROM centos:6.10 as runner
RUN yum -y install git autoconf automake libtool make gawk \
   readline-devel texinfo net-snmp-devel groff pkgconfig \
   json-c-devel pam-devel flex epel-release perl-XML-LibXML \
   c-ares-devel rpm-build libcap-devel
COPY --from=builder /pkgs/* /pkgs/
RUN yum -y install /pkgs/bison-2.7-4.el6.x86_64.rpm
RUN tar zxpf /pkgs/autoconf.tar.gz -C /
RUN tar zxpf /pkgs/automake.tar.gz -C /
RUN rpm -ivh https://centos6.iuscommunity.org/ius-release.rpm
RUN yum -y install python27 python27-pip python27-devel
RUN pip2.7 install pytest

ADD puias6.repo /etc/yum.repos.d/puias6.repo
RUN yum -y update
RUN yum -y install python27-sphinx

ADD build.env /root/
ADD package.sh /root/
RUN useradd -m frrbuild
