#!/bin/bash

export CXXFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls -fPIC"
export CXX="clang++"
export CFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls -fPIC"
export CC="clang"
export LDFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls"

#Build libav

cd /src/libav
./configure --prefix=/usr/ --cc=clang --enable-shared --disable-asm
make -j4
make install


#Build fuzzer
$CXX $CFLAGS -std=c++11 -I$(pwd) $(pwd)/libavutil/*.so -lz -lvdpau -lX11  \
             -lFuzzer $(pwd)/libavcodec/*.o $(pwd)/libavresample/*.o \
             -o libav-fuzzer libav-fuzzer.c
