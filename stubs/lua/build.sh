#!/bin/bash

set -ex

export CXXFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls -fPIC"
export CXX="clang++"
export CFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls -fPIC"
export CC="clang"
export LDFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls"

cd /src/${TARGET}-${TARGET_VERSION}
ls -la

# build lua
make linux CC=$CC "CFLAGS=$CFLAGS" "LDFLAGS=$LDFLAGS"
make install

#Build fuzzer
$CXX -std=c++11 -o /lua-fuzzer lua-fuzzer.c \
    -I/usr/local/include \
    -L/usr/local/lib \
    -llua -lm -ldl \
    -lFuzzer $LDFLAGS
