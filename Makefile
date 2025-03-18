KERNELDIR ?= /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

BINDGEN ?= bindgen
HELPER_BINDINGS := bindings/bindings_helpers_generated.rs

obj-m += hello.o
hello-objs := helper/prinkt.o hello_world.o

all: $(HELPER_BINDINGS)
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) clean
	rm -f $(HELPER_BINDINGS)

$(HELPER_BINDINGS): helper/prinkt.c
	$(BINDGEN) $< \
		--output $@ \
		--rust-target 1.68 \
		--use-core \
		--with-derive-default \
		--no-layout-tests \
		--no-debug '.*' \
		--enable-function-attribute-detection \
		--blocklist-type '.*' \
		--allowlist-function 'rust_helper_.*' \
		-- \
		-I$(KERNELDIR)/include \
		-I$(KERNELDIR)/arch/x86/include \
		-DMODULE \
		-Wno-missing-prototypes \
		-Wno-missing-declarations
	@sed -i 's/pub fn rust_helper_\([a-zA-Z0-9_]*\)/#[link_name="rust_helper_\1"]\n    pub fn \1/g' $@
