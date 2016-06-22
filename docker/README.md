
# libfuzzerfication dockerfiles

# How to run containers?
* Build base image
```
docker-compose build libfuzzer-base
```
* Run container (ImageMagick example)
```
docker-compose run imagemagick
```
* You can find other targets from docker-compose.yml
* libfuzzer-base includes fuzz.sh script for collecting results
