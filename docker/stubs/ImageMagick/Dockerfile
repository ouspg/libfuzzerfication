FROM ouspg/libfuzzer-base

ENV TARGET 'ImageMagick'

#Install dependencies and fetch the source.

RUN apt-get update && \
    apt-get full-upgrade -y && \
    apt-get build-dep imagemagick -y && \
    apt-get install libiomp5 libiomp-dev -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


RUN cd /src && git clone https://github.com/ImageMagick/ImageMagick.git

ADD ${TARGET}_fuzzer.c /src/$TARGET/
RUN mkdir -p /work/$TARGET/

#Build

ADD build.sh /src/scripts/
RUN bash /src/scripts/build.sh

#Entrypoint and default args
#ENTRYPOINT /src/scripts/fuzz.sh
#CMD ['/samples/libfuzzer-imagemagick']
