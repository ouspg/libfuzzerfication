# zlib

# Purpose

Zlib is data compression library.

What is included?

* [`zlib-fuzzer.cc`](zlib-fuzzer.cc)-stub to act as the interface between the `libfuzzer` and the test target
* [`build.sh`](build.sh)-script to build the library, and the stub and to link them with the fuzzer
* [`Dockerfile`](Dockerfile) to automate build of Docker image

# Building

## Building container

```console
docker-compose build zlib
```

# Running

## Starting the container

```console
docker-compose run zlib
```
