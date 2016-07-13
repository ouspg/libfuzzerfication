#!/bin/bash
set -e

export CXXFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls,8bit-counters,trace-cmp"
export CXX="clang++"
export CFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls,8bit-counters,trace-cmp"
export CC="clang"
export LDFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls,8bit-counters,trace-cmp"


cd /src/libxslt/

if [ ! -f configure ]
then
    ./autogen.sh
fi

echo =========== MAKE
make -j 16

$CXX $CXXFLAGS -std=c++11 libxslt_fuzzer.cc -Werror \
                -I. $(xml2-config --cflags) \
                -Llibxslt/.libs -lxslt -lFuzzer \
                $(xml2-config --libs) \
                -o /src/libxslt/libxslt_fuzzer
