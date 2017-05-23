#!/bin/bash

# directory used for deployment
DEPLOY_DIR=lambda
# where packages were built
BUILD_DIR=/build
# where user installed libraries found
PRE=/usr/local

# install app
pip install .
cp lambda_handler.py $DEPLOY_DIR/

# copy libs
mkdir -p $DEPLOY_DIR/lib/python2.7/site-packages
cp $BUILD_DIR/lib/libproj.so* $DEPLOY_DIR/lib/
cp $BUILD_DIR/lib/libgdal.so* $DEPLOY_DIR/lib/
rsync -ax $PRE/lib/python2.7/site-packages/ $DEPLOY_DIR/lib/python2.7/site-packages/ --exclude-from $PRE/etc/lambda-excluded-packages

# copy 64-bit libs
mkdir -p $DEPLOY_DIR/lib64/python2.7/site-packages
cp /usr/lib64/libgeos_c.so.1 $DEPLOY_DIR/lib64/
cp /usr/lib64/libgeos-3.4.2.so $DEPLOY_DIR/lib64/
rsync -ax $PRE/lib64/python2.7/site-packages/ $DEPLOY_DIR/lib64/python2.7/site-packages/ --exclude-from $PRE/etc/lambda-excluded-packages

# zip up deploy package
cd $DEPLOY_DIR
zip -ruq ../deploy.zip ./ -x excluded_packages
