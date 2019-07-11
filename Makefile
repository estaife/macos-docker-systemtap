.PHONY: all
all: .config LINUX_VERSION LINUX_TIMESTAMP
	docker build . \
		--build-arg LINUX_VERSION="$(shell cat LINUX_VERSION)" \
		--build-arg LINUX_TIMESTAMP="$(shell cat LINUX_TIMESTAMP)" \
		-t dylan

.config:
	docker run -i -v /:/host busybox zcat /host/proc/config.gz > $@

LINUX_VERSION:
	docker run -i busybox sh -c 'uname -r | cut -d - -f 1' > $@

LINUX_TIMESTAMP:
	docker run -i busybox sh -c 'uname -v | sed "s/#1 SMP //"' > $@


