KERNELDIR ?= /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

RUSTDIR ?= $(KERNELDIR)/rust

BINDGEN ?= bindgen
RUSTC ?= rustc

BINDINGS := bindings/bindings_generated.rs

obj-m += two.o
two-objs := helper/prinkt.o hello_world.o

all: $(BINDINGS)
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) clean
	rm -f $(BINDINGS)

$(BINDINGS): myprintkaaa.h
	$(BINDGEN) $< \
		--output $@ \
		--rust-target 1.68 \
		--use-core \
		--with-derive-default \
		--no-layout-tests \
		--no-debug '.*' \
		--enable-function-attribute-detection \
		-- \
		-I$(KERNELDIR)/include \
		-I$(KERNELDIR)/arch/x86/include \
		-DMODULE
	@sed -i '1i pub mod bindings {' $@
	@echo "}" >> $@



# 编译 Rust 代码
# hello_world.o: hello_world.rs $(BINDINGS)
# 	$(RUSTC) --crate-type=staticlib \
# 		--target=x86_64-unknown-linux-gnu \
# 		--edition=2021 \
# 		--out-dir . \
# 		--emit=obj \
# 		-L $(RUSTDIR) \
# 		--extern kernel=$(RUSTDIR)/kernel.o \
# 		$<
# 	mv hello_world.a hello_world.o