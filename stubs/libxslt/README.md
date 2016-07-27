# libxslt

# Purpose

Libxslt is the XSLT C library that is developed fro Gnome project. XSLT itself is a an XML language to define transformation for XML.

What is included?

* [`libxslt-fuzzer.cc`](libxslt-fuzzer.cc)-stub to act as the interface between the `libfuzzer` and the test target
* [`build.sh`](build.sh)-script to build the library, and the stub and to link them with the fuzzer
* [`Dockerfile`](Dockerfile) to automate build of Docker image
* [`Samples`](samples.tar.gz) to provide sample files to get started with

# Building

## Building container

```console
docker-compose build libxslt
```

# Running

## Starting the container

```console
docker-compose run libxslt
```

# Samples
