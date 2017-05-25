FROM developmentseed/geolambda:gdal2min

WORKDIR /work
COPY requirements.txt /build/requirements.txt
COPY requirements-dev.txt /build/requirements-dev.txt

# install dev dependencies for testing
RUN \
	pip install numpy wheel; \
    pip install -r /build/requirements.txt; \
    pip install -r /build/requirements-dev.txt;