#!/bin/sh

export KERNELVER=$(uname -r  | cut -d '-' -f 1)
export KERNELDIR=/linux-$KERNELVER
cd /
curl -L -o linux-${KERNELVER}.tar.gz https://www.kernel.org/pub/linux/kernel/v4.x/linux-${KERNELVER}.tar.gz
file linux-${KERNELVER}.tar.gz
fgrep title linux-${KERNELVER}.tar.gz
tar zxf linux-${KERNELVER}.tar.gz
cd linux-${KERNELVER}
cp /.config .config
make -j4 all
make modules_prepare
make headers_install
make modules_install
