FROM ouspg/libfuzzer-base

MAINTAINER https://github.com/ouspg/libfuzzerification

#Install build-deps
RUN apt-get update && apt-get build-dep libmad0 -y
#Download source, extract and remove downloaded files.
RUN mkdir -p /src/ && cd /src/ && apt-get source libmad0 && ls -p | grep -v / | xargs rm

#Copy stub
ADD libmad-fuzzer.c /src/libmad-0.15.1b/

#Add build script and build
ADD build.sh /src/scripts/
RUN bash /src/scripts/build.sh
