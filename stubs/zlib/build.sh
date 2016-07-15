#!/bin/bash

export CXX="clang++"
export CC="clang"

export SANCOV="-fsanitize=address -fsanitize-coverage=edge,indirect-calls"

export CXXFLAGS=$SANCOV
export CFLAGS=$SANCOV
export LDFLAGS=$SANCOV

#Build libav
cd /src/zlib
./configure --prefix=/usr/
make -j4
make install


#Build fuzzer
$CXX $CFLAGS -std=c++11 -I$(pwd) -lFuzzer -lz -o \
    zlib-fuzzer zlib-fuzzer.cc
