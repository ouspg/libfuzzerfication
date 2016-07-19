FROM ouspg/libfuzzer-base

MAINTAINER https://github.com/ouspg/libfuzzerification

RUN apt-get update && apt-get install -y liblzma-dev
RUN apt-get build-dep libxml2 -y
RUN cd /src && git clone git://git.gnome.org/libxml2

RUN export LD_LIBRARY_PATH="/src/libxml2/.libs/"

ADD libxml2_fuzzer.cc /src/libxml2/
ADD xml.dict /src/libxml2/

ADD build.sh /src/scripts/
RUN mkdir -p /work/libxml2/
RUN bash /src/scripts/build.sh
