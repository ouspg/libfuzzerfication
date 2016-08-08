FROM ouspg/libfuzzer-base

# Enviroment variables used by the fuzzer

ENV TARGET "zlib"

MAINTAINER https://github.com/ouspg/libfuzzerification
ENV TARGET 'zlib'

RUN apt-get update && apt-get upgrade -y && apt-get install -y zlib1g-dev && apt-get build-dep zlib1g-dev -y
RUN cd /src && git clone https://github.com/madler/zlib.git
ADD zlib-fuzzer.cc /src/zlib/

ADD build.sh /src/zlib/
WORKDIR /src/zlib
RUN bash ./build.sh
