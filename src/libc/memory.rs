
//------------------------------------------------
//
// externs / aliases
//
//------------------------------------------------

extern "rust-intrinsic" {
    pub fn offset<T>(dst: *const T, offset: isize) -> *const T;
}




//------------------------------------------------
//
// functions
//
//------------------------------------------------

// sets the value of all bytes in the range [dest:dest+cnt) to the
// demoted (u8) value of `val`.
pub unsafe fn memset(dest: *mut u8, val: i32, cnt: u32) {
    // TODO: copy-by-word optimization
    for i in 0..cnt {
        *(offset(dest as *const u8, i as isize) as *mut u8) = val as u8;
    }
}

