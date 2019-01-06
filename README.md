# geolambda: geospatial Docker image and packaging for Amazon Linux

The geolambda project aims to make it easier to develop and deploy code to AWS Lambda functions, however the Docker images available also provide a ready to go Docker image based on Amazon Linux that contains common geospatial libaries and packages for other purposes.

## Usage

Unless interested in modifying the geolambda images themselves, most users will find most useful the product of this repository: a series of images available on Dockerhub. This repository contains a series of Dockerfiles that build upon one another to provide different versions of a geospatial Docker image for different appications.

### Available image tags

The developmentseed/geolambda image in Docker Hub is tagged by version. The latest version, 1.0.0 contains GDAL 2.3.1, compiled with libopenjpeg 2.3, hdf4, hdf5, netcdf, libcurl, and both Python 2.7 and 3.6 support.

	$ docker pull developmentseed/geolambda:<version>

| geolambda | GDAL  |
| -------- | ----  |
| 1.0.0    | 2.3.1 |
| 1.0.1    | 2.3.3 |

### Creating a new geolambda based project

The geolambda image will most often be used an image used in the creation of a package suitable for deploying to an AWS Lambda function. There are two main use cases:

- No additional libraries are required, and the client application is a simpler handler function that draws upon libraries and packages that are already included in the geolambda image. In this case the only files really needed are the docker-compose.yml file and the handler.py function.
- Additional libraries, either installed via PyPi or Git, and custom modules are needed to run the Lambda function. In this case a new Dockerfile is needed to create a new image that will be used (along with docker-compose.yml and the handler.py function)

In either case, the files in the geolambda-seed directory in this repository can be used as a template to create your new Lambda function.

### Building your project

After editing the geolambda-seed template project, you first build a Docker image for your project with:

$ docker-compose build

And you can test it by running an interactive container:

$ docker-compose run base

### Deploying to Lambda

The geolambda imgaes contain scripts for collecting and packaging all the files needed to deploy to a Lambda function (the zip file can either be uploaded directly to a Lambda function or added to S3), and can be run with docker-compose commands, depending on if it's Python 2.7 or 3.6 that is needed:

$ docker-compose run package27

$ docker-compose run package36

The geolambda-seed project contains simple tests for the Lambda handler and will test it out on a base Docker container that represents the Lambda environment.

$ docker-compose run testpackage27

$ docker-compose run testpackage36

This will add all the needed library files and Python dependencies for your project (as defined in requirements.txt) into the lambda/ directory and create a zip package for deployment. To add in additional files (such as system library files you installed in your Dockerfile), you can add commands to the lambda/lambda-package.sh file.


### geolambda Development

Contributions to the geolambda project are encouraged. The goal is to provide a turnkey method for developing and deploying geospatial Python based projects to Amazon Web Services. The 'master' branch in this repository contains the current state as deployed to the developmentseed/geolambda image on Dockerhub. The 'develop' branch is the development version and is not deployed to Dockerhub. To use the develop branch the images must be locally built first.

Make geolambda layer public

```
aws lambda add-layer-version-permission --layer-name geolambda \
--statement-id public --version-number 1 --principal '*' \
--action lambda:GetLayerVersion
```
