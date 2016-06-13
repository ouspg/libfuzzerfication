set -e -x

docker build $* -t libfuzzer/base base/
