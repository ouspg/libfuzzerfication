#!/bin/bash
set -e

export CXXFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls,8bit-counters,trace-cmp"
export CXX="clang++"
export CFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls,8bit-counters,trace-cmp"
export CC="clang"
export LDFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls,8bit-counters,trace-cmp"

cd /src/libmad-0.15.1b/

./configure --prefix=/usr/ --enable-speed 

make -j4
make install

$CXX $CXXFLAGS -std=c++11 ./.libs/libmad.so -Iinclude -lFuzzer \
               ./libmad_fuzzer.c -o /src/libmad-0.15.1b/libmad_fuzzer

