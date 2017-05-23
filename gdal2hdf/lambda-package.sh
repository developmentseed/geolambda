#!/bin/bash

DEPLOY_DIR=lambda

mkdir -p $DEPLOY_DIR/lib
cp /usr/lib64/libgeos_c.so.1 $DEPLOY_DIR/lib/
cp /usr/lib64/libgeos-3.4.2.so $DEPLOY_DIR/lib/
cp /usr/lib64/libpq.so.5 $DEPLOY_DIR/lib/
cp /usr/local/lib/libdf.so.0 $DEPLOY_DIR/lib/
cp /usr/local/lib/libsz.so.2 $DEPLOY_DIR/lib/
cp /usr/local/lib/libhdf5.so.10 $DEPLOY_DIR/lib/
cp /usr/local/lib/libmfhdf.so.0 $DEPLOY_DIR/lib/
cp /usr/local/lib/libproj.so.9 $DEPLOY_DIR/lib/
cp /usr/local/lib/libgdal.so.1 $DEPLOY_DIR/lib/

# package app and python libs
pip install .
rsync -ax /usr/local/lib/python2.7/site-packages/ $DEPLOY_DIR/site-packages/ --exclude-from /usr/local/etc/lambda-excluded-packages

# zip up deploy package
cd $DEPLOY_DIR
zip -ruq deploy.zip ./ -x deploy.zip -x excluded_packages -x package.sh test_lambda.py
