FROM developmentseed/geolambda:gdal2hdf

COPY full/requirements.txt $BUILD

# install dev dependencies for testing
RUN pip install -r $BUILD/requirements.txt;
