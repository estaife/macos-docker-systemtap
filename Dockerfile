FROM ubuntu:16.04

RUN apt-get update
RUN apt-get --yes install build-essential cmake bc curl diffutils git kmod libcurl4-openssl-dev wget
RUN apt-get --yes install systemtap systemtap-sdt-dev

WORKDIR /

ARG STAP_VERSION=4.1
RUN export KERNELVER=$(uname -r  | cut -d '-' -f 1)
RUN export KERNELDIR=/linux-$KERNELVER
RUN cd /
RUN curl -o linux-${KERNELVER}.tar.gz https://www.kernel.org/pub/linux/kernel/v4.x/linux-${KERNELVER}.tar.gz
RUN tar zxf linux-${KERNELVER}.tar.gz
RUN cd linux-${KERNELVER}
RUN zcat /proc/1/root/proc/config.gz > .config
RUN make all
RUN make modules_prepare
RUN make headers_install
RUN make modules_install

WORKDIR systemtap-${STAP_VERSION}

RUN ./configure
RUN make -j4 all
RUN make install
