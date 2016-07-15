FROM ouspg/libfuzzer-base

MAINTAINER https://github.com/ouspg/libfuzzerification
ENV TARGET 'zlib'

RUN apt-get update && apt-get upgrade -y && apt-get install -y zlib1g-dev && apt-get build-dep zlib1g-dev -y
RUN cd /src && git clone https://github.com/madler/zlib.git
ADD zlib-fuzzer.cc /src/$TARGET/

ADD build.sh /src/$TARGET/
WORKDIR /src/zlib
RUN bash ./build.sh
