FROM ouspg/libfuzzer-base

RUN apt-get update && apt-get upgrade -y

ADD build.sh fuzzer.c mysamplelib.h mysamplelib.c /src/samplelib/

WORKDIR /src/samplelib
RUN ./build.sh
