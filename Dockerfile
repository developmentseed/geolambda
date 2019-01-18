#from developmentseed/geolambda-base:latest
FROM lambci/lambda:build-provided

# install system libraries
RUN \
    yum makecache fast; \
    yum install -y \
        wget tar gcc  gcc-c++ zip rsync git ssh cmake bzip2 automake \
        zlib-devel curl-devel libjpeg-devel \
        pkg-config glib2-devel; \
    yum clean all; \
    yum autoremove

# versions of packages
ENV \
	PROJ_VERSION=5.2.0 \
	GEOS_VERSION=3.7.1 \
	HDF4_VERSION=4.2.14 \
	SZIP_VERSION=2.1.1 \
	HDF5_VERSION=1.10.4 \
    NETCDF_VERSION=4.6.2 \
	OPENJPEG_VERSION=2.3.0 \
    PKGCONFIG_VERSION=0.29.2 \
    WEBP_VERSION=1.0.0 \
    ZSTD_VERSION=1.3.4 \
	GDAL_VERSION=2.4.0

# Paths to things
ENV \
	BUILD=/build \
	PREFIX=/usr/local \
	GDAL_CONFIG=/usr/local/bin/gdal-config \
	LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64

# switch to a build directory
WORKDIR /build

# proj
RUN \
    wget http://download.osgeo.org/proj/proj-$PROJ_VERSION.tar.gz; \
    tar -zvxf proj-$PROJ_VERSION.tar.gz; \
    cd proj-$PROJ_VERSION; \
    ./configure --prefix=$PREFIX; \
    make; make install; cd ..; \
    rm -rf proj-$PROJ_VERSION proj-$PROJ_VERSION.tar.gz

# GEOS
RUN \
	wget http://download.osgeo.org/geos/geos-$GEOS_VERSION.tar.bz2; \
	tar xjf geos*bz2; \
	cd geos*; \
	./configure --enable-python --prefix=$PREFIX CFLAGS="-O2 -Os"; \
	make -j 10; make install; \
	cd ..; \
    rm -rf geos*;

# libopenjpeg
RUN \
    wget https://github.com/uclouvain/openjpeg/archive/v$OPENJPEG_VERSION.tar.gz; \
    tar xvf v$OPENJPEG_VERSION.tar.gz; \
    cd openjpeg-$OPENJPEG_VERSION; mkdir build; cd build; \
    cmake .. -DCMAKE_BUILT_TYPE=Release -DMAKE_INSTALL_PREFIX=$PREFIX; \
    make; make install; make clean; \
    cd ../..; rm -rf openjpeg-* v$OPENJPEG_VERSION.tar.gz;

# szip (for hdf)
RUN \
    wget https://support.hdfgroup.org/ftp/lib-external/szip/$SZIP_VERSION/src/szip-$SZIP_VERSION.tar.gz; \
    tar -xvf szip-$SZIP_VERSION.tar.gz; \
    cd szip-$SZIP_VERSION; \
    ./configure --prefix=$PREFIX; \
    make; make install; cd ..; \
    rm -rf szip-$SZIP_VERSION*

# libhdf4
RUN \
    yum install -y bison flex; \
    wget https://support.hdfgroup.org/ftp/HDF/releases/HDF$HDF4_VERSION/src/hdf-$HDF4_VERSION.tar; \
    tar -xvf hdf-$HDF4_VERSION.tar; \
    cd hdf-$HDF4_VERSION; \
    ./configure \
        --prefix=$PREFIX \
        --with-szlib=$PREFIX \
        --enable-shared \
        --disable-netcdf \
        --disable-fortran; \
    make; make install; cd ..; \
    rm -rf hdf-$HDF4_VERSION*; \
    yum remove -y bison flex

# libhdf5
RUN \
    wget https://support.hdfgroup.org/ftp/HDF5/current/src/hdf5-$HDF5_VERSION.tar; \
    tar -xvf hdf5-$HDF5_VERSION.tar; \
    cd hdf5-$HDF5_VERSION; \
    ./configure \
        --prefix=$PREFIX \
        --with-szlib=$PREFIX; \
    make; make install; cd ..; \
    rm -rf hdf5-$HDF5_VERSION*

# NetCDF
RUN \
    wget https://github.com/Unidata/netcdf-c/archive/v$NETCDF_VERSION.tar.gz; \
    tar -xvf v$NETCDF_VERSION.tar.gz; \
    cd netcdf-c-$NETCDF_VERSION; \
    ./configure \
        --prefix=$PREFIX; \
    make; make install; cd ..; \
    rm -rf netcdf-c-${NETCDF_VERSION} v$NETCDF_VERSION.tar.gz;

# WEBP
RUN \
    wget -q https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-${WEBP_VERSION}.tar.gz; \
    tar xzf libwebp-${WEBP_VERSION}.tar.gz; \
    cd libwebp-${WEBP_VERSION}; \
    CFLAGS="-O2 -Wl,-S" ./configure --prefix=$PREFIX; \
    make -j4 --silent; make install --silent && make clean --silent; \
    rm -rf libwebp-${WEBP_VERSION} libwebp-${WEBP_VERSION}.tar.gz

# ZSTD
RUN \
  wget -q https://github.com/facebook/zstd/archive/v${ZSTD_VERSION}.tar.gz; \
  tar -zvxf v${ZSTD_VERSION}.tar.gz; \
  cd zstd-${ZSTD_VERSION}; \
  make -j4 PREFIX=$PREFIX ZSTD_LEGACY_SUPPORT=0 CFLAGS=-O1 --silent; \
  make install PREFIX=$PREFIX ZSTD_LEGACY_SUPPORT=0 CFLAGS=-O1 --silent; \
  make clean --silent; \
  rm -rf v${ZSTD_VERSION}.tar.gz zstd-${ZSTD_VERSION}

# GDAL
RUN \
    wget http://download.osgeo.org/gdal/$GDAL_VERSION/gdal-$GDAL_VERSION.tar.gz; \
    tar -xzvf gdal-$GDAL_VERSION.tar.gz; \
    cd gdal-$GDAL_VERSION; \
    ./configure \
        --prefix=$PREFIX \
        --with-hdf4=$PREFIX \
        --with-hdf5=$PREFIX \
        --with-netcdf=$PREFIX \
        --with-web=$PREFIX \
        --with-zstd=$PREFIX \
        --with-openjpeg \
		--with-curl=yes \
        --without-python \
        --with-geos=$PREFIX/bin/geos-config \
		--with-hide-internal-symbols=yes \
        CFLAGS="-O2 -Os" CXXFLAGS="-O2 -Os"; \
    make; make install; \
    #cd swig/python; \
    #python setup.py install; \
    #python3 setup.py install; \ 
    #mv $PREFIX/lib64/python2.7/site-packages/GDAL*/osgeo $PREFIX/lib64/python2.7/site-packages/osgeo; \
    #mv $PREFIX/lib64/python3.6/site-packages/GDAL*/osgeo $PREFIX/lib64/python3.6/site-packages/osgeo; \
    cd $BUILD; rm -rf gdal-$GDAL_VERSION*

#RUN \
#    pip3 install pyproj

# Copy shell scripts and config files over
COPY bin/* /usr/local/bin/
COPY etc/* /usr/local/etc/

WORKDIR /home/geolambda
