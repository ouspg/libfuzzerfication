# libFuzzerfication stubs

# About

What is included in directories?

Each directory consists of at least following files:

 * fuzzer -stub to act as the interface between the `libfuzzer` and the test target
 * build.sh - script to build the library, and the stub and to link them with the fuzzer
 * Dockerfile - to build Docker image


# Building

Base image can be pulled from Dockerhub to avoid building locally.

```console
$ docker pull ouspg/libfuzzer-base
```

Stub images can be built using docker-compose

```console
$ docker-compose build <stub-name>
```

# Running

## Starting the container

```console
$ docker-compose run <stub-name>
```

Fuzzer is started automatically when container is started with docker-compose.


```console
INFO: Seed: 50837522
INFO: -max_len is not provided, using 64
INFO: A corpus is not provided, starting from an empty corpus
#0      READ   units: 1 exec/s: 0
#1      INITED cov: 12 bits: 12 units: 1 exec/s: 0
#2      NEW    cov: 15 bits: 15 units: 2 exec/s: 0 L: 64 MS: 0
...
```

# Example

[mysamplelib readme](mysamplelib/README.md) is also suggested to read to get started testing and writing your own stubs.
