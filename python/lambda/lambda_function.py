import os
import sys
import logging

# set up logger
logger = logging.getLogger(__file__)
logger.setLevel(logging.DEBUG)
# commented out to avoid duplicate logs in lambda
# logger.addHandler(logging.StreamHandler())

# imports used for the example code below
from osgeo import gdal


def lambda_handler(event, context=None):
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


if __name__ == "__main__":
    """ Test lambda_handler """
    event = {
        'filename': 'https://landsat-pds.s3.amazonaws.com/c1/L8/086/240/LC08_L1GT_086240_20180827_20180827_01_RT/LC08_L1GT_086240_20180827_20180827_01_RT_B1.TIF'
    }
    stats = lambda_handler(event)
    print(stats)