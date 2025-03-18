# 概述
## 这是一个示例代码仓库，展示如何在 Linux 内核源码树外（out-of-tree）编写 Rust 内核模块，同时保持与树内（in-tree）模块一致的编码和构建方式。该模块调用一个简单的 C 函数 my_printk，并通过 bindgen 生成 Rust 绑定，依赖内核树内的 rust/ 目录提供的 kernel 和 ffi crate。