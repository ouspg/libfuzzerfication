#![feature(libc)]
#[crate_type = "lib"]
#[no_std]
#[allow(ctypes)]

extern crate libc;

use std::io::{self, Read};

#[no_mangle]
pub extern fn LLVMFuzzerTestOneInput(data: *const std::ffi::CString, size: libc::size_t) {
let mut input = String::new();
    println!("starting!");
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
