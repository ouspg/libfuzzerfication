#!/bin/sh

GHCOPTS="-Wall -package bytestring -package cryptohash -package directory -package x509"

ghc-asan ${GHCOPTS} -c test.hs
ghc-wrapper ${GHCOPTS} -no-hs-main -o test test.o /work/libfuzzer/*.o
