FROM ouspg/libfuzzer-base

# Enviroment variables used by the fuzzer

ENV TARGET "rust"

#Install dependencies and fetch the source.

RUN apt-get update && apt-get install cmake && apt-get -y build-dep rust

RUN cd /src && git clone https://github.com/rust-lang/rust.git

ADD rust-fuzzer.c /src/rust/
RUN mkdir -p /work/rust/

#Build
ADD build.sh /src/scripts/
RUN bash /src/scripts/build.sh
