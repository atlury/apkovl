build: $(ETC)/runlevels/default/local \
	$(ETC)/local.d/oneshot.start \
	$(TRG)$(ONESHOT)

$(ETC)/local.d/oneshot.start:
	mkdir -p $(ETC)/local.d
	sed 's|COMMAND|$(ONESHOT)|' < cfg/oneshot.start > $(ETC)/local.d/oneshot.start
	chmod +x $(ETC)/local.d/oneshot.start
