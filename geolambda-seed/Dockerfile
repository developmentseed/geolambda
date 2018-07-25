FROM developmentseed/geolambda:latest

# install app
#COPY . /build
#WORKDIR /build
#RUN \
#    pip install -r /build/requirements.txt; \
#    pip install . -v; \
#    rm -rf /build/*;

COPY lambda/lambda-package.sh /usr/local/bin/

WORKDIR /home/geolambda
