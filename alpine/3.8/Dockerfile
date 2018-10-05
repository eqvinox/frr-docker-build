FROM alpine:3.8
RUN apk add --no-cache abuild acct alpine-sdk attr autoconf automake bash \
    binutils bison bsd-compat-headers build-base c-ares c-ares-dev \
    ca-certificates cryptsetup-libs curl device-mapper-libs expat fakeroot \
    flex fortify-headers g++ gcc gdbm git gmp isl json-c json-c-dev kmod \
    lddtree libacl libatomic libattr libblkid libburn libbz2 libc-dev libcap \
    libcurl libedit libffi libgcc libgomp libltdl libressl libssh2 \
    libstdc++ libtool libuuid linux-headers lzip lzo m4 make mkinitfs mpc1 \
    mpfr3 mtools musl-dev ncurses-libs ncurses-terminfo ncurses-terminfo-base \
    patch pax-utils pcre perl pkgconf python3 python3-dev readline \
    readline-dev sqlite-libs squashfs-tools sudo tar texinfo xz-libs \
    groff gzip bc py-sphinx
RUN apk add pytest

ADD build.env /root/
RUN adduser -D frrbuild
