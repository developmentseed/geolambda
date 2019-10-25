# GeoLambda: geospatial AWS Lambda Layer

The GeoLambda project provides public Docker images and AWS Lambda Layers containing common geospatial native libraries. GeoLambda contains the libraries PROJ.5, GEOS, GeoTIFF, HDF4/5, SZIP, NetCDF, OpenJPEG, WEBP, ZSTD, and GDAL. For some applications you may wish to minimize the size of the libraries by excluding unused libraries, or you may wish to add other libraries. In this case this repository can be used as a template to create your own Docker image or Lambda Layer following the instructions in this README.

This repository also contains additional images and layers for specific runtimes. Using them as a Layer assumes the use of the basee GeoLambda layer.

- [Python](python/README.md)

## Usage

While GeoLambda was initially intended for AWS Lambda it is also useful as a base geospatial Docker image. For detailed info on what is included in each image, see the Dockerfile for that version or the [CHANGELOG](CHANGELOG.md). A version summary is provided here:

| geolambda | GDAL  | Notes |
| --------- | ----  | ----- |
| 1.0.0     | 2.3.1 | |
| 1.1.0     | 2.4.1 | |
| 1.2.0     | 2.4.2 | Separate Python (3.7.4) image and Lambda Layer added |
| 2.0.0		| 3.0.1 | libgeotiff 1.5.1, proj 6.2.0 |

### Docker images

The Docker images used to create the Lambda layer are also published to Docker Hub, and thus are also suitable for general use as a base image for geospatial applications. 

The developmentseed/geolambda image in Docker Hub is tagged by version.

	$ docker pull developmentseed/geolambda:<version>

Or just include it in your own Dockerfile as the base image.

```
FROM developmentseed/geolambda:<version>
```

The GeoLambda image does not have an entrypoint defined, so a command must be provided when you run it. This example will mount the current directory to /work and run the container interactively.

	$ docker run --rm -v $PWD:/home/geolambda -it developmentseed/geolambda:latest /bin/bash

All of the GDAL CLI tools are installed so could be run on images in the current directory.

### Lambda Layer

If you just wish to use the publicly available Lambda layer you will need the ARN for the layer in the same region as your Lambda function. Currently, GeoLambda layers are available in `us-east-1`, `us-west-2`, and `eu-central-1`. If you want to use it in another region please file an issue or you can also create your own layer using this repository (see instructions below on 'Create a new version').

#### v2.0.0rc1

| Region | ARN |
| ------ | --- |
| us-east-1 | arn:aws:lambda:us-east-1:552188055668:layer:geolambda:3 |
| us-west-2 | arn:aws:lambda:us-west-2:552188055668:layer:geolambda:3 |
| eu-central-1 | arn:aws:lambda:eu-central-1:552188055668:layer:geolambda:3 |

#### v2.0.0rc1-python

See the [GeoLambda Python README](python/README.md). The Python Lambda Layer includes the libraries `numpy`, `rasterio`, `GDAL`, `pyproj`, and `shapely`.

| Region | ARN |
| ------ | --- |
| us-east-1 | arn:aws:lambda:us-east-1:552188055668:layer:geolambda-python:2 |
| us-west-2 | arn:aws:lambda:us-west-2:552188055668:layer:geolambda-python:2 |
| eu-central-1 | arn:aws:lambda:eu-central-1:552188055668:layer:geolambda-python:2 |

#### v1.2.0

| Region | ARN |
| ------ | --- |
| us-east-1 | arn:aws:lambda:us-east-1:552188055668:layer:geolambda:2 |
| us-west-2 | arn:aws:lambda:us-west-2:552188055668:layer:geolambda:2 |
| eu-central-1 | arn:aws:lambda:eu-central-1:552188055668:layer:geolambda:2 |

#### v1.2.0-python

See the [GeoLambda Python README](python/README.md). The Python Lambda Layer includes the libraries `numpy`, `rasterio`, `GDAL`, `pyproj`, and `shapely`.

| Region | ARN |
| ------ | --- |
| us-east-1 | arn:aws:lambda:us-east-1:552188055668:layer:geolambda-python:1 |
| us-west-2 | arn:aws:lambda:us-west-2:552188055668:layer:geolambda-python:1 |
| eu-central-1 | arn:aws:lambda:eu-central-1:552188055668:layer:geolambda-python:1 |

#### v1.1.0

| Region | ARN |
| ------ | --- |
| us-east-1 | arn:aws:lambda:us-east-1:552188055668:layer:geolambda:1 |
| us-west-2 | arn:aws:lambda:us-west-2:552188055668:layer:geolambda:1 |
| eu-central-1 | arn:aws:lambda:eu-central-1:552188055668:layer:geolambda:1 |


## Development

Contributions to the geolambda project are encouraged. The goal is to provide a turnkey method for developing and deploying geospatial applications to AWS. The 'master' branch in this repository contains the current state as deployed to the Docker Hub images `developmentseed/geolambda:latest` and `devlopmentseed/geolambda-python:latest`, along with a tag of the version. The 'develop' branch is the development version and is not deployed to Docker Hub.

When making a merge to the `master` branch be sure to increment the `VERSION` file. Circle will push the new version as a tag to GitHub and build and push the image to Docker Hub. If a GitHub tag already exists with that version the process will fail.

### Create a new version

Use the Dockerfile here as a template for your own version of GeoLambda. Simply edit it to remove or add additional libraries, then build and tag with your own name. The steps below are used to create a new official version of GeoLambda, replace `developmentseed/geolambda` with your own name.

To create a new version of GeoLambda follow these steps. Note that this is the manual process of what is currently done in CircleCI, so it is not necessary to perform them but they are useful as an example for deploying your own versions.

1. update the version in the `VERSION` file

The version in the VERSION file will be used to tag the Docker images and create a GitHub tag.

2. build the image:
  
```
$ VERSION=$(cat VERSION)
$ docker build . -t developmentseed/geolambda:${VERSION}
```

3. Push the image to Docker Hub:

```
$ docker push developmentseed/geolambda:${VERSION}
```

4. Create deployment package using the built-in [packaging script](bin/package.sh)

```
$ docker run --rm -v $PWD:/home/geolambda \
	-it developmentseed/geolambda:${VERSION} package.sh
```

This will create a lambda/ directory containing the native libraries and related files, along with a `lambda-deploy.zip` file that can be deployed as a Lambda layer.

5. Push as Lambda layer (if layer already exists a new version will be created)

```
$ aws lambda publish-layer-version \
	--layer-name geolambda \
	--license-info "MIT" \
	--description "Native geospatial libaries for all runtimes" \
	--zip-file fileb://lambda-deploy.zip
```

6. Make layer public (needs to be done each time a new version is published)

```
$ aws lambda add-layer-version-permission --layer-name geolambda \
	--statement-id public --version-number 1 --principal '*' \
	--action lambda:GetLayerVersion
```
