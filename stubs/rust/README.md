# rust

# Purpose

Rust is a systems programming language that is fast, prevents segfaults, and guarantees thread safety.

What is included?

* [`rust-fuzzer.cc`](rust-fuzzer.cc)-stub to act as the interface between the `libfuzzer` and the test target
* [`build.sh`](build.sh)-script to build the library, and the stub and to link them with the fuzzer
* [`Dockerfile`](Dockerfile) to automate build of Docker image

# Building

## Building container

```console
docker-compose build rust
```

# Running

## Starting the container

```console
docker-compose run rust
```
