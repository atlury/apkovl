MIRROR ?= http://dl-cdn.alpinelinux.org/alpine
BRANCH ?= v3.7

PKGS += alpine-base
ifdef KERNEL
PKGS += linux-$(KERNEL) syslinux
endif

build: $(ETC)/runlevels/default/networking $(ETC)/hostname \
	$(ETC)/apk/keys \
	$(ETC)/apk/repositories \
	$(ETC)/apk/world \
	$(ETC)/runlevels/boot/hostname

build: $(ETC)/runlevels/boot/hwclock \
	$(ETC)/runlevels/boot/sysctl \
	$(ETC)/runlevels/boot/hostname \
	$(ETC)/runlevels/boot/bootmisc \
	$(ETC)/runlevels/boot/syslog \

build: $(ETC)/runlevels/sysinit/dmesg \
	$(ETC)/runlevels/sysinit/devfs \
	$(ETC)/runlevels/sysinit/modloop \
	$(ETC)/runlevels/sysinit/hwdrivers \
	$(ETC)/runlevels/sysinit/mdev

build: $(ETC)/runlevels/shutdown/mount-ro \
	$(ETC)/runlevels/shutdown/killprocs \
	$(ETC)/runlevels/shutdown/savecache

$(ETC)/hostname:
	mkdir -p $(ETC)
	echo $(HOST) > $(ETC)/hostname

$(ETC)/runlevels/boot/% $(ETC)/runlevels/default/% $(ETC)/runlevels/sysinit/% $(ETC)/runlevels/shutdown/%:
	mkdir -p $(shell dirname $@)
	ln -sf /etc/init.d/$(shell basename $@) "$@"

$(ETC)/apk/keys:
	mkdir -p $(ETC)/apk/
	cp -r cfg/apk/keys $(ETC)/apk/

$(ETC)/apk/repositories:
	 mkdir -p $(ETC)/apk
	( echo $(MIRROR)/$(BRANCH)/main; echo $(MIRROR)/$(BRANCH)/community ) > $(ETC)/apk/repositories

$(ETC)/apk/world:
	mkdir -p $(ETC)/apk
	for i in $(PKGS); do echo $$i; done | sort -u > $(ETC)/apk/world
