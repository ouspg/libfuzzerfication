#!/bin/sh
set -e

mkdir -p /work/llvm
cd /work/llvm

if [ ! -f CMakeCache.txt ]
then
    cmake -G "Ninja" \
      -DCMAKE_C_COMPILER=/usr/bin/gcc \
      -DCMAKE_CXX_COMPILER=/usr/bin/g++ \
      -DCMAKE_BUILD_TYPE=Release /src/llvm
fi

ninja
