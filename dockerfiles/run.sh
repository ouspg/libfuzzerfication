set -e -x

docker build $* -t libfuzzer/base base/
docker build $* -t libfuzzer/base-clang base-clang/
docker build $* -t libfuzzer/base-fuzzer base-fuzzer/