#!/bin/bash

set -ex

export CXXFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls"
export CXX="clang++"
export CFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls"
export CC="clang"
export LDFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls"

cd /src/rust

# build rust
./configure --prefix=/usr/ --enable-clang
make -j4
make install

#Build fuzzer
$CXX -std=c++11 -o /rust-fuzzer rust-fuzzer.c \
    -I/usr/local/include \
    -L/usr/local/lib \
    -llua -lm -ldl \
    -lFuzzer $LDFLAGS
