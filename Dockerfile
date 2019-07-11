FROM ubuntu:16.04

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install build-essential psmisc iproute2
RUN apt-get -y install cmake bc curl diffutils git kmod libcurl4-openssl-dev wget
RUN apt-get -y install gettext elfutils libdw-dev python wget tar

ENV STAP_VERSION 4.1

## Build from source
RUN wget https://sourceware.org/systemtap/ftp/releases/systemtap-${STAP_VERSION}.tar.gz
RUN tar xzvf systemtap-${STAP_VERSION}.tar.gz

WORKDIR systemtap-${STAP_VERSION}
RUN ./configure
RUN apt-get -y install apt-file
RUN apt-file update
RUN apt-file search elfutils/libebl.h
#RUN apt-get -y install libelf-dev libdw-dev libdw1 libebl^
RUN make -j4 all
RUN make install

COPY install-systemtap-kernel.sh /
COPY .config /
RUN /install-systemtap-kernel.sh


