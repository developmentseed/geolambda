#!/bin/bash

# directory used for deployment
DEPLOY_DIR=lambda

PYVER=${1:-2.7}

# make deployment directory and add lambda handler
mkdir -p $DEPLOY_DIR/lib/python$PYVER/site-packages

# copy 32-bit libs
cp $PREFIX/lib/libproj.so* $DEPLOY_DIR/lib/
cp $PREFIX/lib/libgdal.so* $DEPLOY_DIR/lib/
cp $PREFIX/lib/libdf.so.0 $DEPLOY_DIR/lib/
cp $PREFIX/lib/libsz.so.2 $DEPLOY_DIR/lib/
cp $PREFIX/lib/libhdf5.so.101 $DEPLOY_DIR/lib/
cp $PREFIX/lib/libmfhdf.so.0 $DEPLOY_DIR/lib/
rsync -ax $PREFIX/lib/python$PYVER/site-packages/ $DEPLOY_DIR/lib/python$PYVER/site-packages/ --exclude-from $PREFIX/etc/lambda-excluded-packages

# copy 64-bit libs
cp /usr/lib64/libgeos_c.so.1 $DEPLOY_DIR/lib/
cp /usr/lib64/libgeos-3.4.2.so $DEPLOY_DIR/lib/
cp /usr/lib64/libjpeg.so.62* $DEPLOY_DIR/lib/
#cp /usr/lib64/libpq.so.5 $DEPLOY_DIR/lib/
rsync -ax $PREFIX/lib64/python$PYVER/site-packages/ $DEPLOY_DIR/lib/python$PYVER/site-packages/ --exclude-from $PREFIX/etc/lambda-excluded-packages
ln -s GDAL-2.2.2-py$PYVER-linux-x86_64.egg/osgeo $DEPLOY_DIR/lib/python$PYVER/site-packages/osgeo

# zip up deploy package
cd $DEPLOY_DIR
zip -ruq ../lambda-deploy.zip ./
