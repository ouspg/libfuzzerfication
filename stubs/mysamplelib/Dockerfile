FROM ouspg/libfuzzer-base

RUN apt-get update && apt-get upgrade -y

WORKDIR /src
COPY build.sh dictionary.txt fuzzer.c mysamplelib.h mysamplelib.c /src/samplelib/

WORKDIR /src/samplelib
COPY samples samples/
RUN ./build.sh
