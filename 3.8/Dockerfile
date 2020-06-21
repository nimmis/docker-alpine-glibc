FROM nimmis/alpine-micro:3.8

MAINTAINER nimmis <kjell.havneskold@gmail.com>

ENV GLIBC_VERSION=2.31-r0

RUN apk update && apk upgrade && \
    # Make info file about this build
    mkdir -p /etc/BUILDS/ && \
    printf "Build of nimmis/alpine-glibc:3.8, date: %s\n"  `date -u +"%Y-%m-%dT%H:%M:%SZ"` > /etc/BUILDS/alpine-glibc && \
    # add curl for download
    apk add curl && \
    # download packages for glibc, see https://github.com/sgerrand/alpine-pkg-glibc for more info
    curl -Ls -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    curl -Ls -o glibc-${GLIBC_VERSION}.apk \
      "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
    curl -Ls -o glibc-bin-${GLIBC_VERSION}.apk \
      "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" && \
    # install libraries
    apk add  glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk && \
    # workaround for Segmentation fault in libc.so.6
    curl -Ls -o /tmp/libz.tar.xz "https://www.archlinux.org/packages/core/x86_64/zlib/download" && \
    mkdir -p /tmp/libz && \
    tar -xJf /tmp/libz.tar.xz -C /tmp/libz && \
    cp /tmp/libz/usr/lib/libz.so.1.2.11 /usr/glibc-compat/lib && \
    /usr/glibc-compat/sbin/ldconfig && \
    rm -rf /tmp/libz /tmp/libz.tar.xz && \
    # remove curl
    apk del curl && \
    # remove cache and downloaded files
    rm -fr glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk /var/cache/apk/* 

