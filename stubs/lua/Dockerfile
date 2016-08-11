FROM ouspg/libfuzzer-base

# Enviroment variables used by the fuzzer

ENV TARGET "lua"

#Install dependencies and fetch the source.

RUN apt-get update && apt-get -y build-dep lua5.3

ADD https://www.lua.org/ftp/lua-5.3.3.tar.gz /src/
RUN tar -C /src -zxf /src/lua-5.3.3.tar.gz

ADD lua-fuzzer.c /src/lua-5.3.3

ADD samples /samples/libfuzzer-lua

#Build
ADD build.sh /src/scripts/
RUN bash /src/scripts/build.sh

#Execute default commands
ENTRYPOINT ["/src/scripts/fuzz.sh"]
CMD ["/lua-fuzzer",\
     "-rss_limit_mb=1024",\
     "-detect_leaks=0",\
     "-exact_artifact_path=/dev/shm/repro-file",\
     "-max_len=1000",\
     "-timeout=5",\
     "-use_counters=1",\
     "-max_total_time=3600",\
     "/srv/fuzzer/samples/"]
