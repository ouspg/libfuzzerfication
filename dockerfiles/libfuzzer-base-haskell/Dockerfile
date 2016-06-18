FROM ubuntu:16.04
# FROM ouspg/libfuzzer-base

MAINTAINER https://github.com/ouspg/libfuzzerification

ENV GHC_VERSION 8.0.1
ENV CABAL_VERSION 1.24
ENV GHC_LLVM 3.7

# https://launchpad.net/~hvr/+archive/ubuntu/ghc
COPY hvr-ghc.list /etc/apt/sources.list.d/
COPY hvr-ghc.key /tmp
RUN apt-key add /tmp/hvr-ghc.key

# I don't have time to build clang.. ;)
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install \
        clang \
        git

# GHC and requirements
RUN apt-get -y install \
        cabal-install-${CABAL_VERSION} \
        ghc-${GHC_VERSION} \
        llvm-${GHC_LLVM}

# Libfuzzer (needs GHC)
COPY FuzzerMain.cpp.patch /tmp/
RUN mkdir -p /src /work/libfuzzer && \
	cd /src && git clone --depth 1 http://llvm.org/git/llvm.git && \
        cd /src/llvm/lib/Fuzzer && \
        patch </tmp/FuzzerMain.cpp.patch && \
	cd /work/libfuzzer && \
        clang++ -std=c++11 -IFuzzer -I/opt/ghc/${GHC_VERSION}/lib/ghc-${GHC_VERSION}/include -c /src/llvm/lib/Fuzzer/*.cpp && \
        ar ruv libFuzzer.a Fuzzer*.o

# My devel tools
RUN apt-get -y install emacs-nox

# Set Clang as default compiler
RUN update-alternatives --set cc /usr/bin/clang && \
    update-alternatives --set c89 /usr/bin/clang && \
    update-alternatives --set c99 /usr/bin/clang && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/clang 1

# GHC needs to find correct version of LLVM's opt and llc
RUN update-alternatives --install /usr/bin/opt opt /usr/bin/opt-${GHC_LLVM} 1 && \
    update-alternatives --install /usr/bin/llc llc /usr/bin/llc-${GHC_LLVM} 1

ENV PATH /opt/ghc/${GHC_VERSION}/bin/:/opt/cabal/${CABAL_VERSION}/bin/:${PATH}

RUN mkdir -p /root/.cabal/
COPY cabal.config /root/.cabal/config

COPY ghc-wrapper ghc-asan /usr/local/bin/
RUN chmod a+x /usr/local/bin/ghc-*

COPY test.hs build.sh /src/
