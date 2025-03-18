#[allow(dead_code)]
#[allow(clippy::undocumented_unsafe_blocks)]
mod bindings_raw {
    type __kernel_size_t = usize;
    type __kernel_ssize_t = isize;
    type __kernel_ptrdiff_t = isize;

    pub use super::bindings_helper::*;
}

#[allow(dead_code)]
mod bindings_helper {
    use super::bindings_raw::*;
    include!("bindings_helpers_generated.rs");
}

pub use bindings_raw::*;