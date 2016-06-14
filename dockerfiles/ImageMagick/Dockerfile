FROM libfuzzer/base-fuzzer

MAINTAINER attekett@gmail.com

ENV TARGET 'ImageMagick'

#Install dependencies and fetch the source.
RUN apt-get build-dep imagemagick -y && apt-get install libiomp5 libiomp-dev -y
RUN cd /src && git clone https://github.com/ImageMagick/ImageMagick.git

ADD ${TARGET}_fuzzer.c /src/$TARGET/
RUN mkdir -p /work/$TARGET/

#Add scripts
ADD build.sh /src/scripts/
ADD fuzz.sh /src/scripts/

#Build
RUN bash /src/scripts/build.sh

#Entrypoint and default args
ENTRYPOINT ["bash", "/src/scripts/fuzz.sh"]
CMD ['/samples/libfuzzer-imagemagick']