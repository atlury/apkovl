PKGS += openssh mosh

# I use urxvt, which requires extra terminfo
PKGS += rxvt-unicode-terminfo

SSH_CERT_VALIDITY ?= 52w

build: $(ETC)/runlevels/default/sshd \
	$(ETC)/ssh/sshd_config

ifdef SECRETS
build: $(ETC)/ssh/ssh_host_rsa_key \
	$(ETC)/ssh/ssh_host_ed25519_key
endif

$(ETC)/ssh/sshd_config: $(ETC)/ssh/ca.pub
	( cat cfg/ssh/sshd_config; echo "TrustedUserCAKeys /etc/ssh/ca.pub" ) > $(ETC)/ssh/sshd_config

$(ETC)/ssh/ca.pub: cfg/ca.pub
	mkdir -p $(ETC)/ssh
	cp cfg/ca.pub $@

$(ETC)/ssh/ssh_host_%_key:
	t=$@; t=$${t##*host_}; t=$${t%_key}; \
	ssh-keygen -q -N "" -t $$t -f $@
	pass ssh/host-ca | ssh-keygen -s /dev/stdin -h \
		-h -n "$(HOST)" \
		-V "+$(SSH_CERT_VALIDITY)" \
		-z "$(shell date +%s)" \
		-I "$(HOST)" $@.pub
