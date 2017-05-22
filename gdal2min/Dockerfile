FROM developmentseed/geolambda:core

# proj4
RUN \
    wget https://github.com/OSGeo/proj.4/archive/$PROJ4_VERSION.tar.gz && \
    tar -zvxf $PROJ4_VERSION.tar.gz && \
    cd proj.4-$PROJ4_VERSION && \
    ./configure --prefix=$HOME/local && \
    make && make install && cd .. && \
    rm -rf proj.4-$PROJ4_VERSION $PROJ4_VERSION.tar.gz

# GDAL2
RUN \
	wget http://download.osgeo.org/gdal/$GDAL_VERSION/gdal-$GDAL_VERSION.tar.gz && \
	tar -xzvf gdal-$GDAL_VERSION.tar.gz && \
	cd gdal-$GDAL_VERSION && \
    ./configure --prefix=$HOME/local \
        --with-python=yes \
        --with-hdf4=no \
        --with-hdf5=no \
        --with-threads \
        --with-gif=no \
        --with-pg=no \
        --with-grass=no \
        --with-libgrass=no \
        --with-cfitsio=no \
        --with-pcraster=no \
        --with-netcdf=no \
        --with-png=no \
        --with-jpeg=no \
        --with-gif=no \
        --with-ogdi=no \
        --with-fme=no \
        --with-jasper=no \
        --with-ecw=no \
        --with-kakadu=no \
        --with-mrsid=no \
        --with-jp2mrsid=no \
        --with-bsb=no \
        --with-grib=no \
        --with-mysql=no \
        --with-ingres=no \
        --with-xerces=no \
        --with-expat=no \
        --with-odbc=no \
        --with-curl=yes \
        --with-sqlite3=no \
        --with-dwgdirect=no \
        --with-idb=no \
        --with-sde=no \
        --with-perl=no \
        --with-php=no \
        --without-mrf \
        --with-hide-internal-symbols=yes \
        CFLAGS="-O2 -Os" CXXFLAGS="-O2 -Os" && \ 
        make && make install && cd .. && \
        rm -rf gdal-$GDAL_VERSION*

COPY gdal2min/lambda-package.sh /usr/local/bin/lambda-package.sh