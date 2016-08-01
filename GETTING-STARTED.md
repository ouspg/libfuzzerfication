# Getting started

##
See the [screencast](https://www.youtube.com/watch?v=B46AMry7lHs&feature=youtu.be) about stub writing.

## Requirements

Before getting started you need the following requirements:
* [Docker version 1.11.2](https://www.docker.com/)
* [docker-compose version 1.8.0](https://github.com/docker/compose/releases)

## Clone repository

First thing you need to do is to clone git repository.

```console
git clone https://github.com/ouspg/libfuzzerfication.git
```

## Get the libfuzzer-base image

```console
cd libfuzzerfication
```

Then you have to get the libfuzzer-base docker image.

```console
docker pull ouspg/libfuzzer-base
```

**Alternatively** you can build libfuzzer-base yourself if you want but it takes longer time.

```console
docker-compose build libfuzzer-base
```

## Build the stub image (ImageMagick in this example)

In this example we are going to build ImageMagick image

```console
docker-compose build ImageMagick
```

## Running fuzzer

Run the container

```console
docker-compose run ImageMagick
```

Fuzzer should produce output like this:

```
INFO: Seed: 802690056
#0      READ   units: 59 exec/s: 0
#59     INITED cov: 2453 bits: 5172 indir: 22 units: 39 exec/s: 0
#67     NEW    cov: 2453 bits: 5188 indir: 22 units: 40 exec/s: 0 L: 393 MS: 3 ChangeBit-ChangeBit-CrossOver-
#69     NEW    cov: 2454 bits: 5189 indir: 22 units: 41 exec/s: 0 L: 406 MS: 5 ChangeBit-ChangeBit-CrossOver-EraseByte-AddFromTempAutoDict- DE: "id=ImageMagick"-
#80     NEW    cov: 2454 bits: 5195 indir: 22 units: 42 exec/s: 0 L: 393 MS: 1 ChangeByte-
#90     NEW    cov: 2454 bits: 5198 indir: 22 units: 43 exec/s: 0 L: 341 MS: 1 ChangeByte-
#120    NEW    cov: 2454 bits: 5206 indir: 22 units: 44 exec/s: 0 L: 874 MS: 1 ChangeByte-
#125    NEW    cov: 2454 bits: 5208 indir: 22 units: 45 exec/s: 0 L: 97 MS: 1 InsertByte-
#144    NEW    cov: 2454 bits: 5209 indir: 22 units: 46 exec/s: 0 L: 861 MS: 5 ChangeByte-InsertByte-InsertByte-ChangeBit-CrossOver-
#148    NEW    cov: 2454 bits: 5210 indir: 22 units: 47 exec/s: 0 L: 875 MS: 4 ChangeByte-ShuffleBytes-InsertByte-AddFromPersAutoDict- DE: "id=ImageMagick"-
#157    NEW    cov: 2455 bits: 5211 indir: 22 units: 48 exec/s: 0 L: 408 MS: 3 ShuffleBytes-InsertByte-AddFromPersAutoDict- DE: "id=ImageMagick"-
```
