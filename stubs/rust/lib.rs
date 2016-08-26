#![feature(libc)]
#[crate_type = "lib"]
#[no_std]
#[allow(ctypes)]

extern crate libc;

use std::io::{self, Read};

pub extern fn LLVMFuzzerTestOneInput(data: std::ffi::CString, size: libc::size_t) {
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
