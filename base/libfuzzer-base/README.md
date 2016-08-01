# libfuzzer-base

libFuzzer base image contains clang, nodejs and libfuzzer. Also nipsu minimizer is included. Fuzzer user is created so that it can be used to prevent running fuzzers as root.

## Build

```console
docker-compose build libfuzzer-base
```

## Alternative: Pull from dockerhub

```console
docker pull ouspg/libfuzzer-base
```
