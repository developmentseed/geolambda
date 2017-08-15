import os
import sys
import logging

# add path to included packages
path = os.path.dirname(os.path.realpath(__file__))
sys.path.insert(0, os.path.join(path, 'lib/python2.7/site-packages'))

# set up logger
logger = logging.getLogger(__file__)
logger.setLevel(logging.DEBUG)
# commented out to avoid duplicate logs in lambda
# logger.addHandler(logging.StreamHandler())

# imports used for the example code below
from osgeo import gdal


def handler(event, context):
    """ Lambda handler """
    logger.debug(event)

    # process event payload and do something like this
    fname = event['filename']
    fname = fname.replace('s3://', '/vsis3/')
    # open and return metadata
    ds = gdal.Open(fname)
    band = ds.GetRasterBand(1)
    stats = band.GetStatistics(0, 1)

    return stats
