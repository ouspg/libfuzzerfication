#!/bin/bash
set -e

export CXXFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls,8bit-counters,trace-cmp"
export CXX="clang++"
export CFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls,8bit-counters,trace-cmp"
export CC="clang"
export LDFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls,8bit-counters,trace-cmp"


cd /src/libxml2/
if [ ! -f configure ]
then
  ./autogen.sh
fi

echo =========== MAKE
make -j 16

$CXX $CXXFLAGS -std=c++11 libxml2_fuzzer.cc \
               -Iinclude -L.libs -lxml2 -llzma -lFuzzer \
               -o /src/libxml2/libxml2-fuzzer
