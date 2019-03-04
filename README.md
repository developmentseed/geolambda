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

Or just include it in your own Dockerfile as the base image.

```
FROM developmentseed/geolambda:<version>
```

The GeoLambda image does not have an entrypoint defined, so provide one when you run it. This example will mount the current directory to /work and run the container interactively.

```
$ docker run --rm -v $PWD:/work -it developmentseed/geolambda:latest /bin/bash
```

### Creating a new Lambda Layer

The Dockerfile here can be used as a template for your own Lambda layer. Simply edit it to remove or add additional libraries, then build it with your own name:

```
$ docker build . -t mygeolambda:latest
```

Then, package up the resulting files by using the [provided script](bin/package.sh). 

```
$ docker run -t 



### Development

Contributions to the geolambda project are encouraged. The goal is to provide a turnkey method for developing and deploying geospatial Python based projects to Amazon Web Services. The 'master' branch in this repository contains the current state as deployed to the `developmentseed/geolambda:latest` image on Dockerhub, along with a tag of the version. The 'develop' branch is the development version and is not deployed to Dockerhub.

When making a merge to the `master` branch be sure to increment the `VERSION` in the CircleCI config.yml file. Circle will push the new version as a tag to GitHub and build and push the image to Docker Hub. If a GitHub tag already exists with that version the process will fail.


#### Make layer public

```
aws lambda add-layer-version-permission --layer-name geolambda \
--statement-id public --version-number 1 --principal '*' \
--action lambda:GetLayerVersion
```
