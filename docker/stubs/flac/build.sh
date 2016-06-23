#!/bin/bash

export CXXFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls"
export CXX="clang++"
export CFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls"
export CC="clang"
export LDFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls"

#Build flac
cd /src/flac
if [ ! -f configure ]
then
  ./autogen.sh
fi
./configure
make -j 4

$CXX $CXXFLAGS -std=c++11 flac_fuzzer.c \
  			   -Iinclude -L.libs -lFuzzer \
   			    -o /src/flac/flac_fuzzer
