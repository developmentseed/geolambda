#!/bin/bash

# directory used for deployment
export DEPLOY_DIR=lambda

# Get Python version
PYVERSION=$(cat /root/.pyenv/version)
MAJOR=${PYVERSION%%.*}
MINOR=${PYVERSION#*.}
PYVER=${PYVERSION%%.*}${MINOR%%.*}
PYPATH=/root/.pyenv/versions/$PYVERSION/lib/python3.6/site-packages/

echo Creating deploy package for Python $PYVERSION

EXCLUDE="boto3* botocore* pip* docutils* *.pyc setuptools* wheel* coverage* testfixtures* mock* *.egg-info *.dist-info __pycache__ easy_install.py"

EXCLUDES=()
for E in ${EXCLUDE}
do
    EXCLUDES+=("--exclude ${E} ")
done

rsync -ax $PYPATH/ $DEPLOY_DIR/ ${EXCLUDES[@]}

# zip up deploy package
cd $DEPLOY_DIR
zip -ruq ../lambda-deploy.zip ./
