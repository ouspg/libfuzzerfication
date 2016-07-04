FROM ouspg/libfuzzer-base

ENV TARGET 'lua'
ENV TARGET_VERSION '5.3.3'

#Install dependencies and fetch the source.

RUN apt-get update && apt-get -y build-dep lua5.3

ADD https://www.lua.org/ftp/lua-${TARGET_VERSION}.tar.gz /src/
RUN tar -C /src -zxf /src/lua-${TARGET_VERSION}.tar.gz

ADD lua_fuzzer.c /src/lua-${TARGET_VERSION}

ADD samples /samples/libfuzzer-lua

#Build
ADD build.sh /src/scripts/
RUN bash /src/scripts/build.sh

#Execute default commands
ENTRYPOINT ["/src/scripts/fuzz.sh"]
CMD ["/lua_fuzzer",\
     "-rss_limit_mb=1024",\
     "-detect_leaks=0",\
     "-exact_artifact_path=/dev/shm/repro-file",\
     "-max_len=1000",\
     "-timeout=5",\
     "-use_counters=1",\
     "-max_total_time=3600",\
     "/samples/libfuzzer-lua"]
