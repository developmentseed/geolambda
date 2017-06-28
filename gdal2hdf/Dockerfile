FROM developmentseed/geolambda:core

# proj4
RUN \
    wget https://github.com/OSGeo/proj.4/archive/$PROJ4_VERSION.tar.gz && \
    tar -zvxf $PROJ4_VERSION.tar.gz && \
    cd proj.4-$PROJ4_VERSION && \
    ./configure --prefix=$PREFIX && \
    make && make install && cd .. && \
    rm -rf proj.4-$PROJ4_VERSION $PROJ4_VERSION.tar.gz

# libhdf4
RUN \
	yum install -y bison flex && \
	wget https://support.hdfgroup.org/ftp/HDF/releases/HDF$HDF4_VERSION/src/hdf-$HDF4_VERSION.tar && \
	tar -xvf hdf-$HDF4_VERSION.tar && \
	cd hdf-$HDF4_VERSION && \
	./configure --prefix=$PREFIX --enable-shared --disable-fortran && \
	make && make install && cd .. && \
	rm -rf hdf-$HDF4_VERSION* && \
    yum remove -y bison flex

# szip
RUN \
	wget https://support.hdfgroup.org/ftp/lib-external/szip/$SZIP_VERSION/src/szip-$SZIP_VERSION.tar.gz && \
	tar -xvf szip-$SZIP_VERSION.tar.gz && \
	cd szip-$SZIP_VERSION && \
	./configure --prefix=$PREFIX && \
	make && make install && cd .. && \
	rm -rf szip-$SZIP_VERSION*

# libhdf
RUN \
	wget https://support.hdfgroup.org/ftp/HDF5/current/src/hdf5-$HDF5_VERSION.tar && \
	tar -xvf hdf5-$HDF5_VERSION.tar && \
	cd hdf5-$HDF5_VERSION && \
	./configure --prefix=$PREFIX --with-szlib=$PREFIX && \
	make && make install && cd .. && \
	rm -rf hdf5-$HDF5_VERSION*

# GDAL
RUN \
	wget http://download.osgeo.org/gdal/$GDAL_VERSION/gdal-$GDAL_VERSION.tar.gz && \
	tar -xzvf gdal-$GDAL_VERSION.tar.gz && \
	cd gdal-$GDAL_VERSION && \
	./configure \
	 	#--prefix=$PREFIX \
    	--with-hdf4=$PREFIX \
    	--with-hdf5=$PREFIX \
    	#--with-geos=$PREFIX/bin/geos-config \
    	#--with-proj4=$PREFIX \
        CFLAGS="-O2 -Os" CXXFLAGS="-O2 -Os"; \
	make; make install; cd swig/python; \
	python setup.py install; \
	python3 setup.py install; \ 
	cd /build; rm -rf gdal-$GDAL_VERSION*

COPY gdal2hdf/lambda-package.sh /usr/local/bin/lambda-package.sh
COPY gdal2hdf/lambda-excluded-packages /usr/local/etc/lambda-excluded-packages

