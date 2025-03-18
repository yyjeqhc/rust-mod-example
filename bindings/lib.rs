// SPDX-License-Identifier: GPL-2.0


#[allow(dead_code)]
#[allow(clippy::undocumented_unsafe_blocks)]
mod bindings_raw {
    // 手动定义可能被屏蔽的类型（根据需要调整）
    type __kernel_size_t = usize;
    type __kernel_ssize_t = isize;
    type __kernel_ptrdiff_t = isize;

    include!("bindings_generated.rs");
}

// 暴露绑定
pub use bindings_raw::*;