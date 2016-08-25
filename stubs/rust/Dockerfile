FROM ouspg/libfuzzer-base

# Enviroment variables used by the fuzzer

ENV TARGET "rust"

#Install dependencies and fetch the source.

RUN apt-get update && apt-get install rustc -y

ADD rust-fuzzer.rs /src/rust/
RUN mkdir -p /work/rust/

#Build
ADD build.sh /src/scripts/
RUN bash /src/scripts/build.sh
