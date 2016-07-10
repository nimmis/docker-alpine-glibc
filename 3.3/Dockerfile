FROM nimmis/alpine-micro:3.3

MAINTAINER nimmis <kjell.havneskold@gmail.com>

RUN apk update && apk upgrade && \
    apk add curl && \
    curl -L -o glibc-2.23-r1.apk \
      "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r1/glibc-2.23-r1.apk" && \
    curl -L -o glibc-bin-2.23-r1.apk \
      "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r1/glibc-bin-2.23-r1.apk" && \
    apk add --allow-untrusted glibc-2.23-r1.apk glibc-bin-2.23-r1.apk && \
    rm -fr glibc-2.23-r1.apk glibc-bin-2.23-r1.apk /var/cache/apk/* 

