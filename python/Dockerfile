ARG VERSION=1.2.0
FROM developmentseed/geolambda:${VERSION}

LABEL maintainer="Development Seed <info@developmentseed.org>"
LABEL authors="Matthew Hanson  <matt.a.hanson@gmail.com>"

ARG PYVERSION=3.7.4

# install Python
ENV \
    PYENV_ROOT=/root/.pyenv \
    PATH=/root/.pyenv/shims:/root/.pyenv/bin:$PATH \
    OPENSSL_VERSION=1.0.2

RUN \
    mkdir openssl; \
    wget -qO- https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz \
        | tar xvz -C openssl --strip-components=1; cd openssl; \
    ./config shared --prefix=$PREFIX/openssl --openssldir=/usr/local/openssl; \
    make depend; make install; \
    cd ..; rm -rf openssl

RUN \
    curl https://pyenv.run | bash; \
    CONFIGURE_OPTS="--with-openssl=/usr/local/openssl" \
        LD_RUN_PATH="/usr/local/openssl/lib" \
        pyenv install ${PYVERSION}; \
    pyenv global ${PYVERSION}; \
    pip install --upgrade pip

COPY requirements*.txt ./

RUN \
    pip install -r requirements-pre.txt; \
    pip install -r requirements.txt

COPY bin/* /usr/local/bin/
