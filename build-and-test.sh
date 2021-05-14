#!/bin/bash
set -e
VERSION=$(cat VERSION)

INTERACTIVE=$(if test -t 0; then echo -i; fi)
docker build . -t developmentseed/geolambda:${VERSION}
docker run --rm -v $PWD:/home/geolambda ${INTERACTIVE} -t developmentseed/geolambda:${VERSION} package.sh

cd python
docker build . --build-arg VERSION=${VERSION} -t developmentseed/geolambda:${VERSION}-python
docker run -v ${PWD}:/home/geolambda -t developmentseed/geolambda:${VERSION}-python package-python.sh

docker run --rm -v ${PWD}/lambda:/var/task -v ${PWD}/../lambda:/opt lambci/lambda:python3.7 lambda_function.lambda_handler '{}'
