#!/bin/sh

CFLAGS="-g -fsanitize=address \
        -fsanitize-coverage=edge,indirect-calls,8bit-counters,trace-cmp"

## compile the library
clang   ${CFLAGS} -c mysamplelib.c

## compile the fuzzing stubs
clang   ${CFLAGS} -c fuzzer.c

## link them together
clang++ ${CFLAGS} mysamplelib.o fuzzer.o -lFuzzer -o fuzzer
