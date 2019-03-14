# Python GeoLambda

The Python GeoLambda image is meant to be used as a template for your own Python based geospatial project.  Follow the usage instructions to package, test, and deploy your own Lambda.

## Usage

These instructions show how to use the files in this directory to create your own Python based geospatial Lambda function and get it deployed.

1. Update requirements

First a Docker image will need to be created based on GeoLambda that includes the dependencies needed. The first thing is to is update the `requirements-pre.txt` and `requirement.txt` files with the dependencies needed. The `requirements-pre.txt` is a way to specify build dependencies to packages in `requirements.txt`. For instance, rasterio requires numpy is installed before rasterio. This is a well known pip problem that is fixed in [PEP 518](https://www.python.org/dev/peps/pep-0518/) but is not used by all packages so this work-around is needed.

2. Create handler

An example Lambda handler is located at [lambda/lambda_function.py](lambda/lambda_function.py). Ideally most of the logic in your Lambda should be in packages and the handler should only be responsible for taking in an event, calling relevant functions, and returning some output. Keep the handler code as small as possible. Move more complex code into packages or make them other functions in the [lambda/lambda_function.py](lambda/lambda_function.py) file.

3. Build image

Now, use the [Dockerfile](Dockerfile) can be used to create a new Docker image based on any version of GeoLambda with any version of Python by providing the versions as build arguments to `docker run`. This will install the specified version of Python along with any Python packages provided in [requirements.txt](requirements.txt).

    $ VERSION=1.1.0
    $ docker build . --build-arg VERSION=${VERSION} --build-arg PYVERSION=3.6.1 -t <myimage>:latest

If not provided, `VERSION` (the version of GeoLambda to use) will default to `latest` and `PYVERSION` (Python version) will default to `3.6.1`.

4. Create deployment package

All that's needed to create a deployment package is to install the Python packages into the lambda/ directory using the package-python.sh script. This copies the installed site-packages over the lambda directory, but excluding some libraries since they won't be needed on Lambda. This includes packages that are already pre-installed in Lambda like boto3, as well as files and libraries that wouldn't be used operationally (e.g., testing files).

    $ docker run -v ${PWD}:/home/geolambda -t <myimage>:latest package-python.sh

This will also create a lambda-deployment.zip file in the current directory.

5. Testing deployment package

You can use the [LambCI Docker images](https://github.com/lambci/docker-lambda) to test out your handler in the Lambda environment by mounting the base GeoLambda Lambda layer (see the [GeoLambda README](../README.md)) and the lambda directory created above.

```
$ docker run --rm -v ${PWD}/lambda:/var/task -v ${PWD}/../lambda:/opt \
    lambci/lambda:python3.6 lambda_function.lambda_handler '{}'
```

The last argument is a JSON string that will be passed as the event payload to the handler function.

6. Deploy

Deploy the Lambda function now by zipping up the lambda directory and using the AWS CLI.

```
$ aws lambda update-function-code --function-name <mylambda> --zip-file fileb://lambda-deploy.zip
```

### Pre-built images

Builds of this default Python image are also available on Docker Hub as tags in the `developmentseed/geolambda` repository.

    $ docker pull developmentseed/geolambda:${VERSION}-python36

To run the image interactively:

    $ docker run -v ${PWD}:/home/geolambda --rm -it developmentseed/geolambda:${VERSION}-python36

This image includes the dependencies specified in the default [requirements.txt](requirements.txt) file.


## Development

To create a new official version of a Python GeoLambda Docker image for publication to Docker Hub follow these steps *after* following the [steps for publishing a new base GeoLambda](../README.md). These steps are performed automatically in [CircleCI](../.circleci/config.yml)

From this directory:

```
$ VERSION=$(cat ../VERSION)
$ docker build . --build-arg VERSION=${VERSION} -t developmentseed/geolambda:${VERSION}-python36
```

Provide `--build-arg PYVERSION=X.Y.Z` to build other Python versions and change the tag to be `${VERSION}-pythonX.Y`



