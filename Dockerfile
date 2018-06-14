FROM developmentseed/geolambda:base

# versions of packages
ENV \
	PROJ4_VERSION=4.9.2 \
	GEOS_VERSION=3.6.2 \
	HDF4_VERSION=4.2.12 \
	SZIP_VERSION=2.1.1 \
	HDF5_VERSION=1.10.1 \
	OPENJPEG_VERSION=2.3.0 \
	GDAL_VERSION=2.3.0

# Paths to things
ENV \
	BUILD=/build \
	PREFIX=/usr/local \
	GDAL_CONFIG=/usr/local/bin/gdal-config \
	LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64

# install system libraries
RUN \
    yum makecache fast; \
    yum install -y wget tar gcc zlib-devel gcc-c++ curl-devel zip libjpeg-devel rsync git ssh cmake bzip2; \
    yum clean all;

# install numpy
RUN \
	pip2 install numpy; \
	pip3 install numpy;

# Copy shell scripts and confi files over
COPY bin/* /usr/local/bin/
COPY etc/* /usr/local/etc/

# switch to a build directory
WORKDIR /build

# proj4
RUN \
    wget https://github.com/OSGeo/proj.4/archive/$PROJ4_VERSION.tar.gz && \
    tar -zvxf $PROJ4_VERSION.tar.gz && \
    cd proj.4-$PROJ4_VERSION && \
    ./configure --prefix=$PREFIX && \
    make && make install && cd .. && \
    rm -rf proj.4-$PROJ4_VERSION $PROJ4_VERSION.tar.gz

# GEOS
RUN \
	wget http://download.osgeo.org/geos/geos-$GEOS_VERSION.tar.bz2; \
	tar xjf geos*bz2; \
	cd geos*; \
	./configure --enable-python --prefix=$PREFIX; \
	make -j 10; make install; \
	cd ..;

# libopenjpeg
RUN \
    wget https://github.com/uclouvain/openjpeg/archive/v$OPENJPEG_VERSION.tar.gz; \
    tar xvf v$OPENJPEG_VERSION.tar.gz; \
    cd openjpeg-$OPENJPEG_VERSION; mkdir build; cd build; \
    cmake .. -DCMAKE_BUILT_TYPE=Release; \
    make; make install; make clean; 
    #cd ../..; rm -rf openjpeg-* v$OPENJPEG_VERSION.tar.gz;

# szip (for hdf)
RUN \
    wget https://support.hdfgroup.org/ftp/lib-external/szip/$SZIP_VERSION/src/szip-$SZIP_VERSION.tar.gz && \
    tar -xvf szip-$SZIP_VERSION.tar.gz && \
    cd szip-$SZIP_VERSION && \
    ./configure --prefix=$PREFIX && \
    make && make install && cd .. && \
    rm -rf szip-$SZIP_VERSION*

# libhdf4
RUN \
    yum install -y bison flex && \
    wget https://support.hdfgroup.org/ftp/HDF/releases/HDF$HDF4_VERSION/src/hdf-$HDF4_VERSION.tar && \
    tar -xvf hdf-$HDF4_VERSION.tar && \
    cd hdf-$HDF4_VERSION && \
    ./configure \
        --prefix=$PREFIX \
        --with-szlib=$PREFIX \
        --enable-shared \
        --disable-fortran; \
    make && make install && cd .. && \
    rm -rf hdf-$HDF4_VERSION* && \
    yum remove -y bison flex

# libhdf5
RUN \
    wget https://support.hdfgroup.org/ftp/HDF5/current/src/hdf5-$HDF5_VERSION.tar && \
    tar -xvf hdf5-$HDF5_VERSION.tar && \
    cd hdf5-$HDF5_VERSION && \
    ./configure \
        --prefix=$PREFIX \
        --with-szlib=$PREFIX; \
    make && make install && cd .. && \
    rm -rf hdf5-$HDF5_VERSION*

# GDAL
RUN \
    wget http://download.osgeo.org/gdal/$GDAL_VERSION/gdal-$GDAL_VERSION.tar.gz && \
    tar -xzvf gdal-$GDAL_VERSION.tar.gz && \
    cd gdal-$GDAL_VERSION && \
    ./configure \
        --prefix=$PREFIX \
        --with-hdf4=$PREFIX \
        --with-hdf5=$PREFIX \
        --with-openjpeg \
		--with-curl=yes \
        --without-python \
        --with-geos=$PREFIX/bin/geos-config \
		--with-hide-internal-symbols=yes \
        #--with-proj4=$PREFIX \
        CFLAGS="-O2 -Os" CXXFLAGS="-O2 -Os"; \
    make; make install; cd swig/python; \
    python setup.py install; \
    python3 setup.py install; \ 
    cd $BUILD; rm -rf gdal-$GDAL_VERSION*