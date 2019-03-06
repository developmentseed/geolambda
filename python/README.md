# Python GeoLambda

The Python GeoLambda image is meant to be used as a template for your own Python based geospatial project.  Follow the usage instructions to package, test, and deploy your own Lambda.

## Usage

These instructions show how to use the files in this directory to create your own Python based geospatial Lambda function and get it deployed.

### Create docker image

First a Docker image will need to be created based on GeoLambda that includes the dependencies needed. Use the [Dockerfile](Dockerfile) can be used to create a new Docker image based on any version of GeoLambda with any version of Python by providing the versions as build arguments to `docker run`. This will install the specified version of Python along with any Python packages provided in [requirements.txt](requirements.txt).

    $ docker build . --build-arg VERSION=1.1.0 --build-arg PYVER=3.6.1 -t <myimage>:latest

If not provided, `VERSION` (the version of GeoLambda to use) will default to `latest` and `PYVER` (Python version) will default to `3.6.1`.

### Create handler

An example Lambda handler is located at [lambda/lambda_function.py](lambda/lambda_function.py). Ideally most of the logic in your Lambda should be in packages and the handler should only be responsible for taking in an event, calling relevant functions, and returning some output. Keep the handler code as small as possible. Move more complex code into packages or make them other functions in the [lambda/lambda_function.py](lambda/lambda_function.py) file.

### Create deployment package

All that's needed to create a deployment package is to install the Python packages into the lambda/ directory.

    $ docker run -v ${PWD}:/home/geolambda -t <myimage>:latest pip install -r requirements -t lambda/

The lambda/ directory can now be zipped up and deployed as a Lambda function:

    $ cd lambda
    $ zip -ru ../lambda-deploy.zip ./

### Testing deployment package

You can use the [LambCI Docker images](https://github.com/lambci/docker-lambda) to test out your handler in the Lambda environment by mounting the base GeoLambda Lambda layer (see the [GeoLambda README](../README.md)) and the lambda directory created above.

```
$ docker run --rm -v ${PWD}/lambda:/var/task -v ${PWD}/../lambda:/opt \
    lambci/lambda:python3.6 lambda_function.lambda_handler '{}'
```

The last argument is a JSON string that will be passed as the event payload to the handler function.

### Pre-built images

Builds of this default Python image are also available on Docker Hub as tags in the `developmentseed/geolambda` repository.

    $ docker pull developmentseed/geolambda:1.1.0-python36

To run the image interactively:

    $ docker run -v ${PWD}:/home/geolambda --rm -it developmentseed/geolambda:${VERSION}-python36

This image includes the dependencies specified in the default [requirements.txt](requirements.txt) file.


## Development

To create a new official version of a Python GeoLambda Docker image for publication to Docker Hub follow these steps *after* following the [steps for publishing a new base GeoLambda](../README.md)

From this directory:

```
$ VERSION=${cat ../VERSION}
$ docker build . --build-arg VERSION=${VERSION} -t developmentseed/geolambda:${VERSION}-python36
```

Provide `--build-arg PYVER=X.Y.Z` to build other Python versions and change the tag to be `${VERSION}-pythonX.Y`



