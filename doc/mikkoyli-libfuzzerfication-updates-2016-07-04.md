class: center, middle

## LibFuzzerfication updates
## OUSPG Open, 2016-07-04

---

# Team

* Mikko Yliniemi (@mikessu)
* Atte Kettunen (@attekett)
* Pauli Huttunen (@WhiteEyeDoll)

---

LibFuzzerfication is a project thats purpose is to do fuzz-testing for applications and libraries.

<img src="https://raw.githubusercontent.com/ouspg/libfuzzerfication/master/pictures/fuzzing.png" width="500" height="284" alt="Fuzzing in action">

Example of lua fuzz test running.

---
# Motivation
There have been lots of vulnerabilities in popular libraries that should have been (theoretically) easy to test. We want to offer easy way to fuzz-test these libraries and increase awareness about the situation. We also want this to be available to everyone.

---

# About libfuzzer
* LibFuzzer is open-source library (part of LLVM)
* Relies on compiler instrumentation to get coverage feedback
* It is linked with the library under test
* Works fully in process -> Fast!

---

# What we have done this far?

* We have currently following stubs in repository:
- haskell-x509
- ImageMagick
- libav
- libxml2
- libxslt
- lua (newest)

---
```
Lua stub was committed by Joonas Kuorilehto (@joneskoo)
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
    int status, result;
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
        goto lua_exit;
    }

    /* Ask Lua to run our little script */
    result = lua_pcall(L, 0, LUA_MULTRET, 0);
    if (result) {
        //fprintf(stderr, "Failed to run script: %s\n", lua_tostring(L, -1));
        goto lua_exit;
    }

    /* Get the returned value at the top of the stack (index -1) */
    ret = lua_tonumber(L, -1);

    //printf("Script returned: %.0f\n", ret);

lua_exit:
    lua_pop(L, 1);  /* Take the returned value out of the stack */
    lua_close(L);   /* Cya, Lua */

    return 0;
}
```

---
#Documentation

Documentation has beed improved. You can find improved documentation from github:

https://github.com/ouspg/libfuzzerfication

---

#Under development
- libflac stub is currently under development
- Pauli (@WhiteEyeDoll) is currently working to get fuzzing running in Google cloud

#Feel free to contribute
* Everyone can contribute

# How does this project work?
* You pull container from Dockerhub
* Start Writing your own libfuzzer stub
* Share dockerfile with other users
* Use libFuzzer to collect corpus so that other people can continue where you left off

You can start writing stubs without docker.

Visit #ouspg @ IRCnet if you're interested!

---
