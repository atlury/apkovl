SECRETS = 1
ONESHOT = /etc/build.sh
PKGS += git alpine-sdk

include tasks/generic.mk
include tasks/network-dhcp.mk
include tasks/sshd.mk
include tasks/oneshot.mk

build: $(ETC)/abuild.key $(ETC)/apk/keys/nero-5abe641c.rsa.pub

$(ETC)/abuild.key:
	pass abuild > $(ETC)/abuild.key

$(ETC)/apk/keys/nero-5abe641c.rsa.pub:
	pass abuild|openssl rsa -in /dev/stdin -pubout > $(ETC)/apk/keys/nero-5abe641c.rsa.pub

$(ETC)/abuild.conf:
	cp cfg/builder/abuild.conf $(ETC)/abuild.conf

$(ETC)/build.sh:
	cp cfg/builder/build.sh $(ETC)/build.sh
