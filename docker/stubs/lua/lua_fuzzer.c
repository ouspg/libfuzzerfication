/*
 * lua_fuzzer.c
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
    int status, result, i;
    double ret;
    lua_State *L;

    /*
     * All Lua contexts are held in this structure. We work with it almost
     * all the time.
     */
    L = luaL_newstate();

    luaL_openlibs(L); /* Load Lua libraries */

    /* Load the file containing the script we are going to run */
    status = luaL_loadbuffer(L, (const char *)data, size, "code");
    if (status) {
        /* If something went wrong, error message is at the top of */
        /* the stack */
        //fprintf(stderr, "Couldn't load script: %s\n", lua_tostring(L, -1));
        return(0);
    }

    /* Ask Lua to run our little script */
    result = lua_pcall(L, 0, LUA_MULTRET, 0);
    if (result) {
        //fprintf(stderr, "Failed to run script: %s\n", lua_tostring(L, -1));
        return(0);
    }

    /* Get the returned value at the top of the stack (index -1) */
    ret = lua_tonumber(L, -1);

    //printf("Script returned: %.0f\n", ret);

    lua_pop(L, 1);  /* Take the returned value out of the stack */
    lua_close(L);   /* Cya, Lua */

    return 0;
}

