FROM ouspg/libfuzzer-base

# Enviroment variables used by the fuzzer

ENV TARGET "rust"

#Install dependencies and fetch the source.
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install curl sudo -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -f -L https://static.rust-lang.org/rustup.sh -O && sh rustup.sh --channel=nightly

#ADD rust-fuzzer.rs /src/rust/
#RUN mkdir -p /work/rust/

#Build
#ADD build.sh /src/scripts/
#RUN bash /src/scripts/build.sh
