FROM ouspg/libfuzzer-base

ENV TARGET 'libav'

#Install dependencies and fetch the source.

RUN apt-get update && apt-get upgrade -y && apt-get install -y libavcodec-dev pkg-config && apt-get build-dep libavcodec-dev -y
RUN cd /src && git clone git://git.libav.org/libav.git libav
ADD libav_fuzzer.c /src/libav/

ADD ${TARGET}_fuzzer.c /src/$TARGET/
RUN mkdir -p /work/$TARGET/

#Build
ADD build.sh /src/scripts/
RUN bash /src/scripts/build.sh

#Execute default commands
ENTRYPOINT ["/src/scripts/fuzz.sh","/src/libav/libav_fuzzer"]
CMD ["-rss_limit_mb=4096",
     "-detect_leaks=0",
     "-exact_artifact_path=/dev/shm/repro-file",
     "-max_len=1000",
     "timeout=5",
     "-use_counters=1",
     "-max_total_time=3600",
     "/samples/libfuzzer-libav"]
