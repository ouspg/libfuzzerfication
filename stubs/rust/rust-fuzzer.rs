use std::io::{self, Read};

#[no_mangle]
pub extern fn LLVMFuzzerTestOneInput(std::ffi::CString) -> *const u8 {
let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();

    if input.starts_with("x") {
        println!("going...");
        if input.starts_with("xy") {
            println!("going...");
            if input.starts_with("xyz") {
                println!("gone!");
                unsafe {
                    let x: *mut usize = 0 as *mut usize;
                    *x = 0xBEEF;
                }
            }
        }
    }
} 
