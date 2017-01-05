FROM nimmis/alpine-micro:3.1

MAINTAINER nimmis <kjell.havneskold@gmail.com>

RUN apk update && apk upgrade && \

    # Make info file about this build
    mkdir -p /etc/BUILDS/ && \
    printf "Build of nimmis/alpine-glibc:3.1, date: %s\n"  `date -u +"%Y-%m-%dT%H:%M:%SZ"` > /etc/BUILDS/alpine-glibc && \

    # add curl for download
    apk add curl && \

    # download packages for glibc, see https://github.com/sgerrand/alpine-pkg-glibc for more info
    curl -L -o glibc-2.23-r3.apk \
      "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk" && \
    curl -L -o glibc-bin-2.23-r3.apk \
      "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-bin-2.23-r3.apk" && \

    # install them
    apk add --allow-untrusted glibc-2.23-r3.apk glibc-bin-2.23-r3.apk && \

    # remove curl
    apk del curl && \

    # remove cache and downloaded files
    rm -fr glibc-2.23-r3.apk glibc-bin-2.23-r3.apk /var/cache/apk/* 

