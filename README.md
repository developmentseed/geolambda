# geolambda: geospatial Docker image and packaging for Amazon Linux

The geolambda project aims to make it easier to develop and deploy code to AWS Lambda functions, however the Docker images available also provide a ready to go Docker image based on Amazon Linux that contains common geospatial libaries and packages for other purposes.

## Usage

Unless interested in modifying the geolambda images themselves, most users will find most useful the product of this repository: a series of images available on Dockerhub. This repository contains a series of Dockerfiles that build upon one another to provide different versions of a geospatial Docker image for different appications.

### Available image tags

The developmentseed/geolambda image in Docker Hub has several available tags:

- **base**: The base image consists of an Amazon base image with python added, along with the boto3 and nose libraries. The purpose of the main image is to replicate the base system in Lambda with the nose testing framework added so that a deployable package can be tested on an image like what is used in the Lambda container.
- **core**: The core image contains system dependencies that are used by other other images. It also defines version numbers for packages that are installed in other images.
- **min**: GDAL2, with a minimized set of packages/drivers is installed with Python support, along with proj.4
- **hdf**: GDAL2, with HDF4 and 5 support added (including szip and proj.4)
- **cloud**: GDAL2, with libraries common for cloud access: GeoTiff and Jpeg2000 (using OpenJPEG)
- **full**: GDAL2 with all libraries compiled in other images

Pull whichever one is most appropriate with the docker command:

	$ docker pull developmentseed/geolambda:<tag>

### Creating a new geolambda based project

The geolambda image will most often be used an image used in the creation of a package suitable for deploying to an AWS Lambda function. There are two main use cases:

- No additional libraries are required, and the client application is a simpler handler function that draws upon libraries and packages that are already included in the geolambda image. In this case the only files really needed are the docker-compose.yml file and the handler.py function.
- Additional libraries, either installed via PyPi or Git, and custom modules are needed to run the Lambda function. In this case a new Dockerfile is needed to create a new image that will be used (along with docker-compose.yml and the handler.py function)

In either case, the files in the geolambda-seed directory in this repository can be used as a template to create your new Lambda function.

### Deploying to Lambda

The geolambda imgaes contain two scripts for collecting and packaging all the files needed to deploy to a Lambda function (the zip file can either be uploaded directly to a Lambda function or added to S3).


### geolambda Development

Contributions to the geolambda project are encouraged. The goal is to provide a turnkey method for developing and deploying geospatial Python based projects to Amazon Web Services. The 'master' branch in this repository contains the current state as deployed to the developmentseed/geolambda image on Dockerhub. The 'develop' branch is the development version and is not deployed to Dockerhub. To use the develop branch the images must be locally built first.
