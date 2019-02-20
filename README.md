# GeoLambda: geospatial AWS Lambda Layer

The GeoLambda project provides public Lambda Layers containing common geospatial native libraries for use with any of the AWS Lambda Runtime languages.

GeoLambda contains the libraries PROJ.5, GEOS, HDF4/5, SZIP, NetCDF, OpenJPEG, WEBP, ZSTD, and GDAL. For some applications you may wish to minimize the size of the libraries by exclusing unused libraries, or you may wish to add other libraries. In this case this repository can be used as a template to create your own Lambda Layer.

## Usage

To use one of the public GeoLambda layers you will need the ARN for the layer in same region as your Lambda function. Currently, GeoLambda layers are available in `us-east-1`, `us-west-2`, and `eu-central-1`. If you want to use it in another region please file an issue or you can also create your own layer using this repository.

| Region | ARN |
| ------ | --- |
| us-east-1 | |
| us-west-2 | |
| eu-central-1 | |

### Docker images

The Docker images used to create the Lambda layer are also published to Docker Hub, and thus are also suitable for general use as a base image for geospatial applications. 

The developmentseed/geolambda image in Docker Hub is tagged by version.

	$ docker pull developmentseed/geolambda:<version>

| geolambda | GDAL  |
| -------- | ----  |
| 1.0.0    | 2.3.1 |
| 1.1.0    | 2.4.0 |

### Creating a new Lambda Layer

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

Contributions to the geolambda project are encouraged. The goal is to provide a turnkey method for developing and deploying geospatial Python based projects to Amazon Web Services. The 'master' branch in this repository contains the current state as deployed to the developmentseed/geolambda image on Dockerhub. The 'develop' branch is the development version and is not deployed to Dockerhub.

Make geolambda layer public

```
aws lambda add-layer-version-permission --layer-name geolambda \
--statement-id public --version-number 1 --principal '*' \
--action lambda:GetLayerVersion
```
