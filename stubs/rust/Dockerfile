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

# Add key for clang-3.9 sources
RUN curl -f -L http://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -

# Add sources for Clang-3.9
RUN echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-3.9 main" >> /etc/apt/sources.list
RUN echo "deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-3.9 main" >> /etc/apt/sources.list

#Install dependencies and fetch the source.
RUN apt-get update && \
    apt-get install clang-3.9 -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Rust nightly build
RUN curl -f -L https://static.rust-lang.org/rustup.sh -O && sh rustup.sh --channel=nightly

ADD rust-fuzzer.rs /src/rust/
RUN mkdir -p /work/rust/

#Build
ADD build.sh /src/scripts/
RUN bash /src/scripts/build.sh
