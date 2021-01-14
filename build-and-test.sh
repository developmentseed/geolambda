#!/bin/bash

VERSION=$(cat VERSION)
PYVERSION=$(cat python/PYVERSION)

docker build . -t developmentseed/geolambda:${VERSION}
docker run --rm -v $PWD:/home/geolambda -it developmentseed/geolambda:${VERSION} package.sh

cd python
docker build . --build-arg VERSION=${VERSION} -t developmentseed/geolambda:${VERSION}-python
docker run -v ${PWD}:/home/geolambda -t developmentseed/geolambda:${VERSION}-python package-python.sh

docker run -e --build-arg PYVERSION=${PYVERSION} GDAL_DATA=/opt/share/gdal -e PROJ_LIB=/opt/share/proj \
    --rm -v ${PWD}/lambda:/var/task -v ${PWD}/../lambda:/opt lambci/lambda:python3.7 lambda_function.lambda_handler '{}'
