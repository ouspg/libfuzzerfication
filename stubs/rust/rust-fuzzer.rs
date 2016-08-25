extern crate libc;

use std::io::{self, Read};

#[no_mangle]
pub extern fn LLVMFuzzerTestOneInput(std::ffi::CString *data, libc::size_t size) -> *const u8 {
let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();

    if input.starts_with("a") {
        println!("a");
        if input.starts_with("ab") {
            println!("ab");
            if input.starts_with("abc") {
                println!("abc");
                unsafe {
                    let x: *mut usize = 0 as *mut usize;
                    *x = 0xBEEF;
                }
            }
        }
    }
}
