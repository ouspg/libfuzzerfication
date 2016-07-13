FROM ouspg/libfuzzer-base

MAINTAINER https://github.com/ouspg/libfuzzerification

RUN apt-get update && apt-get install -y liblzma-dev
RUN apt-get build-dep libxslt -y
RUN cd /src && git clone git://git.gnome.org/libxslt

ADD libxslt_fuzzer.cc /src/libxslt/
#ADD xslt.dict /src/libxslt/

ADD build.sh /src/scripts/
RUN mkdir -p /work/libxslt/
RUN bash /src/scripts/build.sh
