FROM developmentseed/geolambda:full

WORKDIR /build

COPY . /build

# install app
RUN \
    pip install -r /build/requirements.txt; \
    pip install -r /build/requirements-dev.txt; \
    pip install . -v; \
    rm -rf /build/*;

WORKDIR /home/geolambda