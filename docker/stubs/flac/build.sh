#!/bin/bash
export CXX="clang++"
export CC="clang"

export SANCOV="-fsanitize=address -fsanitize-coverage=edge,indirect-calls"

export CXXFLAGS=$SANCOV
export CFLAGS=$SANCOV
export LDFLAGS=$SANCOV


#Build flac

if [ ! -f configure ]
then
  ./autogen.sh
fi
./configure --enable-shared --prefix=/usr/
make -j4
make install

$CXX $CXXFLAGS -std=c++11 flac_fuzzer.c \
  			   -Iinclude -lFLAC -lFuzzer \
   			    -o flac_fuzzer
