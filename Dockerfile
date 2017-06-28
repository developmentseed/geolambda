FROM developmentseed/geolambda:base

RUN \
    yum -y update; \
    yum install -y wget tar gcc zlib-devel gcc-c++ libgeos curl-devel zip libjpeg-devel; \
    yum clean all;

RUN \
	pip install numpy wheel;

ENV \
	BUILD=/build \
	PREFIX=/usr/local \
	GDAL_CONFIG=/usr/local/bin/gdal-config \
	LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64

# versions of packages
ENV \
	PROJ4_VERSION=4.9.2 \
	HDF4_VERSION=4.2.12 \
	SZIP_VERSION=2.1 \
	HDF5_VERSION=1.10.1 \
	GDAL_VERSION=2.2.0 \