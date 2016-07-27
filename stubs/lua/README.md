# lua

# Purpose

Lua is a lightweight, embeddable scripting language. The fuzzer loads lua libraries and the file that has lua script that we're going to run and runs the script.

What is included?

* [`lua-fuzzer.c`](lua-fuzzer.c)-stub to act as the interface between the `libfuzzer` and the test target
* [`build.sh`](build.sh)-script to build the library, and the stub and to link them with the fuzzer
* [`Dockerfile`](Dockerfile) to automate build of Docker image
* [`Samples`](samples/) to provide sample file to get started with

# Building

## Building container

```console
docker-compose build lua
```

# Running

## Starting the container

```console
docker-compose run lua
```

# Samples

Samples directory contains simple lua script that is used by this fuzzer.
