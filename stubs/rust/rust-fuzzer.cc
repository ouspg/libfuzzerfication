/*
 * lua-fuzzer.c
 * libfuzzer stub for fuzzing LUA
 */
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
extern "C" {
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
}

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {

    return 0;
}
