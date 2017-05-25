#!/bin/bash

# directory used for deployment
DEPLOY_DIR=lambda

# install app
pip install .
cp lambda_handler.py $DEPLOY_DIR/

# copy libs
mkdir -p $DEPLOY_DIR/lib/python2.7/site-packages
cp $PREFIX/lib/libproj.so* $DEPLOY_DIR/lib/
cp $PREFIX/lib/libgdal.so* $DEPLOY_DIR/lib/
cp $PREFIX/lib/libdf.so.0 $DEPLOY_DIR/lib/
cp $PREFIX/lib/libsz.so.2 $DEPLOY_DIR/lib/
cp $PREFIX/lib/libhdf5.so.10 $DEPLOY_DIR/lib/
cp $PREFIX/lib/libmfhdf.so.0 $DEPLOY_DIR/lib/
rsync -ax $PREFIX/lib/python2.7/site-packages/ $DEPLOY_DIR/lib/python2.7/site-packages/ --exclude-from $PREFIX/etc/lambda-excluded-packages

# copy 64-bit libs
mkdir -p $DEPLOY_DIR/lib64/python2.7/site-packages
cp /usr/lib64/libgeos_c.so.1 $DEPLOY_DIR/lib64/
cp /usr/lib64/libgeos-3.4.2.so $DEPLOY_DIR/lib64/
#cp /usr/lib64/libpq.so.5 $DEPLOY_DIR/lib/
rsync -ax $PREFIX/lib64/python2.7/site-packages/ $DEPLOY_DIR/lib64/python2.7/site-packages/ --exclude-from $PREFIX/etc/lambda-excluded-packages

# zip up deploy package
cd $DEPLOY_DIR
zip -ruq ../deploy.zip ./ -x excluded_packages
