#!/bin/sh

set -ex

GHCOPTS="-package bytestring"

ghc-asan ${GHCOPTS} -c test.hs
ghc-wrapper ${GHCOPTS} -no-hs-main -o test test.o /work/libfuzzer/libFuzzer.a
