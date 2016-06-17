#!/bin/bash

export CXXFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls -fPIC"
export CXX="clang++"
export CFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls -fPIC"
export CC="clang"
export LDFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls"
export LIBFUZZER_OBJS="/home/mikko/work/libfuzzer/*.o"

#Build libav
cd /home/mikessu/src/libav
./configure --prefix=$HOME --cc=clang --enable-shared --disable-asm
make -j4
make install


#Build fuzzer
#$CXX $CFLAGS -std=c++11 -I$(pwd) /home/mikessu/libfuzzer/Fuzzer*.o  -o libav_fuzzer $HOME/libav_fuzzer.c

$CXX $CFLAGS -std=c++11 -I$(pwd) $(pwd)/libavutil/*.so -lz -lvdpau -lX11  \
/home/mikessu/libfuzzer/Fuzzer*.o  $(pwd)/libavcodec/*.o $(pwd)/libavcodec/x86/*.o   $(pwd)/libavresample/*.o \
 -o libav_fuzzer $HOME/libav_fuzzer.c
