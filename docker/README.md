
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

# Developing
* Build image
* If you want to do developing (for ImageMagick in example) use:
```
docker run -it --rm -v <path>/<to>/docker/stubs/ImageMagick/:/src/src/ImageMagick --entrypoint bash <image>
```
This will run ImageMagick container with your development directory mounted inside container.

* [Docker tutorial](https://rominirani.com/docker-tutorial-series-a7e6ff90a023#.zysi49h2s)
