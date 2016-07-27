FROM ouspg/libfuzzer-base

# Enviroment variables used by the fuzzer

ENV TARGET "mysamplelib"

RUN apt-get update && apt-get upgrade -y

WORKDIR /src
COPY build.sh dictionary.txt fuzzer.c mysamplelib.h mysamplelib.c /src/samplelib/

WORKDIR /src/samplelib
COPY samples samples/
RUN ./build.sh
