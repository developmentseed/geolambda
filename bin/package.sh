#!/bin/bash

# directory used for deployment
export DEPLOY_DIR=lambda

echo Creating deploy package

# make deployment directory and add lambda handler
mkdir -p $DEPLOY_DIR/lib

# copy 32-bit libs
cp $PREFIX/lib/libproj.so.13 $DEPLOY_DIR/lib/
cp $PREFIX/lib/libgdal.so.20 $DEPLOY_DIR/lib/
cp $PREFIX/lib/libdf.so.0 $DEPLOY_DIR/lib/
cp $PREFIX/lib/libsz.so.2 $DEPLOY_DIR/lib/
cp $PREFIX/lib/libhdf5.so.103 $DEPLOY_DIR/lib/
cp $PREFIX/lib/libhdf5_hl.so.100 $DEPLOY_DIR/lib/
cp $PREFIX/lib/libmfhdf.so.0 $DEPLOY_DIR/lib/
cp $PREFIX/lib/libgeos_c.so.1 $DEPLOY_DIR/lib/
cp $PREFIX/lib/libgeos-3.7.1.so $DEPLOY_DIR/lib/
cp $PREFIX/lib/libnetcdf.so.13 $DEPLOY_DIR/lib/
cp $PREFIX/lib/libopenjp2.so.7 $DEPLOY_DIR/lib/
cp $PREFIX/lib/libwebp.so.7 $DEPLOY_DIR/lib/
cp $PREFIX/lib/libgeotiff.so.2 $DEPLOY_DIR/lib/
cp $PREFIX/lib/libzstd.so.1 $DEPLOY_DIR/lib/

# copy 64-bit libs
cp /usr/lib64/libjpeg.so.62 $DEPLOY_DIR/lib/
#cp /usr/lib64/libpq.so.5 $DEPLOY_DIR/lib/

strip $DEPLOY_DIR/lib/* || true

# copy GDAL_DATA files over
mkdir -p $DEPLOY_DIR/share
rsync -ax $PREFIX/share/gdal $DEPLOY_DIR/share/

# zip up deploy package
cd $DEPLOY_DIR
zip -ruq ../lambda-deploy.zip ./
