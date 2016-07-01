#!/bin/bash
export CXX="clang++"
export CC="clang"

export SANCOV="-fsanitize=address -fsanitize-coverage=edge,indirect-calls"

export CXXFLAGS=$SANCOV
export CFLAGS=$SANCOV
export LDFLAGS=$SANCOV


#Build flac
#cd /src/flac
if [ ! -f configure ]
then
  ./autogen.sh
fi
./configure
make -j 4

$CXX $CXXFLAGS -std=c++11 flac_fuzzer.c \
  			   -Iinclude -L.libs -lFuzzer \
   			    -o flac_fuzzer
