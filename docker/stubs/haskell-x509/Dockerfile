FROM ouspg/libfuzzer-base-haskell

MAINTAINER https://github.com/ouspg/libfuzzerification

WORKDIR /haskell
RUN cabal update && cabal install x509
COPY test.hs build.sh /haskell/
RUN sh ./build.sh
