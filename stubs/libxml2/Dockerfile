FROM ouspg/libfuzzer-base

# Enviroment variables used by the fuzzer

ENV TARGET "libxml2"
ENV LD_LIBRARY_PATH="/src/libxml2/.libs/"

MAINTAINER https://github.com/ouspg/libfuzzerification

RUN apt-get update && apt-get install -y liblzma-dev
RUN apt-get build-dep libxml2 -y
RUN cd /src && git clone git://git.gnome.org/libxml2

ADD libxml2-fuzzer.cc /src/libxml2/
ADD xml.dict /src/libxml2/

ADD samples.tar.gz /

ADD build.sh /src/scripts/
RUN mkdir -p /work/libxml2/
RUN bash /src/scripts/build.sh
