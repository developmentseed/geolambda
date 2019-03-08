#!/bin/bash

# directory used for deployment
export DEPLOY_DIR=lambda

echo Creating deploy package

EXCLUDE="boto3* botocore* pip* docutils* *.pyc setuptools* wheel* coverage* testfixtures* mock* *.egg-info *.dist-info"

EXCLUDES=()
for E in ${EXCLUDE}
do
    echo ${E}
    EXCLUDES+=("--exclude ${E} ")
done

rsync -ax $PREFIX/lib/python$PYVER/site-packages/ $DEPLOY_DIR/ ${EXCLUDES[@]}
rsync -ax $PREFIX/lib64/python$PYVER/site-packages/ $DEPLOY_DIR/ ${EXCLUDES[@]}

# zip up deploy package
cd $DEPLOY_DIR
zip -ruq ../lambda-deploy.zip ./
