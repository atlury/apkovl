build: $(ETC)/network/interfaces

$(ETC)/network/interfaces: $(ETC)/runlevels/sysinit/network
	mkdir -p $(ETC)/network
	cp cfg/network/interfaces-dhcp $(ETC)/network/interfaces
