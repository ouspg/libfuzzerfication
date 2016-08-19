FROM ouspg/libfuzzer-base

# Enviroment variables used by the fuzzer

ENV TARGET "libxslt"
ENV LD_LIBRARY_PATH="/src/libxslt/libxslt/.libs/"

MAINTAINER https://github.com/ouspg/libfuzzerification

RUN apt-get update && apt-get install -y liblzma-dev
RUN apt-get build-dep libxslt -y
RUN cd /src && git clone git://git.gnome.org/libxslt

ADD libxslt-fuzzer.cc /src/libxslt/
#ADD xslt.dict /src/libxslt/

ADD samples.tar.gz /

ADD build.sh /src/scripts/
RUN mkdir -p /work/libxslt/
RUN bash /src/scripts/build.sh
