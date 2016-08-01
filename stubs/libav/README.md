# libav (under development)

# Purpose

Libav is a library that provides cross-platform tools and libraries to convert, manipulate and stream different multimedia formats and protocols. Purpose is to do fuzz testing to dirreferent codecs included in libav.

TODO:Libav stub is currently under development and it's not working correctly at the moment. See [Issue #18](https://github.com/ouspg/libfuzzerfication/issues/18)

What is included?

 * [`libav-fuzzer.c`](ImageMagick-fuzzer.c)-stub to act as the interface between the `libfuzzer` and the test target
 * [`build.sh`](build.sh)-script to build the library, and the stub and to link them with the fuzzer
 * [`Dockerfile`](Dockerfile) to automate build of Docker image

# Building

## Building container

```console
docker-compose build libav
```

# Running

## Starting the container

```console
docker-compose run libav
```
