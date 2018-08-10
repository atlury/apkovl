build: $(ETC)/openvpn/openvpn.conf $(ETC)/openvpn/ca.crt

ifdef SECRETS
build: $(ETC)/openvpn/$(HOST).key $(ETC)/openvpn/$(HOST).crt
endif

PKGS += openvpn

$(ETC)/openvpn/openvpn.conf:
	mkdir -p $(ETC)/openvpn
	sed 's|HOSTNAME|$(HOST)|g' <cfg/openvpn/client.conf >$@

$(ETC)/openvpn/ca.crt:
	mkdir -p $(ETC)/openvpn
	cp cfg/openvpn/ca.crt $@
