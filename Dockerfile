FROM ubuntu:16.04

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install build-essential psmisc iproute2
RUN apt-get -y install cmake bc curl diffutils git kmod libcurl4-openssl-dev wget
RUN apt-get -y install gettext elfutils libdw-dev python wget tar

WORKDIR /build

ARG LINUX_VERSION
RUN : "${LINUX_VERSION:?LINUX_VERSION build-arg is required.}"
RUN curl -L -o linux-${LINUX_VERSION}.tar.gz \
    https://www.kernel.org/pub/linux/kernel/v4.x/linux-${LINUX_VERSION}.tar.gz

RUN tar zxf linux-${LINUX_VERSION}.tar.gz
WORKDIR linux-${LINUX_VERSION}
COPY .config .config
RUN make oldconfig
RUN make config
ARG LINUX_TIMESTAMP="Fri Sep 7 08:20:28 UTC 2018"
ENV KBUILD_BUILD_TIMESTAMP=${LINUX_TIMESTAMP}
RUN make -j8 all
RUN make modules_prepare
RUN make headers_install
RUN make modules_install

WORKDIR /build
ARG STAP_VERSION=4.1

## Build from source
RUN wget https://sourceware.org/systemtap/ftp/releases/systemtap-${STAP_VERSION}.tar.gz
RUN tar xzvf systemtap-${STAP_VERSION}.tar.gz

WORKDIR systemtap-${STAP_VERSION}
RUN ./configure
RUN make -j4 all
RUN make install

WORKDIR /

