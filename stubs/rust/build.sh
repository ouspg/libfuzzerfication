#!/bin/bash

export CXXFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls,8bit-counters,trace-cmp"
export CXX="clang++"
export CFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls,8bit-counters,trace-cmp"
export CC="clang"
export LDFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls,8bit-counters,trace-cmp"

set -ex

cd /src/rust
rustc rust-fuzzer.rs --emit=llvm-bc --crate-type=lib
clang-3.9 $CFLAGS -dynamic-linker -std=c++11 \
    -Iinclude -L.libs \
    /usr/local/lib/rustlib/x86_64-unknown-linux-gnu/lib/libstd-411f48d3.so \
    rust-fuzzer.bc -lFuzzer -o rust-fuzzer -lpthread -lm -lstdc++
