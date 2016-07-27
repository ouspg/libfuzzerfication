# ImageMagick

# Purpose

ImageMagick is a software suite to create, edit, compose, or convert bitmap images. In the stub we use BlobToImage to load input as an image and if successful then destroy the image.

What is included?

 * [`ImageMagick-fuzzer.c`](ImageMagick-fuzzer.c)-stub to act as the interface between the `libfuzzer` and the test target
 * [`build.sh`](build.sh)-script to build the library, and the stub and to link them with the fuzzer
 * [`Dockerfile`](Dockerfile) to automate build of Docker image
 * [`Samples`](samples.tar.gz) to provide sample files to get started with

# Building

## Building container

```console
docker-compose build ImageMagick
```

# Running

## Starting the container

```console
docker-compose run ImageMagick
```

# Samples

samples.tar.gz contains sample files from [imagetestsuite](https://code.google.com/archive/p/imagetestsuite/).
