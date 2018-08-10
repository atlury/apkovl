TRG=tmp/$(HOST)
ETC=$(TRG)/etc

.PHONY: default build

ifdef HOST
default: build
	tar -c -C "$(TRG)" etc | gzip -9n > $(HOST).apkovl.tar.gz

build:
	true

include hosts/$(HOST).mk
endif

%.apkovl.tar.gz:
	name="$@"; \
	make HOST=$${name%.apkovl.tar.gz} default

clean:
	rm -rf tmp *.apkovl.tar.gz
