# 内核源码目录
KERNELDIR ?= /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

# Rust for Linux 路径（如果使用内核树的 rust/ 目录）
RUSTDIR ?= $(KERNELDIR)/rust

# 工具
BINDGEN ?= bindgen
RUSTC ?= rustc

# 生成的绑定文件
BINDINGS := bindings_generated.rs

# 模块目标
obj-m += two.o
two-objs := helper/prinkt.o hello_world.o

# 默认目标
all: $(BINDINGS)
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

# 清理
clean:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) clean
	rm -f $(BINDINGS)

# 生成 Rust 绑定
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
		-DMODULE

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